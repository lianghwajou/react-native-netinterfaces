
# react-native-netinterfaces

## Getting started

`$ npm install react-native-netinterfaces --save`

### Mostly automatic installation

`$ react-native link react-native-netinterfaces`

### Manual installation


#### iOS

1. In XCode, in the project navigator, right click `Libraries` ➜ `Add Files to [your project's name]`
2. Go to `node_modules` ➜ `react-native-netinterfaces` and add `RNNetinterfaces.xcodeproj`
3. In XCode, in the project navigator, select your project. Add `libRNNetinterfaces.a` to your project's `Build Phases` ➜ `Link Binary With Libraries`
4. Run your project (`Cmd+R`)<

#### Android

1. Open up `android/app/src/main/java/[...]/MainActivity.java`
  - Add `import com.reactlibrary.RNNetinterfacesPackage;` to the imports at the top of the file
  - Add `new RNNetinterfacesPackage()` to the list returned by the `getPackages()` method
2. Append the following lines to `android/settings.gradle`:
  	```
  	include ':react-native-netinterfaces'
  	project(':react-native-netinterfaces').projectDir = new File(rootProject.projectDir, 	'../node_modules/react-native-netinterfaces/android')
  	```
3. Insert the following lines inside the dependencies block in `android/app/build.gradle`:
  	```
      compile project(':react-native-netinterfaces')
  	```

#### Windows
[Read it! :D](https://github.com/ReactWindows/react-native)

1. In Visual Studio add the `RNNetinterfaces.sln` in `node_modules/react-native-netinterfaces/windows/RNNetinterfaces.sln` folder to their solution, reference from their app.
2. Open up your `MainPage.cs` app
  - Add `using Netinterfaces.RNNetinterfaces;` to the usings at the top of the file
  - Add `new RNNetinterfacesPackage()` to the `List<IReactPackage>` returned by the `Packages` method


## Usage
```javascript
import RNNetinterfaces from 'react-native-netinterfaces';

// TODO: What to do with the module?
RNNetinterfaces;
```
  