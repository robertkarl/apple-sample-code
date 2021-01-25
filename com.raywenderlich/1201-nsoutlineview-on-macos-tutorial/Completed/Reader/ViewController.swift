/*
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
import WebKit

class ViewController: NSViewController {
  
  @IBOutlet weak var webView: WebView!
  @IBOutlet weak var outlineView: NSOutlineView!
  
  let dateFormatter = DateFormatter()

  required init?(coder: NSCoder) {
    super.init(coder: coder)
    if let filePath = Bundle.main.path(forResource: "Feeds", ofType: "plist") {
      feeds = Feed.feedList(filePath)
      print(feeds)
    }
    dateFormatter.dateStyle = .short
  }
  var feeds = [Feed]()
  override func viewDidLoad() {
    super.viewDidLoad()
  }
  
}

extension ViewController: NSOutlineViewDataSource {
  func outlineView(_ outlineView: NSOutlineView, numberOfChildrenOfItem item: Any?) -> Int {
    if let feed = item as? Feed {
      return feed.children.count
    }
    return feeds.count
  }
  
  func outlineView(_ outlineView: NSOutlineView, child index: Int, ofItem item: Any?) -> Any {
    if let feed = item as? Feed {
      return feed.children[index]
    }
    return feeds[index]
  }
  
  func outlineView(_ outlineView: NSOutlineView, isItemExpandable item: Any) -> Bool {
    if let feed = item as? Feed {
      return feed.children.count > 0
    }
    return false
  }

}

let feedCellId = NSUserInterfaceItemIdentifier("FeedCell")
let feedItemCellId = NSUserInterfaceItemIdentifier("FeedItemCell")
let dateCellId = NSUserInterfaceItemIdentifier("DateCell")
let dateColumnId = NSUserInterfaceItemIdentifier("DateColumn")

extension ViewController : NSOutlineViewDelegate {
  

  func outlineView(_ outlineView: NSOutlineView, viewFor tableColumn: NSTableColumn?, item: Any) -> NSView? {
    var view: NSTableCellView?
    
    if let feed = item as? Feed {
      view = outlineView.makeView(withIdentifier: feedCellId,
                                  owner: self) as? NSTableCellView
      if let textField = view?.textField {
        textField.stringValue = feed.name
        textField.sizeToFit()
      }
    }
    else if let feedItem = item as? FeedItem {
      if tableColumn?.identifier == dateColumnId {
        view = outlineView.makeView(withIdentifier: dateCellId, owner: self) as? NSTableCellView
        if let textField = view?.textField {
          textField.stringValue = dateFormatter.string(from: feedItem.publishingDate)
          textField.sizeToFit()
        }
      }
      else {
        view = outlineView.makeView(withIdentifier: feedItemCellId, owner: self) as? NSTableCellView
        if let textField = view?.textField {
          textField.stringValue = feedItem.title
          textField.sizeToFit()
        }
      }

    }
    return view
  }
}
