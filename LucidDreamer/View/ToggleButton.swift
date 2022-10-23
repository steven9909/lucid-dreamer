//
//  ToggleButton.swift
//  LucidDreamer
//
//  Created by Steven Hyun on 2021-05-15.
//

import UIKit

class ToggleButton:UIButton{
    var isOn:Bool = false {
        didSet {
            updateState()
        }
    }
    
    let onImage:UIImage? = UIImage(named:"toggle_on")
    let offImage:UIImage? = UIImage(named:"toggle_off")
    
    func updateState(){
        if isOn{
            self.setBackgroundImage(onImage, for: .normal)
        }
        else{
            self.setBackgroundImage(offImage, for: .normal)
        }
    }
    
    override func endTracking(_ touch: UITouch?, with event: UIEvent?) {
        super.endTracking(touch, with: event)
        isOn = !isOn
    }
}
