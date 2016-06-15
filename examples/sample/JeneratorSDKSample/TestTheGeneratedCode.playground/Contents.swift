
// Generated with Jenerator : github.com/romainmenke/Jenerator

import Foundation

/**
 *  Your Description For YWClose Goes Here
 */
class YWClose {
    
    var min : Double
    var maxDate : String
    var values : [Double]
    var max : Double
    var minDate : String
    
    init(data:[String:AnyObject]) {
        
        self.min = (data["min"] as? Double) ?? 0.0
        
        self.maxDate = (data["maxDate"] as? String) ?? ""
        
        self.values = (data["values"] as? [Double]) ?? []
        
        self.max = (data["max"] as? Double) ?? 0.0
        
        self.minDate = (data["minDate"] as? String) ?? ""
    }
}



/**
 *  Your Description For YWDataSeries Goes Here
 */
class YWDataSeries {
    
    var close : YWClose?
    
    init(data:[String:AnyObject]) {
        
        if let object = data["close"] as? [String:AnyObject] {
            self.close = YWClose(data: object)
        }
    }
}



/**
 *  Your Description For YWElements Goes Here
 */
class YWElements {
    
    var Symbol : String
    var `Type` : String
    var TimeStamp : Any?
    var DataSeries : YWDataSeries?
    var Currency : String
    
    init(data:[String:AnyObject]) {
        
        self.Symbol = (data["Symbol"] as? String) ?? ""
        
        self.`Type` = (data["Type"] as? String) ?? ""
        
        self.TimeStamp = (data["TimeStamp"] as? Any) ?? nil
        
        if let object = data["DataSeries"] as? [String:AnyObject] {
            self.DataSeries = YWDataSeries(data: object)
        }
        
        self.Currency = (data["Currency"] as? String) ?? ""
    }
}



/**
 *  Your Description For YWJenerator Goes Here
 */
class YWJenerator {
    
    var Positions : [Int]
    var Labels : Any?
    var Dates : [String]
    var Elements : [YWElements]
    
    init(data:[String:AnyObject]) {
        
        self.Positions = (data["Positions"] as? [Int]) ?? []
        
        self.Labels = (data["Labels"] as? Any) ?? nil
        
        self.Dates = (data["Dates"] as? [String]) ?? []
        
        self.Elements = []
        if let array = data["Elements"] as? [AnyObject] {
            for element in array {
                if let element = element as? [String:AnyObject] {
                    self.Elements.append(YWElements(data: element))
                }
            }
        }
    }
    
    /**
     Give this function some parameters to make the query a bit more dynamic
     
     - returns: Your Return Description Here.
     */
    static func fromSource(parameters: String?) -> YWJenerator? {
        
        let parametersEncoded = (parameters ?? "{"Normalized":false,"NumberOfDays":365,"DataPeriod":"Day","Elements":[{"Symbol":"AAPL","Type":"price","Params":["c"]}]}").stringByAddingPercentEncodingWithAllowedCharacters(NSCharacterSet.URLQueryAllowedCharacterSet()) ?? ""
        
        guard let url = NSURL(string: "http://dev.markitondemand.com/MODApis/Api/v2/InteractiveChart/json?parameters=\(parametersEncoded)"), data = NSData(contentsOfURL: url) else {
            return nil
        }
        do {
            let json = try NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.MutableContainers)
            if let dict = json as? [String:AnyObject] {
                return YWJenerator(data: dict)
            }
        } catch {}
        return nil
    }
}



