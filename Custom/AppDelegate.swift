import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        CustomStyle.apply()

        self.window = UIWindow(frame: UIScreen.main.bounds)
        self.window?.rootViewController = Controller()
        self.window!.makeKeyAndVisible()

        return true
    }
}

