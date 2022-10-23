//
//  AudioRecorderObserver.swift
//  LucidDreamer
//
//  Created by Steven Hyun on 2021-05-02.
//

import Foundation

protocol AudioRecorderObserver:AnyObject{
    func audioPermissionGranted()
    func audioPermissionDenied()
    func startRecordingFailed()
    func startRecordingSucceed()
    func audioEncodingError()
    func recordingStopped(audio:AudioJournal)
    func audioRecordingInterruptionBegan()
    func audioRecordingInterruptionEnded()
}
