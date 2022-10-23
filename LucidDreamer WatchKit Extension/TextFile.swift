//
//  TextFile.swift
//  LucidDreamer WatchKit Extension
//
//  Created by Steven Hyun on 2021-05-08.
//

import Foundation

class TextFile{
    
    private var filename:String
    private var url:URL
    
    init(filename:String){
        self.filename = filename
        let dir:URL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).last!
        self.url = dir.appendingPathComponent(filename)
    }
    
    func appendLine(buf:String){
        
        if let fileHandle = FileHandle(forWritingAtPath: url.path){
            defer{
                fileHandle.closeFile()
            }
            fileHandle.seekToEndOfFile()
            fileHandle.write((buf+"\n").data(using: String.Encoding.utf8)!)
        }
        else{
            FileManager.default.createFile(atPath: self.url.path, contents: (buf+"\n").data(using: String.Encoding.utf8)!, attributes: nil)
        }
    }
    
    func empty(){
        
    }
    
    func delete(){
        
    }
    
    func readText() throws -> String {
        return try String(contentsOf: self.url, encoding: .utf8)
    }
    
    
}
