/*
* ViewController.swift
* SlidesMagic
*
* Created by Gabriel Miro on Oct 2016.
* Copyright (c) 2016 Razeware LLC
*
* Permission is hereby granted, free of charge, to any person obtaining a copy
* of this software and associated documentation files (the "Software"), to deal
* in the Software without restriction, including without limitation the rights
* to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
* copies of the Software, and to permit persons to whom the Software is
* furnished to do so, subject to the following conditions:
*
* The above copyright notice and this permission notice shall be included in
* all copies or substantial portions of the Software.
*
* THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
* IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
* FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
* AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
* LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
* OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
* THE SOFTWARE.
*/

import Cocoa

class ViewController: NSViewController {
  
  @IBOutlet weak var collectionView: NSCollectionView!
  
  let imageDirectoryLoader = ImageDirectoryLoader()

  override func viewDidLoad() {
    super.viewDidLoad()
    let initialFolderUrl = URL(fileURLWithPath: "/Library/Desktop Pictures", isDirectory: true)
    imageDirectoryLoader.loadDataForFolderWithUrl(initialFolderUrl)
    configureCollectionView()
  }
  
  func loadDataForNewFolderWithUrl(_ folderURL: URL) {
    imageDirectoryLoader.loadDataForFolderWithUrl(folderURL)
    collectionView.reloadData()
  }
  
  fileprivate func configureCollectionView() {
    let flowLayout = NSCollectionViewFlowLayout()
    flowLayout.itemSize = NSSize(width: 160.0, height: 140.0)
    flowLayout.sectionInset = EdgeInsets(top: 30.0, left: 20.0, bottom: 30.0, right: 20.0)
    flowLayout.minimumInteritemSpacing = 20.0
    flowLayout.minimumLineSpacing = 20.0
    flowLayout.sectionHeadersPinToVisibleBounds = true
    collectionView.collectionViewLayout = flowLayout
    view.wantsLayer = true
    collectionView.layer?.backgroundColor = NSColor.black.cgColor
  }

  @IBAction func showHideSections(sender: NSButton) {
    let show = sender.state
    imageDirectoryLoader.singleSectionMode = (show == NSOffState)
    imageDirectoryLoader.setupDataForUrls(nil)
    collectionView.reloadData()
  }
}

extension ViewController : NSCollectionViewDataSource {
  
  func numberOfSections(in collectionView: NSCollectionView) -> Int {
    return imageDirectoryLoader.numberOfSections
  }
  
  func collectionView(_ collectionView: NSCollectionView, numberOfItemsInSection section: Int) -> Int {
    return imageDirectoryLoader.numberOfItemsInSection(section)
  }
  
  func collectionView(_ itemForRepresentedObjectAtcollectionView: NSCollectionView, itemForRepresentedObjectAt indexPath: IndexPath) -> NSCollectionViewItem {
    
    let item = collectionView.makeItem(withIdentifier: "CollectionViewItem", for: indexPath)
    guard let collectionViewItem = item as? CollectionViewItem else {return item}
    
    let imageFile = imageDirectoryLoader.imageFileForIndexPath(indexPath)
    collectionViewItem.imageFile = imageFile
    
    return item
  }
  
  func collectionView(_ collectionView: NSCollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> NSView {
    let view = collectionView.makeSupplementaryView(ofKind: NSCollectionElementKindSectionHeader, withIdentifier: "HeaderView", for: indexPath) as! HeaderView
    view.sectionTitle.stringValue = "Section \(indexPath.section)"
    let numberOfItemsInSection = imageDirectoryLoader.numberOfItemsInSection(indexPath.section)
    view.imageCount.stringValue = "\(numberOfItemsInSection) image files"
    return view
  }
  
}

extension ViewController : NSCollectionViewDelegateFlowLayout {
  func collectionView(_ collectionView: NSCollectionView, layout collectionViewLayout: NSCollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> NSSize {
    return imageDirectoryLoader.singleSectionMode ? NSZeroSize : NSSize(width: 1000, height: 40)
  }
}
