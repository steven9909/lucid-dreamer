//
//  TipsTricksController.swift
//  LucidDreamer
//
//  Created by Steven Hyun on 2021-05-06.
//

import UIKit

class TipsTricksController: UIViewController {

  
    @IBOutlet weak var contentView: UIView!
    
    @IBOutlet weak var tip1TextView: UITextView!
    @IBOutlet weak var tip2TextView: UITextView!
    @IBOutlet weak var tip3TextView: UITextView!
    @IBOutlet weak var tip4TextView: UITextView!
    @IBOutlet weak var topImageView: UIImageView!
    
    private let tip1:String = "<h1 style=\"text-align:center\">Tip #1</h1><p style=\"font-size:150%;\"><b>Don't get discouraged if you are not able to lucid dream!</b> It takes patience and practice to fully master the art of lucid dreaming. Keep trying and you will find success!</p>"
    private let tip2:String = "<h1 style=\"text-align:center\">Tip #2</h1><p style=\"font-size:150%;\"><b>Keep your dream journals active!</b> Whenever you wake up, don't move and begin recalling your dream. Focus on all of the minor details and either write them down or record them. For convenience you can ues the app to store all of your dream journal or you can write it down on a physical paper!</p>"
    private let tip3:String = "<h1 style=\"text-align:center\">Tip #3</h1><p style=\"font-size:150%;\"><b>Wake Back to Bed Method</b> is a popular method where you set your alarm clock to wake you up 5 hours after you fall asleep. The idea is that an average person will be in REM sleep after 5 hours of sleep. This app uses a combination of heart rate and motion data to wake you up during your REM sleep. After you wake up, you should try to stay awake for 10 minutes to 1 hour (although a few seconds also works for the sleep deprived). During this time you should read/listen to your dream journals and keep telling yourself that you will have a lucid dream!</p>"
    private let tip4:String = "<h1 style=\"text-align:center\">Tip #4</h1><p style=\"font-size:150%;\"><b>Do reality checks often!</b> You should select an action such as looking at your watch, looking at your hands, pinching your nose. Whatever action works for you! While performing these actions you should ask yourself, \"Am I dreaming?\". This forms a habit so that in your dream when you perform the reality check you will suddenly realize that something is not quite right. You can configure notifications to remind you to perform reality checks in the Settings page!</p>"
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        topImageView.image = UIImage.animatedImageNamed("TipsAnimation/final-", duration: 1.0)
       
        contentView.backgroundColor = UIColor.black.withAlphaComponent(0.4)
        
        tip1TextView.attributedText = tip1.htmlToAttributedString
        tip2TextView.attributedText = tip2.htmlToAttributedString
        tip3TextView.attributedText = tip3.htmlToAttributedString
        tip4TextView.attributedText = tip4.htmlToAttributedString
        
        tip1TextView.textColor = UIColor.white
        tip2TextView.textColor = UIColor.white
        tip3TextView.textColor = UIColor.white
        tip4TextView.textColor = UIColor.white
        
        tip1TextView.layer.borderWidth = 1.0
        tip1TextView.layer.borderColor = CGColor.init(red: 255, green: 255, blue: 255, alpha: 0.8)
        tip1TextView.layer.cornerRadius = 10.0
        
        tip2TextView.layer.borderWidth = 1.0
        tip2TextView.layer.borderColor = CGColor.init(red: 255, green: 255, blue: 255, alpha: 0.8)
        tip2TextView.layer.cornerRadius = 10.0
        
        tip3TextView.layer.borderWidth = 1.0
        tip3TextView.layer.borderColor = CGColor.init(red: 255, green: 255, blue: 255, alpha: 0.8)
        tip3TextView.layer.cornerRadius = 10.0
        
        tip4TextView.layer.borderWidth = 1.0
        tip4TextView.layer.borderColor = CGColor.init(red: 255, green: 255, blue: 255, alpha: 0.8)
        tip4TextView.layer.cornerRadius = 10.0
       
    }
    
    @IBAction func backButtonPressed(_ sender: Any) {
        self.performSegue(withIdentifier: "unwindToMenu", sender: self)
    }
   
    

}
