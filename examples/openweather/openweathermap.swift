// Generated with Jenerator : github.com/romainmenke/Jenerator

import Foundation


struct WESys {

    var sunrise : Int
    var country : String
    var message : Double
    var sunset : Int


    init(data:[String:AnyObject]) {
        self.sunrise = (data["sunrise"] as? Int) ?? 0
        self.country = (data["country"] as? String) ?? ""
        self.message = (data["message"] as? Double) ?? 0.0
        self.sunset = (data["sunset"] as? Int) ?? 0
    }

}


struct WEWeather {

    var icon : String
    var id : Int
    var main : String
    var description : String


    init(data:[String:AnyObject]) {
        self.icon = (data["icon"] as? String) ?? ""
        self.id = (data["id"] as? Int) ?? 0
        self.main = (data["main"] as? String) ?? ""
        self.description = (data["description"] as? String) ?? ""
    }

}


struct WEWind {

    var speed : Double
    var deg : Double


    init(data:[String:AnyObject]) {
        self.speed = (data["speed"] as? Double) ?? 0.0
        self.deg = (data["deg"] as? Double) ?? 0.0
    }

}


struct WEClouds {

    var all : Int


    init(data:[String:AnyObject]) {
        self.all = (data["all"] as? Int) ?? 0
    }

}


struct WECoord {

    var lon : Double
    var lat : Double


    init(data:[String:AnyObject]) {
        self.lon = (data["lon"] as? Double) ?? 0.0
        self.lat = (data["lat"] as? Double) ?? 0.0
    }

}


struct WEMain {

    var temp : Double
    var temp_min : Double
    var grnd_level : Double
    var humidity : Int
    var sea_level : Double
    var temp_max : Double
    var pressure : Double


    init(data:[String:AnyObject]) {
        self.temp = (data["temp"] as? Double) ?? 0.0
        self.temp_min = (data["temp_min"] as? Double) ?? 0.0
        self.grnd_level = (data["grnd_level"] as? Double) ?? 0.0
        self.humidity = (data["humidity"] as? Int) ?? 0
        self.sea_level = (data["sea_level"] as? Double) ?? 0.0
        self.temp_max = (data["temp_max"] as? Double) ?? 0.0
        self.pressure = (data["pressure"] as? Double) ?? 0.0
    }

}


struct WEContainer {

    var sys : WESys?
    var id : Int
    var weather : [WEWeather]
    var base : String
    var wind : WEWind?
    var clouds : WEClouds?
    var dt : Int
    var cod : Int
    var coord : WECoord?
    var main : WEMain?
    var name : String


    init(data:[String:AnyObject]) {

        if let object = data["sys"] as? [String:AnyObject] {
            self.sys = WESys(data: object)
        }
        self.id = (data["id"] as? Int) ?? 0

        self.weather = []
        if let array = data["weather"] as? [AnyObject] {
            for element in array {
                if let element = element as? [String:AnyObject] {
                    self.weather.append(WEWeather(data: element))
                }
            }
        }
        self.base = (data["base"] as? String) ?? ""

        if let object = data["wind"] as? [String:AnyObject] {
            self.wind = WEWind(data: object)
        }

        if let object = data["clouds"] as? [String:AnyObject] {
            self.clouds = WEClouds(data: object)
        }
        self.dt = (data["dt"] as? Int) ?? 0
        self.cod = (data["cod"] as? Int) ?? 0

        if let object = data["coord"] as? [String:AnyObject] {
            self.coord = WECoord(data: object)
        }

        if let object = data["main"] as? [String:AnyObject] {
            self.main = WEMain(data: object)
        }
        self.name = (data["name"] as? String) ?? ""
    }
    static func fromSource(openWeatherAppId appId:String,lat:Double,long:Double) -> WEContainer? {

        guard let url = NSURL(string: "http://api.openweathermap.org/data/2.5/weather?lat=\(lat)&lon=\(long)&appid=\(appId)"), data = NSData(contentsOfURL: url) else {
            return nil
        }
        do {
            let json = try NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.MutableContainers)
            if let dict = json as? [String:AnyObject] {
                return WEContainer(data: dict)
            }
        } catch {}
        return nil
    }

}
