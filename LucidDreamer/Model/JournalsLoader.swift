//
//  JournalsLoader.swift
//  LucidDreamer
//
//  Created by Steven Hyun on 2021-05-03.
//

import Foundation

protocol JournalsLoader{
    static var FOLDER_NAME: String {get}
    static var JOURNALS_PATH:URL? {get}
    static var DATE_FORMAT:DateFormatter {get}
    
    func loadJournalsFromFS()  -> [Journal]
}
