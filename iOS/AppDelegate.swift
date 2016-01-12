import UIKit
import FormTextField

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        self.window = UIWindow(frame: UIScreen.mainScreen().bounds)

        let controller = Controller()
        controller.title = "Payment Details"
        let navigationController = UINavigationController(rootViewController: controller)
        self.window?.rootViewController = navigationController
        self.window!.makeKeyAndVisible()

        return true
    }
}

 
