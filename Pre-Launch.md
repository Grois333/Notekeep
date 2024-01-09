# Pre-launch Android Deploy todo list: (update this to add to Readme or seperated file)

- Follow the steps in Google Play console

- Github link about privacy policy of the app

- Short description of the app

- Full description of the app

- App Icon image 512x512

- Feature Graphic image (app icon plus some text 1024x500)

- Video of app in youtube link

- Screenshots:
 *install adb
 *screenshots terminal command: `adb exec-out screencap -p > fileX.png`
 *tablet screenshot

- Create a release app: https://docs.flutter.dev/deployment/android
 *Create an upload keystore: 
 *Reference the keystore from the app
 *Git ignore the android/key.properties file
 *Configure signing in gradle

-Cleaning app and build bundle:
 * `flutter clean`
 * `flutter pub get`
 * `flutter build appbundle`

- Production countries:
 *In Google Play console unde Production, add all the countries for release

- Rollout to Production to release the app and wait

 