//
//  AudioPlayerObserver.swift
//  LucidDreamer
//
//  Created by Steven Hyun on 2021-05-02.
//

import Foundation

protocol AudioPlayerObserver:AnyObject{
    
    func startAudioFailed()
    func startAudioSuccess()
    func audioFinishedPlaying()
    func audioDecodeError()
    func audioPlaybackPaused()
    func audioPlaybackResumed()
}
