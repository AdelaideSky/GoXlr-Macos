#  <img src="https://media.discordapp.net/attachments/756659826045485088/968640294033686619/icon_128x128.png" width="30"> GoXlr for Mac
### Macos app for managing GoXlr without any VM

For now, full control & compatibility is not possible on mac, you still need a windows VM if you want to update colors, mic & effects but - unlike what TC-helicon said, the device is perfectly compatible with Macos and this app shows it.

Oh also, I have absolutely no link with TC-Helicon, i'm not affiliated with them and neither is this project. The official driver is on their website and it's not their responsibility if there is any damage to your device (GoXlr/GoXlr mini).

## Warning

This project is at a really early stage, and is not really ready for use. I'm working on a solution to make it easier to install, use and to add more functionalities. So if you're not friendly with the terminal and with command lines, this project isn't for you (for now).

## Installation

#### Install the dependices:

- Install [Rust](https://rustup.rs/): `curl https://sh.rustup.rs -sSf | sh`
- Install libusb: `brew install libusb`
- Install (& build) [GoXlr-Utility](https://github.com/GoXLR-on-Linux/GoXLR-Utility):
    - Run in the folder of your choice: `git clone https://github.com/GoXLR-on-Linux/GoXLR-Utility.git`
    - `cd GoXLR-Utility`
    - `cargo build` (or `cargo install --path daemon` & `cargo install --path client`)

#### Install the app:

- Download the latest [release](https://github.com/Adelenade/GoXlr-Macos/releases)
- Unzip, move the app where you want and open it
- Go to the settings tab and click "Create audio outputs"
- Verify that you selected your GoXlr as default audio output
- Enjoy !

## Notes

- The GoXlr can be initialized without restarting (no need to reboot each time your device loses power)
- The app itselfs does no more than provide a graphic control of the GoXlr-Utility that you've installed below, and creating the sound outputs.

## ToDo

- Synchronize sliders and pickers with the actual physical configuration of the GoXlr
- Add chat mic / broadcast mix support (all mic system in general)
- Add other features of the GoXlr (profiles, colors, micro etc)
- Create a custom plugin to communicate directly with the GoXlr without the need to use another project
- Many more.
