import Flutter
import UIKit
import GoogleMaps

@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    GeneratedPluginRegistrant.register(with: self)

    GMSServices.provideAPIKey("AIzaSyDsLxsd0qDWOO1ANXC-mSzpzYS7V-PahhA")

      guard let pluginRegisterar = self.registrar(forPlugin: "Runner") else { return false }

      let factory = FLNativeViewFactory(messenger: pluginRegisterar.messenger())
      pluginRegisterar.register(
          factory,
          withId: "congratulation_view")

    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
}
