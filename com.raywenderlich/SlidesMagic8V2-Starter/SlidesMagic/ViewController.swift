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

fileprivate let collectionViewId = NSUserInterfaceItemIdentifier(rawValue: "CollectionViewItem")

class ViewController: NSViewController {
  
  @IBOutlet weak var collectionView: NSCollectionView!
  
  let imageDirectoryLoader = ImageDirectoryLoader()

  func configureCollectionView() {
    let flowlayout = NSCollectionViewFlowLayout()
    flowlayout.itemSize = NSSize(width: 160, height: 140)
    flowlayout.sectionInset = NSEdgeInsets(top: 10, left: 20, bottom: 10, right: 20)
    flowlayout.minimumInteritemSpacing = 20
    flowlayout.minimumLineSpacing = 20
    collectionView.collectionViewLayout = flowlayout
    view.wantsLayer = true
    collectionView.layer?.backgroundColor = NSColor.black.cgColor
  }

  override func viewDidLoad() {
    super.viewDidLoad()
    let initialFolderUrl = URL(fileURLWithPath: "/System/Library/Desktop Pictures", isDirectory: true)
    imageDirectoryLoader.loadDataForFolderWithUrl(initialFolderUrl)
    configureCollectionView()
  }
  
  func loadDataForNewFolderWithUrl(_ folderURL: URL) {
    imageDirectoryLoader.loadDataForFolderWithUrl(folderURL)
    collectionView.reloadData()
  }
  
  @IBAction func showHideSections(sender: NSButton) {
    let show = sender.state
    imageDirectoryLoader.singleSectionMode = (show == .off)
    imageDirectoryLoader.setupDataForUrls(nil)
    collectionView.reloadData()
  }


}



extension ViewController: NSCollectionViewDataSource {
  func numberOfSections(in collectionView: NSCollectionView) -> Int {
    imageDirectoryLoader.numberOfSections
  }
  
  func collectionView(_ collectionView: NSCollectionView, numberOfItemsInSection section: Int) -> Int {
    imageDirectoryLoader.numberOfItemsInSection(section)
  }
  
  func collectionView(_ collectionView: NSCollectionView,
                      itemForRepresentedObjectAt indexPath: IndexPath) -> NSCollectionViewItem {
    
    let item = collectionView.makeItem(withIdentifier: collectionViewId, for: indexPath)
    guard let collectionViewItem = item as? CollectionViewItem else {
      return item
    }
    collectionViewItem.imageFile = imageDirectoryLoader.imageFileForIndexPath(indexPath)
    return collectionViewItem
  }
}
