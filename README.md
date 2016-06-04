<p align="center">
    <a href="https://swift.org"><img src="https://img.shields.io/badge/Swift-2.3-orange.svg?style=flat" alt="Swift" /></a>
    <a href="https://swift.org"><img src="https://img.shields.io/badge/Swift-3.0-orange.svg?style=flat" alt="Swift" /></a>
    <a href="https://travis-ci.org/romainmenke/Jenerator"><img src="https://travis-ci.org/romainmenke/Jenerator.svg?branch=master" alt="Travis CI" /></a>
    <a href="https://codecov.io/gh/romainmenke/Jenerator"><img src="https://codecov.io/gh/romainmenke/Jenerator/branch/master/graph/badge.svg" alt="CodeCov" /></a>
</p>

# Jenerator
Create Swift Models from JSON files or API calls


Build it -> Drop somewhere in your PATH -> Profit

Download from releases -> Drop somewhere in your PATH -> Profit

cmd : 

`jenerator "myJSONRemoteSource" "saveDirectory" "filename" "classPrefix"`

`jenerator "myJSONLocalSource" "filename" "classPrefix"`

Try it:

cmd : 

`jenerator "https://query.yahooapis.com/v1/public/yql?q=select%20item.condition%20from%20weather.forecast%20where%20woeid%20%3D%202487889&format=json&env=store%3A%2F%2Fdatatables.org%2Falltableswithkeys" "$HOME/Desktop/" YahooWeatherCurrent YW`

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

struct YWResults {

    var channel : YWChannel?

    init(data:[String:AnyObject]) {

        if let nested = data["channel"] as? [String:AnyObject] {
            self.channel = YWChannel(data: nested)
        }
    }
}

struct YWChannel {

    var item : YWItem?

    init(data:[String:AnyObject]) {

        if let nested = data["item"] as? [String:AnyObject] {
            self.item = YWItem(data: nested)
        }
    }
}

struct YWItem {

    var condition : YWCondition?

    init(data:[String:AnyObject]) {

        if let nested = data["condition"] as? [String:AnyObject] {
            self.condition = YWCondition(data: nested)
        }
    }
}

struct YWQuery {

    var lang : String
    var created : String
    var results : YWResults?
    var count : Int

    init(data:[String:AnyObject]) {
        self.lang = (data["lang"] as? String) ?? ""
        self.created = (data["created"] as? String) ?? ""

        if let nested = data["results"] as? [String:AnyObject] {
            self.results = YWResults(data: nested)
        }
        self.count = (data["count"] as? Int) ?? 0
    }

    static func fromSource() -> YWQuery? {
        guard let url = NSURL(string: "https://query.yahooapis.com/v1/public/yql?q=select%20item.condition%20from%20weather.forecast%20where%20woeid%20%3D%202487889&format=json&env=store%3A%2F%2Fdatatables.org%2Falltableswithkeys"), data = NSData(contentsOfURL: url) else {
            return nil
        }
        do {
            let json = try NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.MutableContainers)
            if let dict = json as? [String:AnyObject], let objectData = dict["query"] as? [String:AnyObject] {
                return YWQuery(data: objectData)
            }
        } catch {}
        return nil
    }
}

struct YWCondition {

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
