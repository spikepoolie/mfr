//
//  Sounds.swift
//  MuscleFLossingRoller
//
//  Created by Rodrigo Schreiner on 3/1/19.
//  Copyright © 2019 MFR. All rights reserved.
//

import UIKit
import AVFoundation
class Sounds: UIViewController {

    @IBOutlet weak var lblSound: UILabel!
    var sound = 1000
    override func viewDidLoad() {
        super.viewDidLoad()
        lblSound.text = String(sound)
        // Do any additional setup after loading the view.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

    @IBAction func minusSound(_ sender: Any) {
        if sound >= 1000 {
            sound -= 1
            lblSound.text = String(sound)
            playSound(soundid: sound)
        }
    }
    
    @IBAction func plusSound(_ sender: Any) {
        sound += 1
        lblSound.text = String(sound)
        playSound(soundid: sound)
    }
    
    private func playSound(soundid: Int) {
        let systemSoundId: SystemSoundID = SystemSoundID(soundid)  // to play apple's built in sound, no need for upper 3 lines
        // self.timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true, block: { (timer) in
        AudioServicesPlaySystemSound(systemSoundId)
        // })
    }
}
