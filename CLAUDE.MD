This project is to connect a 
Raspberry Pi compatible Camera -> MIPI CSI -> RPI Zero W -> DPI -> FPGA -> DVI. 

We are using the IcePi Zero board which has a small ECP5 FPGA. 

We are driving the FPGA with the RPi DPI signal. 

We will also be driving an RPI Zero HDMI display at the same
video mode (resolution, frequency and pixel clock) as the dpi. 

There are two approaches.  First we want to have the DPI pixel clock
drive the FPGA PLL.  This only works if the RPi pixel clock has low
jitter, meaning it cannot use a fractional divider.  And the parent
pll cannot use a fractional multiplier.  Only a limited number of
resolutions are possible.   A 216 MHz pllh_aux can be divided by
integers to support the following standard CEA/VESA pixel clock
frequencies: 27, 36, 54 and 72 MHz.  Other RPI Zero frequencies based
on integer divides and multiplies may also be possible.

Later we will do proper Clock Domain Crossings with FIFO queues, and
the two chips running off of their own oscillators.


