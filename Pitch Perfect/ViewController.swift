//
//  ViewController.swift
//  Pitch Perfect
//
//  Created by Stephan König on 12/31/15.
//  Copyright © 2015 dynarchy. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var recordingInProgress: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func recordAudio(sender: UIButton) {
        recordingInProgress.hidden = false
        //TODO: Record the user's voice
    }
    
    @IBAction func stopRecording(sender: UIButton) {
        recordingInProgress.hidden = true
    }
}

