## ECPi Camera

ECPi camera uses a $10 Raspberry Py Zero to connect any Raspberry Pi 2
or 3 camera to an ECP5 FPGA, process the image, and display it on DVI
or USB 3.  You can control the camera settings using the RPI Zero.


ECPi Camera uses the Display Parallel Interface (DPI) protocol rather
than MIPI CSI.  DPI is a very simple, low frequency, license free
protocol for transmitting images using parallel single ended wires.
There is the similar Digital Video Port (DVP) protocol but there are
no cameras with a 24 bit wide DVP data path, so until now, only
smaller or lower resolution DVP images were possible. For larger
bandwidth, the more complex, higher frequency, proprietary MIPI CSI
has to be used but there are no open source FPGAs with MIPI CSI hard
cores currently available.  The Lattice Crosslink NX 17/40 is back
ordered for two years. The Appicula project to support Gowin FPGAs
with MIPI CSI hard cores just started and will take time to complete.
There are closed source FPGAs with MIPI CSI, but they are all more
expensive.  And even if you did buy a MIPI CSI FPGA, you would still
need a microcontroller to run the software to set all of the registers
in the image sensor. Best to start with the inexpensive [ECPi Camera
RGB888 application](apps/rgb888).

![ECPi Camera Schematic](images/icepi-zero)

ECPi Camera uses a
[Raspberry Pi Zero]
(https://www.raspberrypi.com/products/raspberry-pi-zero/) and a
Rasperry Pi Camera version 2 or 3 to drive an 
[IcePi Zero]
(https://www.crowdsupply.com/icy-electronics/icepi-zero) board with a 
[Lattice ECP5 FPGA]
(https://www.latticesemi.com/view_document?document_id=50461). 
You can use either the $10 Raspberry Pi Zero (one core) or the $15
Raspberry Pi Zero 2W (four cores, Bluetooth and WiFi). This is an
entirely open source tool chain, although obviously the chips
themselves are all proprietary.

## Assembly

You need a Raspberry Pi Zero, an IcePi Zero available from 
[CrowdSupply](https://www.crowdsupply.com/icy-electronics/icepi-zero)
or [Electrow](https://www.elecrow.com/icepi-zero.html), any Raspberry 
Pi Camera version 2 or 3, a camera  cable and a male and a female
header. The camera cable should convert between the standard 24 pin
camera flexible printed cable socket and the Raspberry Pi Zero's 15
pin FPC socket. The standard header configuration is male headers on
the RPI Zero facing up, and female headers on the IcePi Zero facing
down. You can solder them, or if you are not comfortable with your
soldering skills, what I am using is the 
[Pimoni Hammer headers]
(https://shop.pimoroni.com/products/gpio-hammer-header?variant=35643318026).
Here is a blog posing about [how to do it]
(https://learn.pimoroni.com/article/fitting-hammer-headers), 
scroll all the way down for how to do the female hat header.

If you are concerned about using hammer headers, here is an article 
[reviewing the product]
(https://hackaday.com/2017/01/16/review-hammer-installed-solderless-raspberry-pi-pin-headers/).
Basically it and the comments say that it works fine, 
and has some plusses and minuses.   "Solder is not glue".  In the
automotive industry the fittings are press fit, solder does not
survive temperature cycling.  But the automotive holes are a
particular size, andthe gold platting is a little thicker.  Pimoroni
and the article tested the electrical characteristics and all is fine.
Be careful to apply equal pressure everywhere and to not bend the 
board.  A vice woudl be the best way to do it.

## FirmWare and GateWare
The firmware and  gateware are in [apps/rgb888](apps/rgb888).

## USB Output 
For development it is fine to use the ECP5 DVI output.  Good to have a
DVI switchbox.  To show it off over Zoom, or capture images or video,
it is nice to have a DVI to USB dongle.  Make sure to buy the USB 3
dongle, not a USB 2 dongle.

## Questions???
Please [send me an email](mailto:lozinski@PythonLinks.info)


