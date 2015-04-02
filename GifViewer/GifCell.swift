//
//  GifCell.swift
//  GifOClock
//
//  Created by Pavel Dusatko on 2015-03-26.
//  Copyright (c) 2015 Themis Solutions Inc. All rights reserved.
//

import UIKit

class GifCell: UICollectionViewCell {
    
    // MARK: - Properties
    
    var session = NSURLSession.sharedSession()
    var task: NSURLSessionDataTask?
    
    var url: NSURL? {
        didSet {
            self.task = self.session.dataTaskWithURL(url!, completionHandler: { data, _, _ in
                dispatch_async(dispatch_get_main_queue(), {
                    let animatedImageView = self.viewWithTag(666) as! FLAnimatedImageView
                    animatedImageView.animatedImage = FLAnimatedImage(animatedGIFData: data)
                })
            })
            self.task?.resume()
        }
    }
    
    // MARK: - Lifecycle
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        //Cancel previous task
        self.task?.cancel()
        
        //Clear image view
        let animatedImageView = viewWithTag(666) as! FLAnimatedImageView
        animatedImageView.image = nil
    }
    
}
