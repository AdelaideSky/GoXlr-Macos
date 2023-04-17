# ``GoXlrKit``

GoXlrKit allows accessing to the status of every GoXLR connected, as well as sending commands to the connected GoXLRs. This module also brings controls on the GoXlr-utility itself.

## Overview

This module uses the GoXlr-Utility tools to bring control over a GoXlr device in Swift. 
It provides:

- A main GoXlr class, grouping all the module's functionalities.
- A Daemon manager, providing controls over the goxlr-utility (*requires adding the goxlr-daemon binary to the module's Resources.*)
- A Websocket manager, allowing to connect/disconnect and send raw commands to the daemon's websocket.
- When connected to the websocket, a Status struct containing every values provided by the daemon. This status struct manages updating the hardware values of the goxlr too.

## Topics

### Articles
- <doc:GetStarted>

### Models

- ``GoXlr``
- ``DaemonWSocket``
- ``Daemon``
- ``StatusClass``
