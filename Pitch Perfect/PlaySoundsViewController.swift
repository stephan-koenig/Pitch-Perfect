//
//  PlaySoundsViewController.swift
//  Pitch Perfect
//
//  Created by Stephan König on 1/2/16.
//  Copyright © 2016 dynarchy. All rights reserved.
//

import UIKit
import AVFoundation

// Make view controller AVAudioPlayerDelegate so it can respond to end of audio playback
class PlaySoundsViewController: UIViewController, AVAudioPlayerDelegate {

    var audioPlayer: AVAudioPlayer!
    
    @IBOutlet weak var stopButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        if let filePath = NSBundle.mainBundle().pathForResource("movie_quote", ofType: "mp3") {
            let filePathUrl = NSURL.fileURLWithPath(filePath)
            audioPlayer = try! AVAudioPlayer(contentsOfURL: filePathUrl)
            audioPlayer.enableRate = true
            
            // Set delegate of audio player to ViewController
            audioPlayer.delegate = self
        } else {
            print("The filePath is empty.")
        }

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
    
    func playAudioAtSpeed(speed: Float) {
        // Stop any audio playback, rewind, and start at
        audioPlayer.stop()
        audioPlayer.rate = speed
        audioPlayer.currentTime = 0.0
        audioPlayer.play()
        stopButton.hidden = false
    }
    
    @IBAction func playSlowAudio(sender: UIButton) {
        playAudioAtSpeed(0.5)
    }

    @IBAction func playFastAudio(sender: UIButton) {
        playAudioAtSpeed(1.5)
    }
    
    @IBAction func stopAudio(sender: UIButton) {
        audioPlayer.stop()
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
