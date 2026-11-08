# ECPi Gateware

This directory holds the RTL which will run on the IcePi Zero. 

> [!CAUTION]
> October 30th 2026. Work is just starting on this part of the project. 

1. **pixel-clock-frequency** is RTL to test the RPL's pixel clock.
   It is a blinky application, but it is driven by the RPi's pixel
   clock.  It should blink once a second for a 27Mhz signal.
   
2. **pixel-pll-lock** will test if the pll can get a lock from the RPi's pixel 
   clock. 

3. **rgb888** will be the simple application.  It will read the DPI signal, 
   and republish   it over the dvi port.    

4. **clock-domain-crossing** will use FIFO queues to tranfer data from the 
   RPi clock domain to the FPGA's clock domain. 
   

   
