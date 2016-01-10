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
        
        // Initializing AVAudioEngine, enables manipulated playback of audio file
        audioEngine = AVAudioEngine()
        audioFile = try! AVAudioFile.init(forReading: receivedAudio.filePathUrl)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(animated: Bool) {
        stopButton.enabled = false
    }
    
    // Audio player delegate function
    func audioPlayerDidFinishPlaying(player: AVAudioPlayer, successfully flag: Bool) {
        stopButton.hidden = true
    }
    
    func playAudioAtSpeedAndPitch(speed: Float, pitch: Float, reverb: Bool, echo: Bool) {
        // Stop any audio playback and reset audio engine
        audioEngine.stop()
        audioEngine.reset()
        
        // Based on parameters audio nodes are added to nodes array
        var nodes = [AVAudioNode]()
        let changePitchEffect: AVAudioUnitTimePitch
        let addReverbEffect: AVAudioUnitReverb
        let addEchoEffect: AVAudioUnitDelay
        
        // Attach player node to audio engine
        audioPlayerNode = AVAudioPlayerNode()
        audioEngine.attachNode(audioPlayerNode)
        nodes.append(audioPlayerNode)
        

        // Attach pitch effect to audio engine
        if speed != 1.0 || pitch != 1.0 {
            changePitchEffect = AVAudioUnitTimePitch()
            changePitchEffect.rate = speed
            changePitchEffect.pitch = pitch
            audioEngine.attachNode(changePitchEffect)
            nodes.append(changePitchEffect)
        }
        
        // Attach reverb effect to audio engine
        if reverb {
            addReverbEffect = AVAudioUnitReverb()
            addReverbEffect.loadFactoryPreset(AVAudioUnitReverbPreset.Cathedral)
            addReverbEffect.wetDryMix = 50.0
            audioEngine.attachNode(addReverbEffect)
            nodes.append(addReverbEffect)
        }
        
        // Attach echo effecto to audio engine
        if echo {
            addEchoEffect = AVAudioUnitDelay()
            addEchoEffect.delayTime = NSTimeInterval(1)
            addEchoEffect.wetDryMix = 100.0
            audioEngine.attachNode(addEchoEffect)
            nodes.append(addEchoEffect)
        }
        
        // Add output node to nodes
        nodes.append(audioEngine.outputNode)
        
        // Loop through nodes and connect them
        for idx in 0...(nodes.count - 2) {
            audioEngine.connect(nodes[idx], to: nodes[idx + 1], format: nil)
        }
        
        audioPlayerNode.scheduleFile(audioFile, atTime: nil, completionHandler: {
            self.stopButton.enabled = false
        })
        try! audioEngine.start()
        audioPlayerNode.play()
        
        stopButton.enabled = true
    }
    
    @IBAction func playSlowAudio(sender: UIButton) {
        playAudioAtSpeedAndPitch(0.5, pitch: 1.0, reverb: false, echo: false)
    }

    @IBAction func playFastAudio(sender: UIButton) {
        playAudioAtSpeedAndPitch(1.5, pitch: 1.0, reverb: false, echo: false)
    }
    
    @IBAction func playChipmunkAudio(sender: UIButton) {
        playAudioAtSpeedAndPitch(1.0, pitch: 1000.0, reverb: false, echo: false)
    }
    
    @IBAction func playDarthVaderAudio(sender: UIButton) {
        playAudioAtSpeedAndPitch(1.0, pitch: -1000.0, reverb: false, echo: false)
    }
    
    @IBAction func platWithReverb(sender: UIButton) {
        playAudioAtSpeedAndPitch(1.0, pitch: 1.0, reverb: true, echo: false)
    }
    
    @IBAction func playWithEcho(sender: UIButton) {
        playAudioAtSpeedAndPitch(1.0, pitch: 1.0, reverb: false, echo: true)
    }
    
    @IBAction func stopAudio(sender: UIButton) {
        audioPlayerNode.stop()
        stopButton.enabled = false
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
