//
//  PlaySoundsViewController.swift
//  Pitch Perfect
//
//  Created by Stephan König on 1/2/16.
//  Copyright © 2016 dynarchy. All rights reserved.
//

import UIKit
import AVFoundation

// // Make view controller AVAudioPlayerDelegate so it can respond to end of audio playback
// class PlaySoundsViewController: UIViewController, AVAudioPlayerDelegate {

class PlaySoundsViewController: UIViewController {
    
    var audioEngine: AVAudioEngine!
    var audioPlayerNode: AVAudioPlayerNode!
    var receivedAudio: RecordedAudio!
    var audioFile: AVAudioFile!
    
    @IBOutlet weak var stopButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        // Initializing AVAudioEngine for manipulation of audio file
        audioEngine = AVAudioEngine()
        audioFile = try! AVAudioFile.init(forReading: receivedAudio.filePathUrl)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(animated: Bool) {
        stopButton.hidden = true
    }
    
    // Audio player delegate function
    func audioPlayerDidFinishPlaying(player: AVAudioPlayer, successfully flag: Bool) {
        stopButton.hidden = true
    }
    
    func playAudioAtSpeedAndPitch(speed: Float, pitch: Float) {
        // Stop any audio playback and reset audio engine
        audioEngine.stop()
        audioEngine.reset()
        
        // Attach player node to audio engine
        audioPlayerNode = AVAudioPlayerNode()
        audioEngine.attachNode(audioPlayerNode)

        // Attach pitch effect to audion engine
        let changePitchEffect = AVAudioUnitTimePitch()
        changePitchEffect.rate = speed
        changePitchEffect.pitch = pitch
        audioEngine.attachNode(changePitchEffect)
        
        // Connect nodes in correct sequence
        audioEngine.connect(audioPlayerNode, to: changePitchEffect, format: nil)
        audioEngine.connect(changePitchEffect, to: audioEngine.outputNode, format: nil)
        
        audioPlayerNode.scheduleFile(audioFile, atTime: nil, completionHandler: {
            self.stopButton.hidden = true
        })
        try! audioEngine.start()
        audioPlayerNode.play()
        
        stopButton.hidden = false
    }
    
    @IBAction func playSlowAudio(sender: UIButton) {
        playAudioAtSpeedAndPitch(0.5, pitch: 1)
    }

    @IBAction func playFastAudio(sender: UIButton) {
        playAudioAtSpeedAndPitch(1.5, pitch: 1)
    }
    
    @IBAction func playChipmunkAudio(sender: UIButton) {
        playAudioAtSpeedAndPitch(1, pitch: 1000)
    }
    
    @IBAction func stopAudio(sender: UIButton) {
        audioPlayerNode.stop()
        stopButton.hidden = true
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
