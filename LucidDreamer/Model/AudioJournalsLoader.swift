//
//  AudioJournalList.swift
//  LucidDreamer
//
//  Created by Steven Hyun on 2021-05-02.
//

import Foundation
import UIKit

class AudioJournalsLoader: JournalsLoader{
    
    public static let FOLDER_NAME: String = "AudioRecordings"
    
    public static let JOURNALS_PATH:URL? = {
        
        let paths = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)
        let docUrl = URL(string:paths[0])!.appendingPathComponent(AudioJournalsLoader.FOLDER_NAME)
        
        do{
            try FileManager.default.createDirectory(atPath: docUrl.path, withIntermediateDirectories: true, attributes: nil)
            return docUrl
        } catch {
            NSLog("Unable to create directory for audio journal")
            return nil
        }
    
    }()
    
    public static let DATE_FORMAT:DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .long
        formatter.timeStyle = .medium
        return formatter
    }()
    
    
    public func loadJournalsFromFS() -> [Journal]{
        
        do{
            var audioJournals = [AudioJournal]()
            let files = try FileManager.default.contentsOfDirectory(at:AudioJournalsLoader.JOURNALS_PATH!, includingPropertiesForKeys: nil)
            
            let filenames = files.map{$0.deletingPathExtension().lastPathComponent}
            
            for i in 0..<files.count{
                audioJournals.append(AudioJournal(date: AudioJournalsLoader.DATE_FORMAT.date(from: filenames[i])!,url: files[i]))
            }
         
            return audioJournals.sorted(by: {$0.date > $1.date})
        } catch {
            return []
        }
    }
    
}
