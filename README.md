
# react-native-cooey

## Getting started

`$ npm install react-native-cooey --save`

### Mostly automatic installation

`$ react-native link react-native-cooey`

### Manual installation


#### iOS

1. In XCode, in the project navigator, right click `Libraries` ➜ `Add Files to [your project's name]`
2. Go to `node_modules` ➜ `react-native-cooey` and add `RNCooey.xcodeproj`
3. In XCode, in the project navigator, select your project. Add `libRNCooey.a` to your project's `Build Phases` ➜ `Link Binary With Libraries`
4. Run your project (`Cmd+R`)<

#### Android

1. Open up `android/app/src/main/java/[...]/MainActivity.java`
  - Add `import com.reactlibrary.RNCooeyPackage;` to the imports at the top of the file
  - Add `new RNCooeyPackage()` to the list returned by the `getPackages()` method
2. Append the following lines to `android/settings.gradle`:
  	```
  	include ':react-native-cooey'
  	project(':react-native-cooey').projectDir = new File(rootProject.projectDir, 	'../node_modules/react-native-cooey/android')
  	```
3. Insert the following lines inside the dependencies block in `android/app/build.gradle`:
  	```
      compile project(':react-native-cooey')
  	```


## Usage
```javascript
import RNCooey from 'react-native-cooey';

// TODO: What to do with the module?
RNCooey;
```
  