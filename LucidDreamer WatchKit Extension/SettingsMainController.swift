//
//  SettingsMainController.swift
//  LucidDreamer WatchKit Extension
//
//  Created by Steven Hyun on 2021-05-18.
//

import WatchKit

class SettingsMainController: WKInterfaceController {

    @IBOutlet weak var picker: WKInterfacePicker!
    
    @IBOutlet weak var notificationSwitch: WKInterfaceSwitch!
    
    private static let list = ["3 hours","3.5 hours","4 hours","4.5 hours","5 hours","5.5 hours","6 hours","6.5 hours","7 hours","7.5 hours","8 hours","8.5 hours","9 hours","9.5 hours","10 hours"]
    
    private let pickerList:[WKPickerItem] = {
      
        return SettingsMainController.list.map { (data:String) in
            let item = WKPickerItem()
            item.title = data
            return item
        }
    }()
  
    
    @IBAction func notificationValueChanged(_ value: Bool) {
        
    }
    override func awake(withContext context: Any?) {
        picker.setItems(pickerList)
        picker.setSelectedItemIndex(SettingsMainController.list.firstIndex(of:SettingsManager.getSharedInstance().getSetting(key: "wbtbactivatetime") as! String? ?? SettingsMainController.list[0])!)
        
        notificationSwitch.setOn(SettingsManager.getSharedInstance().getSetting(key: "isnotificationenabled") as! Bool? ?? false)
    }
}
