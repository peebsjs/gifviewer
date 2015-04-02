//
//  RowSelectionInterfaceController.swift
//  GifViewer
//
//  Created by Jason Peebles on 2015-04-02.
//  Copyright (c) 2015 Themis Solutions Inc. All rights reserved.
//

import WatchKit
import Foundation


class RowSelectionInterfaceController: WKInterfaceController {

    @IBOutlet private weak var table: WKInterfaceTable!
    
    let searchTitleTextPairs: [(String, String)] = [
        ("🐱" , "cat"),
        ("🐶" , "dog"),
        ("🍺" , "beer"),
        ("💃" , "dance"),
        ("Epic", "epic"),
        ("Fail" , "fail"),
        ("Jump" , "jump"),
        ("Nicolas Cage" , "nicolas cage"),
        ("Ninja" , "ninja"),
        ("Smile" , "smile"),
        ("Welcome" , "welcome")
    ]
    
    override func awakeWithContext(context: AnyObject?) {
        super.awakeWithContext(context)
        
        self.table.setNumberOfRows(self.searchTitleTextPairs.count, withRowType: "SearchTextRowController")
    
        for (index, (title, _)) in enumerate(self.searchTitleTextPairs) {
            let row = self.table.rowControllerAtIndex(index) as! SearchTextRowController
            row.label.setText(title)
        }
    }
    
    override func contextForSegueWithIdentifier(segueIdentifier: String, inTable table: WKInterfaceTable, rowIndex: Int) -> AnyObject? {
        return self.searchTitleTextPairs[rowIndex].1
    }
}
