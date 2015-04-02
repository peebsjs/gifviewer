import WatchKit
import Foundation


class ButtonSelectionInterfaceController: WKInterfaceController {

    // MARK: - Storyboard
//    
    override func contextForSegueWithIdentifier(segueIdentifier: String) -> AnyObject? {
        switch segueIdentifier {
        case "ShowCat": return "cat"
        case "ShowDog": return "dog"
        case "ShowBeer": return "beer"
        case "ShowDance": return "dance"
        case "ShowEpic": return "epic"
        case "ShowFail": return "fail"
        case "ShowJump": return "jump"
        case "ShowNicolasCage": return "nicolas cage"
        case "ShowNinja": return "ninja"
        case "ShowSmile": return "smile"
        case "ShowWelcome": return "welcome"
        default: return nil
        }
    }    
}
