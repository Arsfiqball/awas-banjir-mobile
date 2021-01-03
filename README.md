# Awas Banjir Mobile
Flutter based mobile app to support [awas-banjir-cloud](https://github.com/Arsfiqball/awas-banjir-cloud) in flood potential monitoring system.

![Shots](/awas_banjir_mobile_preview.gif)

## Setup

1. Download and install [Android Studio][1].
2. Install [Flutter SDK][2].
3. Install [VS CODE][3].
4. Install Flutter VS Code Extension by going to VS Code > Select **View** > **Command Palette** > Type "install" > Select **Extensions: Install Extensions.** > Search for "flutter" and click **Install**.
5. Activate [Developer Option][4] and USB Debugging in your phone (if you don't want to use emulator).
6. Setup your [Firebase Cloud Messaging][5] service to get `google-services.json` file and put it into `/android/app` directory.
7. Create `.env` file in root directory for environment variables. Available variables are:
   * `API_BASE`: API URI hostname including scheme, e.g: `https://awas-banjir.arsfiqball.com`

> If you are running Ubuntu or Debian based Linux, I highly recommend using Snap to install Flutter SDK and VS Code

[1]: https://developer.android.com/studio#downloads
[2]: https://flutter.dev/docs/get-started/install
[3]: https://code.visualstudio.com/download
[4]: https://developer.android.com/studio/debug/dev-options
[5]: https://firebase.google.com/docs/cloud-messaging

## Develop & Build Bundle

1. Open your project in VS CODE.
2. Connect your phone.
3. Press F5 to run dev app.
4. Open Terminal in VS CODE, and run `flutter build apk` to build `.apk` file.
5. Your released bundle app will be available in `/build/app/outputs/apk/release/app-release.apk`

## Maintainer

Iqbal Mohammad Abdul Ghoni / [@Arsfiqball](https://github.com/Arsfiqball)
