#include <asm.h>
#include <regdef.h>
#include <inst_test.h>

LEAF(n1_abs_test)
    .set noreorder
    addiu s0, s0 ,1
    addiu s2, zero, 0x0
    lui   t2, 0x1
###test inst
    TEST_ABS(0xee3a1577,0x11c5ea89)
	TEST_ABS(0x7408f15d,0x7408f15d)
	TEST_ABS(0xb239c25d,0x4dc63da3)
	TEST_ABS(0xa2e0dca4,0x5d1f235c)
	TEST_ABS(0xdf03ffeb,0x20fc0015)
	TEST_ABS(0xc4abf8c8,0x3b540738)
	TEST_ABS(0xf6be63e6,0x09419c1a)
	TEST_ABS(0x4832bc95,0x4832bc95)
	TEST_ABS(0x5b53e02f,0x5b53e02f)
	TEST_ABS(0x1df80450,0x1df80450)
	TEST_ABS(0x3462629d,0x3462629d)
	TEST_ABS(0x478bf6de,0x478bf6de)
	TEST_ABS(0xe48768e3,0x1b78971d)
	TEST_ABS(0x424fe367,0x424fe367)
	TEST_ABS(0x13332529,0x13332529)
	TEST_ABS(0x17e1e3e5,0x17e1e3e5)
	TEST_ABS(0x294ce1e6,0x294ce1e6)
	TEST_ABS(0x0c8d4d32,0x0c8d4d32)
	TEST_ABS(0xb259582c,0x4da6a7d4)
	TEST_ABS(0x1654c534,0x1654c534)
	TEST_ABS(0xf23c9745,0x0dc368bb)
	TEST_ABS(0x6aa0dfaa,0x6aa0dfaa)
	TEST_ABS(0xd8c74fcc,0x2738b034)
	TEST_ABS(0x1951dd25,0x1951dd25)
	TEST_ABS(0xbfb41e1a,0x404be1e6)
	TEST_ABS(0x176c10ee,0x176c10ee)
	TEST_ABS(0xc91b2382,0x36e4dc7e)
	TEST_ABS(0xa70b884d,0x58f477b3)
	TEST_ABS(0xd63e69d0,0x29c19630)
	TEST_ABS(0x7c1c2949,0x7c1c2949)
	TEST_ABS(0xf77644ba,0x0889bb46)
	TEST_ABS(0x089fad5e,0x089fad5e)
	TEST_ABS(0x0a325ebf,0x0a325ebf)
	TEST_ABS(0x36cbedf5,0x36cbedf5)
	TEST_ABS(0xc0b0007d,0x3f4fff83)
	TEST_ABS(0x76fa4d13,0x76fa4d13)
	TEST_ABS(0x140b1fed,0x140b1fed)
	TEST_ABS(0xfd7f6c33,0x028093cd)
	TEST_ABS(0xd9910637,0x266ef9c9)
	TEST_ABS(0xe5f72432,0x1a08dbce)
	TEST_ABS(0xb995eca0,0x466a1360)
	TEST_ABS(0x7a112d13,0x7a112d13)
	TEST_ABS(0x59a95760,0x59a95760)
	TEST_ABS(0xbdebbebd,0x42144143)
	TEST_ABS(0xadbd3c33,0x5242c3cd)
	TEST_ABS(0xc287c89a,0x3d783766)
	TEST_ABS(0x66f38e59,0x66f38e59)
	TEST_ABS(0x8b7f450a,0x7480baf6)
	TEST_ABS(0xc5b3d450,0x3a4c2bb0)
	TEST_ABS(0x387870b1,0x387870b1)
	TEST_ABS(0xe28c4083,0x1d73bf7d)
	TEST_ABS(0xf0d1bfb1,0x0f2e404f)
	TEST_ABS(0x53b89618,0x53b89618)
	TEST_ABS(0xf6bf36ce,0x0940c932)
	TEST_ABS(0xf67951e2,0x0986ae1e)
	TEST_ABS(0x277f81bc,0x277f81bc)
	TEST_ABS(0x1cdd9396,0x1cdd9396)
	TEST_ABS(0xdde10103,0x221efefd)
	TEST_ABS(0x66b81e8a,0x66b81e8a)
	TEST_ABS(0x20c92e5e,0x20c92e5e)
	TEST_ABS(0xa01dea3d,0x5fe215c3)
	TEST_ABS(0xed0b2921,0x12f4d6df)
	TEST_ABS(0x009840ed,0x009840ed)
	TEST_ABS(0x2b26f388,0x2b26f388)
	TEST_ABS(0x91a6273b,0x6e59d8c5)
	TEST_ABS(0x8a09b332,0x75f64cce)
	TEST_ABS(0x32e5ff11,0x32e5ff11)
	TEST_ABS(0xc928f161,0x36d70e9f)
	TEST_ABS(0x876b4a45,0x7894b5bb)
	TEST_ABS(0xaaa6cba2,0x5559345e)
	TEST_ABS(0x04cc1264,0x04cc1264)
	TEST_ABS(0x023e874f,0x023e874f)
	TEST_ABS(0xb406dba2,0x4bf9245e)
	TEST_ABS(0x523b0684,0x523b0684)
	TEST_ABS(0xd5cbaebc,0x2a345144)
	TEST_ABS(0x06bb3a3a,0x06bb3a3a)
	TEST_ABS(0x2eaeb710,0x2eaeb710)
	TEST_ABS(0xc3629f9a,0x3c9d6066)
	TEST_ABS(0x0c6a0208,0x0c6a0208)
	TEST_ABS(0x06a7b60b,0x06a7b60b)
	TEST_ABS(0xec47ce69,0x13b83197)
	TEST_ABS(0xe707e23d,0x18f81dc3)
	TEST_ABS(0xd5e43965,0x2a1bc69b)
	TEST_ABS(0x185ca4b4,0x185ca4b4)
	TEST_ABS(0xb8d0f75b,0x472f08a5)
	TEST_ABS(0x3dbe85a3,0x3dbe85a3)
	TEST_ABS(0xd03367d7,0x2fcc9829)
	TEST_ABS(0x9639e9ed,0x69c61613)
	TEST_ABS(0xd43d95af,0x2bc26a51)
	TEST_ABS(0x28993089,0x28993089)
	TEST_ABS(0x512d9d0c,0x512d9d0c)
	TEST_ABS(0xc96dc95a,0x369236a6)
	TEST_ABS(0x15c834b7,0x15c834b7)
	TEST_ABS(0x2f903dc4,0x2f903dc4)
	TEST_ABS(0xc952c2cb,0x36ad3d35)
	TEST_ABS(0x2196a686,0x2196a686)
	TEST_ABS(0xb39059a6,0x4c6fa65a)
	TEST_ABS(0x5a307403,0x5a307403)
	TEST_ABS(0x471ebf45,0x471ebf45)
	TEST_ABS(0x396fffe2,0x396fffe2)
	TEST_ABS(0x8be521c5,0x741ade3b)
	TEST_ABS(0x34c04cd6,0x34c04cd6)
	TEST_ABS(0x53d426e4,0x53d426e4)
	TEST_ABS(0xdd2ea8ee,0x22d15712)
	TEST_ABS(0x6d698919,0x6d698919)
	TEST_ABS(0x7dfc1052,0x7dfc1052)
	TEST_ABS(0xe3bc55ae,0x1c43aa52)
	TEST_ABS(0x8257a286,0x7da85d7a)
	TEST_ABS(0x9b9a8e7d,0x64657183)
	TEST_ABS(0xe8df552b,0x1720aad5)
	TEST_ABS(0x21727484,0x21727484)
	TEST_ABS(0x3353df8d,0x3353df8d)
	TEST_ABS(0x0e8ed341,0x0e8ed341)
	TEST_ABS(0xf633cef5,0x09cc310b)
	TEST_ABS(0xb0f9c1c7,0x4f063e39)
	TEST_ABS(0x95265983,0x6ad9a67d)
	TEST_ABS(0xfd55fab0,0x02aa0550)
	TEST_ABS(0x34e7cc7f,0x34e7cc7f)
	TEST_ABS(0xe6b975e3,0x19468a1d)
	TEST_ABS(0x56fbbc52,0x56fbbc52)
	TEST_ABS(0xb3008aa1,0x4cff755f)
	TEST_ABS(0x83eada35,0x7c1525cb)
	TEST_ABS(0xeba339bb,0x145cc645)
	TEST_ABS(0x820af1fa,0x7df50e06)
	TEST_ABS(0xbdff72ae,0x42008d52)
	TEST_ABS(0x0479226a,0x0479226a)
	TEST_ABS(0x76521e67,0x76521e67)
	TEST_ABS(0x31acb781,0x31acb781)
	TEST_ABS(0xe685cc9b,0x197a3365)
	TEST_ABS(0xe7bdeb8e,0x18421472)
	TEST_ABS(0x2307a08b,0x2307a08b)
	TEST_ABS(0xb03a1925,0x4fc5e6db)
	TEST_ABS(0xb113f41f,0x4eec0be1)
	TEST_ABS(0x9980d4b6,0x667f2b4a)
	TEST_ABS(0x7b005544,0x7b005544)
	TEST_ABS(0x6fe1e230,0x6fe1e230)
	TEST_ABS(0xd3a6072d,0x2c59f8d3)
	TEST_ABS(0xedfbb76b,0x12044895)
	TEST_ABS(0xe2cacf61,0x1d35309f)
	TEST_ABS(0x6c4b4692,0x6c4b4692)
	TEST_ABS(0x63d503b6,0x63d503b6)
	TEST_ABS(0x7c4ab07f,0x7c4ab07f)
	TEST_ABS(0x3f7c71fb,0x3f7c71fb)
	TEST_ABS(0xf36f8198,0x0c907e68)
	TEST_ABS(0x702fb9fb,0x702fb9fb)
	TEST_ABS(0xbb7ebcc5,0x4481433b)
	TEST_ABS(0x6223ae9f,0x6223ae9f)
	TEST_ABS(0xf0956391,0x0f6a9c6f)
	TEST_ABS(0xfc47d329,0x03b82cd7)
	TEST_ABS(0x35a15302,0x35a15302)
	TEST_ABS(0x3ab954b4,0x3ab954b4)
	TEST_ABS(0x56f411c9,0x56f411c9)
	TEST_ABS(0xebac95e7,0x14536a19)
	TEST_ABS(0xa79758d0,0x5868a730)
	TEST_ABS(0xf6a3231f,0x095cdce1)
	TEST_ABS(0xab3926ee,0x54c6d912)
	TEST_ABS(0xfbc63bc8,0x0439c438)
	TEST_ABS(0xd222b2fb,0x2ddd4d05)
	TEST_ABS(0xcaad0a44,0x3552f5bc)
	TEST_ABS(0xd6e6173a,0x2919e8c6)
	TEST_ABS(0xdfd619f6,0x2029e60a)
	TEST_ABS(0x662c1b94,0x662c1b94)
	TEST_ABS(0x6bb4bb9f,0x6bb4bb9f)
	TEST_ABS(0xf25604f5,0x0da9fb0b)
	TEST_ABS(0x37743a7d,0x37743a7d)
	TEST_ABS(0xfef9e0da,0x01061f26)
	TEST_ABS(0x93675771,0x6c98a88f)
	TEST_ABS(0x10deceff,0x10deceff)
	TEST_ABS(0x554cc6ee,0x554cc6ee)
	TEST_ABS(0xcd04e975,0x32fb168b)
	TEST_ABS(0xfcff041b,0x0300fbe5)
	TEST_ABS(0x657447ae,0x657447ae)
	TEST_ABS(0x0ca3513e,0x0ca3513e)
	TEST_ABS(0x9f696195,0x60969e6b)
	TEST_ABS(0x39d400bc,0x39d400bc)
	TEST_ABS(0x1c77814a,0x1c77814a)
	TEST_ABS(0xfb92f5cf,0x046d0a31)
	TEST_ABS(0x4e83fdc8,0x4e83fdc8)
	TEST_ABS(0x2b132630,0x2b132630)
	TEST_ABS(0x0d467fc6,0x0d467fc6)
	TEST_ABS(0xe7685b75,0x1897a48b)
	TEST_ABS(0x716cb6eb,0x716cb6eb)
	TEST_ABS(0xfa787fbe,0x05878042)
	TEST_ABS(0xa4b264a3,0x5b4d9b5d)
	TEST_ABS(0x77caa9f3,0x77caa9f3)
	TEST_ABS(0xc97a8f30,0x368570d0)
	TEST_ABS(0x737dd3b8,0x737dd3b8)
	TEST_ABS(0x89816477,0x767e9b89)
	TEST_ABS(0xe3bb3518,0x1c44cae8)
	TEST_ABS(0xeaa08693,0x155f796d)
	TEST_ABS(0x17190aab,0x17190aab)
	TEST_ABS(0x5b4aa679,0x5b4aa679)
	TEST_ABS(0xf2a6ed06,0x0d5912fa)
	TEST_ABS(0x55966908,0x55966908)
	TEST_ABS(0x9c5161b7,0x63ae9e49)
	TEST_ABS(0x8095b53c,0x7f6a4ac4)
	TEST_ABS(0xdc48a29c,0x23b75d64)
	TEST_ABS(0x4da63d05,0x4da63d05)
	TEST_ABS(0x8c6eca4f,0x739135b1)
	TEST_ABS(0xe3db15b9,0x1c24ea47)

###detect exception
    bne s2, zero, inst_error
    nop
###score ++
    addiu s3, s3, 1
###output (s0<<24)|s3
inst_error:  
    sll t1, s0, 24
    or t0, t1, s3 
    sw t0, 0(s1)
    jr ra
    nop
END(n1_abs_test)
