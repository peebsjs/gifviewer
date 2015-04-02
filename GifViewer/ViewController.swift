//
//  ViewController.swift
//  GifViewer
//
//  Created by Jason Peebles on 2015-04-02.
//  Copyright (c) 2015 Themis Solutions Inc. All rights reserved.
//

import UIKit
import GifViewerKit

class ViewController: UIViewController {
    
    // MARK: - Properties
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    var items = [Gif]()
    
    // MARK: - Lifecycle
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        let titleView = self.navigationItem.titleView
        titleView?.frame = CGRectMake(0, 0, CGRectGetWidth(view.frame), CGRectGetHeight(titleView!.frame))
        self.navigationItem.titleView = titleView
    }
    
}

extension ViewController: UISearchBarDelegate {
    
    func searchBarTextDidBeginEditing(searchBar: UISearchBar) {
        searchBar.setShowsCancelButton(true, animated: true)
    }
    
    func searchBarTextDidEndEditing(searchBar: UISearchBar) {
        searchBar.setShowsCancelButton(false, animated: true)
    }
    
    func searchBarSearchButtonClicked(searchBar: UISearchBar) {
        gifSearch(searchBar.text, 100, { items in
            self.items = items
            self.collectionView.reloadData()
        })
    }
    
    func searchBarCancelButtonClicked(searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }
    
}

extension ViewController: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
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

