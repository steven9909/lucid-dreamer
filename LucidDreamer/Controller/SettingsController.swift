//
//  SettingsController.swift
//  LucidDreamer
//
//  Created by Steven Hyun on 2021-05-04.
//

import UIKit

class SettingsController: UIViewController {

    private let settingsManager:SettingsManager = SettingsManager.getSharedInstance()
    
    @IBOutlet weak var backButton: UIBarButtonItem!
    @IBOutlet weak var rootView: UIView!
    
    @IBOutlet weak var navigationBar: UINavigationBar!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationBar.setBackgroundImage(UIImage(), for: .default)
        navigationBar.shadowImage = UIImage()
        navigationBar.isTranslucent = true
        navigationBar.titleTextAttributes = [NSAttributedString.Key.font:UIFont.systemFont(ofSize: 20),NSAttributedString.Key.foregroundColor : UIColor.white]
        
        backButton.setTitleTextAttributes([NSAttributedString.Key.font : UIFont.systemFont(ofSize: 20)], for: .normal)
    }
    
    @IBAction func backButtonPressed(_ sender: UIBarButtonItem) {
        self.performSegue(withIdentifier: "unwindToMenu", sender: self)
    }
    
    func showNotificationView(){
        self.performSegue(withIdentifier: "showNotificationSegue", sender: self)
    }
    
    @IBAction func unwindToSettings(sender: UIStoryboardSegue) {}
   
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        if segue.identifier == "showNotificationSegue"{
            
        }
        else if segue.identifier == "embeddedSettingsSegue"{
            (segue.destination as? SettingsTableViewController)?.delegate = self
        }
    }
    

}
