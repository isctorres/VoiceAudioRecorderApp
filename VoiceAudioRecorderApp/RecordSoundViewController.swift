//
//  RecordSoundViewController.swift
//  VoiceAudioRecorderApp
//
//  Created by Isc. Torres on 2/1/20.
//  Copyright © 2020 isctorres. All rights reserved.
//

import UIKit
import AVFoundation

class RecordSoundViewController: UIViewController, AVAudioRecorderDelegate {

    @IBOutlet var btnRecord: UIButton!
    @IBOutlet var btnStopRecord: UIButton!
    @IBOutlet var lblRecord: UILabel!
    
    var audioRecorder: AVAudioRecorder!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        btnStopRecord.isEnabled = false
    }

    @IBAction func btnRecord(_ sender: Any) {
        
        lblRecord.text = "Record in progress.."
        btnStopRecord.isEnabled = true
        btnRecord.isEnabled = false
        
        let dirPath = NSSearchPathForDirectoriesInDomains(.documentDirectory,.userDomainMask, true)[0] as String
         let recordingName = "recordedVoice.wav"
         let pathArray = [dirPath, recordingName]
         let filePath = URL(string: pathArray.joined(separator: "/"))
        
         let session = AVAudioSession.sharedInstance()
         try! session.setCategory(AVAudioSession.Category.playAndRecord, mode: AVAudioSession.Mode.default, options: AVAudioSession.CategoryOptions.defaultToSpeaker)
        try! audioRecorder = AVAudioRecorder(url: filePath!, settings: [:])
         audioRecorder.delegate = self
         audioRecorder.isMeteringEnabled = true
         audioRecorder.prepareToRecord()
         audioRecorder.record()
    }
    
    @IBAction func btnStopRecord(_ sender: Any) {
        lblRecord.text = "Tap to Record"
        btnStopRecord.isEnabled = false
        btnRecord.isEnabled = true
        
        audioRecorder.stop()
        let audioSession = AVAudioSession.sharedInstance()
        try! audioSession.setActive(false)
    }
    
    // Metodo del delegado
    func audioRecorderDidFinishRecording(_ recorder: AVAudioRecorder, successfully flag: Bool) {
        if flag {
            performSegue(withIdentifier: "stopRecording", sender: audioRecorder.url)
        }else{
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
    
    
}

