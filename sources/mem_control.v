`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2021/01/01 10:50:09
// Design Name: 
// Module Name: mem_control
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////
`include "defines.vh"

module mem_control(
    // write to memory
    input [5:0] op,
    input [31:0] addr,
    input [31:0] writeData,
    output reg [31:0] writeData2,
    output reg [3:0] sel,
    // read from memory
    input [31:0] readData,
    output reg [31:0] finalData,
    // except
    input [31:0] pc,
    output [31:0] bad_addr,
    output adel, ades
    );
    
    assign adel = ((op == `EXE_LW_OP)  && (addr[1:0] != 2'b00)) 
                | ((op == `EXE_LH_OP)  && (addr[1:0] != 2'b00) && (addr[1:0] != 2'b10))
                | ((op == `EXE_LHU_OP) && (addr[1:0] != 2'b00) && (addr[1:0] != 2'b10));
    
    assign ades = ((op == `EXE_SW_OP)  && (addr[1:0] != 2'b00)) 
                | ((op == `EXE_SH_OP)  && (addr[1:0] != 2'b00) && (addr[1:0] != 2'b10));
    
    assign bad_addr = (adel | ades) ? addr : pc;

    // write enable(sel)
    always@(*) begin
        case (op)
            `EXE_LB_OP, `EXE_LBU_OP, `EXE_LH_OP, `EXE_LHU_OP, `EXE_LW_OP: begin
                sel <= 4'b0000;
            end 
            `EXE_SW_OP: begin
                writeData2 <= writeData;
                sel <= 4'b1111;
            end
            `EXE_SH_OP: begin
                writeData2 <= {2{writeData[15:0]}};
                case (addr[1:0])
                    2'b00:   sel <= 4'b0011;
                    2'b10:   sel <= 4'b1100;
                    default: sel <= 4'b0000;
                endcase
            end
            `EXE_SB_OP: begin
                writeData2 <= {4{writeData[7:0]}};
                case (addr[1:0])
                    2'b00:   sel <= 4'b0001;
                    2'b01:   sel <= 4'b0010;
                    2'b10:   sel <= 4'b0100;
                    2'b11:   sel <= 4'b1000;
                    default: sel <= 4'b0000;
                endcase
            end
            default: sel <= 4'b0000;
        endcase
    end

    // choose the right part from readData
    always@(*) begin
        case (op)
            `EXE_LW_OP: begin
                finalData <= readData;
            end 
            `EXE_LH_OP: begin
                case (addr[1:0])
                    2'b00:   finalData <= {{16{readData[15]}}, readData[15:0]};
                    2'b10:   finalData <= {{16{readData[31]}}, readData[31:16]};
                    default: finalData <= 32'b0;
                endcase
            end
            `EXE_LHU_OP: begin
                case (addr[1:0])
                    2'b00:   finalData <= {16'b0, readData[15:0]};
                    2'b10:   finalData <= {16'b0, readData[31:16]};
                    default: finalData <= 32'b0;
                endcase
            end
            `EXE_LB_OP: begin
                case (addr[1:0])
                    2'b00:   finalData <= {{24{readData[7]}}, readData[7:0]};
                    2'b01:   finalData <= {{24{readData[15]}}, readData[15:8]};
                    2'b10:   finalData <= {{24{readData[23]}}, readData[23:16]};
                    2'b11:   finalData <= {{24{readData[31]}}, readData[31:24]};
                    default: finalData <= 32'b0;
                endcase
            end
            `EXE_LBU_OP: begin
                case (addr[1:0])
                    2'b00:   finalData <= {24'b0, readData[7:0]};
                    2'b01:   finalData <= {24'b0, readData[15:8]};
                    2'b10:   finalData <= {24'b0, readData[23:16]};
                    2'b11:   finalData <= {24'b0, readData[31:24]};
                    default: finalData <= 32'b0;
                endcase
            end
            default: finalData <= 32'b0;
        endcase
    end
endmodule
