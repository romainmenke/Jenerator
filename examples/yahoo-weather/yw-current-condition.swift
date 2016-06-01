// https://developer.yahoo.com/weather/


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
    
    static func fromSource(withWoeID woeid:String) -> YWQuery? {
        guard let url = NSURL(string: "https://query.yahooapis.com/v1/public/yql?q=select%20item.condition%20from%20weather.forecast%20where%20woeid%20%3D%20\(woeid)&format=json&env=store%3A%2F%2Fdatatables.org%2Falltableswithkeys"), data = NSData(contentsOfURL: url) else {
            return nil
        }
        do {
            let json = try NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.MutableContainers)
            if let outerDict = json as? [String:AnyObject], let dict = outerDict["query"] as? [String:AnyObject] {
                return YWQuery(data: dict)
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
