module i_cache (
    input wire clk, rst,
    //mips core
    input         cpu_inst_req     ,
    input         cpu_inst_wr      ,
    input  [1 :0] cpu_inst_size    ,
    input  [31:0] cpu_inst_addr    ,
    input  [31:0] cpu_inst_wdata   ,
    output [31:0] cpu_inst_rdata   ,
    output        cpu_inst_addr_ok ,
    output        cpu_inst_data_ok ,

    //axi interface
    output         cache_inst_req     ,
    output         cache_inst_wr      ,
    output  [1 :0] cache_inst_size    ,
    output  [31:0] cache_inst_addr    ,
    output  [31:0] cache_inst_wdata   ,
    input   [31:0] cache_inst_rdata   ,
    input          cache_inst_addr_ok ,
    input          cache_inst_data_ok 
);
    //Cache配置
    parameter  INDEX_WIDTH  = 10, OFFSET_WIDTH = 2, GROUP_WIDTH = 2;
    localparam TAG_WIDTH    = 32 - INDEX_WIDTH - OFFSET_WIDTH;
    localparam CACHE_DEEPTH = 1 << (INDEX_WIDTH + GROUP_WIDTH);
    
    //Cache存储单元
    reg                 cache_valid [CACHE_DEEPTH - 1 : 0];
    reg [TAG_WIDTH-1:0] cache_tag   [CACHE_DEEPTH - 1 : 0];
    reg [31:0]          cache_block [CACHE_DEEPTH - 1 : 0];
    reg [(1<<GROUP_WIDTH)-2:0] cache_recent [(1<<INDEX_WIDTH) - 1 : 0];  //存储最近使用的信息,数组形式存储树结构


    //访问地址分解
    wire [OFFSET_WIDTH-1:0] offset;
    wire [INDEX_WIDTH-1:0] index;
    wire [TAG_WIDTH-1:0] tag;
    
    assign offset = cpu_inst_addr[OFFSET_WIDTH - 1 : 0];
    assign index = cpu_inst_addr[INDEX_WIDTH + OFFSET_WIDTH - 1 : OFFSET_WIDTH];
    assign tag = cpu_inst_addr[31 : INDEX_WIDTH + OFFSET_WIDTH];

    //访问Cache line
    //索引一个组中的所有块
    wire                               c_valid_all [(1<<GROUP_WIDTH)-1 : 0];
    wire [TAG_WIDTH-1:0]               c_tag_all   [(1<<GROUP_WIDTH)-1 : 0];
    wire [31:0]                        c_block_all [(1<<GROUP_WIDTH)-1 : 0];
    wire [INDEX_WIDTH+GROUP_WIDTH-1:0] index_all   [(1<<GROUP_WIDTH)-1 : 0];
    wire [(1<<GROUP_WIDTH)-1 : 0]      hit_all;
    

    genvar i;
    generate for(i=0;i<(1<<GROUP_WIDTH);i=i+1)
        begin: gforAll
            assign index_all[i]   = (index<<GROUP_WIDTH) + i;
            assign c_valid_all[i] = cache_valid [index_all[i]];
            assign c_tag_all[i]   = cache_tag   [index_all[i]];
            assign c_block_all[i] = cache_block [index_all[i]];
            assign hit_all[i]     = c_valid_all[i] & (tag == c_tag_all[i]);
        end
    endgenerate

    //编码器
    reg [GROUP_WIDTH-1:0] group_offset;    // 用来标识是组中的第几个块
    always @(hit_all) begin
        case(hit_all)
        4'b0001: group_offset = 2'b00;
        4'b0010: group_offset = 2'b01;
        4'b0100: group_offset = 2'b10;
        4'b1000: group_offset = 2'b11;
        default: group_offset = 2'b00;
        endcase
    end

    //判断是否命中
    wire hit, miss;
    assign hit = (hit_all != 0);  //当组中有一个命中时，即 hit = 1
    assign miss = ~hit;

    //4选1 从四路中选出一路的数据和脏位
    wire [31:0] c_block;
    wire [TAG_WIDTH-1:0] c_tag;
    wire [INDEX_WIDTH + GROUP_WIDTH -1 : 0] c_index;
    
    assign c_block = c_block_all [group_offset];
    assign c_tag   = c_tag_all   [group_offset];
    assign c_index = index_all   [group_offset];
    
    // 记录最近访问的数据
    wire [GROUP_WIDTH-1:0] c_recent;    //相当于标识组中的哪一个块,含义上等同于group_offset
    wire [GROUP_WIDTH-1:0] tree_path_miss, tree_path_hit;   // 用来更新三位的最近访问记录
    //initial
    assign c_recent[0] = cache_recent[index][0];
    assign tree_path_miss[0] = 1'b0;
    assign tree_path_hit[0] = 1'b0;
    //从根节点走到叶节点
    genvar j;
    generate for(j=1;j<GROUP_WIDTH;j=j+1)
        begin: gforRecent
            assign c_recent[j] =  c_recent[j-1] ? cache_recent[index][2*(j-1) + 1] : cache_recent[index][2*(j-1) + 2];
            assign tree_path_miss[j] = c_recent[j-1] ? (2*(j-1) + 1) : (2*(j-1) + 2);
            assign tree_path_hit[j] = group_offset[j-1] ? (2*(j-1) + 1) : (2*(j-1) + 2);
        end
    endgenerate

    //根据最近访问的寄存器来选择下一个可以替换的块
    //包括该块的index，标签
    wire [INDEX_WIDTH+GROUP_WIDTH-1 : 0] replace_index;
    wire [TAG_WIDTH-1 : 0] replcae_tag;
    
    assign replace_index = index_all[0] + c_recent;
    assign replcae_tag = cache_tag[replace_index];


    //FSM
    parameter IDLE = 2'b00, RM = 2'b01; // i cache只有read
    reg [1:0] state;
    always @(posedge clk) begin
        if(rst) begin
            state <= IDLE;
        end
        else begin
            case(state)
                IDLE:   state <= cpu_inst_req & miss ? RM : IDLE;
                RM:     state <= cache_inst_data_ok ? IDLE : RM;
            endcase
        end
    end

    //读内存
    //变量read_req, addr_rcv, read_finish用于构造类sram信号。
    wire read_req;      //一次完整的读事务，从发出读请求到结束
    reg addr_rcv;       //地址接收成功(addr_ok)后到结束
    wire read_finish;   //数据接收成功(data_ok)，即读请求结束
    always @(posedge clk) begin
        addr_rcv <= rst ? 1'b0 :
                    cache_inst_req & cache_inst_addr_ok ? 1'b1 :
                    read_finish ? 1'b0 : addr_rcv;
    end
    assign read_req = state==RM;
    assign read_finish = cache_inst_data_ok;

    //output to mips core
    assign cpu_inst_rdata   = hit ? c_block : cache_inst_rdata;
    assign cpu_inst_addr_ok = cpu_inst_req & hit | cache_inst_req & cache_inst_addr_ok;
    assign cpu_inst_data_ok = cpu_inst_req & hit | cache_inst_data_ok;

    //output to axi interface
    assign cache_inst_req   = read_req & ~addr_rcv;
    assign cache_inst_wr    = cpu_inst_wr;
    assign cache_inst_size  = cpu_inst_size;
    assign cache_inst_addr  = cpu_inst_addr;
    assign cache_inst_wdata = cpu_inst_wdata;

    //写入Cache
    //保存地址中的tag, index，防止addr发生改变
    reg [TAG_WIDTH-1:0] tag_save;
    reg [INDEX_WIDTH-1:0] index_save;
    reg [INDEX_WIDTH+GROUP_WIDTH-1:0] c_index_save, replace_index_save;

    always @(posedge clk) begin
        tag_save   <= rst ? 0 :
                      cpu_inst_req ? tag : tag_save;
        index_save <= rst ? 0 :
                      cpu_inst_req ? index : index_save;
        c_index_save <= rst ? 0 :
                      cpu_inst_req ? c_index : c_index_save;
        replace_index_save <= rst ? 0 :
                      cpu_inst_req ? replace_index : replace_index_save;
    end

    integer t;
    always @(posedge clk) begin
        if(rst) begin
            for(t=0; t<CACHE_DEEPTH; t=t+1) begin   //刚开始将Cache置为无效
                cache_valid[t] <= 0;
            end
        end
        else begin
            if(read_finish) begin //读缺失，访存结束时
                cache_valid[replace_index_save] <= 1'b1;             //将Cache line置为有效
                cache_tag  [replace_index_save] <= tag_save;
                cache_block[replace_index_save] <= cache_inst_rdata; //写入Cache line
            end
        end
    end

   //更新cache最近访问存储
   //注意命中和缺失使用的tree_path不一样
   //缺失时，是在从内存读入新块后，再更新cache_recent;命中时是在cache传到cpu的数据ok之后更新cache_recent
    integer r, s;
    always @(posedge clk) begin
        if(rst) begin
            for(s=0; s<(1<<INDEX_WIDTH); s=s+1) begin   //刚开始将最近访问记录全部置为3’b000，也就是默认替换组中的第0块
                cache_recent[s] <= 0;
            end
        end
        else begin
            if(read_finish) begin
                for(r=0;r<GROUP_WIDTH;r=r+1) begin
                    cache_recent[index_save][tree_path_miss[r]] <= ~cache_recent[index_save][tree_path_miss[r]];
                end
            end
            else if(hit & cpu_inst_data_ok) begin
                for(r=0;r<GROUP_WIDTH;r=r+1) begin
                    if(cache_recent[index_save][tree_path_hit[r]] == group_offset[r])
                        cache_recent[index_save][tree_path_hit[r]] <= ~cache_recent[index_save][tree_path_hit[r]];
                    else
                        cache_recent[index_save][tree_path_hit[r]] <= cache_recent[index_save][tree_path_hit[r]];
                end
            end
        end
    end
endmodule