//
//  AudioPlayer.swift
//  LucidDreamer
//
//  Created by Steven Hyun on 2021-05-02.
//

import Foundation
import CoreAudio
import AVFoundation
import UIKit

class AudioPlayer: NSObject, AVAudioPlayerDelegate{
    
    private weak var notify:AudioPlayerObserver?
    private var session:AVAudioSession?
    private var player:AVAudioPlayer?
    
    func registerListener(obs:AudioPlayerObserver){
        self.notify = obs
    }
    
    func playAudio(url:URL, loops:Int){
        do{
            session = AVAudioSession.sharedInstance()
            setupNotifications()
            try session?.setActive(false)
            try session?.setCategory(.playback,mode:.default)
            try session?.setActive(true)
            
            try player = AVAudioPlayer(contentsOf:url, fileTypeHint: "m4a")
            player?.numberOfLoops = loops
            player?.prepareToPlay()
            player?.delegate = self
            player?.play()
            self.notify?.startAudioSuccess()
            
        }catch{
            self.notify?.startAudioFailed()
        }
    }
    
    func setupNotifications(){
        let nc = NotificationCenter.default
        nc.addObserver(self, selector: #selector(handleInterruption), name: AVAudioSession.interruptionNotification, object: session)
    }
    
    @objc func handleInterruption(notification:Notification){
        guard let userInfo = notification.userInfo,
              let typeValue = userInfo[AVAudioSessionInterruptionTypeKey] as? UInt,
              let type = AVAudioSession.InterruptionType(rawValue: typeValue) else {return}
        
        switch type {
            case .began:
                player?.pause()
                self.notify?.audioPlaybackPaused()
                break
            case .ended:
                player?.play()
                self.notify?.audioPlaybackResumed()
                break;
            default: ()
        }
        
    }
    
   
        
    
    
    func audioPlayerDecodeErrorDidOccur(_ player: AVAudioPlayer, error: Error?) {
        self.notify?.audioDecodeError()
    }
    
    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        self.notify?.audioFinishedPlaying()
    }
    
    func pauseAudio(){
        self.player?.pause()
        self.notify?.audioPlaybackPaused()
    }
    
    func stopAudio(){
        self.player?.stop()
    }
    
    func seekFromCurrent(value:Double){
        if let audioPlayer = self.player{
            if audioPlayer.isPlaying{
                audioPlayer.currentTime = audioPlayer.currentTime + value
            }
        }
    }
    
    func getNormalizedTime() -> Float{
        if let audioPlayer = self.player{
            return Float((Float(audioPlayer.currentTime) / Float(audioPlayer.duration)))
        }
        else{
            return 0.0
        }
        
    }
    
    func stopSession(){
        do{
            try self.session?.setActive(false)
        }catch{
            
        }
    }
    
    func isPlaying() -> Bool{
        return self.player?.isPlaying ?? false
    }
}
