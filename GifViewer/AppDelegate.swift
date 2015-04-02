import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        let url = NSFileManager.defaultManager().containerURLForSecurityApplicationGroupIdentifier("group.com.themis.gifviewer")
        return true
    }
}

