#  GoXlr for Mac
### Macos app for managing GoXlr without any VM

For now, full control & compatibility is not possible on mac, you still need a windows vm if you want to update colors, mic & effects but - unlike what TC-helicon said, the device is perfectly compatible with Macos and this app shows it.

Oh also, I have absolutely no link with TC-Helicon, i'm not affiliated with them and this project too. The official driver is on their website and it's not their responsability if there is any damage to your device (GoXlr/GoXlr mini)

## Warning

This project is at an really early state, and is not really ready for use. I'm working on a solution to make it easier to install, use and add more capabilities. So if you're not friendly with the terminal and with command lines, this project isn't for you for now.

## Installation

#### Install the dependices : 

- Install [Rust](https://rustup.rs/) : `curl https://sh.rustup.rs -sSf | sh`
- Install libusb : `brew install libusb`
- Install (& build) [GoXlr-Utility](https://github.com/GoXLR-on-Linux/GoXLR-Utility) so:
    - Run in the folder of your choice: `git clone https://github.com/GoXLR-on-Linux/GoXLR-Utility.git`
    - `cd GoXLR-Utility`
    - `cargo build` (or `cargo install --path daemon` & `cargo install --path client`)

#### Install the App:

- Download the latest [release](https://github.com/Adelenade/GoXlr-Macos/releases)
- Unzip, move the app where you want and open it
- Go to the settings tab and click "Create audio outputs"
- Verify that you selected your GoXlr as default audio output
- Enjoy !

## Notes

- The GoXlr can be initialized without restarting (no need to reboot each time your device loose power)
- The app itselfs do no more than provide a graphic control of the GoXlr-Utility that you've installed below, and creating the sound outputs.

## ToDo

- Synchronize sliders and pickers with the actual physical configuration of the GoXlr
- Add Chat mic / broadcast mix support (mic in general)
- Add other features of the GoXlr (profiles, colors, micro etc)
- Create custom plugin to communicate directly with the GoXlr without need to use another project
- Many more.
