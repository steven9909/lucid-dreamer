//
//  ViewController.swift
//  LucidDreamer
//
//  Created by Steven Hyun on 2021-04-30.
//

import UIKit

class MainMenuController: UIViewController {

    @IBOutlet weak var backgroundImageView: UIImageView!
    
    var orientations = UIInterfaceOrientationMask.portrait
    
    override var supportedInterfaceOrientations : UIInterfaceOrientationMask {
        get { return self.orientations }
        set { self.orientations = newValue }
    }
    
    @IBOutlet weak var explainImageView: UIImageView!
    @IBOutlet var rootView: UIView!
    @IBOutlet weak var settingsButton: UIButton!
    @IBOutlet weak var tipsAndTricksButton: UIButton!
    @IBOutlet weak var journalsButton: UIButton!
    
    private lazy var firstLaunchLoader:FirstLaunchManager = {
        return FirstLaunchManager(for:[self.journalsButton,self.tipsAndTricksButton,self.settingsButton],root:self.rootView,explanations: ["Keeping a dream journal is a very important part of lucid dreaming. You can either keep your journals here in this app or physically write your dream journal instead. The imporant part is to keep writing or recording all of your dreams that you had right after you wake up!","To read more about how to lucid dream, be sure to visit this section for some assistance!","Click on the settings page to personalize the app to your own likings!"])
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
      
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if(UIViewController.isFirstLaunch() && !firstLaunchLoader.isPrepared()){
            firstLaunchLoader.prepare()
            rootView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.rootViewClicked)))
        }
    }
    
    @objc func rootViewClicked(){
        firstLaunchLoader.showNext()
    }

    @IBAction func mainMenuButtonClicked(_ sender: UIButton) {
        
        switch sender.tag{
            case 1:
                self.performSegue(withIdentifier: "journalListSegue", sender: nil)
                break
            case 2:
                self.performSegue(withIdentifier: "tipsTricksSegue", sender: nil)
                break
            case 3:
                self.performSegue(withIdentifier: "settingsSegue", sender: nil)
                break
            default:
                break
        }
    }
    
    @IBAction func unwindToMenu(sender: UIStoryboardSegue) {}
}

