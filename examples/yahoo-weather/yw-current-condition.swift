// Generated with Jenerator : github.com/romainmenke/Jenerator

import Foundation


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


struct YWItem {
    
    var condition : YWCondition?
    
    
    init(data:[String:AnyObject]) {
        
        if let object = data["condition"] as? [String:AnyObject] {
            self.condition = YWCondition(data: object)
        }
    }
    
}


struct YWChannel {
    
    var item : YWItem?
    
    
    init(data:[String:AnyObject]) {
        
        if let object = data["item"] as? [String:AnyObject] {
            self.item = YWItem(data: object)
        }
    }
    
}


struct YWResults {
    
    var channel : YWChannel?
    
    
    init(data:[String:AnyObject]) {
        
        if let object = data["channel"] as? [String:AnyObject] {
            self.channel = YWChannel(data: object)
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
        
        if let object = data["results"] as? [String:AnyObject] {
            self.results = YWResults(data: object)
        }
        self.count = (data["count"] as? Int) ?? 0
    }
    
}


struct YWContainer {
    
    var query : YWQuery?
    
    
    init(data:[String:AnyObject]) {
        
        if let object = data["query"] as? [String:AnyObject] {
            self.query = YWQuery(data: object)
        }
    }
    static func fromSource(withWoeID woeid:String) -> YWContainer? {
        
        guard let url = NSURL(string: "https://query.yahooapis.com/v1/public/yql?q=select%20item.condition%20from%20weather.forecast%20where%20woeid%20%3D%\(woeid)&format=json&env=store%3A%2F%2Fdatatables.org%2Falltableswithkeys"), data = NSData(contentsOfURL: url) else {
            return nil
        }
        do {
            let json = try NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.MutableContainers)
            if let dict = json as? [String:AnyObject] {
                return YWContainer(data: dict)
            }
        } catch {}
        return nil
    }
    
}


// YWContainer.fromSource(withWoeID: "202487889")?.query?.results?.channel?.item?.condition?.temp