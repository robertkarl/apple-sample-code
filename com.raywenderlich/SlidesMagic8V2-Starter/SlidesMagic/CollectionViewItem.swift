//
//  CollectionViewItem.swift
//  SlidesMagic
//
//  Created by Robert Karl on 12/13/20.
//  Copyright © 2020 razeware. All rights reserved.
//

import Cocoa

class CollectionViewItem: NSCollectionViewItem {

  var imageFile: ImageFile? {
    didSet {
      guard isViewLoaded else { return }
      if let imageFile = imageFile {
        imageView?.image = imageFile.thumbnail
        textField?.stringValue = imageFile.fileName
      }
      else {
        imageView?.image = nil
        textField?.stringValue = ""
      }
    }
  }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.wantsLayer = true
        view.layer?.backgroundColor = NSColor.lightGray.cgColor
    }
}
