# THIS REPOSITORY HAS BEEN ARCHIVED. We moved the Budipest-related repositories into a dedicated organisation, and placed the apps into a monorepo. The new GitHub repository can be found here: [https://github.com/budipest/mono](https://github.com/budipest/mono)


# Budipest | [App Store](https://apps.apple.com/us/app/budipest/id1544448699) | [Google Play](https://play.google.com/store/apps/details?id=com.dnlgrgly.budipest) | [Facebook](https://facebook.com/budipestapp)

![Budipest cover image with logo](./github_assets/cover.jpeg?raw=true)

## What's the deal with the name?

Budapest is the capital of Hungary and is our hometown. It was created in 1873 by merging Óbuda, **Buda and Pest**. **Budi**, on the other hand, is a slang word for toilets. The rest is up to you... (Alternative name ideas would include Loondon or Honolua)

## App features
Budipest is a community-based toilet finder app that seeks to alleviate the problem of public toilets in Hungary by making existing toilets more visible, and displaying restrooms in clubs and bars that are open to anyone.

The main features of Budipest:
- See restrooms around you on a map and in a list
- Check the opening hours of restrooms, and their main features (eg. free or paid, price of entry, accessibility, etc.)
- Rate toilets or add helpful comments to them
- Anyone can add new toilets to the app

![App screenshots and description](./github_assets/features.png?raw=true)

## Getting Started

This project has been built with Dart and Flutter, so in the first place, [you may want to get your hands dirty](https://flutter.dev/docs/get-started) with these technologies before contributing to Budipest.

A few resources to get you started if this is your first Flutter project:

- [Lab: Write your first Flutter app](https://flutter.dev/docs/get-started/codelab)
- [Cookbook: Useful Flutter samples](https://flutter.dev/docs/cookbook)

### Tech stack
- Dart and Flutter
- [google_maps_flutter](https://pub.dev/packages/google_maps_flutter)

### Setting up the project

Add a Google Maps API key both for Android and iOS. For instructions on how to do this, [click here](https://stackoverflow.com/a/59834585).
For the backend, we use our own API that can be found in [this repository](https://github.com/dnlgrgly/budipest-api).

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

We created Budipest with our small team in our spare time, so any help is welcome. If you fixed a bug, made a new feature, translated the app for a new language or just fixed a typo, create a pull request and I'll be sure to check it out and merge it once it's ready to be merged.
If you want to contribute but don't have any feature ideas, check out our [Trello board](https://trello.com/b/EZNASMNg/budipest). (If you find a card that seems interesting and isn't translated to Hungarian, don't hesitate to contact us!)
