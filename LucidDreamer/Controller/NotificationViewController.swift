//
//  NotificationViewController.swift
//  LucidDreamer
//
//  Created by Steven Hyun on 2021-05-10.
//

import UIKit

class NotificationViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, NotificationManagerObserver{

    @IBOutlet weak var notificationBar: UINavigationBar!
    
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var addButton: UIBarButtonItem!
    @IBOutlet weak var backButton: UIBarButtonItem!
    
    private var selectedIndex:Int?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        notificationBar.setBackgroundImage(UIImage(), for: .default)
        notificationBar.shadowImage = UIImage()
        notificationBar.isTranslucent = true
        notificationBar.titleTextAttributes = [NSAttributedString.Key.font:UIFont.systemFont(ofSize: 20),NSAttributedString.Key.foregroundColor : UIColor.white]
        
        
        tableView.delegate = self
        tableView.dataSource = self
     
        let cell = UINib(nibName: "NotificationCell", bundle: nil)
        tableView.register(cell, forCellReuseIdentifier: "NotificationCell")
        
        NotificationManager.getSharedInstance().addObserver(obs: self)
        
        backButton.setTitleTextAttributes([NSAttributedString.Key.font : UIFont.systemFont(ofSize: 20)], for: .normal)
        addButton.setTitleTextAttributes([NSAttributedString.Key.font : UIFont.systemFont(ofSize: 20)], for: .normal)
    }
    
    @IBAction func backButtonPressed(_ sender: Any) {
        self.performSegue(withIdentifier: "unwindToSettings", sender: nil)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "NotificationCell") as? NotificationCell {
            let notification = NotificationManager.getSharedInstance().getNotificationAt(indexPath.row)
            cell.isEnabled.setOn(notification.isEnabled,animated:true)
            cell.timeLabel.text = "\(notification.hour):\(notification.minute)"
            cell.daysLabel.text = notification.getDaysEnabledAsReadableString()
            cell.backgroundColor = UIColor.clear
            cell.superTableView = self.tableView
   
            return cell
        }
        
        return UITableViewCell()
    }
    
    func notificationsChanged() {
        DispatchQueue.main.async{
            self.tableView.reloadData()
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return NotificationManager.getSharedInstance().count()
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete{
            guard let index = self.tableView.dataSourceIndexPath(forPresentationIndexPath: indexPath)?.row else {return}
            NotificationManager.getSharedInstance().deleteNotificationAt(index)
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedIndex = self.tableView.dataSourceIndexPath(forPresentationIndexPath: indexPath)?.row
        self.tableView.deselectRow(at: indexPath, animated: true)
        self.performSegue(withIdentifier: "notificationEditSegue", sender: nil)
    }
    
    
    
    
  
    @IBAction func addButtonPressed(_ sender: Any) {
        selectedIndex = nil
        self.performSegue(withIdentifier: "notificationEditSegue", sender: nil)
    }
    
    @IBAction func unwindToNotificationList(sender: UIStoryboardSegue) {}
  
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "notificationEditSegue"{
            guard let index = selectedIndex else {return}
            (segue.destination as! NotificationEditController).notification = NotificationManager.getSharedInstance().getNotificationAt(index)
        }
    }
    

}
