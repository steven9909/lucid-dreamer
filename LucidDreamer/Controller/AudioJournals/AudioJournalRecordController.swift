//
//  AudioJournalRecordController.swift
//  LucidDreamer
//
//  Created by Steven Hyun on 2021-05-01.
//

import UIKit
import CoreAudio
import AVFoundation
import UIKit

class AudioJournalRecordController: UIViewController, AudioRecorderObserver{
    
    private let audioRecorder:AudioRecorder = AudioRecorder()

    @IBOutlet weak var recordingImageView: UIImageView!
    
    @IBOutlet weak var recordButton: UIButton!
    
    @IBOutlet weak var timestampLabel: UILabel!
    
    private static let BUTTON_STOP_TEXT = "Stop"
    private static let BUTTON_RECORD_TEXT = "Record"
    private static let BUTTON_RESUME_TEXT = "Resume"
    
    private var recordingIconTimer:Timer?
    private var timestampLabelTimer:Timer?
    
    private var totalSecondsElasped:Int = 0
    
    public var isAudioRecording:Bool = false
    private var isAudioInterrupted:Bool = false
    
    public weak var delegate: JournalListController!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        audioRecorder.registerListener(obs: self)
        // Do any additional setup after loading the view.
    }
    
    @IBAction func recordButtonPressed(_ sender: UIButton) {
        if isAudioInterrupted {
            return
        }
        if isAudioRecording{
            isAudioRecording = false
            self.delegate.updateIsAudioRecording(newVal: isAudioRecording)
            audioRecorder.stopRecording()
        }
        else{
            isAudioRecording = true
            self.delegate.updateIsAudioRecording(newVal: isAudioRecording)
            audioRecorder.requestPermission()
        }
    }
    
    func audioRecordingInterruptionEnded() {
        isAudioInterrupted = false
    }
    
    func resumeAudioRecording() {
        recordingIconTimer = Timer.scheduledTimer(timeInterval: 1.5, target: self, selector: #selector(transitionRecordingIcon), userInfo: nil, repeats: true)
        timestampLabelTimer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(incrementTimestampLabel), userInfo: nil, repeats: true)
        
        recordButton.setTitle(AudioJournalRecordController.BUTTON_STOP_TEXT, for: .normal)
    }
    
    func audioRecordingInterruptionBegan() {
        
        isAudioInterrupted = true
        recordingIconTimer?.invalidate()
        timestampLabelTimer?.invalidate()
        
        recordButton.setTitle(AudioJournalRecordController.BUTTON_RESUME_TEXT, for: .normal)
        
        recordingImageView.alpha = 0.0
    }
    
    func audioPermissionGranted() {
        audioRecorder.startRecording()
    }
    
    func audioPermissionDenied() {
        resetState()
    }
    
    func startRecordingFailed() {
        resetState()
    }
    
    func startRecordingSucceed() {
        recordButton.setTitle(AudioJournalRecordController.BUTTON_STOP_TEXT, for: .normal)
        
        recordingIconTimer?.invalidate()
        timestampLabelTimer?.invalidate()
        
        recordingIconTimer = Timer.scheduledTimer(timeInterval: 1.5, target: self, selector: #selector(transitionRecordingIcon), userInfo: nil, repeats: true)
        timestampLabelTimer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(incrementTimestampLabel), userInfo: nil, repeats: true)
    }
    
    @objc func incrementTimestampLabel(){
        totalSecondsElasped += 1
        
        let minute = totalSecondsElasped / 60
        let second = totalSecondsElasped % 60
        
        self.timestampLabel.text = "\(minute):"+String(format:"%02d",second)
        
    }
    
    @objc func transitionRecordingIcon(){
        UIView.animate(withDuration: 0.5, animations: {
            if self.recordingImageView.alpha == 0.0{
                self.recordingImageView.alpha = 1.0
            }
            else{
                self.recordingImageView.alpha = 0.0
            }
        },completion: nil)
    }
    
    func audioEncodingError() {
        resetState()
    }
    
    func recordingStopped(audio: AudioJournal) {
        self.delegate.addNewJournalToTableView(journal: audio)
        self.dismiss(animated: true, completion: nil)
    }
    
    func resetState(){
        recordingIconTimer?.invalidate()
        timestampLabelTimer?.invalidate()
        recordingIconTimer = nil
        timestampLabelTimer = nil
        
        timestampLabel.text = "0:00"
        recordingImageView.alpha = 0.0
        isAudioRecording = false
        self.delegate.updateIsAudioRecording(newVal:isAudioRecording)
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
