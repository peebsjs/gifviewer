import UIKit
import GifViewerKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    var gifSearchViewController: GifSearchViewController!

    var gifConverter: GIFConverter!
    
    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        UINavigationBar.appearance().barTintColor = UIColor.blackColor()
        let window = UIWindow(frame: UIScreen.mainScreen().bounds)
        
        self.gifSearchViewController = GifSearchViewController()
        window.rootViewController = self.gifSearchViewController
        window.makeKeyAndVisible()
        self.window = window
        
        self.gifConverter = GIFConverter()
        return true
    }
    
    func application(application: UIApplication, handleWatchKitExtensionRequest userInfo: [NSObject : AnyObject]?, reply: (([NSObject : AnyObject]!) -> Void)!) {
        if let searchText = userInfo?["text"] as? String {
            self.gifSearchViewController.performSearchWithText(searchText, completion: { (items) -> () in
                let gif = items.sample()
                let filename = gif.id
                
                self.gifConverter.exportUrl(gif.smallUrl, size: CGSizeMake(CGFloat(gif.smallWidth), CGFloat(gif.smallHeight)), suiteName: "group.com.themis.gifviewer", filename: filename, completion: { framesCount in
                    reply(["filename": filename, "framesCount": framesCount])
                })
            })
        }
    }
}   
