# Budipest

<img src="https://github.com/danielgrgly/budipest/blob/master/assets/icons/icon.png?raw=true" alt="Budipest logo with slogan" height="100" width="100" >

Budipest is a community-based toilet finder app.

## What's the deal with the name?

Budapest is the capital of Hungary and is our hometown. It was created in 1873 by merging Óbuda, **Buda and Pest**. **Budi**, on the other hand, is a slang word for toilets. The rest is up to you...

## Getting Started

This project has been built with Dart and Flutter, so in the first place, [you may want to get your hands dirty](https://flutter.dev/docs/get-started) with these techs before contributing to Budipest.

A few resources to get you started if this is your first Flutter project:

- [Lab: Write your first Flutter app](https://flutter.dev/docs/get-started/codelab)
- [Cookbook: Useful Flutter samples](https://flutter.dev/docs/cookbook)

### Setting up the project

For the backend, we use Firebase. We use Firebase Databases, Anonymous Authentication, and Analytics. To configure it, create a Firebase project and [follow this documentation](https://firebase.google.com/docs/flutter/setup). **Make sure that you run over these docs for all of your desired build platforms!**

### Running on iOS

Make sure you have a connected device. If you want to use a Simulator and have Xcode installed, run:

```bash
open -a Simulator.app
```

While you wait for your device to start up, install native iOS dependencies. This step is only needed once:

```bash
cd ios
pod install
cd ..
```

(Oh, and if you don't have CocoaPods installed, [download it!](https://cocoapods.org/))

And once it's all done, run

```bash
flutter run
```

### Running on Android

Once you're all set with the Firebase thingy and made sure that there is an Android device connected to your machine, you can just run `flutter run` and expect things to be going fine.

## Contributing

All contributions are more than welcome! If you fixed a bug, developed a feature, made a new language locale or your fixed a typo, create a pull request and I'll be sure to check it out and merge it. Once you contributed a decent amount of work (more than just fixing a few typos) into the project, I'll be sure to contact you and add you to the About us section of the app if you'd wish to.
