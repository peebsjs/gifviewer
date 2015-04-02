//
//  GifSearchViewController.swift
//  GifViewer
//
//  Created by Jason Peebles on 2015-04-02.
//  Copyright (c) 2015 Themis Solutions Inc. All rights reserved.
//

import UIKit
import GifViewerKit

class GifSearchViewController: UIViewController {
    
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var collectionView: UICollectionView!
    
    var items: [Gif] = []
    
    init() {
        super.init(nibName: "GifSearchViewController", bundle: nil)
    }

    convenience required init(coder aDecoder: NSCoder) {
        self.init()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.collectionView.registerNib(UINib(nibName: "GifCell", bundle: nil), forCellWithReuseIdentifier: "GifCell")
    }
    
    func performSearchWithText(text: String) {
        self.performSearchWithText(text, completion: nil)
    }
    
    func performSearchWithText(text: String, completion: ((items: [Gif]) -> ())?) {
        self.reset()
        self.searchBar.text = text
        gifSearch(text, 25, { items in
            self.items = items
            self.collectionView.reloadData()
            
            if let completionBlock = completion {
                completionBlock(items: items)
            }
        })
    }
    
    func resetData() {
        self.items = []
        self.collectionView.reloadData()
    }
    
    func reset() {
        self.searchBar.resignFirstResponder()
        self.searchBar.text = nil
        self.resetData()
    }
    
}

extension GifSearchViewController: UISearchBarDelegate {
    
    func searchBarTextDidBeginEditing(searchBar: UISearchBar) {
        searchBar.setShowsCancelButton(true, animated: true)
    }
    
    func searchBarSearchButtonClicked(searchBar: UISearchBar) {
        self.performSearchWithText(searchBar.text)
    }
    
    func searchBarCancelButtonClicked(searchBar: UISearchBar) {
        self.reset()
    }
}

extension GifSearchViewController: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return items.count
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("GifCell", forIndexPath: indexPath) as! GifCell
        cell.url = items[indexPath.row].normalUrl
        return cell
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        let dimension = CGRectGetWidth(view.frame) / 2 - 0.5
        return CGSizeMake(dimension, dimension)
    }
    
}
