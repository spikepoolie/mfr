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
        defaults.set("Neck", forKey: "bodypartname")
        defaults.set("24", forKey: "bodypart")
        defaults.set("Neck", forKey: "mybodypartimage")
        goToRollerView()
    }
    
    @IBAction func btnRightTrapezius(_ sender: Any) {
        defaults.set("Right Trapezius", forKey: "bodypartname")
        defaults.set("25", forKey: "bodypart")
        defaults.set("RightTrapezius", forKey: "mybodypartimage")
        goToRollerView()
    }
    
    @IBAction func btnLeftTrapezius(_ sender: Any) {
        defaults.set("Left Trapezius", forKey: "bodypartname")
        defaults.set("37", forKey: "bodypart")
        defaults.set("LeftTrapezius", forKey: "mybodypartimage")
        goToRollerView()
    }
    
    @IBAction func btnLeftBackShoulder(_ sender: Any) {
        defaults.set("Left Shoulder", forKey: "bodypartname")
        defaults.set("39", forKey: "bodypart")
        defaults.set("LeftBackShoulder", forKey: "mybodypartimage")
        goToRollerView()
    }
    
    @IBAction func btnRightBackShoulder(_ sender: Any) {
        defaults.set("Right Shoulder", forKey: "bodypartname")
        defaults.set("27", forKey: "bodypart")
        defaults.set("RightBackShoulder", forKey: "mybodypartimage")
        goToRollerView()
    }
    @IBAction func btnLeftElbow(_ sender: Any) {
        defaults.set("Left Elbow", forKey: "bodypartname")
        defaults.set("41", forKey: "bodypart")
        defaults.set("LeftElbow", forKey: "mybodypartimage")
        goToRollerView()
    }
    
    @IBAction func btnLeftMidBack(_ sender: Any) {
        defaults.set("Left Mid Back", forKey: "bodypartname")
        defaults.set("38", forKey: "bodypart")
        defaults.set("LeftMidBack", forKey: "mybodypartimage")
        goToRollerView()
    }
    
    @IBAction func btnRightMidBack(_ sender: Any) {
        defaults.set("Right Mid Back", forKey: "bodypartname")
        defaults.set("26", forKey: "bodypart")
        defaults.set("RightMidBack", forKey: "mybodypartimage")
        goToRollerView()
    }
    
    @IBAction func btnLeftTricepsBack(_ sender: Any) {
        defaults.set("Left Triceps", forKey: "bodypartname")
        defaults.set("40", forKey: "bodypart")
        defaults.set("LeftBackTriceps", forKey: "mybodypartimage")
        goToRollerView()
    }
    
    @IBAction func btnRightTricepsBack(_ sender: Any) {
        defaults.set("Right Triceps", forKey: "bodypartname")
        defaults.set("28", forKey: "bodypart")
        defaults.set("RightBackTriceps", forKey: "mybodypartimage")
        goToRollerView()
    }
    
    @IBAction func btnLeftLatBack(_ sender: Any) {
        defaults.set("Left Lat", forKey: "bodypartname")
        defaults.set("42", forKey: "bodypart")
        defaults.set("LeftLatBack", forKey: "mybodypartimage")
        goToRollerView()
    }
    
    @IBAction func btnRightLatBack(_ sender: Any) {
        defaults.set("Right Lat", forKey: "bodypartname")
        defaults.set("30", forKey: "bodypart")
        defaults.set("RightLatBack", forKey: "mybodypartimage")
        goToRollerView()
    }
    
    @IBAction func btnRIghtElbow(_ sender: Any) {
        defaults.set("Right Elbow", forKey: "bodypartname")
        defaults.set("29", forKey: "bodypart")
        defaults.set("RightElbow", forKey: "mybodypartimage")
        goToRollerView()
    }
    
    @IBAction func btnLeftLowerBack(_ sender: Any) {
        defaults.set("Left Lower Back", forKey: "bodypartname")
        defaults.set("31", forKey: "bodypart")
        defaults.set("LeftLowerBack", forKey: "mybodypartimage")
        goToRollerView()
    }
    
    @IBAction func btnRightLowerBack(_ sender: Any) {
        defaults.set("Right Lower Back", forKey: "bodypartname")
        defaults.set("43", forKey: "bodypart")
        defaults.set("RightLowerBack", forKey: "mybodypartimage")
        goToRollerView()
    }
    
    @IBAction func btnLeftForeArmBack(_ sender: Any) {
        defaults.set("Left Forearm", forKey: "bodypartname")
        defaults.set("44", forKey: "bodypart")
        defaults.set("LeftForeArmBack", forKey: "mybodypartimage")
        goToRollerView()
    }
    
    @IBAction func btnRightForeArmBack(_ sender: Any) {
        defaults.set("Right Forearm", forKey: "bodypartname")
        defaults.set("45", forKey: "bodypart")
        defaults.set("RightForeArmBack", forKey: "mybodypartimage")
        goToRollerView()
    }
    
    @IBAction func btnLeftWristBack(_ sender: Any) {
        defaults.set("Left Wrist", forKey: "bodypartname")
        defaults.set("46", forKey: "bodypart")
        defaults.set("LeftWristBack", forKey: "mybodypartimage")
        goToRollerView()
    }
    
    @IBAction func btnRightWristBack(_ sender: Any) {
        defaults.set("Right Wrist", forKey: "bodypartname")
        defaults.set("47", forKey: "bodypart")
        defaults.set("RightWristBack", forKey: "mybodypartimage")
        goToRollerView()
    }
    
    @IBAction func btnLeftGlut(_ sender: Any) {
        defaults.set("Left Glut", forKey: "bodypartname")
        defaults.set("32", forKey: "bodypart")
        defaults.set("LeftGlut", forKey: "mybodypartimage")
        goToRollerView()
    }
    
    @IBAction func btnRightGlut(_ sender: Any) {
        defaults.set("Right Glut", forKey: "bodypartname")
        defaults.set("48", forKey: "bodypart")
        defaults.set("RightGlut", forKey: "mybodypartimage")
        goToRollerView()
    }
    
    @IBAction func btnLeftHamString(_ sender: Any) {
        defaults.set("Left Hamstring", forKey: "bodypartname")
        defaults.set("33", forKey: "bodypart")
        defaults.set("LeftHamString", forKey: "mybodypartimage")
        goToRollerView()
    }
    
    @IBAction func btnRightHamString(_ sender: Any) {
        defaults.set("Right Hamstring", forKey: "bodypartname")
        defaults.set("49", forKey: "bodypart")
        defaults.set("RightHamString", forKey: "mybodypartimage")
        goToRollerView()
    }
    
    @IBAction func btnLeftKneeBack(_ sender: Any) {
        defaults.set("Left Knee", forKey: "bodypartname")
        defaults.set("50", forKey: "bodypart")
        defaults.set("LeftBackKnee", forKey: "mybodypartimage")
        goToRollerView()
    }
    
    @IBAction func btnRightKneeBack(_ sender: Any) {
        defaults.set("Right Knee", forKey: "bodypartname")
        defaults.set("51", forKey: "bodypart")
        defaults.set("RightBackKnee", forKey: "mybodypartimage")
        goToRollerView()
    }
    
    @IBAction func btnLeftCalf(_ sender: Any) {
        defaults.set("Left Calf", forKey: "bodypartname")
        defaults.set("52", forKey: "bodypart")
        defaults.set("LeftCalf", forKey: "mybodypartimage")
        goToRollerView()
    }
    @IBAction func btnRightCalf(_ sender: Any) {
        defaults.set("Right Calf", forKey: "bodypartname")
        defaults.set("34", forKey: "bodypart")
        defaults.set("RightCalf", forKey: "mybodypartimage")
        goToRollerView()
    }
    
    @IBAction func btnLeftAchilles(_ sender: Any) {
        defaults.set("Left Achilles Tendon", forKey: "bodypartname")
        defaults.set("53", forKey: "bodypart")
        defaults.set("LeftAchillesTendon", forKey: "mybodypartimage")
        goToRollerView()
    }
    
    @IBAction func btnRightAchilles(_ sender: Any) {
        defaults.set("Right Achilles Tendon", forKey: "bodypartname")
        defaults.set("35", forKey: "bodypart")
        defaults.set("RighAchillesTendon", forKey: "mybodypartimage")
        goToRollerView()
    }
    
    func goToRollerView(){
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        
        let vc:UIViewController = storyBoard.instantiateViewController(withIdentifier: "rollertracker") as UIViewController
        self.present(vc,animated:true,completion: nil)
    }
    
    
}
