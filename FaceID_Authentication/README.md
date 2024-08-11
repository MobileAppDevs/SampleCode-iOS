# BiometricAuthentication
Use Apple Face/Touch ID authentication in your app using BiometricAuthentication.
It's very simple and easy to use that handles Touch/Face ID authentication based on the device.

**Note:** - Face ID authentication requires user's persmission to be add in info.plist.
```
<key>NSFaceIDUsageDescription</key>
<string>This app requires Face ID permission to authenticate using Face recognition.</string>
```

- Updated to Swift 5.0
- Implemented **Result** type as completion callback
- Check if **TouchID**  or **FaceID** authentication is available for iOS device.


## Features

- Works with Apple Face ID which Device's having the Touch ID.
- Automatic authentication with Face/Touch ID.

## Getting Started

### Prerequisites

- **Xcode IDE:** Make sure you have installed Xcode IDE on your machine. 
### Installation

1. **Clone the repository:**

    ```bash
    git clone https://github.com/MobileAppDevs/SampleCode-iOS.git
    
    ```


## Requirements

- iOS 15.0+
- Xcode 12+
- Swift 4.0+

## Set Up

1. Clone this repository to your local computer.
2. Open **FaceID_Authentication.xcodeproj** in Xcode. Wait for all dependencies to install and indexing to finish.
3. Run the app (on an iOS device or in the iOS simulator) 🚀

## Contributing

Contributions are welcome! Please open an issue or submit a pull request for any improvements or bug fixes.
