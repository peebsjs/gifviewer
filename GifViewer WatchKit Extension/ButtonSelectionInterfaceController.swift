import WatchKit
import Foundation


class ButtonSelectionInterfaceController: WKInterfaceController {

    // MARK: - Storyboard
//    
    override func contextForSegueWithIdentifier(segueIdentifier: String) -> AnyObject? {
        return segueIdentifier
    }
}
