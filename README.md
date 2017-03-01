[![npm (scoped)](https://img.shields.io/npm/v/@cycle/core.svg)](https://github.com/MacKentoch/react-native-beacons-manager)

# react-native-state
React Native library to check device state. Focused in iOS +8.0 and Android +4.4 for now.

## Getting started

`$ npm install react-native-state --save`

### Automatic installation

`$ react-native link react-native-state`

### Manual installation


#### iOS

1. In XCode, in the project navigator, right click `Libraries` ➜ `Add Files to [your project's name]`
2. Go to `node_modules` ➜ `react-native-state` and add `RNState.xcodeproj`
3. In XCode, in the project navigator, select your project. Add `libRNState.a` to your project's `Build Phases` ➜ `Link Binary With Libraries`
4. Run your project (`Cmd+R`)<

#### Android

1. Open up `android/app/src/main/java/[...]/MainActivity.java`
  - Add `import com.ismaeld.RNStatePackage;` to the imports at the top of the file
  - Add `new RNStatePackage()` to the list returned by the `getPackages()` method
2. Append the following lines to `android/settings.gradle`:
  	```
  	include ':react-native-state'
  	project(':react-native-state').projectDir = new File(rootProject.projectDir, 	'../node_modules/react-native-state/android')
  	```
3. Insert the following lines inside the dependencies block in `android/app/build.gradle`:
  	```
      compile project(':react-native-state')
  	```


## Usage
```javascript
import State from 'react-native-state'

State.isBluetoothEnabled().then(console.log) // true|false
State.isLocationEnabled().then(console.log) // true|false
State.isLocationAuthorized().then(console.log) // true|false

```

## API
| **Method** | **Details** | **Resolve** |
| ---------- | ----------- | ----------- |
| isBluetoothEnabled    |  | *bool* |
| isLocationEnabled     | Android network and gps location take count. | *bool* |
| isLocationAuthorized  | Android always returns true. | *bool* |


## Credits

Thanks to **dpa99c** for the inspiration and cordova plugin.
https://github.com/mablack/cordova-diagnostic-plugin

## License
MIT
