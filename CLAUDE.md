# CLAUDE INSTRUCTIONS

Your job is to review the code, and provide feedback, but not write it. 

This is a project to connect a camera to an ECP5 FPGA using a Raspberry Pi
(RPi) zero W and the IcePi Zero FPGA board.  Here is the data flow.

Camera -> MIPI CSI -> RPI Zero W -> DPI -> FPGA -> DVI

For debugging purposes the RPI Zero W also drives an HDMI display at the same
video mode (resolution, frequency and pixel clock) as the dpi output.  

There are two approaches.  The simple approach is to have the DPI
pixel clock drive the FPGA PLL.  This only works if the RPi pixel
clock has sufficiently low jitter, meaning it cannot use fractional
multiplies or dividers.  Therefore only a limited number of
industry standard resolutions would be  possible.  A 216 MHz pllh_aux can be
divided by integers to support the following standard CEA/VESA pixel
clock frequencies: 27, 36, 54, 72 and 108 MHz.  Other RPI Zero W
frequencies based on integer divides and multiplies may also be
possible.

A later project will do proper Clock Domain Crossings with FIFO queues, and
with the two chips running off of their own oscillators.


