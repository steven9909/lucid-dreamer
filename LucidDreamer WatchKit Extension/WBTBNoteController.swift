//
//  WBTBNoteController.swift
//  LucidDreamer WatchKit Extension
//
//  Created by Steven Hyun on 2021-05-17.
//

import WatchKit

class WBTBNoteController: WKInterfaceController {

    @IBOutlet weak var textLabel: WKInterfaceLabel!
    
    let text = "You have started your WBTB session. The app will attempt to wake you up in \(SettingsManager.getSharedInstance().getSetting(key: "wbtbactivatetime") as! String? ?? "3 hours") at a point where you are deemed to be in REM sleep. After you wake up, remember to stay awake for 5 minutes before going to bed again. During the time that you are awake, you should write down any dreams that you have had and look through your dream journal."
    
    override func awake(withContext context: Any?) {
        textLabel.setText(text)
    }
}
