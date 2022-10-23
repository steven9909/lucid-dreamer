//
//  TypingTextView.swift
//  LucidDreamer
//
//  Created by Steven Hyun on 2021-05-13.
//

import UIKit

class TypingTextView: UITextView{
    
    private var typingTimer:Timer?
    private var isTyping:Bool = false
    private var counter:Int = 0
    
    func typeText(content:String,clearContent:Bool = true){
        
        if isTyping {
            self.typingTimer?.invalidate()
            self.typingTimer = nil
            self.isTyping = false
            counter = 0
        }
        
        if(clearContent){
            self.text = ""
        }
        
        self.isTyping = true
        self.typingTimer = Timer.scheduledTimer(timeInterval: 0.02, target: self, selector:#selector(incrementText) , userInfo: ["data":content], repeats: true)
        
        
    }
    
    @objc private func incrementText(){
        if !(self.typingTimer?.isValid ?? false){
            return
        }
        let data = (self.typingTimer?.userInfo as! Dictionary<String, String>)["data"]!
        if self.counter == data.count{
            self.typingTimer?.invalidate()
            return
        }
        self.text = self.text + String(data[self.counter])
        self.counter += 1
    }
}
