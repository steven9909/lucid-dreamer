//
//  SettingsManager.swift
//  LucidDreamer WatchKit Extension
//
//  Created by Steven Hyun on 2021-05-18.
//

import Foundation

class SettingsManager{
    
    private static let sharedInstance = SettingsManager()
    private let defaults = UserDefaults.standard
    
    public static let VALID_SETTINGS_KEY = ["wbtbenabled","wbtbactivatetime","isnotificationenabled","isusingapplewatch"]
    
    private init(){
       
    }
    
    public static func getSharedInstance() -> SettingsManager{
        return sharedInstance
    }
    
    
    func saveSetting(key:String,data:Any) throws{
        defaults.set(data,forKey:key)
    }
    
    func getSetting(key:String) -> Any?{
        return defaults.value(forKey: key)
    }
    

}
