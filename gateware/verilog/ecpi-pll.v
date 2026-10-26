`default_nettype none

module ECPI_PLL (
    input  CLKI,
//  input  CLKFB,
//    input  PHASESEL1,
//    input  PHASESEL0,
//    input  PHASEDIR,
//    input  PHASESTEP,
//    input  PHASELOADREG,
//    input  STDBY,
//    input  PLLWAKESYNC,
//    input  RST,
//    input  ENCLKOP,
//    input  ENCLKOS,
//    input  ENCLKOS2,
//    input  ENCLKOS3,
    output CLKOP,
    output CLKOS,
//    output CLKOS2,  // Now FEEDBACK_CLOCK
//    output CLKOS3,
    output LOCK,
///   output INTLOCK,
//  output REFCLK,
//  output CLKINTFB
);
(* FREQUENCY_PIN_CLKI="25.175" *)
(* FREQUENCY_PIN_CLKOP="125.875" *)
(* ICP_CURRENT="12" *) (* LPF_RESISTOR="8" *) (* MFG_ENABLE_FILTEROPAMP="1" *) (* MFG_GMCREF_SEL="2" *)
   parameter INPUT_DIV = 1;
   parameter CLKOP_DIV = 5;   
   parameter CLKOS_DIV = 25;
   parameter CLKOS2_DIV = 5;
   parameter FEEDBACK_DIV = 5;
   parameter ENABLED = 1'b1;
   parameter DISABLED = 1'b0   
   wire	     FEEDBACK_CLOCK;
 
    EHXPLLL #(
        .CLKI_DIV        (INPUT_DIV),
        .CLKFB_DIV       (FEEDBACK_DIV),  
        .CLKOP_DIV       (CLKOP_DIV),
        .CLKOS_DIV       (CLKOS_DIV),
        .CLKOS2_DIV      (CLKOS2_DIV),
//      .CLKOS3_DIV      (8),
        .CLKOP_ENABLE    (ENABLED),
        .CLKOS_ENABLE    (ENABLED),
        .CLKOS2_ENABLE   (ENABLED),
 //     .CLKOS3_ENABLE   (DISABLED),
        .CLKOP_CPHASE    (CLKOP_DIV-1),
        .CLKOS_CPHASE    (CLKOS_DIV-1),
        .CLKOS2_CPHASE   (CLKOS2_DIV-1),
//      .CLKOS3_CPHASE   (0),
//      .CLKOP_FPHASE    (0),
//      .CLKOS_FPHASE    (0),
        .CLKOS2_FPHASE   (0),
//      .CLKOS3_FPHASE   (0),
        .FEEDBK_PATH     ("CLKOS2"),
//      .CLKOP_TRIM_POL  ("RISING"),  
//      .CLKOP_TRIM_DELAY(0),         
//      .CLKOS_TRIM_POL  ("RISING"),  
//      .CLKOS_TRIM_DELAY(0),         
        .OUTDIVIDER_MUXA ("DIVA"),
        .OUTDIVIDER_MUXB ("DIVB"),
        .OUTDIVIDER_MUXC ("DIVC"),
        .OUTDIVIDER_MUXD ("DIVD"),
        .PLL_LOCK_MODE   (0),
        .PLL_LOCK_DELAY  (200),
        .STDBY_ENABLE    (DISABLED),
        .REFIN_RESET     (DISABLED),
        .SYNC_ENABLE     (DISABLED),
        .INT_LOCK_STICKY (ENABLED),
        .DPHASE_SOURCE   (DISABLED),
        .PLLRST_ENA      (DISABLED),
        .INTFB_WAKE      (DISABLED)
    ) ehxplll_inst (
        .CLKI        (CLKI),  //good
        .CLKFB       (FEEDBACK_CLOCK), //good
//      .PHASESEL1   (PHASESEL1), 
//      .PHASESEL0   (PHASESEL0),
//      .PHASEDIR    (PHASEDIR),
//      .PHASESTEP   (PHASESTEP),
//      .PHASELOADREG(PHASELOADREG),
//      .STDBY       (STDBY),
//      .PLLWAKESYNC (PLLWAKESYNC),
//      .RST         (RST),
        .ENCLKOP     (ENABLED),
        .ENCLKOS     (ENABLED),
        .ENCLKOS2    (ENABLED),
        .ENCLKOS3    (DISABLED),
        .CLKOP       (CLKOP),    //good
        .CLKOS       (CLKOS),    //good
        .CLKOS2      (FEEDBACK_CLOCK),   //good
//      .CLKOS3      (CLKOS3),
        .LOCK        (LOCK),     //good
//      .INTLOCK     (INTLOCK),  
//      .REFCLK      (REFCLK),
//      .CLKINTFB    (CLKINTFB)
    );

endmodule
