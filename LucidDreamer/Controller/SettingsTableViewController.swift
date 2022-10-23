//
//  SettingsTableViewController.swift
//  LucidDreamer
//
//  Created by Steven Hyun on 2021-05-08.
//

import UIKit

class SettingsTableViewController: UITableViewController, UIPickerViewDataSource, UIPickerViewDelegate{
    @IBOutlet weak var pickerView: UIPickerView!
    
    public var delegate:SettingsController?
    @IBOutlet weak var usingAppleWatchSwitch: UISwitch!
    @IBOutlet weak var usingWBTBSwitch: UISwitch!
    @IBOutlet weak var usingNotificationSwitch: UISwitch!
    
    private let pickerList = ["3 hours","3.5 hours","4 hours","4.5 hours","5 hours","5.5 hours","6 hours","6.5 hours","7 hours","7.5 hours","8 hours","8.5 hours","9 hours","9.5 hours","10 hours"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.pickerView.dataSource = self
        self.pickerView.delegate = self
        
        self.tableView.sectionHeaderHeight = 50
        self.tableView.sectionFooterHeight = 20
        self.tableView.allowsSelection = false
        
        self.usingNotificationSwitch.setOn(SettingsManager.getSharedInstance().getSetting(key: "isnotificationenabled") as! Bool? ?? false, animated: true)
        self.usingWBTBSwitch.setOn(SettingsManager.getSharedInstance().getSetting(key: "wbtbenabled") as! Bool? ?? true, animated: true)
        self.usingAppleWatchSwitch.setOn(SettingsManager.getSharedInstance().getSetting(key: "isusingapplewatch") as! Bool? ?? true, animated: true)
        self.pickerView.selectRow(pickerList.firstIndex(of: SettingsManager.getSharedInstance().getSetting(key: "wbtbactivatetime") as! String? ?? pickerList[0])!, inComponent: 0, animated: true)
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 3
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return self.pickerList.count
    }
    
    func pickerView(_ pickerView: UIPickerView, attributedTitleForRow row: Int, forComponent component: Int) -> NSAttributedString? {

        return NSAttributedString(string: self.pickerList[row], attributes: [NSAttributedString.Key.foregroundColor: UIColor.white])
    }

    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        do{
            try SettingsManager.getSharedInstance().saveSetting(key: "wbtbactivatetime", data: pickerList[row])
        } catch {
            
        }
    }

    @IBAction func viewButtonPressed(_ sender: Any) {
        self.delegate?.showNotificationView()
    }
    
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let root = UIView()
        let separator = UIView(frame: CGRect(x:0,y:tableView.sectionHeaderHeight,width:tableView.frame.width,height:1))
        separator.backgroundColor = UIColor.white
        let vw = InsetLabel(frame: CGRect(x:0,y:0,width:tableView.frame.width,height:30))
        
        vw.layer.borderColor = CGColor.init(red: 255, green: 255, blue: 255, alpha: 1)
        vw.layer.borderWidth = 2.0
        vw.layer.cornerRadius = 5.0
        
        switch section {
            case 0:
                vw.text = "General"
                vw.textColor = UIColor.white
                break
            case 1:
                vw.text = "WBTB"
                vw.textColor = UIColor.white
                break
            case 2:
                vw.text = "Reality Check Notifications"
                vw.textColor = UIColor.white
                break
        default: ()
        }
        root.addSubview(vw)
        root.addSubview(separator)
        
        vw.textInsets = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        vw.sizeToFit()
        
        return root
    }
    
    override func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 20
    }
    
    override func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return UIView()
    }
 
    @IBAction func notificationValueChanged(_ sender: UISwitch) {
        do{
            try SettingsManager.getSharedInstance().saveSetting(key: "isnotificationenabled", data: sender.isOn)
            if !sender.isOn{
                try NotificationManager.getSharedInstance().removeAllNotifications()
            }
        } catch {
            print(error)
            sender.setOn(!sender.isOn, animated: true)
        }
    }
    
    @IBAction func enableWBTBValueChanged(_ sender: UISwitch) {
        do{
            try SettingsManager.getSharedInstance().saveSetting(key: "wbtbenabled", data: sender.isOn)
        } catch {
            sender.setOn(!sender.isOn, animated: true)
        }
    }
    
    @IBAction func enableAppleWatchChanged(_ sender: UISwitch) {
        do{
            try SettingsManager.getSharedInstance().saveSetting(key: "isusingapplewatch", data: sender.isOn)
        } catch {
            sender.setOn(!sender.isOn, animated: true)
        }
    }
    
}
