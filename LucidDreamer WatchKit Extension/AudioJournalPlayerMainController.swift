//
//  AudioJournalPlayerMainController.swift
//  LucidDreamer WatchKit Extension
//
//  Created by Steven Hyun on 2021-05-12.
//


import WatchKit

class AudioJournalPlayerMainController: WKInterfaceController{
    
    private var audioUrl:URL?
    
    override func awake(withContext context: Any?) {
        guard let data = context as? URL else {return}
        
        audioUrl = data
        print(audioUrl?.absoluteString ?? "audio url was nil")
    }
    
    deinit {
        print("audio journal player being deinitialized")
        do{
            if let audioUrl = audioUrl{
                if FileManager.default.fileExists(atPath: audioUrl.path){
                    print("removing audio file...")
                    try FileManager.default.removeItem(at: audioUrl)
                }
            }
        } catch {
            
        }
    }
    
}
