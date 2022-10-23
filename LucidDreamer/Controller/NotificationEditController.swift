//
//  NotificationEditController.swift
//  LucidDreamer
//
//  Created by Steven Hyun on 2021-05-15.
//

import UIKit

class NotificationEditController: UIViewController {
    
    @IBOutlet weak var notificationBar: UINavigationBar!
    
    @IBOutlet weak var datePicker: UIDatePicker!
    
    public var notification:UserNotification?
    private var isNew:Bool = false
    
    @IBOutlet weak var sunday: ToggleButton!
    @IBOutlet weak var saturday: ToggleButton!
    @IBOutlet weak var friday: ToggleButton!
    @IBOutlet weak var thursday: ToggleButton!
    @IBOutlet weak var wednesday: ToggleButton!
    @IBOutlet weak var tuesday: ToggleButton!
    @IBOutlet weak var monday: ToggleButton!
    
    @IBOutlet weak var everyDayButton: UISwitch!
    @IBOutlet weak var backButton: UIBarButtonItem!
    @IBOutlet weak var saveButton: UIBarButtonItem!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        datePicker.setValue(UIColor.white, forKey: "textColor")
        
        if notification == nil{
            isNew = true
            self.setIsOnForAll(on: true)
            self.setEnableForAll(enable: false)
            everyDayButton.setOn(true, animated: true)
        }
        else{
            isNew = false
            datePicker.date = Calendar.current.date(bySettingHour: Int(notification!.hour), minute: Int(notification!.minute), second: 0, of: Date()) ?? datePicker.date
            let daysEnabled = notification!.getDaysEnabledAsBool()
            monday.isOn = daysEnabled[0]
            tuesday.isOn = daysEnabled[1]
            wednesday.isOn = daysEnabled[2]
            thursday.isOn = daysEnabled[3]
            friday.isOn = daysEnabled[4]
            saturday.isOn = daysEnabled[5]
            sunday.isOn = daysEnabled[6]
            if daysEnabled[0] && daysEnabled[1] && daysEnabled[2] && daysEnabled[3] && daysEnabled[4] && daysEnabled[5] && daysEnabled[6]{
                everyDayButton.setOn(true, animated: true)
            }
            else{
                everyDayButton.setOn(false, animated: true)
            }
            
            
        }
        
        backButton.setTitleTextAttributes([NSAttributedString.Key.font : UIFont.systemFont(ofSize: 20)], for: .normal)
        saveButton.setTitleTextAttributes([NSAttributedString.Key.font : UIFont.systemFont(ofSize: 20)], for: .normal)
        
        notificationBar.setBackgroundImage(UIImage(), for: .default)
        notificationBar.shadowImage = UIImage()
        notificationBar.isTranslucent = true
        notificationBar.titleTextAttributes = [NSAttributedString.Key.font:UIFont.systemFont(ofSize: 20),NSAttributedString.Key.foregroundColor : UIColor.white]
        
    }
    
    @IBAction func saveButtonPressed(_ sender: Any) {
    
        if !isNew{
            if notification?.getDaysEnabledAsBool().firstIndex(of: true) == nil{
                self.performSegue(withIdentifier: "unwindToNotificationList", sender: nil)
                return
            }
        }
        
        let notificationSettingEnabled = SettingsManager.getSharedInstance().getSetting(key: "isnotificationenabled") as! Bool? ?? false
        
        
        if isNew{
            
            let pass = UserNotificationObject(hour: Int32(Calendar.current.component(.hour,from:datePicker.date)), minute: Int32(Calendar.current.component(.minute,from:datePicker.date)), identifier: UUID().uuidString, daysEnabled: [monday.isOn,tuesday.isOn,wednesday.isOn,thursday.isOn,friday.isOn,saturday.isOn,sunday.isOn], isEnabled: notificationSettingEnabled)
            
            NotificationManager.getSharedInstance().insertNewNotifications(user: pass)
            
        }
        else{
            
            do{
                try NotificationManager.getSharedInstance().updateNewNotifications(user: notification!)
            }
            catch{
                
            }
        }
        
        self.performSegue(withIdentifier: "unwindToNotificationList", sender: nil)
    }
    
    @IBAction func datePickerValueChanged(_ sender: Any) {
        notification?.hour = Int32(Calendar.current.component(.hour,from:datePicker.date))
        notification?.minute = Int32(Calendar.current.component(.minute,from:datePicker.date))
    }
    @IBAction func daysButtonPressed(_ sender: ToggleButton) {
        
        if sender.isOn{
            var text = ""
            for i in (0...6){
                if i == sender.tag{
                    text += "1,"
                }
                else{
                    text += "0,"
                }
            }
            notification?.daysEnabled = String(text.prefix(text.count-1))
        }
        else{
            notification?.daysEnabled = "0,0,0,0,0,0,0"
        }
        
        if monday !== sender{
            monday.isOn = false
        }
        if tuesday !== sender{
            tuesday.isOn = false
        }
        if wednesday !== sender{
            wednesday.isOn = false
        }
        if thursday !== sender{
            thursday.isOn = false
        }
        if friday !== sender{
            friday.isOn = false
        }
        if saturday !== sender{
            saturday.isOn = false
        }
        if sunday !== sender{
            sunday.isOn = false
        }
    }
    @IBAction func backButtonPressed(_ sender: Any) {
        self.performSegue(withIdentifier: "unwindToNotificationList", sender: nil)
    }
    
    @IBAction func everyDayToggled(_ sender: UISwitch) {
        if sender.isOn{
            self.setEnableForAll(enable: false)
            self.setIsOnForAll(on: true)
        }
        else{
            self.setEnableForAll(enable: true)
            self.setIsOnForAll(on: false)
        }
    }
    
    func setEnableForAll(enable:Bool){
        monday.isEnabled = enable
        tuesday.isEnabled = enable
        wednesday.isEnabled = enable
        thursday.isEnabled = enable
        friday.isEnabled = enable
        saturday.isEnabled = enable
        sunday.isEnabled = enable
    }
    
    func setIsOnForAll(on:Bool){
        monday.isOn = on
        tuesday.isOn = on
        wednesday.isOn = on
        thursday.isOn = on
        friday.isOn = on
        saturday.isOn = on
        sunday.isOn = on
        if on {
            notification?.daysEnabled = "1,1,1,1,1,1,1"
        }
        else{
            notification?.daysEnabled = "0,0,0,0,0,0,0"
        }
    }
}
