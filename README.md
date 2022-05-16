<div align=center>

#  <img src="https://media.discordapp.net/attachments/756659826045485088/968640294033686619/icon_128x128.png" width="30"> GoXLR for Mac
### MacOS application to manage GoXLR without virtual machine.

<img src="https://cdn.discordapp.com/attachments/756659826045485088/973891094351872010/unknown.png" width="700">
</div>

For now, full control and compatibility of the GoXLR are not available on Mac. 
You would need a Windows virtual machine (VM) if you want to update
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
- Make sure your GoXLR is initialized, it should not display the full-blue state when you power it on. If it's not:
    - Connect your GoXLR to your computer
    - Run the following command on terminal: `sudo path-to-the-.app-file/Contents/Resources/goxlr-daemon`
    - Type your password when asked for
    - Wait some time for the daemon to initialize the device
    - Quit the terminal or end the process when you see the faders move and the colours change
- Unzip, move the app where you want and open it
- Go to the settings tab and click on "Create audio outputs"
- Make sure you have selected your GoXLR as the default audio output before clicking “OK”
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
[GoXlr-Utility](https://github.com/Adelenade/GoXlr-Macos/releases)! 
Without this project, the development of this application would not
have been possible.
