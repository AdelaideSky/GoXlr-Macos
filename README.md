<div align=center>

#  <img src="https://media.discordapp.net/attachments/756659826045485088/968640294033686619/icon_128x128.png" width="30"> GoXLR for Mac
### MacOS application to manage GoXLR without virtual machine.

<img src="https://cdn.discordapp.com/attachments/756659826045485088/973891094351872010/unknown.png" width="700">
</div>

For now, full control and compatibility of the GoXLR are not available on Mac. 
You would need a Windows virtual machine if you want to update
colours, mic or effects settings but - unlike what TC-Helicon said, 
the device is perfectly compatible with MacOS and this application proves it.

**Disclaimer:** I have absolutely no link with TC-Helicon.
I'm not affiliated with them and neither is this project.
The official driver is available on their website and any damage caused to
your device is your responsibility.


## Set up

#### Install the dependencies:

- Install libusb: `brew install libusb`

#### Set up the app:

- Download the latest [release](https://github.com/Adelenade/GoXlr-Macos/releases), and select the M1 or Intel version.
- Open the .pkg file and follow the instructions to install the app on your computer.
- If your GoXLR is plugged in, unplug it and plug it in again.
- Wait a few seconds before launching the app.
- **If the app crashes**:
  - Run the command `killall goxlr-daemon` in your terminal.
  - Wait a few seconds before restarting the app.
- Go to the settings tab and click on "Create audio outputs".
- Make sure you have selected your GoXLR as the default audio output before clicking “OK”.
- Enjoy!

## Notice

- The GoXLR can be initialized without being rebooted each time it shuts down.
- The app itself does no more than provide a graphic control panel of the
GoXLR-Utility that you've already installed, and create the sound outputs.

## To-do list

- Synchronize sliders and pickers with the actual physical configuration 
of the GoXLR (actually not the REAL data but quite the same)
- Add chat mic and broadcast mix supports (all mic system in general)
- Add other features of the GoXLR (profiles, colours, micro, routing…)
- Many more...


## Credits

- A lot of love to the devs of the 
[GoXLR-Utility](https://github.com/GoXLR-on-Linux/GoXLR-Utility)! 
Without this project, the development of this application would not
have been possible.
