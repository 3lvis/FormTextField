import UIKit
import FormTextField

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_: UIApplication, didFinishLaunchingWithOptions _: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        window = UIWindow(frame: UIScreen.main.bounds)

        let controller = Controller()
        controller.title = "Payment Details"
        let navigationController = UINavigationController(rootViewController: controller)
        window?.rootViewController = navigationController
        window!.makeKeyAndVisible()

        return true
    }
}
