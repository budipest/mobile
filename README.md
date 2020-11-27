![Budipest logo](https://github.com/danielgrgly/budipest/blob/master/github_assets/titlecard.png?raw=true)

## What's the deal with the name?

Budapest is the capital of Hungary and is our hometown. It was created in 1873 by merging Óbuda, **Buda and Pest**. **Budi**, on the other hand, is a slang word for toilets. The rest is up to you... (Alternative name ideas: Loondon, Honolua)

## App features
The app shows the toilets nearby you on a map and in a list, ordered by distance from you. It recommends you the nearest open toilet, and when selecting a toilet, you'll see the opening hours, notes and ratings of the toilet. You can also add new toilets, or edit and rate existing ones.

![App screenshots](https://github.com/danielgrgly/budipest/blob/master/github_assets/appfeatures.png?raw=true)

## Getting Started

This project has been built with Dart and Flutter, so in the first place, [you may want to get your hands dirty](https://flutter.dev/docs/get-started) with these techs before contributing to Budipest.

A few resources to get you started if this is your first Flutter project:

- [Lab: Write your first Flutter app](https://flutter.dev/docs/get-started/codelab)
- [Cookbook: Useful Flutter samples](https://flutter.dev/docs/cookbook)

### Tech stack
- Dart and Flutter
- [google_maps_flutter](https://pub.dev/packages/google_maps_flutter)


### Setting up the project

Add a Google Maps API key both for Android and iOS. For instructions on how to do this, [click here](https://stackoverflow.com/a/59834585).
For the backend, we use our own API that can be found in [this repository](https://github.com/danielgrgly/budipest-api).

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

Once you're all set with connecting an Android device to your machine, you can just run `flutter run` and expect things to be going fine.

## Contributing

All contributions are more than welcome! If you fixed a bug, developed a feature, made a new language locale or your fixed a typo, create a pull request and I'll be sure to check it out and merge it. Once you contributed a decent amount of work (more than just fixing a few typos) into the project, I'll be sure to contact you and add you to the About us section of the app if you'd wish to.
