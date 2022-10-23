//
//  AudioJournalPlayController.swift
//  LucidDreamer
//
//  Created by Steven Hyun on 2021-05-02.
//

import UIKit

class AudioJournalPlayController: UIViewController, AudioPlayerObserver{

    @IBOutlet weak var audioSlider: UISlider!
    @IBOutlet weak var playButton: UIButton!
  
    @IBOutlet weak var backButton: UIBarButtonItem!
    
    @IBOutlet weak var centerImageView: UIImageView!
    
    public var audioJournal:AudioJournal?
    
    
    @IBOutlet weak var navigationbar: UINavigationBar!
    private let audioPlayer:AudioPlayer = AudioPlayer()
    private var updater:CADisplayLink! = nil
 
    override func viewDidLoad() {
        super.viewDidLoad()
        audioPlayer.registerListener(obs: self)
        centerImageView.image = UIImage.animatedImageNamed("AudioAnimation/final-", duration: 2)
        centerImageView.stopAnimating()
        navigationbar.setBackgroundImage(UIImage(), for: .default)
        navigationbar.shadowImage = UIImage()
        navigationbar.isTranslucent = true
        navigationbar.titleTextAttributes = [NSAttributedString.Key.font:UIFont.systemFont(ofSize: 20),NSAttributedString.Key.foregroundColor : UIColor.white]
        
        backButton.setTitleTextAttributes([NSAttributedString.Key.font : UIFont.systemFont(ofSize: 20)], for: .normal)
    
    }
    
    func audioPlaybackResumed() {
        playButton.setImage(UIImage(named: "Buttons/pause"), for: .normal)
    }
    
    func audioPlaybackPaused() {
        playButton.setTitle("Resume", for: .normal)
        playButton.setImage(UIImage(named: "Buttons/play"), for: .normal)
    }
    
    @IBAction func backButtonPressed(_ sender: Any) {
        if self.audioPlayer.isPlaying(){
            self.audioPlayer.stopAudio()
            self.audioPlayer.stopSession()
        }
        
        self.performSegue(withIdentifier: "unwindToList", sender: nil)
    }
    @IBAction func seekForwardButtonPressed(_ sender: Any) {
        self.audioPlayer.seekFromCurrent(value: 15)
    }
    
    @IBAction func seekBackwardButtonPressed(_ sender: Any) {
        self.audioPlayer.seekFromCurrent(value: -15)
    }
    
    @IBAction func playButtonPressed(_ sender: Any) {
        if self.audioPlayer.isPlaying(){
            self.audioPlayer.pauseAudio()
            centerImageView.stopAnimating()
        }
        else{
            if let audio = audioJournal{
                self.audioPlayer.playAudio(url:audio.url,loops:0)
            }
        }
    }
    
    @objc func trackAudio(){
        audioSlider.value = self.audioPlayer.getNormalizedTime()
    }
    

    
    func startAudioFailed() {
        
    }
    
    
    
    func startAudioSuccess() {
        self.updater = CADisplayLink(target:self, selector: #selector(self.trackAudio))
        self.updater.preferredFramesPerSecond = 0
        self.updater.add(to: .current, forMode: .common)
        playButton.setImage(UIImage(named: "Buttons/pause"), for: .normal)
        centerImageView.startAnimating()
    }
    
    
    
    func audioFinishedPlaying() {
        centerImageView.stopAnimating()
    }
    
    func audioDecodeError() {
        
    }
    
    func resetState(){
        self.updater?.invalidate()
    }
    

    
    

}
