// http://query.yahooapis.com/v1/public/yql?q=select%20*%20from%20geo.places%20where%20text%3D%22Place%20Antwerp%22&format=json

import Foundation

struct WISouthWest {

    var longitude : String
    var latitude : String

    init(data:[String:AnyObject]) {
        self.longitude = (data["longitude"] as? String) ?? ""
        self.latitude = (data["latitude"] as? String) ?? ""
    }
}

struct WILocality1 {

    var woeid : String
    var content : String
    var type : String

    init(data:[String:AnyObject]) {
        self.woeid = (data["woeid"] as? String) ?? ""
        self.content = (data["content"] as? String) ?? ""
        self.type = (data["type"] as? String) ?? ""
    }
}

struct WICountry {

    var code : String
    var content : String
    var woeid : String
    var type : String

    init(data:[String:AnyObject]) {
        self.code = (data["code"] as? String) ?? ""
        self.content = (data["content"] as? String) ?? ""
        self.woeid = (data["woeid"] as? String) ?? ""
        self.type = (data["type"] as? String) ?? ""
    }
}

struct WIAdmin1 {

    var code : String
    var content : String
    var woeid : String
    var type : String

    init(data:[String:AnyObject]) {
        self.code = (data["code"] as? String) ?? ""
        self.content = (data["content"] as? String) ?? ""
        self.woeid = (data["woeid"] as? String) ?? ""
        self.type = (data["type"] as? String) ?? ""
    }
}

struct WIQuery {

    var lang : String
    var created : String
    var results : WIResults?
    var count : Int

    init(data:[String:AnyObject]) {
        self.lang = (data["lang"] as? String) ?? ""
        self.created = (data["created"] as? String) ?? ""

        if let nested = data["results"] as? [String:AnyObject] {
            self.results = WIResults(data: nested)
        }
        self.count = (data["count"] as? Int) ?? 0
    }

    static func fromSource(withPlaceName placeName : String) -> WIQuery? {
        guard let url = NSURL(string: "http://query.yahooapis.com/v1/public/yql?q=select%20*%20from%20geo.places%20where%20text%3D%22Place%20\(placeName)%22&format=json"), data = NSData(contentsOfURL: url) else {
            return nil
        }
        do {
            let json = try NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.MutableContainers)
            if let outerDict = json as? [String:AnyObject], let dict = outerDict["query"] as? [String:AnyObject] {
                return WIQuery(data: dict)
            }
        } catch {}
        return nil
    }
}

struct WICentroid {

    var longitude : String
    var latitude : String

    init(data:[String:AnyObject]) {
        self.longitude = (data["longitude"] as? String) ?? ""
        self.latitude = (data["latitude"] as? String) ?? ""
    }
}

struct WITimezone {

    var woeid : String
    var content : String
    var type : String

    init(data:[String:AnyObject]) {
        self.woeid = (data["woeid"] as? String) ?? ""
        self.content = (data["content"] as? String) ?? ""
        self.type = (data["type"] as? String) ?? ""
    }
}

struct WIResults {

    var place : [WIPlace]

    init(data:[String:AnyObject]) {

        self.place = []
        if let arrayOfNested = data["place"] as? [[String:AnyObject]] {
            for element in arrayOfNested {
                self.place.append(WIPlace(data: element))
            }
        }
    }
}

struct WIAdmin2 {

    var code : String
    var content : String
    var woeid : String
    var type : String

    init(data:[String:AnyObject]) {
        self.code = (data["code"] as? String) ?? ""
        self.content = (data["content"] as? String) ?? ""
        self.woeid = (data["woeid"] as? String) ?? ""
        self.type = (data["type"] as? String) ?? ""
    }
}

struct WIBoundingBox {

    var northEast : WINorthEast?
    var southWest : WISouthWest?

    init(data:[String:AnyObject]) {

        if let nested = data["northEast"] as? [String:AnyObject] {
            self.northEast = WINorthEast(data: nested)
        }

        if let nested = data["southWest"] as? [String:AnyObject] {
            self.southWest = WISouthWest(data: nested)
        }
    }
}

struct WINorthEast {

    var longitude : String
    var latitude : String

    init(data:[String:AnyObject]) {
        self.longitude = (data["longitude"] as? String) ?? ""
        self.latitude = (data["latitude"] as? String) ?? ""
    }
}

struct WIPlace {

    var woeid : String
    var uri : String
    var locality1 : WILocality1?
    var country : WICountry?
    var popRank : String
    var admin1 : WIAdmin1?
    var yahoo : String
    var centroid : WICentroid?
    var name : String
    var lang : String
    var timezone : WITimezone?
    var xmlns : String
    var locality2 : Any
    var admin2 : WIAdmin2?
    var boundingBox : WIBoundingBox?
    var placeTypeName : WIPlaceTypeName?
    var postal : Any
    var admin3 : Any
    var areaRank : String

    init(data:[String:AnyObject]) {
        self.woeid = (data["woeid"] as? String) ?? ""
        self.uri = (data["uri"] as? String) ?? ""

        if let nested = data["locality1"] as? [String:AnyObject] {
            self.locality1 = WILocality1(data: nested)
        }

        if let nested = data["country"] as? [String:AnyObject] {
            self.country = WICountry(data: nested)
        }
        self.popRank = (data["popRank"] as? String) ?? ""

        if let nested = data["admin1"] as? [String:AnyObject] {
            self.admin1 = WIAdmin1(data: nested)
        }
        self.yahoo = (data["yahoo"] as? String) ?? ""

        if let nested = data["centroid"] as? [String:AnyObject] {
            self.centroid = WICentroid(data: nested)
        }
        self.name = (data["name"] as? String) ?? ""
        self.lang = (data["lang"] as? String) ?? ""

        if let nested = data["timezone"] as? [String:AnyObject] {
            self.timezone = WITimezone(data: nested)
        }
        self.xmlns = (data["xmlns"] as? String) ?? ""
        self.locality2 = (data["locality2"] as? Any) ?? nil

        if let nested = data["admin2"] as? [String:AnyObject] {
            self.admin2 = WIAdmin2(data: nested)
        }

        if let nested = data["boundingBox"] as? [String:AnyObject] {
            self.boundingBox = WIBoundingBox(data: nested)
        }

        if let nested = data["placeTypeName"] as? [String:AnyObject] {
            self.placeTypeName = WIPlaceTypeName(data: nested)
        }
        self.postal = (data["postal"] as? Any) ?? nil
        self.admin3 = (data["admin3"] as? Any) ?? nil
        self.areaRank = (data["areaRank"] as? String) ?? ""
    }
}

struct WIPlaceTypeName {

    var content : String
    var code : String

    init(data:[String:AnyObject]) {
        self.content = (data["content"] as? String) ?? ""
        self.code = (data["code"] as? String) ?? ""
    }
}

struct WIPostal {

    var woeid : String
    var content : String
    var type : String

    init(data:[String:AnyObject]) {
        self.woeid = (data["woeid"] as? String) ?? ""
        self.content = (data["content"] as? String) ?? ""
        self.type = (data["type"] as? String) ?? ""
    }
}
