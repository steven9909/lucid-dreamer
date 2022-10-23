//
//  UserNotificationObject.swift
//  LucidDreamer
//
//  Created by Steven Hyun on 2021-05-14.
//

import Foundation

extension UserNotification{
   
    private static let DAYS_ENABLED_MAPPING = [0:"M",1:"T",2:"W",3:"Th",4:"F",5:"Sa",6:"Su"]
    
    public func getDaysEnabledAsBool() -> [Bool]{
        return daysEnabled!.split(separator: ",").map({ (ss:Substring) in
            return ss == "1"
        })
    }
    public func getDaysEnabledAsReadableString() -> String{
        var text:String = ""
        
        for (index,val) in getDaysEnabledAsBool().enumerated(){
            if val {
                text += UserNotification.DAYS_ENABLED_MAPPING[index]! + ","
            }
        }
        
        if text.count == 0{
            return ""
        }
        
        return String(text.prefix(text.count-1))
    }
    
}

class UserNotificationObject{
    
    private static let DAYS_ENABLED_MAPPING = [0:"M",1:"T",2:"W",3:"Th",4:"F",5:"Sa",6:"Su"]
    
    public var hour:Int32
    public var minute:Int32
    public var identifier:String
    public var daysEnabled:[Bool]
    public var isEnabled:Bool
    
    init(hour:Int32,minute:Int32,identifier:String,daysEnabled:[Bool],isEnabled:Bool){
        self.hour = hour
        self.minute = minute
        self.identifier = identifier
        self.daysEnabled = daysEnabled
        self.isEnabled = isEnabled
    }
    
    
    
}
