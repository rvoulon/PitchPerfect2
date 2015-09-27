//
//  PlaySoundsViewController.swift
//  PitchPerfect2
//
//  Created by Roberta Voulon on 2015-09-24.
//  Copyright © 2015 Roberta Voulon. All rights reserved.
//

import UIKit
import AVFoundation

class PlaySoundsViewController: UIViewController {
    
    var audioPlayer: AVAudioPlayer!
    var receivedAudio: RecordedAudio!

    var audioEngine: AVAudioEngine!
    var audioFile: AVAudioFile!

    var audioPlayerNode: AVAudioPlayerNode!

    override func viewDidLoad() {
        super.viewDidLoad()

        // We use AVAudioPlayer for playback with a different rate (speed)
        audioPlayer = try! AVAudioPlayer(contentsOfURL: receivedAudio.url)
        audioPlayer.enableRate = true
        
        // We use AVAudioEngine for the other 4 sound effects
        audioEngine = AVAudioEngine()
        // Convert NSURL to AVAudioFile for AVAudioEngine
        audioFile = try! AVAudioFile(forReading: receivedAudio.url)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func playAudioWithVariableRate(rate: Float) {
        
        stopAndResetPlayerAndEngine()
        
        audioPlayer.currentTime = 0
        audioPlayer.rate = rate
        audioPlayer.play()
    }
        
    func playAudioWithVariablePitch(pitch: Float) {

        setupPlayerNode()

        let audioPlayerNode = AVAudioPlayerNode()
        audioEngine.attachNode(audioPlayerNode)
        
        // set up the pitchNode, to connect between the audioPlayerNode and the audioEngine
        let pitchNode = AVAudioUnitTimePitch()
        pitchNode.pitch = pitch
        audioEngine.attachNode(pitchNode)
        
        // Now connect the audioPlayerNode to the pitchNode
        audioEngine.connect(audioPlayerNode, to: pitchNode, format: nil)
        // And then connect the pitchNode to the outputNode (speakers) = implicit destination node
        audioEngine.connect(pitchNode, to: audioEngine.outputNode, format: nil)
        // It helps to think of this as if you're connecting MakerBloks together in the right order, from input to output
        
        audioPlayerNode.scheduleFile(audioFile, atTime: nil, completionHandler: nil)
        try! audioEngine.start()
        
        audioPlayerNode.play()
    }
    
    func playAudioWithDelay(delay: Double) {

        setupPlayerNode()

        let delayNode = AVAudioUnitDelay()
        audioEngine.attachNode(delayNode)
        delayNode.delayTime = delay
        
        audioEngine.connect(audioPlayerNode, to: delayNode, format: nil)
        audioEngine.connect(delayNode, to: audioEngine.outputNode, format: nil)
        
        audioPlayerNode.scheduleFile(audioFile, atTime: nil, completionHandler: nil)
        try! audioEngine.start()
        
        audioPlayerNode.play()
    }

    func playAudioWithReverb() {
        
        setupPlayerNode()
        
        let reverbNode = AVAudioUnitReverb()
        audioEngine.attachNode(reverbNode)
        reverbNode.loadFactoryPreset(.Cathedral)
        reverbNode.wetDryMix = 50
        
        audioEngine.connect(audioPlayerNode, to: reverbNode, format: nil)
        audioEngine.connect(reverbNode, to: audioEngine.outputNode, format: nil)
        
        audioPlayerNode.scheduleFile(audioFile, atTime: nil, completionHandler: nil)
        try! audioEngine.start()
        
        audioPlayerNode.play()
    }
    
    func stopAndResetPlayerAndEngine() {
        audioEngine.stop()
        audioEngine.reset()
        audioPlayer.stop()
    }

    func setupPlayerNode() {
        stopAndResetPlayerAndEngine()
        
        // set up the audioPlayerNode (= audio source)
        audioPlayerNode = AVAudioPlayerNode()
        audioEngine.attachNode(audioPlayerNode)

    }
    
    @IBAction func playSlow(sender: UIButton) {
        playAudioWithVariableRate(0.5)
    }
    
    @IBAction func playFast(sender: UIButton) {
        playAudioWithVariableRate(1.5)
    }
    
    @IBAction func playChipmunk(sender: UIButton) {
        playAudioWithVariablePitch(1000)
    }
    
    @IBAction func playDarthVader(sender: UIButton) {
        playAudioWithVariablePitch(-1000)
    }
    
    @IBAction func playParrot(sender: UIButton) {
        playAudioWithDelay(1)
    }
    
    @IBAction func playReverb(sender: UIButton) {
        playAudioWithReverb()
    }
    
    @IBAction func stopPlayback(sender: UIButton) {
        stopAndResetPlayerAndEngine()
    }
}




