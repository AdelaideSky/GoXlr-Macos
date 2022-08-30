<div align=center>

#  <img src="https://media.discordapp.net/attachments/756659826045485088/968640294033686619/icon_128x128.png" width="30"> GoXLR for Mac
![LastRelease](https://img.shields.io/github/release-date/Adelenade/GoXlr-Macos)
![Contributors](https://img.shields.io/github/contributors/Adelenade/GoXlr-Macos)
![OpenIssues](https://img.shields.io/github/issues-raw/Adelenade/GoXlr-Macos)
![ClosedIssues](https://img.shields.io/github/issues-closed-raw/Adelenade/GoXlr-Macos)
![Discord](https://img.shields.io/discord/1006144319289303140?label=Support%20server)
<!-- ![License](https://img.shields.io/github/license/Adelenade/GoXlr-Macos) -->
### MacOS application to manage GoXLR without virtual machine.

<img src="https://cdn.discordapp.com/attachments/756659826045485088/973891094351872010/unknown.png" width="700">
</div>

There is currently no official support for the GoXLR on MacOS provided by TC-Helicon,
however the GoXLR is compatible as a basic audio device. This project aims to bring
unofficial support for all the GoXLRs features to MacOS.

**Disclaimer:** I have absolutely no link with TC-Helicon.
I'm not affiliated with them and neither is this project.
The official driver is available on their website and any damage caused to
your device is your responsibility.


## Set up

#### Install the dependencies:

- Install libusb: `brew install libusb`

#### Set up the app:

- Download the latest [release](https://github.com/Adelenade/GoXlr-Macos/releases).
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

## Support

If you have any problem using your app and don't feel confident using github issues, you can go to this support server to ask for help !

[![Discord](https://img.shields.io/badge/%3CServer%3E-%237289DA.svg?style=for-the-badge&logo=discord&logoColor=white)](https://discord.gg/cyavp8F2WW)

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

## Sponsors

These are the super-cool sponsors of the project !

<div align=center>
<a href="https://github.com/blacksails"><img src="https://github.com/blacksails.png" width="60px" alt="Benjamin Nørgaard" /></a>
<!-- sponsors --><a href="https://github.com/brymon68"><img src="https://github.com/brymon68.png" width="60px" alt="Bryce Montano" /></a><!-- sponsors -->
</div>
