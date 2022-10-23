//
//  notificationCell.swift
//  LucidDreamer
//
//  Created by Steven Hyun on 2021-05-15.
//

import UIKit

class NotificationCell: UITableViewCell {

    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var isEnabled: UISwitch!
    @IBOutlet weak var daysLabel: UILabel!
    
    public weak var superTableView: UITableView?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    @IBAction func switchValueChanged(_ sender: Any) {
        
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @IBAction func enableToggled(_ sender: UISwitch) {
        
     
        let row = superTableView?.dataSourceIndexPath(forPresentationIndexPath: superTableView?.indexPath(for: self))?.row
        guard let row = row else {return}
    
        if sender.isOn{
            if SettingsManager.getSharedInstance().getSetting(key: "isnotificationenabled") as! Bool? ?? false{
                NotificationManager.getSharedInstance().getNotificationAt(row).isEnabled = true
                NotificationManager.getSharedInstance().updateNewNotifications(at: row)
            }
            else{
                sender.setOn(false, animated: true)
            }
        }
        else{
            NotificationManager.getSharedInstance().getNotificationAt(row).isEnabled = false
            NotificationManager.getSharedInstance().updateNewNotifications(at: row)
        }
    }
}
