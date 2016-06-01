# Jenerator
Create Swift Models from JSON files or API calls


Build it -> Drop somewhere in your PATH -> Profit

cmd : 

`jenerator "myJSONSource" "saveDirectory" "filename"`

Try it:

cmd : 

`jenerator "https://query.yahooapis.com/v1/public/yql?q=select%20item.condition%20from%20weather.forecast%20where%20woeid%20%3D%202487889&format=json&env=store%3A%2F%2Fdatatables.org%2Falltableswithkeys" "$HOME/Desktop/" YahooWeatherCurrent`

turns this :

```
{
 "query": {
  "count": 1,
  "created": "2016-06-01T17:31:48Z",
  "lang": "en-us",
  "results": {
   "channel": {
    "item": {
     "condition": {
      "code": "30",
      "date": "Wed, 01 Jun 2016 09:00 AM PDT",
      "temp": "64",
      "text": "Partly Cloudy"
     }
    }
   }
  }
 }
}
```

Into this : 


```
import Foundation

struct Results {

    var channel : Channel?

    init(data:[String:AnyObject]) {

        if let nested = data["channel"] as? [String:AnyObject] {
            self.channel = Channel(data: nested)
        }
    }
}

struct Channel {

    var item : Item?

    init(data:[String:AnyObject]) {

        if let nested = data["item"] as? [String:AnyObject] {
            self.item = Item(data: nested)
        }
    }
}

struct Item {

    var condition : Condition?

    init(data:[String:AnyObject]) {

        if let nested = data["condition"] as? [String:AnyObject] {
            self.condition = Condition(data: nested)
        }
    }
}

struct Query {

    var lang : String
    var created : String
    var results : Results?
    var count : Int

    init(data:[String:AnyObject]) {
        self.lang = (data["lang"] as? String) ?? ""
        self.created = (data["created"] as? String) ?? ""

        if let nested = data["results"] as? [String:AnyObject] {
            self.results = Results(data: nested)
        }
        self.count = (data["count"] as? Int) ?? 0
    }

    static func fromSource() -> Query? {
        guard let url = NSURL(string: "https://query.yahooapis.com/v1/public/yql?q=select%20item.condition%20from%20weather.forecast%20where%20woeid%20%3D%202487889&format=json&env=store%3A%2F%2Fdatatables.org%2Falltableswithkeys"), data = NSData(contentsOfURL: url) else {
            return nil
        }
        do {
            let json = try NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.MutableContainers)
            if let dict = json as? [String:AnyObject], let objectData = dict["query"] as? [String:AnyObject] {
                return Query(data: objectData)
            }
        } catch {}
        return nil
    }
}

struct Condition {

    var code : String
    var temp : String
    var text : String
    var date : String

    init(data:[String:AnyObject]) {
        self.code = (data["code"] as? String) ?? ""
        self.temp = (data["temp"] as? String) ?? ""
        self.text = (data["text"] as? String) ?? ""
        self.date = (data["date"] as? String) ?? ""
    }
}
```

The top level Type will have a `fromSource()` method that can be used to fetch the data to goes with the model. Obviously you can and should modify this to create other queries.


Note :

Swift CLI's don't like urls as arguments, will see if I can fix it in an update.
