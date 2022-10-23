//
//  WatchConnectivity.swift
//  LucidDreamer WatchKit Extension
//
//  Created by Steven Hyun on 2021-05-11.
//

import Foundation
import WatchKit
import WatchConnectivity

protocol WatchSessionObserver:AnyObject{
    func fileTransferError()
    func fileTransferSucceed(url:URL)
}

class WatchSession: NSObject, WCSessionDelegate{
    
    private static let watchsession:WatchSession = WatchSession()
    private var session = WCSession.default
    
    private var notify:[WatchSessionObserver] = []
    
    private override init(){
        super.init()
    }
    
    func activate(){
        session.delegate = self
        session.activate()
    }
    
    static func getSharedInstance() -> WatchSession{
        return watchsession
    }
    
    func isReachable() -> Bool{
        return session.isReachable
    }
    
    func addListener(obs:WatchSessionObserver){
        self.notify.append(obs)
    }
    
    func removeListener(obs:WatchSessionObserver){
        self.notify.remove(at:self.notify.firstIndex { (wso:WatchSessionObserver) in
            return obs === wso
        }!)
    }
    
    func sendCommand(command:[String : Any], reply: (([String : Any]) -> Void)?, error: ((Error) -> Void)?){
        
        session.sendMessage(command, replyHandler: reply, errorHandler: error)

    }
    
    func session(_ session: WCSession, didReceiveApplicationContext applicationContext: [String : Any]) {
        
        for (key,value) in applicationContext{
            do{
                try SettingsManager.getSharedInstance().saveSetting(key: key, data: value)
            } catch {
                
            }
        }
        
    }
    
    func sendApplicationContextData(key:String,value:Any) throws{
        try session.updateApplicationContext([key : value])
    }
    
    func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) {
       
        switch activationState{
            case .activated:
                break
            case .inactive:
                break
            case .notActivated:
                break
            default: ()
        }
    }
    
    func session(_ session: WCSession, didFinish fileTransfer: WCSessionFileTransfer, error: Error?) {
        if error != nil{
            self.notify.forEach({ (wso:WatchSessionObserver) in
                wso.fileTransferError()
            })
        }
    }
    
    func session(_ session: WCSession, didReceive file: WCSessionFile) {
        do {
            var docUrl = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("Downloads")
            docUrl?.appendPathComponent(file.fileURL.lastPathComponent)
            
            guard let docUrl = docUrl else {
                self.notify.forEach({ (wso:WatchSessionObserver) in
                    wso.fileTransferError()
                })
                return
            }
            
            try FileManager.default.copyItem(at: file.fileURL, to: docUrl)
            
            self.notify.forEach({ (wso:WatchSessionObserver) in
                wso.fileTransferSucceed(url: docUrl)
            })
            
        } catch {
            self.notify.forEach({ (wso:WatchSessionObserver) in
                wso.fileTransferError()
            })
        }
    }
}
