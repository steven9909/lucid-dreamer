//
//  WatchSession.swift
//  LucidDreamer
//
//  Created by Steven Hyun on 2021-05-04.
//

import Foundation
import WatchConnectivity
import CoreMotion


class WatchSession: NSObject, WCSessionDelegate{
    
    private static var watchSession:WatchSession = WatchSession()
    private var session:WCSession = WCSession.default
    
    private override init(){
        super.init()
    
    }
    
    func activate(){
        if WCSession.isSupported(){
            session.delegate = self
            session.activate()
        }
    }
    
    static func getSharedInstance() -> WatchSession{
        return watchSession
    }
    
    
    func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) {
        
    }
    
    //no real way to separate this logic since this can get called even when the app is terminated, so this logic can't be put into view controllers... maybe app delegate? but that doesnt really seem like a good place to put it...
    func session(_ session: WCSession, didReceiveMessage message: [String : Any], replyHandler: @escaping ([String : Any]) -> Void) {
        if message["getAudioList"] as? Bool == true {
            replyHandler(["getAudioList":AudioJournalsLoader().loadJournalsFromFS().map({ (journal:Journal) in
                return journal.url.deletingPathExtension().lastPathComponent
            })])
        }
        
    }
    
    func session(_ session: WCSession, didReceiveMessage message: [String : Any]) {
        if message["sendAudioFile"] as? String != nil {
            guard let journalsPath = AudioJournalsLoader.JOURNALS_PATH else {return}
            self.session.transferFile(journalsPath.appendingPathComponent(message["sendAudioFile"] as! String+AudioJournal.EXTENSION), metadata: nil)
        }
    }
    
    func sessionDidDeactivate(_ session: WCSession) {
        self.session.activate()
        self.session.delegate = self
    }
    
    func sessionDidBecomeInactive(_ session: WCSession) {
        
    }
    
    func sendSettingsToWatch(key:String,value:Any) throws{
        try self.session.updateApplicationContext([key : value])
    }
    
    
    
    
}
