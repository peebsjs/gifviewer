//
//  DetailInterfaceController.swift
//  GifOClock
//
//  Created by Pavel Dusatko on 2015-03-29.
//  Copyright (c) 2015 Themis Solutions Inc. All rights reserved.
//

import WatchKit
import Foundation

class DetailInterfaceController: WKInterfaceController {
    
    // MARK: - Properties
    
    @IBOutlet weak var imageView: WKInterfaceImage!
    
    var text: String?
    
    // MARK: - Lifecycle

    override func awakeWithContext(context: AnyObject?) {
        super.awakeWithContext(context)
        
        text = context as? String
    }

    override func willActivate() {
        super.willActivate()
        
        if let text = self.text {
            search(text)
        }
    }
    
    // MARK: - Actions
    
    func search(text: String) {
        WKInterfaceController.openParentApplication(["text" : text], reply: { (replyInfo, _) -> Void in
            if let filename = replyInfo["filename"] as? String,
                framesCount = replyInfo["framesCount"] as? Int {
                    self.showImage(filename, framesCount: framesCount)
            }
        })
    }
    
    func showImage(filename: String, framesCount: Int) {
        let containerUrl = NSFileManager.defaultManager().containerURLForSecurityApplicationGroupIdentifier("group.com.themis.gifviewer")?.URLByAppendingPathComponent("Frames", isDirectory: true)
        
        var images = [UIImage]()
        
        for index in 0..<framesCount {
            let url = containerUrl?.URLByAppendingPathComponent("\(filename)-\(index).png", isDirectory: false)
            let data = NSData(contentsOfURL: url!)
            let image = UIImage(data: data!)
            images.append(image!)
        }
        
        let animatedImage = UIImage.animatedImageWithImages(images, duration: 1)
        
        imageView.setImage(animatedImage)
        imageView.startAnimating()
    }

}
