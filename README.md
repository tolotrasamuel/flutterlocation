# Flutter Location Plugin [![pub package](https://img.shields.io/pub/v/location.svg)](https://pub.dartlang.org/packages/location)

This plugin for [Flutter](https://flutter.io)
handles getting location on Android and iOS. It also provides callbacks when location is changed.

<p align="center">
  <img src="https://raw.githubusercontent.com/Lyokone/flutterlocation/master/src/demo_readme.gif" alt="Demo App" style="margin:auto" width="372" height="686">
</p>

# Breaking Changes
As of the 2.0 version, you have to call the returned location is an LocationData Object. You can just access the different attribute like so : location.latitude.
See the API part of the README for the changes.
This version also switched to AndroidX instead of the old Android Support library. In order to use it you have to do the following things:

Update your gradle.properties file with this:
```
android.enableJetifier=true
android.useAndroidX=true
org.gradle.jvmargs=-Xmx1536M
```

Please also make sure that you have those dependencies in your build.gradle:
```
  dependencies {
      classpath 'com.android.tools.build:gradle:3.3.0'
      classpath 'com.google.gms:google-services:4.2.0'
  }
...
  compileSdkVersion 28
```


## Getting Started
### Android
In order to use this plugin in Android, you have to add this permission in AndroidManifest.xml :
```xml
<uses-permission android:name="android.permission.ACCESS_FINE_LOCATION" />
```
Permission check for Android 6+ was added. Still no callback when permissions granted
so aiming SDK 21 is safer.

### iOS
And to use it in iOS, you have to add this permission in Info.plist :
```xml
NSLocationWhenInUseUsageDescription
NSLocationAlwaysUsageDescription
```
**Warning:** there is a currently a bug in iOS simulator in which you have to manually select a Location several in order for the Simulator to actually send data. Please keep that in mind when testing in iOS simulator.  

### Sample Code
Then you just have to import the package with
```dart
import 'package:location/location.dart';
```

Look into the example for utilisation, but a basic implementation can be done like this for a one time location :
```dart
var currentLocation = LocationData;

var location = new Location();

// Platform messages may fail, so we use a try/catch PlatformException.
try {
  currentLocation = await location.getLocation();
} on PlatformException catch (e) {
  if (e.code == 'PERMISSION_DENIED') {
    error = 'Permission denied';
  } 
  currentLocation = null;
}
```

You can also get continuous callbacks when your position is changing:
```dart
var location = new Location();

location.onLocationChanged().listen((LocationData currentLocation) {
  print(currentLocation.latitude);
  print(currentLocation.longitude);
  print(currentLocation.accuracy);
  print(currentLocation.altitude);
  print(currentLocation.speed);
  print(currentLocation.speed_accuracy); // Will always be 0 on iOS
  print(currentLocation.heading);
});
```

## API
In this table you can find the different functions exposed by this plugin:

| Methods |Description|
|--------|-----|
| Future\<bool> **requestPermission()** | Request the Location permission. Return a boolean to know if the permission has been granted. |
| Future\<bool> **hasPermission()** | Return a boolean to know the state of the location permission. |
| Future\<LocationData> **getLocation()** | Allow to get a one time position of the user. It will try to request permission if not granted yet and will throw a `PERMISSION_DENIED` error code if permission still not granted. |
| Stream\<LocationData> **onLocationChanged()** | Get the stream of the user's location. It will try to request permission if not granted yet and will throw a `PERMISSION_DENIED` error code if permission still not granted. |
  
You should try to manage permission manually with `requestPermission()` to avoid error, but plugin will try handle some cases for you.

### Objects
```dart
class LocationData {
  final double latitude;
  final double longitude;
  final double accuracy;
  final double altitude;
  final double speed; // In meters/second
  final double speedAccuracy;
  final double heading;
}
 ```


## Feedback

Please feel free to [give me any feedback](https://github.com/Lyokone/flutterlocation/issues)
helping support this plugin !
