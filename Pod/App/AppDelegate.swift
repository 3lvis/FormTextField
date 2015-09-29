import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        TextFieldDefaultStyle.apply()

        self.window = UIWindow(frame: UIScreen.mainScreen().bounds)
        self.window?.rootViewController = Controller()
        self.window!.makeKeyAndVisible()

        return true
    }
}

