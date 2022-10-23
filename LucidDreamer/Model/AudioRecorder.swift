//
//  AudioRecorder.swift
//  LucidDreamer
//
//  Created by Steven Hyun on 2021-05-01.
//

import Foundation
import CoreAudio
import AVFoundation
import UIKit

class AudioRecorder: NSObject, AVAudioRecorderDelegate{
    
    private var recordingSession: AVAudioSession
    private weak var notify: AudioRecorderObserver?
    private var audioRecorder: AVAudioRecorder?
    private var audioJournal: AudioJournal?
    private static let MAX_DURATION = 6*60
    
    private static let AUDIO_SETTINGS = [AVFormatIDKey: Int(kAudioFormatMPEG4AAC), AVSampleRateKey: 12000, AVNumberOfChannelsKey: 1, AVEncoderAudioQualityKey: AVAudioQuality.medium.rawValue]
    
    override init() {
        recordingSession = AVAudioSession.sharedInstance()
        super.init()
        self.setupNotifications()
    }
    
    public func registerListener(obs: AudioRecorderObserver){
        notify = obs
    }
    
    public func requestPermission(){
        do{
            try recordingSession.setActive(false)
            try recordingSession.setCategory(.record, mode: .default)
            try recordingSession.setActive(true)
            recordingSession.requestRecordPermission() {[unowned self] allowed in DispatchQueue.main.async {
                    if allowed {
                        self.notify?.audioPermissionGranted()
                    } else {
                        self.notify?.audioPermissionDenied()
                    }
                }
            }
        } catch {
            self.notify?.audioPermissionDenied()
        }
    }
    
    func setupNotifications(){
        let nc = NotificationCenter.default
        nc.addObserver(self, selector: #selector(handleInterruption), name: AVAudioSession.interruptionNotification, object: recordingSession)
    }
    
    @objc func handleInterruption(notification:Notification){
        guard let userInfo = notification.userInfo,
              let typeValue = userInfo[AVAudioSessionInterruptionTypeKey] as? UInt,
              let type = AVAudioSession.InterruptionType(rawValue: typeValue) else {return}
        
        switch type {
            case .began:
                audioRecorder?.pause()
                self.notify?.audioRecordingInterruptionBegan()
                break
            case .ended:
                self.notify?.audioRecordingInterruptionEnded()
                break;
            default: ()
        }
        
    }
  
    
    public func startRecording(){
        audioJournal = AudioJournal.createNewInstance() as? AudioJournal
   
        do{
            audioRecorder = try AVAudioRecorder(url: audioJournal!.url, settings: AudioRecorder.AUDIO_SETTINGS)
            audioRecorder?.delegate = self
            let success = audioRecorder?.record(forDuration: TimeInterval(AudioRecorder.MAX_DURATION))
            
            if let audioRecordingStatus = success {
                if audioRecordingStatus {
                    self.notify?.startRecordingSucceed()
                }
                else{
                    self.notify?.startRecordingFailed()
                }
            }
            else{
                self.notify?.startRecordingFailed()
            }
            
        } catch {
            audioJournal = nil
            self.notify?.startRecordingFailed()
        }
        
    }
    
    func audioRecorderEncodeErrorDidOccur(_ recorder: AVAudioRecorder, error: Error?) {
        audioRecorder?.stop()
        audioRecorder = nil
        self.notify?.audioEncodingError()
    }
    
    func audioRecorderDidFinishRecording(_ recorder: AVAudioRecorder, successfully flag: Bool) {
        if audioRecorder != nil{
            stopRecording()
        }
        self.notify?.recordingStopped(audio:self.audioJournal!)
    }
    
    public func stopRecording(){
        audioRecorder?.stop()
        audioRecorder = nil
        do{
            try recordingSession.setActive(false)
        } catch {
        }
    }
    
}
