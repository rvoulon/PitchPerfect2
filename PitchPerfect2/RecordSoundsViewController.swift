//
//  RecordSoundsViewController.swift
//  PitchPerfect2
//
//  Created by Roberta Voulon on 2015-09-24.
//  Copyright © 2015 Roberta Voulon. All rights reserved.
//

import UIKit
import AVFoundation

class RecordSoundsViewController: UIViewController, AVAudioRecorderDelegate {
    
    //TODO: Allow users to pause and resume recording.
    
    var audioRecorder: AVAudioRecorder!
    var recordedAudio: RecordedAudio!
    let session = AVAudioSession.sharedInstance()
    
    @IBOutlet weak var recordButton: UIButton!
    @IBOutlet weak var recordingLabel: UILabel!
    @IBOutlet weak var stopButton: UIButton!
    @IBOutlet weak var pauseResumeButton: UIButton!
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        setUIRecordingMode(false)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


    func audioRecorderDidFinishRecording(recorder: AVAudioRecorder, successfully flag: Bool) {
        if (flag) {
            recordedAudio = RecordedAudio(url: recorder.url, title: recorder.url.lastPathComponent!)
            performSegueWithIdentifier("stopRecording", sender: recordedAudio)
        } else {
            print("Recording was not successful")
            setUIRecordingMode(false)
        }

        try! session.setCategory(AVAudioSessionCategoryPlayback)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if (segue.identifier == "stopRecording") {
            let playSoundsVC: PlaySoundsViewController = segue.destinationViewController as! PlaySoundsViewController
            let data = sender as! RecordedAudio
            playSoundsVC.receivedAudio = data
        }
    }
    
    func setUIRecordingMode(inProgress: Bool) {
        if (inProgress) {
            recordButton.enabled = false
            recordingLabel.text = "recording..."
            pauseResumeButton.hidden = false
            stopButton.hidden = false
        } else {
            recordButton.enabled = true
            recordingLabel.text = "tap to record"
            pauseResumeButton.hidden = true
            stopButton.hidden = true
        }
    }
        
    @IBAction func recordAudio(sender: UIButton) {
        
        setUIRecordingMode(true)
        
        let dirPath = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)[0] as String
        // We don't want to use up unnecessary storage on the phone so we 
        // use the same file and overwrite it each time.
        let recordingName = "my_audio.wav"
        let pathArray = [dirPath, recordingName]
        let filePath = NSURL.fileURLWithPathComponents(pathArray)
        
        try! session.setCategory(AVAudioSessionCategoryRecord)
        
        try! audioRecorder = AVAudioRecorder(URL: filePath!, settings: [:])
        audioRecorder.delegate = self
        audioRecorder.meteringEnabled = true
        audioRecorder.prepareToRecord()
        audioRecorder.record()
    }
    
    
    @IBAction func togglePauseResumeRecording(sender: UIButton) {
        if sender.imageForState(UIControlState.Normal) == UIImage(named: "Pause") {
            audioRecorder.pause()
            recordingLabel.text = "recording paused"
            pauseResumeButton.setImage(UIImage(named: "Resume"), forState: UIControlState.Normal)
        } else {
            audioRecorder.record()
            recordingLabel.text = "recording..."
            pauseResumeButton.setImage(UIImage(named: "Pause"), forState: UIControlState.Normal)
        }
    }

    
    @IBAction func stopRecording(sender: UIButton) {
        setUIRecordingMode(false)
        
        audioRecorder.stop()
        let audioSession = AVAudioSession.sharedInstance()
        try! audioSession.setActive(false)
    }
}

