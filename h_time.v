`define TC_DRA 1
`define TC_SPI 1
`define TC_FIL 1
`define TC_WAS 3
`define TC_RIN 2
`define TG_WAS (`TC_FIL + `TC_WAS)
`define TG_RIN (`TC_DRA + `TC_SPI + `TC_FIL + `TC_RIN)
`define TG_DRY (`TC_DRA + `TC_SPI)
