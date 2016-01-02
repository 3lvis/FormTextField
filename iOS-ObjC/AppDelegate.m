#import "AppDelegate.h"
#import "Controller.h"
#import "CustomStyle.h"

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    [CustomStyle apply];

    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];

    Controller *controller = [Controller new];
    self.window.rootViewController = controller;
    [self.window makeKeyAndVisible];

    return YES;
}

@end
