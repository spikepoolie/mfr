//
//  BackView.swift
//  FitLab
//
//  Created by Rodrigo Schreiner on 8/30/17.
//  Copyright © 2017 Up2SpeedTraining. All rights reserved.
//

import UIKit

class BackView: UIViewController {
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    @IBOutlet var bodyView: UIView!
    
    let defaults = UserDefaults.standard
    var bodyPartSelected = ""
    var bodypartid = 0;
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
        bodyView.layer.shadowOpacity=0.3
        bodyView.layer.borderWidth=1.5
        bodyView.layer.borderColor = UIColor.red.cgColor
        
        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        defaults.set("back", forKey: "fronwhichside")
    }
    
    @IBAction func quickSessions(_ sender: Any) {
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        let vc:UIViewController = storyBoard.instantiateViewController(withIdentifier: "quicksessions") as UIViewController
        self.present(vc,animated:true,completion: nil)
    }
    
    @IBAction func GoBack(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func btnNeck(_ sender: Any) {
        self.bodyPartSelected = "Neck"
        self.bodypartid = 24
        goToRollerView(bodypart: self.bodyPartSelected, bodypartid: self.bodypartid)
    }
    
    @IBAction func btnRightTrapezius(_ sender: Any) {
        self.bodyPartSelected = "Right Trapezius"
        self.bodypartid = 25
        goToRollerView(bodypart: self.bodyPartSelected, bodypartid: self.bodypartid)
    }
    
    @IBAction func btnLeftTrapezius(_ sender: Any) {
        self.bodyPartSelected = "Left Trapezius"
        self.bodypartid = 37
        goToRollerView(bodypart: self.bodyPartSelected, bodypartid: self.bodypartid)
    }
    
    @IBAction func btnLeftBackShoulder(_ sender: Any) {
        self.bodyPartSelected = "Left Shoulder"
        self.bodypartid = 39
        goToRollerView(bodypart: self.bodyPartSelected, bodypartid: self.bodypartid)
    }
    
    @IBAction func btnRightBackShoulder(_ sender: Any) {
        self.bodyPartSelected = "Right Shoulder"
        self.bodypartid = 27
        goToRollerView(bodypart: self.bodyPartSelected, bodypartid: self.bodypartid)
    }
    
    @IBAction func btnLeftElbow(_ sender: Any) {
        self.bodyPartSelected = "Left Elbow"
        self.bodypartid = 41
        goToRollerView(bodypart: self.bodyPartSelected, bodypartid: self.bodypartid)
    }
    
    @IBAction func btnUpperBback(_ sender: Any) {
        self.bodyPartSelected = "Upper Back"
        self.bodypartid = 99
        goToRollerView(bodypart: self.bodyPartSelected, bodypartid: self.bodypartid)
    }
    
    @IBAction func btnLeftMidBack(_ sender: Any) {
        self.bodyPartSelected = "Left Mid Back"
        self.bodypartid = 38
        goToRollerView(bodypart: self.bodyPartSelected, bodypartid: self.bodypartid)
    }
    
    @IBAction func btnRightMidBack(_ sender: Any) {
        self.bodyPartSelected = "Right Mid Back"
        self.bodypartid = 26
        goToRollerView(bodypart: self.bodyPartSelected, bodypartid: self.bodypartid)
    }
    
    @IBAction func btnLeftTricepsBack(_ sender: Any) {
        self.bodyPartSelected = "Left Triceps"
        self.bodypartid = 40
        goToRollerView(bodypart: self.bodyPartSelected, bodypartid: self.bodypartid)
    }
    
    @IBAction func btnRightTricepsBack(_ sender: Any) {
        self.bodyPartSelected = "Right Triceps"
        self.bodypartid = 28
        goToRollerView(bodypart: self.bodyPartSelected, bodypartid: self.bodypartid)
    }
    
    @IBAction func btnLeftLatBack(_ sender: Any) {
        self.bodyPartSelected = "Left Lat"
        self.bodypartid = 42
        goToRollerView(bodypart: self.bodyPartSelected, bodypartid: self.bodypartid)
    }
    
    @IBAction func btnRightLatBack(_ sender: Any) {
        self.bodyPartSelected = "Right Lat"
        self.bodypartid = 30
        goToRollerView(bodypart: self.bodyPartSelected, bodypartid: self.bodypartid)
    }
    
    @IBAction func btnRIghtElbow(_ sender: Any) {
        self.bodyPartSelected = "Right Elbow"
        self.bodypartid = 29
        goToRollerView(bodypart: self.bodyPartSelected, bodypartid: self.bodypartid)
    }
    
    @IBAction func btnLeftLowerBack(_ sender: Any) {
        self.bodyPartSelected = "Left Lower Back"
        self.bodypartid = 31
        goToRollerView(bodypart: self.bodyPartSelected, bodypartid: self.bodypartid)
    }
    
    @IBAction func btnRightLowerBack(_ sender: Any) {
        self.bodyPartSelected = "Right Lower Back"
        self.bodypartid = 43
        goToRollerView(bodypart: self.bodyPartSelected, bodypartid: self.bodypartid)
    }
    
    @IBAction func btnLeftForeArmBack(_ sender: Any) {
        self.bodyPartSelected = "Left Forearm"
        self.bodypartid = 44
        goToRollerView(bodypart: self.bodyPartSelected, bodypartid: self.bodypartid)
    }
    
    @IBAction func btnRightForeArmBack(_ sender: Any) {
        self.bodyPartSelected = "Right Forearm"
        self.bodypartid = 45
        goToRollerView(bodypart: self.bodyPartSelected, bodypartid: self.bodypartid)
    }
    
    @IBAction func btnLeftWristBack(_ sender: Any) {
        self.bodyPartSelected = "Left Wrist"
        self.bodypartid = 46
        goToRollerView(bodypart: self.bodyPartSelected, bodypartid: self.bodypartid)
    }
    
    @IBAction func btnRightWristBack(_ sender: Any) {
        self.bodyPartSelected = "Right Wrist"
        self.bodypartid = 47
        goToRollerView(bodypart: self.bodyPartSelected, bodypartid: self.bodypartid)
    }
    
    @IBAction func btnLeftGlut(_ sender: Any) {
        self.bodyPartSelected = "Left Glut"
        self.bodypartid = 32
        goToRollerView(bodypart: self.bodyPartSelected, bodypartid: self.bodypartid)
    }
    
    @IBAction func btnRightGlut(_ sender: Any) {
        self.bodyPartSelected = "Right Glut"
        self.bodypartid = 48
        goToRollerView(bodypart: self.bodyPartSelected, bodypartid: self.bodypartid)
    }
    
    @IBAction func btnLeftHamString(_ sender: Any) {
        self.bodyPartSelected = "Left Hamstring"
        self.bodypartid = 33
        goToRollerView(bodypart: self.bodyPartSelected, bodypartid: self.bodypartid)
    }
    
    @IBAction func btnRightHamString(_ sender: Any) {
        self.bodyPartSelected = "Right Hamstring"
        self.bodypartid = 49
        goToRollerView(bodypart: self.bodyPartSelected, bodypartid: self.bodypartid)
    }
    
    @IBAction func btnLeftKneeBack(_ sender: Any) {
        self.bodyPartSelected = "Left Knee"
        self.bodypartid = 50
        goToRollerView(bodypart: self.bodyPartSelected, bodypartid: self.bodypartid)
    }
    
    @IBAction func btnRightKneeBack(_ sender: Any) {
        self.bodyPartSelected = "Right Knee"
        self.bodypartid = 51
        goToRollerView(bodypart: self.bodyPartSelected, bodypartid: self.bodypartid)
    }
    
    @IBAction func btnLeftCalf(_ sender: Any) {
        self.bodyPartSelected = "Left Calf"
        self.bodypartid = 52
        goToRollerView(bodypart: self.bodyPartSelected, bodypartid: self.bodypartid)
    }
    @IBAction func btnRightCalf(_ sender: Any) {
        self.bodyPartSelected = "Right Calf"
        self.bodypartid = 34
        goToRollerView(bodypart: self.bodyPartSelected, bodypartid: self.bodypartid)
    }
    
    @IBAction func btnLeftAchilles(_ sender: Any) {
        self.bodyPartSelected = "Left Achilles Tendon"
        self.bodypartid = 53
        goToRollerView(bodypart: self.bodyPartSelected, bodypartid: self.bodypartid)
    }
    
    @IBAction func btnRightAchilles(_ sender: Any) {
        self.bodyPartSelected = "Right Achilles Tendon"
        self.bodypartid = 35
        goToRollerView(bodypart: self.bodyPartSelected, bodypartid: self.bodypartid)
    }
    
    
    func goToRollerView(bodypart: String, bodypartid: Int){
        let vc = storyboard?.instantiateViewController(withIdentifier: "rollertracker") as? RollerTracker
        vc?.pageFrom = "frontview"
        vc?.bodypartname = self.bodyPartSelected
        vc?.bodypartid = self.bodypartid
        self.present(vc!, animated: true, completion: nil)
    }
}
