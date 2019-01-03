//
//  SaveSessions.swift
//  MyFitLabSolutions
//
//  Created by Rodrigo Schreiner on 6/18/18.
//  Copyright © 2018 Rodrigo Schreiner. All rights reserved.
//

import UIKit
import FirebaseDatabase

extension UITextView {
    
    func addDoneButton() {
        let keyboardToolbar = UIToolbar()
        keyboardToolbar.sizeToFit()
        let flexBarButton = UIBarButtonItem(barButtonSystemItem: .flexibleSpace,
                                            target: nil, action: nil)
        let doneBarButton = UIBarButtonItem(barButtonSystemItem: .done,
                                            target: self, action: #selector(UIView.endEditing(_:)))
        keyboardToolbar.items = [flexBarButton, doneBarButton]
        self.inputAccessoryView = keyboardToolbar
    }
}

class SaveSessions: UIViewController, UITextViewDelegate {
    var ref: DatabaseReference?
    override var prefersStatusBarHidden: Bool {
        return true
    }
    var delegate: triggerSaveSessionComplete?
    var painlevelbefore=0
    var currentImageName = "favorites"
    var bodyPartId = 0
    var painlevelafer=0
    
    
    let defaults = UserDefaults.standard
    
   
    @IBOutlet var savesession: UIView!
    @IBOutlet weak var btntest: CustomButton!
    @IBOutlet weak var labelPainBefore: UILabel!
    @IBOutlet weak var notes: UITextView!
    @IBOutlet weak var labelPainAfter: UILabel!
    @IBOutlet weak var sliderPainAfter: UISlider!
    @IBOutlet weak var sliderPainBefore: UISlider!
    @IBOutlet weak var favoriteimage: UIImageView!

    @IBAction func slidePainBefore(_ sender: Any) {
        let myPainBefore = Int(sliderPainBefore.value)
        labelPainBefore.text = "\(myPainBefore)"
    }
   
    @IBAction func setFavorite(_ sender: Any) {
        if currentImageName == "favorites"{
            currentImageName = "setfavorite"
            favoriteimage.image = UIImage(named:"setfavorite")
        }
        else{
            currentImageName = "favorites"
            favoriteimage.image = UIImage(named:"favorites")
        }
    }
    
    @IBAction func sliderPainAfter(_ sender: Any) {
        let myPainAfter = Int(sliderPainAfter.value)
        labelPainAfter.text = "\(myPainAfter)"
    }
    
    
    @IBAction func SaveRollSession(_ sender: Any) {
        
        let defaults = UserDefaults.standard
        if let myUsename = defaults.string(forKey: "myuserid") {
            let myMinutes = defaults.string(forKey: "minutesrolling")!
            let myReps = defaults.string(forKey: "repsdone")!
            //let myBodyPart = defaults.string(forKey: "bodypart")!
            let myBodyPart = bodyPartId
            let myCoolOff = defaults.string(forKey: "cooloff")!
            let myPainBefore = sliderPainBefore.value
            let myPainAfter =  sliderPainAfter.value
            let myNotes = notes.text!
            var myFavorite = 0
            if currentImageName != "favorites"{
                myFavorite = 1
            }
            else{
                myFavorite = 0
            }
            
            let key = ref?.childByAutoId().key
            let newSession = [
                "username" : myUsename,
                "minutes" : myMinutes,
                "reps" : myReps,
                "bodypart" : bodyPartId,
                "cooloff" : myCoolOff,
                "painbefore": myPainBefore,
                "painafter" :myPainAfter,
                "notes" : myNotes,
                "isfavorite" : myFavorite
                ] as [String : Any]
            if ((self.ref?.child(key!).setValue( newSession )) != nil){
                UserDefaults.standard.set("session saved", forKey: "issessionsaved")
                 UserDefaults.standard.set("Session Saved", forKey: "loginMessage")
            } else {
                UserDefaults.standard.set("Error Saving Session", forKey: "loginMessage")
                SendInfo()
            }
        }
       
    }
    
    override func viewDidLoad() {
        ref = Database.database().reference().child("Sessions")
        super.viewDidLoad()
        notes.text=""
        notes.delegate = self
        savesession.layer.cornerRadius=5
        savesession.layer.shadowOpacity=0.3
        savesession.layer.borderWidth=1.5
        savesession.layer.borderColor = UIColor.white.cgColor
       
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidLayoutSubviews() {
//        let maskLayer = CAShapeLayer()
//        maskLayer.path = UIBezierPath(roundedRect: view.bounds, byRoundingCorners: [.topLeft, .topRight], cornerRadii: CGSize(width: 10, height: 10)).cgPath
//        saveSessionTopBar.layer.mask = maskLayer
    }
    
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        let resultRange = text.rangeOfCharacter(from: CharacterSet.newlines, options: .backwards)
        if text.count == 1 && resultRange != nil {
            textView.resignFirstResponder()
            return false
        }
        return true
    }
    
    @IBAction func CloseSaveSession(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }

    
    func SendInfo(){
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        let vc:UIViewController = storyBoard.instantiateViewController(withIdentifier: "alertview") as UIViewController
        self.present(vc,animated:true,completion: nil)
    }
}

protocol triggerSaveSessionComplete{
    func triggerMySession(data:String)
}
