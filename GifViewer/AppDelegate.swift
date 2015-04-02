import UIKit
import GifViewerKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    var gifConverter: GIFConverter!
    
    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        //Customize appearance
        UINavigationBar.appearance().barTintColor = UIColor.blackColor()
        
        self.gifConverter = GIFConverter()
        return true
    }
    
    
    func application(application: UIApplication, handleWatchKitExtensionRequest userInfo: [NSObject : AnyObject]?, reply: (([NSObject : AnyObject]!) -> Void)!) {
        gifSearch(userInfo?["search.text"] as! String, { items in
            let gif = items.sample()
            let filename = gif.id
            self.gifConverter.exportUrl(gif.smallUrl, size: CGSizeMake(CGFloat(gif.smallWidth), CGFloat(gif.smallHeight)), suiteName: "group.com.themis.gifviewer", filename: filename, completion: { framesCount in
                reply(["search.filename": filename, "search.framesCount": framesCount])
            })
        })
    }
}   

