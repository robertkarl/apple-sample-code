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

class ViewController: NSViewController {

  @IBOutlet weak var statusLabel: NSTextField!

  @IBOutlet weak var tableView: NSTableView!
  let sizeFormatter = ByteCountFormatter()
  var directory: Directory?
  var directoryItems: [Metadata]?
  var sortOrder = Directory.FileOrder.Name
  var sortAscending = true
  
  func reloadFileList() {
    directoryItems = directory?.contentsOrderedBy(sortOrder, ascending: sortAscending)
    tableView.reloadData()
  }

  override func viewDidLoad() {
    super.viewDidLoad()
    statusLabel.stringValue = ""
    tableView.delegate = self
    tableView.dataSource = self
  }

  override var representedObject: Any? {
    didSet {
      if let url = representedObject as? URL {
        print("Represented object: \(url)")
        directory = Directory(folderURL: url)
        reloadFileList()

      }
    }
  }
}


extension ViewController: NSTableViewDataSource {
  func numberOfRows(in tableView: NSTableView) -> Int {
    directoryItems?.count ?? 0
  }
  
}

extension ViewController: NSTableViewDelegate {
  
  fileprivate enum CellIdentifiers {
    static let nameCell = NSUserInterfaceItemIdentifier("NameCellID")
    static let dateCell = NSUserInterfaceItemIdentifier("DateCellID")
    static let sizeCell = NSUserInterfaceItemIdentifier("SizeCellID")
  }
  
  func tableView(_ tableView: NSTableView,
                 viewFor tableColumn: NSTableColumn?,
                 row: Int) -> NSView? {
    var image: NSImage?
    var text = ""
    var cellID: NSUserInterfaceItemIdentifier?
    let dateFormatter = DateFormatter()
    dateFormatter.dateStyle = .long
    dateFormatter.timeStyle = .long
    guard let item = directoryItems?[row] else {
      return nil
    }
    
    if tableColumn == tableView.tableColumns[0] {
      image = item.icon
      text = item.name
      cellID = CellIdentifiers.nameCell
    }
    else if tableColumn == tableView.tableColumns[1] {
      text = dateFormatter.string(from: item.date)
      cellID = CellIdentifiers.sizeCell
      // What happens if you set image here?
    } else if tableColumn == tableView.tableColumns[2] {
      text = item.isFolder ? "--" : sizeFormatter.string(fromByteCount: item.size)
      cellID = CellIdentifiers.sizeCell
    }
    
    if let cell = tableView.makeView(withIdentifier: cellID!, owner: nil) as? NSTableCellView {
      cell.textField?.stringValue = text
      cell.imageView?.image = image
      return cell
    }

    return nil
  }
  
}
