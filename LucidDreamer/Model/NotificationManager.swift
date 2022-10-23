//
//  NotificationManager.swift
//  LucidDreamer
//
//  Created by Steven Hyun on 2021-05-10.
//

import UIKit
import CoreData

class NotificationError:Error{
    
}

protocol NotificationManagerObserver:AnyObject{
    func notificationsChanged()
}

/**
 todo: Add concurrency protection around notifications list
 */
class NotificationManager{
    private static var manager:NotificationManager = NotificationManager()
    
    public weak var notify:NotificationManagerObserver?
    
    private lazy var notifications:[UserNotification] = {
        guard let appDelegate =
            UIApplication.shared.delegate as? AppDelegate else {
            return []
          }
          
        let managedContext =
        appDelegate.persistentContainer.viewContext

        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "UserNotification")
        do{
            let fetchedObjects = try managedContext.fetch(fetchRequest)
            return fetchedObjects as! [UserNotification]
        } catch {
            return []
        }
        
    }()
    
    private init(){
        
    }

    
    static func getSharedInstance() -> NotificationManager{
        return manager
    }
    
    func addObserver(obs:NotificationManagerObserver){
        self.notify = obs
    }
    
    func count()-> Int {
        return notifications.count
    }
    
    func insertNewNotifications(user:UserNotificationObject) {
        guard let appDelegate =
            UIApplication.shared.delegate as? AppDelegate else {
            return
          }
          
        let managedContext =
        appDelegate.persistentContainer.viewContext
        
        let entity = NSEntityDescription.entity(forEntityName: "UserNotification", in: managedContext)
        let newNotification = NSManagedObject(entity: entity!, insertInto:managedContext)
        
        newNotification.setValue(user.hour,forKey:"hour")
        newNotification.setValue(user.minute,forKey:"minute")
        newNotification.setValue(user.identifier,forKey:"identifier")
        newNotification.setValue(user.daysEnabled.map { (val:Bool) in
                                 return val == true ? "1" : "0"
                             }.joined(separator: ","),forKey:"daysEnabled")
        newNotification.setValue(user.isEnabled,forKey:"isEnabled")
        
        self.addNotification(user: newNotification as! UserNotification) { [weak self] (error:Error?) in
            if error == nil{
                do {
                    try managedContext.save()
                    self?.notifications.append(newNotification as! UserNotification)
                    self?.notify?.notificationsChanged()
                } catch {
                    self?.removeNotification(identifier: (newNotification as! UserNotification).identifier!)
                }
                
            }
            
        }
        
       
        
        
    }
    
    func isDuplicateNotification(user:UserNotification) -> Bool{
        var counter = 0
        for notification in notifications{
            if notification.hour == user.hour && notification.minute == user.minute{
                counter += 1
            }
        }
        
        return counter >= 2
    }
    
    public func removeNotification(_ at:Int){
        UNUserNotificationCenter.current().removeDeliveredNotifications(withIdentifiers: [notifications[at].identifier!])
        UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: [notifications[at].identifier!])
    }
    
    public func removeNotification(identifier:String){
        UNUserNotificationCenter.current().removeDeliveredNotifications(withIdentifiers: [identifier])
        UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: [identifier])
    }
    
    public func addNotification(at:Int, handler: @escaping (Error?) -> Void){
        self.addNotification(user: notifications[at], handler: handler)
    }
    
    private func addNotification(user:UserNotification, handler: @escaping (Error?) -> Void){
        
        self.removeNotification(identifier: user.identifier!)
        
        if !user.isEnabled{
            handler(nil)
            return
        }
        
        var dateComponents = DateComponents()
        dateComponents.calendar = Calendar.current
        
        let index = user.getDaysEnabledAsBool().firstIndex(of: true)
        
        guard var index = index else {
            handler(NotificationError())
            return
        }
        index = index + 2
        if index == 8{
            index = 1
        }
        dateComponents.weekday = index
        dateComponents.hour = Int(user.hour)
        dateComponents.minute = Int(user.minute)
        
        let content = UNMutableNotificationContent()
        content.title = "Reality check!"
        content.subtitle = "Remember to ask yourself: Am I dreaming?"
        
        let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: true)
        let request = UNNotificationRequest(identifier: user.identifier!, content: content, trigger: trigger)
        UNUserNotificationCenter.current().add(request) { (error:Error?) in
            handler(error)
        }
        
    }
    
    func removeAllNotifications() throws{
        
        guard let appDelegate =
            UIApplication.shared.delegate as? AppDelegate else {
            return
          }
          
        let managedContext = appDelegate.persistentContainer.viewContext
        
        var previousState:[Bool] = []
        
        for notif in notifications{
            previousState.append(notif.isEnabled)
            notif.isEnabled = false
        }
        
        do{
            
            try managedContext.save()
            
            UNUserNotificationCenter.current().removeAllDeliveredNotifications()
            UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
            
            self.notify?.notificationsChanged()
            
        } catch {
            for (index,notif) in notifications.enumerated(){
                notif.isEnabled = previousState[index]
            }
            throw error
        }

    }
    
    func deleteNotificationAt(_ index:Int) {
        
        guard let appDelegate =
            UIApplication.shared.delegate as? AppDelegate else {
            return
          }
          
        let managedContext = appDelegate.persistentContainer.viewContext
        managedContext.delete(notifications[index])
        
        let identifier = notifications[index].identifier!
        
        do{
            try managedContext.save()
            removeNotification(identifier: identifier)
            notifications.remove(at: index)
            self.notify?.notificationsChanged()
        } catch {
            
        }
    }
    
    func getNotificationAt(_ index:Int) -> UserNotification{
        return notifications[index]
    }
    
    func updateNewNotifications(at:Int) {
        updateNewNotifications(user: notifications[at])
    }
    
    func updateNewNotifications(user:UserNotification){
        guard let appDelegate =
            UIApplication.shared.delegate as? AppDelegate else {
            return
          }
          
        let managedContext = appDelegate.persistentContainer.viewContext
        
        self.addNotification(user: user) { [weak self] (error:Error?) in
            if error == nil{
                do {
                    try managedContext.save()
                    self?.notify?.notificationsChanged()
                } catch {
                    self?.removeNotification(identifier: user.identifier!)
                    user.isEnabled = false
                    self?.notify?.notificationsChanged()
                }
            }
        }
      
    }
    

    
    
    
}
