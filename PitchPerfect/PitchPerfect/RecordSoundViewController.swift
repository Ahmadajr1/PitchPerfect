//
//  RecordSoundViewController.swift
//  PitchPerfect
//
//  Created by Ahmed Al Ramadhan on 26/10/2018.
//  Copyright © 2018 Ahmed Al Ramadhan. All rights reserved.
//

import UIKit
import AVFoundation

class RecordSoundViewController: UIViewController, AVAudioRecorderDelegate{

    var audioRecorder: AVAudioRecorder!
    
    @IBOutlet weak var recordingLabel: UILabel!
    @IBOutlet weak var recordButton: UIButton!
    @IBOutlet weak var stopRecordingButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        print("Loaded to memory")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        print("View will appear")
        configureUI(recordState: false)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        print("View did appear")
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        print("View will disappear")
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        print("View disappeared")
    }


    @IBAction func recordAudio(_ sender: Any) {
        print("Record button was pressed")
        configureUI(recordState: true)
        
        let dirPath = NSSearchPathForDirectoriesInDomains(.documentDirectory,.userDomainMask, true)[0] as String
        let recordingName = "recordedVoice.wav"
        let pathArray = [dirPath, recordingName]
        let filePath = URL(string: pathArray.joined(separator: "/"))
        
        
        let session = AVAudioSession.sharedInstance()
        try! session.setCategory(.record, mode:.default, options: [])
        try! audioRecorder = AVAudioRecorder(url: filePath!, settings: [ : ])
        audioRecorder.delegate = self
        audioRecorder.isMeteringEnabled = true
        audioRecorder.record()
        
    }
    @IBAction func stopRecording(_ sender: Any) {
        print("Stop button was pressed")
        configureUI(recordState: false)
        audioRecorder.stop()
        let audioSession = AVAudioSession.sharedInstance()
        try! audioSession.setCategory(.playback, mode:.default, options: [])
        try! audioSession.setActive(false)
    }
    
    
    func audioRecorderDidFinishRecording(_ recorder: AVAudioRecorder, successfully flag: Bool) {
        if flag{
            performSegue(withIdentifier: "stopRecording", sender: audioRecorder.url)
        }
        else {
        print("Recording was not successful")
        }

    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "stopRecording"{
            let playSoundsVC = segue.destination as! PlaySoundsViewController
            let recordedAudioURL = sender as! URL
            playSoundsVC.recordedAudioURL = recordedAudioURL
        }
    }
    
    func configureUI(recordState: Bool){
        
    if recordState{
    recordButton.isEnabled = false
    stopRecordingButton.isEnabled = true
    recordingLabel.text = "Recording in progress"
    }
    else{
    recordButton.isEnabled = true
    stopRecordingButton.isEnabled = false
    recordingLabel.text = "Recording has stopped"
    }
    }
}


