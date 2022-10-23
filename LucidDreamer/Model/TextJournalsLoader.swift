//
//  TextJournalsLoader.swift
//  LucidDreamer
//
//  Created by Steven Hyun on 2021-05-02.
//

import Foundation

class TextJournalsLoader: JournalsLoader{
    public static let FOLDER_NAME: String = "TextRecordings"
    
    public static let JOURNALS_PATH:URL? = {
        
        let docUrl = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent(TextJournalsLoader.FOLDER_NAME)
        if let dir = docUrl{
            do{
                try FileManager.default.createDirectory(atPath: dir.path, withIntermediateDirectories: true, attributes: nil)
                return dir
            } catch {
                NSLog("Unable to create directory for text journal")
                return nil
            }
        }
        return nil
    }()
    
    public static let DATE_FORMAT:DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .long
        formatter.timeStyle = .medium
        return formatter
    }()
    
    public func loadJournalsFromFS()  -> [Journal]{
        do{
            var textJournals = [TextJournal]()
            let files = try FileManager.default.contentsOfDirectory(at:TextJournalsLoader.JOURNALS_PATH!, includingPropertiesForKeys: nil)
            
            let filenames = files.map{$0.deletingPathExtension().lastPathComponent}
            
            for i in 0..<files.count{
                textJournals.append(TextJournal(date: TextJournalsLoader.DATE_FORMAT.date(from: filenames[i])!,url: files[i]))
            }
            return textJournals.sorted(by: {$0.date > $1.date})
        } catch {
            return []
        }
    }
}
