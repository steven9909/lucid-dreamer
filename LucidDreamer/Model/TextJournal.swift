//
//  TextJournal.swift
//  LucidDreamer
//
//  Created by Steven Hyun on 2021-05-02.
//

import Foundation

class TextJournal: Journal{
    var date: Date
    var url: URL
    
    required init(date:Date,url:URL){
        self.date = date
        self.url = url
    }
    
    func save(text: String) -> Bool{
        self.delete()
        print(self.url)
        do{
            try text.write(to: url, atomically: true, encoding: String.Encoding.utf8)
            return true
        }catch{
            print(error)
            return false
        }
    }
    
    func read() -> String?{
        do{
            return try String(contentsOf:self.url, encoding: .utf8)
        }catch{
            return nil
        }
    }
    
    static func createNewInstance() -> Journal? {
        let now = Date()
        
        let dateString = TextJournalsLoader.DATE_FORMAT.string(from: now)
        
        let date = now
        let filename = dateString+".txt"
        
        let url = TextJournalsLoader.JOURNALS_PATH?.appendingPathComponent(filename)
        
        if let nn_url = url{
            let journal:TextJournal? = TextJournal(date: date,url: nn_url)
            return journal
        }
        else{
            return nil
        }
    }
    
}
