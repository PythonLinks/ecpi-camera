// Diamond Documentation is at the bottom of the page.

module dvi_pll (
    input clk_in,
    output clkp,
    output clkt,
    output locked
);
(* FREQUENCY_PIN_CLKI="25.175" *)
(* FREQUENCY_PIN_CLKOP="251.175" *)
(* FREQUENCY_PIN_CLKOS="25.175" *)

(* ICP_CURRENT="12" *) (* LPF_RESISTOR="8" *) (* MFG_ENABLE_FILTEROPAMP="1" *) (* MFG_GMCREF_SEL="2" *)
/* verilator lint_off PINCONNECTEMPTY */
wire feedback_clock;
   
EHXPLLL #(
        .PLLRST_ENA("DISABLED"),
        .INTFB_WAKE("DISABLED"),
        .STDBY_ENABLE("DISABLED"),
        .DPHASE_SOURCE("DISABLED"),
        .OUTDIVIDER_MUXA("DIVA"),
        .OUTDIVIDER_MUXB("DIVB"),
        .OUTDIVIDER_MUXC("DIVC"),
        .OUTDIVIDER_MUXD("DIVD"),
        .CLKI_DIV(1),
        .CLKOP_ENABLE("ENABLED"),
        .CLKOP_DIV(5),
        .CLKOP_CPHASE(0),
        .CLKOP_FPHASE(0),
        .CLKOS_ENABLE("ENABLED"),
        .CLKOS_DIV(25),
        .CLKOS2_ENABLE("ENABLED"),
        .CLKOS2_DIV(1),
        .CLKOS_CPHASE(0),
        .CLKOS_FPHASE(0),
        .FEEDBK_PATH("CLKOS2"),
        .CLKFB_DIV(63)
    ) pll_i (
        .RST(1'b0),
        .STDBY(1'b0),
        .CLKI(clk_in),
        .CLKOP(tmds_clock),
        .CLKOS(pixel_clock),
	.CLKOS2(feedback_clock),     
        .CLKFB(feedback_clock),
        .CLKINTFB(),
        .PHASESEL0(1'b0),
        .PHASESEL1(1'b0),
        .PHASEDIR(1'b1),
        .PHASESTEP(1'b1),
        .PHASELOADREG(1'b1),
        .PLLWAKESYNC(1'b0),
        .ENCLKOP(1'b0),
        .LOCK(locked)
     );
endmodule




// diamond 3.7 accepts this PLL
// diamond 3.8-3.9 is untested
// diamond 3.10 or higher is likely to abort with error about unable to use feedback signal
// cause of this could be from wrong CPHASE/FPHASE parameters
