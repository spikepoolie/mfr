//
//  SaveSessions.swift
//  MyFitLabSolutions
//
//  Created by Rodrigo Schreiner on 6/18/18.
//  Copyright © 2018 Rodrigo Schreiner. All rights reserved.
//

import UIKit
import FirebaseFirestore

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
   // var ref: DatabaseReference?
    override var prefersStatusBarHidden: Bool {
        return true
    }
    var delegate: triggerSaveSessionComplete?
    var currentImageName = "favorites"
    var bodyPartId = 0
    var minutesRolling = 0
    var repsDone = 0
    var bodyPartName = ""
    var coolOff = 0
    var dateString = ""
    
    
    let defaults = UserDefaults.standard
    
   
    @IBOutlet var savesession: UIView!
    @IBOutlet weak var btntest: CustomButton!
    @IBOutlet weak var labelPainBefore: UILabel!
    @IBOutlet weak var notes: UITextView!
    @IBOutlet weak var labelPainAfter: UILabel!
    @IBOutlet weak var sliderPainAfter: UISlider!
    @IBOutlet weak var sliderPainBefore: UISlider!
    @IBOutlet weak var favoriteimage: UIImageView!
    
    override func viewDidLoad() {
       // ref = Database.database().reference().child("Sessions")
        super.viewDidLoad()
        notes.text=""
        notes.delegate = self
        savesession.layer.cornerRadius=5
        savesession.layer.shadowOpacity=0.3
        savesession.layer.borderWidth=1.5
        savesession.layer.borderColor = UIColor.white.cgColor
        
//        let timestamp = Date().timeIntervalSince1970
//
//        let date = Date(timeIntervalSince1970: timestamp)
//
//        let dateFormatter = DateFormatter()
//        dateFormatter.dateFormat = "MM/dd/yyyy h:mm:ss a"  // change to your required format
//        dateFormatter.amSymbol = "AM"
//        dateFormatter.pmSymbol = "PM"
//        dateFormatter.timeZone = TimeZone.current
//
//        // date with time portion in your specified timezone
//        dateString = dateFormatter.string(from: Date())
        
    }

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
            let myPainBefore = Int(sliderPainBefore.value)
            let myPainAfter =  Int(sliderPainAfter.value)
            let myNotes = notes.text!
            var myFavorite = 0
            if currentImageName != "favorites"{
                myFavorite = 1
            }
            else{
                myFavorite = 0
            }
            
            let db = Firestore.firestore()

            db.collection("sessions").document(myUsename).setData([
                "username" : myUsename,
                "minutes" : minutesRolling,
                "reps" : repsDone,
                "bodypartname" : bodyPartName,
                "bodypartid" : bodyPartId,
                "cooloff" : coolOff,
                "painbefore": myPainBefore,
                "painafter" :myPainAfter,
                "notes" : myNotes,
                "isfavorite" : myFavorite,
                "sessiondate" : Date()
            ]) { err in
                if err != nil {
                    UserDefaults.standard.set("Error Saving Session", forKey: "loginMessage")
                    self.SendInfo()

                } else {
                    self.dismiss(animated: true, completion: nil)
                    UserDefaults.standard.set("session saved", forKey: "issessionsaved")
                    UserDefaults.standard.set("Session Saved", forKey: "loginMessage")
                }
            }
        }
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
