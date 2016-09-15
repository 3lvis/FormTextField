import UIKit
import FormTextField

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        self.window = UIWindow(frame: UIScreen.main.bounds)

        let controller = Controller()
        controller.title = "Payment Details"
        let navigationController = UINavigationController(rootViewController: controller)
        self.window?.rootViewController = navigationController
        self.window!.makeKeyAndVisible()

        return true
    }
}
