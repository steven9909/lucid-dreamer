//
//  AudioJournal.swift
//  LucidDreamer
//
//  Created by Steven Hyun on 2021-05-02.
//

import Foundation
import UIKit

class AudioJournal: Journal{
    
    var date: Date
    var url: URL
    
    public static let EXTENSION = ".m4a"
    
    required init(date:Date, url:URL) {
        self.date = date
        self.url = url
    }
    
    static func createNewInstance() -> Journal?{
        
        let now = Date()
        
        let dateString = AudioJournalsLoader.DATE_FORMAT.string(from: now)
        
        let date = now
        let filename = dateString+AudioJournal.EXTENSION
        
        let url = AudioJournalsLoader.JOURNALS_PATH?.appendingPathComponent(filename)
        
        if let nn_url = url{
            let journal:AudioJournal? = AudioJournal(date: date,url: nn_url)
            return journal
        }
        else{
            return nil
        }
        
    }
    
  
    
}
