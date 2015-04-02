//
//  InterfaceController.swift
//  GifViewer WatchKit Extension
//
//  Created by Jason Peebles on 2015-04-02.
//  Copyright (c) 2015 Themis Solutions Inc. All rights reserved.
//

import WatchKit
import Foundation


class InterfaceController: WKInterfaceController {

    // MARK: - Storyboard
    
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
        case "ShowPanda": return "panda"
        case "ShowParty": return "party"
        case "ShowReaction": return "reaction"
        case "ShowSmile": return "smile"
        case "ShowWelcome": return "welcome"
        default: return nil
        }
    }
    
    // MARK: - Actions
    
    @IBAction func showTextInput() {
        presentTextInputControllerWithSuggestions(nil, allowedInputMode: .Plain) { input in
            if input != nil {
                self.presentControllerWithName("DetailController", context: input)
            }
        }
    }

}
