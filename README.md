#  <img src="https://media.discordapp.net/attachments/756659826045485088/968640294033686619/icon_128x128.png" width="30"> GoXlr for Mac
### MacOS app for managing GoXlr without any VM.

<img src="https://cdn.discordapp.com/attachments/756659826045485088/973891094351872010/unknown.png" width="700">

For now, full control & compatibility is not possible on mac, you still need a windows VM if you want to update colours, mic & effects but - unlike what TC-helicon said, the device is perfectly compatible with Macos and this app shows it.

Oh also, I have absolutely no link with TC-Helicon, i'm not affiliated with them and neither is this project. The official driver is on their website and it's not their responsibility if there is any damage to your device (GoXlr/GoXlr mini).

## Installation

#### Install the dependencies:

- Install libusb: `brew install libusb`

#### Install the app:

- Download the latest [release](https://github.com/Adelenade/GoXlr-Macos/releases)
- Open the .pkg and install the app.
- If your GoXlr is plugged-in, unplug it and plug it.
- Wait few seconds and launch the app
- IF THE APP CRASHES:
    - Run the command `killall goxlr-daemon`
    - Wait few seconds & launch the app again.
- Go to the settings tab and click "Create audio outputs"
- Verify that you selected your GoXlr as default audio output before clicking “OK”
- Enjoy !

## Notes

- The GoXlr can be initialised without restarting (no need to reboot each time your device loses power)
- The app itself does no more than provide a graphic control of the GoXlr-Utility that you've installed below, and creating the sound outputs.

## ToDo

- Synchronise sliders and pickers with the actual physical configuration of the GoXlr (it’s actually not the REAL data but quite)
- Add chat mic / broadcast mix support (all mic system in general)
- Add other features of the GoXlr (lightning, samples, micros, fx…)
- Many more...


## Credits

- A lot of love to the devs of the [GoXlr-Utility](https://github.com/Adelenade/GoXlr-Macos/releases) ! Without that project, that app would not be possible.
