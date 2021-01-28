
https://www.raywenderlich.com/830-macos-nstableview-tutorial

# Gotchas

### Cell vs. View mode

There's an old legacy mode based on NSCell. If you have the NSTableView set wrong, it will just never call your 
methods to generate views.

### Column Width
You can set this in IB through the `NSTableColumn`'s "Size Inspector" tab.

