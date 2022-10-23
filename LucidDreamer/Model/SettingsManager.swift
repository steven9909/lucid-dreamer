//
//  SettingsManager.swift
//  LucidDreamer
//
//  Created by Steven Hyun on 2021-05-04.
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
        try WatchSession.getSharedInstance().sendSettingsToWatch(key: key, value: data)
    }
    
    func getSetting(key:String) -> Any?{
        return defaults.value(forKey: key)
    }
    

}
