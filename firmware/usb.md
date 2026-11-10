# Logging in to the Pi over USB

The easiest way to login is over wifi, the RPi install program
configures it.  Once Wifi is working, one can use it to configure usb
connections. 

There are two different RPi programs which can be used to login over
USB: `g_cdc` and `g_ncm`.  I used the older `g_cdc`.  It allows both
an ssh login and a tty login.  On mac and linux use ssh.  On windows
it is reportedly easier to configure the tty login.

Make sure to use the Pi Zero's **USB** (data) port, the one in the
middle of the board, not the power connector on the edge of the board.
Use a data cable, not a charge-only cable.  And make sure that your Pi
has the power plug plugged in, maybe to a usb phone charger.

## Pi setup (once)

1. Edit `/boot/firmware/config.txt`: at the end, under `[all]`, **after** 
   the DPI `dtparam=` lines append the following: 
   ```
   # Set the USB port in device (gadget) mode: 
   # USB Ethernet (usb0) + USB serial (ttyGS0)
   dtoverlay=dwc2,dr_mode=peripheral
   ```
2. Edit `/boot/firmware/cmdline.txt`: append to the end of the single line:
   ```
   modules-load=dwc2,g_cdc
   ```
3. Reboot.
4. Since there is never a dhcp server on the USB link, give  `usb0` a 
   self-assigned (link-local, 169.254.x.x) address:
   ```
   sudo nmcli con add type ethernet ifname usb0 con-name usb0-ll ipv4.method link-local ipv6.method link-local
   ```
5. Print it:
   ```
   ip -br addr show usb0
   ```
6.  Raise the profile's priority so the netplan `eth0` profile (empty `match:`)    can't claim `usb0`:
   ```
   sudo nmcli con mod usb0-ll connection.autoconnect-priority 10
   ```

To enable usb login from Linux, on Linux run:
   ```
   sudo nmcli con add type ethernet con-name pi-usb match.driver cdc_ether ipv4.method link-local ipv6.method link-local
   ```
   
On mac and Linux, to connect over wifi or usb:

```
ssh ecpi@ecpi.local
```


If you want to login from windows you will need to enable usb tty login on the pi.
```
sudo systemctl enable --now serial-getty@ttyGS0.service
```
