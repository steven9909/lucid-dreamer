//
//  AudioJournalListLoader.swift
//  LucidDreamer WatchKit Extension
//
//  Created by Steven Hyun on 2021-05-10.
//

import Foundation
import UIKit

protocol AudioJournalListLoaderEvents{
    func audioListReturned(_ list:[String])
    func audioListReturnedError()
    func audioFileRequestReturnedError()
}

class AudioJournalListLoader{
    
    
    private var notify:AudioJournalListLoaderEvents?
    
    func addListener(obs:AudioJournalListLoaderEvents){
        self.notify = obs
    }
    
    func fetchAudioList(){
        WatchSession.getSharedInstance().sendCommand(command: ["getAudioList":true],reply:fetchAudioListReplyHandler,error:fetchAudioListErrorHandler)
    }
    
    func fetchAudio(filename:String){
        WatchSession.getSharedInstance().sendCommand(command:["sendAudioFile":filename],reply:nil,error:fetchAudioErrorHandler)
    }
    
    func addWatchSessionObserver(wso:WatchSessionObserver){
        WatchSession.getSharedInstance().addListener(obs: wso)
    }
    
    func removeWatchSessionObserver(wso:WatchSessionObserver){
        WatchSession.getSharedInstance().removeListener(obs: wso)
    }
    
    private func fetchAudioErrorHandler(error:Error){
        self.notify?.audioFileRequestReturnedError()
    }
    
    private func fetchAudioListReplyHandler(data:[String : Any]){
        guard let _ = data["getAudioList"],
        let list = (data["getAudioList"] as? [String]) else {
            self.notify?.audioListReturnedError()
            return
        }
        
        self.notify?.audioListReturned(list)
        
    }
    
    private func fetchAudioListErrorHandler(error:Error){
        self.notify?.audioListReturnedError()
    }
    
    
    
    
}
