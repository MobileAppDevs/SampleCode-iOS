# Fit: HealthKit in Action

===========================================================================

HealthKit Demo is a sample intended as a quick introduction to HealthKit. It teaches you everything from writing data into HealthKit to reading data from HealthKit. 

HealthKit Demo shows examples of using queries to retrieve information from HealthKit using HKObjectType.

HealthKit requires user's persmission to be add in info.plist.

    <key>NSHealthShareUsageDescription</key>
    <string>To show your Health Details in our app</string>
    <key>NSHealthUpdateUsageDescription</key>
    <string>To update your Health Details in iPhone App</string>


**Note:** For important guidelines that govern how you can use HealthKit and user health information in your app, see: https://developer.apple.com/app-store/review/guidelines/#healthkit.

===========================================================================
## Using the Sample

HealthKit Demo tries to emulate a fitness tracker app. The goal of this fitness app is to track the net energy burn, sleep time & step count for a given day. 

===========================================================================
## Getting Started

### Prerequisites

- **Xcode IDE:** Make sure you have installed Xcode IDE on your machine. 
### Installation

1. **Clone the repository:**

    ```bash
    git clone https://github.com/MobileAppDevs/SampleCode-iOS.git
    ```

## Build

This sample requires capabilities that are only available when run on an iOS device. Note that in order to run this sample on a device, you will need to change the bundle identifier of the application.

===========================================================================

## Requirements

- iOS 15.0+
- Xcode 12+
- Swift 4.0+

## Set Up

1. Clone this repository to your local computer.
2. Open **HealthKit Demo.xcodeproj** in Xcode. Wait for all dependencies to install and indexing to finish.
3. Run the app on an iOS device🚀

## Contributing

Contributions are welcome! Please open an issue or submit a pull request for any improvements or bug fixes.
