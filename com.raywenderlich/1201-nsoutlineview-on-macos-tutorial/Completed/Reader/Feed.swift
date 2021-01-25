import Cocoa

class Feed: NSObject {
  let name: String
  var children = [FeedItem]()
  init(name: String) {
    self.name = name
  }
  
  class func feedList(_ fileName: String) -> [Feed] {
    var feeds = [Feed]()
    guard let feedList = NSArray(contentsOfFile: fileName) as? [NSDictionary] else {
      return feeds
    }
    for feedItems in feedList {
      let feed = Feed(name: feedItems.object(forKey: "name") as! String)
      let items = feedItems.object(forKey:  "items") as! [NSDictionary]
      for dict in items {
        let item = FeedItem(dictionary: dict)
        feed.children.append(item)
      }
      feeds.append(feed)
    }
    return feeds
  }

}


class FeedItem: NSObject {
  let url: String
  let title: String
  let publishingDate: Date
  init(dictionary: NSDictionary) {
    self.url = dictionary.object(forKey: "url") as! String
    self.title = dictionary.object(forKey: "title") as! String
    self.publishingDate = dictionary.object(forKey: "date") as! Date
  }
}
