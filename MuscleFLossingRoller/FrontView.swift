//
//  FrontView.swift
//  MyFitLabSolutions
//
//  Created by Rodrigo Schreiner on 6/14/18.
//  Copyright © 2018 Rodrigo Schreiner. All rights reserved.
//

import UIKit

class FrontView: UIViewController {
    override var prefersStatusBarHidden: Bool {
        return true
    }
    @IBOutlet var bodyView: UIView!
    var myImage = Data()
    let defaults = UserDefaults.standard
    var bodyPartSelected = ""
    var bodypartid = 0;
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let rightSwipe = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipe(sender:)))
        rightSwipe.direction = .right
        bodyView.layer.shadowOpacity=0.3
        bodyView.layer.borderWidth=1.5
        bodyView.layer.borderColor = UIColor.red.cgColor
        view.addGestureRecognizer(rightSwipe)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        defaults.set("front", forKey: "fronwhichside")
    }
    
    @IBAction func QuickSessions(_ sender: Any) {
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        let vc:UIViewController = storyBoard.instantiateViewController(withIdentifier: "quicksessions") as UIViewController
        self.present(vc,animated:true,completion: nil)
    }
    
    @IBAction func BackToBodyParts(_ sender: Any) {
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        let vc:UIViewController = storyBoard.instantiateViewController(withIdentifier: "bodyparts") as UIViewController
        self.present(vc,animated:true,completion: nil)
    }
    
    @IBAction func buttonrightshoulder(_ sender: Any) {
        self.bodyPartSelected = "Right Shoulder"
        self.bodypartid = 3
        goToRollerView(bodypart: self.bodyPartSelected, bodypartid: self.bodypartid)
    }
    
    @IBAction func buttonleftshoulder(_ sender: Any) {
        self.bodyPartSelected = "Left Shoulder"
        self.bodypartid = 4
        goToRollerView(bodypart: self.bodyPartSelected, bodypartid: self.bodypartid)
    }


    @IBAction func buttonrightbiceps(_ sender: Any) {
        self.bodyPartSelected = "Right Biceps"
        self.bodypartid = 7
        goToRollerView(bodypart: self.bodyPartSelected, bodypartid: self.bodypartid)
    }

    @IBAction func buttonleftbiceps(_ sender: Any) {
        self.bodyPartSelected = "Left Biceps"
        self.bodypartid = 8
        goToRollerView(bodypart: self.bodyPartSelected, bodypartid: self.bodypartid)
    }

    @IBAction func buttonrightforearm(_ sender: Any) {
        self.bodyPartSelected = "Right Fore Arm"
        self.bodypartid = 9
        goToRollerView(bodypart: self.bodyPartSelected, bodypartid: self.bodypartid)
    }

    @IBAction func buttonleftforearm(_ sender: Any) {
        self.bodyPartSelected = "Left Fore Arm"
        self.bodypartid = 10
        goToRollerView(bodypart: self.bodyPartSelected, bodypartid: self.bodypartid)
    }

    @IBAction func buttonrightwrist(_ sender: Any) {
        self.bodyPartSelected = "Right Wrist"
        self.bodypartid = 11
        goToRollerView(bodypart: self.bodyPartSelected, bodypartid: self.bodypartid)
    }

    @IBAction func buttonleftwrist(_ sender: Any) {
        self.bodyPartSelected = "Left Wrist"
        self.bodypartid = 12
        goToRollerView(bodypart: self.bodyPartSelected, bodypartid: self.bodypartid)
    }

    @IBAction func buttonrightabs(_ sender: Any) {
        self.bodyPartSelected = "Right Abs"
        self.bodypartid = 14
        goToRollerView(bodypart: self.bodyPartSelected, bodypartid: self.bodypartid)
    }

    @IBAction func buttonleftabs(_ sender: Any) {
        self.bodyPartSelected = "Left Abs"
        self.bodypartid = 13
        goToRollerView(bodypart: self.bodyPartSelected, bodypartid: self.bodypartid)
    }

    @IBAction func buttonmiddleabs(_ sender: Any) {
        self.bodyPartSelected = "Middle Abs"
        self.bodypartid = 15
        goToRollerView(bodypart: self.bodyPartSelected, bodypartid: self.bodypartid)
    }

    @IBAction func buttonrightthigh(_ sender: Any) {
        self.bodyPartSelected = "Right Thigh"
        self.bodypartid = 16
        goToRollerView(bodypart: self.bodyPartSelected, bodypartid: self.bodypartid)
    }

    @IBAction func buttonleftthigh(_ sender: Any) {
        self.bodyPartSelected = "Left Thigh"
        self.bodypartid = 17
        goToRollerView(bodypart: self.bodyPartSelected, bodypartid: self.bodypartid)
    }

    @IBAction func buttonrightknee(_ sender: Any) {
        self.bodyPartSelected = "Right Knee"
        self.bodypartid = 20
        goToRollerView(bodypart: self.bodyPartSelected, bodypartid: self.bodypartid)
    }

    @IBAction func buttonleftknee(_ sender: Any) {
        self.bodyPartSelected = "Left Knee"
        self.bodypartid = 21
        goToRollerView(bodypart: self.bodyPartSelected, bodypartid: self.bodypartid)
    }


    @IBAction func buttonrightchin(_ sender: Any) {
        self.bodyPartSelected = "Right Chin"
        self.bodypartid = 24
        goToRollerView(bodypart: self.bodyPartSelected, bodypartid: self.bodypartid)
    }

    @IBAction func buttonleftchin(_ sender: Any) {
        self.bodyPartSelected = "Left Chin"
        self.bodypartid = 25
        goToRollerView(bodypart: self.bodyPartSelected, bodypartid: self.bodypartid)
    }

    @IBAction func buttonrightchest(_ sender: Any) {
        self.bodyPartSelected = "Right Chest"
        self.bodypartid = 1
        goToRollerView(bodypart: self.bodyPartSelected, bodypartid: self.bodypartid)
    }

    @IBAction func buttonleftchest(_ sender: Any) {
        self.bodyPartSelected = "Left Chest"
        self.bodypartid = 2
        goToRollerView(bodypart: self.bodyPartSelected, bodypartid: self.bodypartid)
    }

    @IBAction func buttonrightankle(_ sender: Any) {
        self.bodyPartSelected = "Right Ankle"
        self.bodypartid = 22
        goToRollerView(bodypart: self.bodyPartSelected, bodypartid: self.bodypartid)
    }

    @IBAction func buttonleftankle(_ sender: Any) {
        self.bodyPartSelected = "Left Ankle"
        self.bodypartid = 23
        goToRollerView(bodypart: self.bodyPartSelected, bodypartid: self.bodypartid)
    }

    @IBAction func back(_ sender: Any) {
      dismiss(animated: true, completion: nil)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @objc func handleSwipe(sender: UISwipeGestureRecognizer) {
        
        if sender.state == .ended {
            switch sender.direction {
            case .right:
                self.goBack()
            default:
                break
            }
        }
    }
    
    func goBack(){
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        let vc:UIViewController = storyBoard.instantiateViewController(withIdentifier: "viewsideoptions") as UIViewController
        self.present(vc,animated:true,completion: nil)
    }
    
    func goToRollerView(bodypart: String, bodypartid: Int){
        let vc = storyboard?.instantiateViewController(withIdentifier: "rollertracker") as? RollerTracker
        vc?.pageFrom = "frontview"
        vc?.bodypartname = self.bodyPartSelected
        vc?.bodypartid = self.bodypartid
        self.present(vc!, animated: true, completion: nil)
    }
}
