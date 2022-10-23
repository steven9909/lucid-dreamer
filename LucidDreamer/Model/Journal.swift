//
//  Journal.swift
//  LucidDreamer
//
//  Created by Steven Hyun on 2021-05-02.
//

import Foundation

protocol Journal{
    
    var date: Date {get set}
    var url: URL {get set}
    
    init(date:Date, url:URL)
    
    func delete()
    static func createNewInstance() -> Journal?
    
}

extension Journal{
    func delete(){
        do{
            try FileManager.default.removeItem(at: self.url)
        } catch {
            
        }
    }
}
