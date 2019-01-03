//
//  SaveSessions.swift
//  MyFitLabSolutions
//
//  Created by Rodrigo Schreiner on 6/18/18.
//  Copyright © 2018 Rodrigo Schreiner. All rights reserved.
//

import UIKit

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
        if let url = URL(string: "http://up2speedtraining.com/mobile/php/up2speed_save_session.php?"){
            let request = NSMutableURLRequest(url:url)
            let defaults = UserDefaults.standard
            if let myUsename = defaults.string(forKey: "username") {
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
                request.httpMethod = "POST";// Compose a query string
                let postString = "mynotes=\(myNotes)&username=\(myUsename)&favorite=\(myFavorite)&minutes=\(myMinutes)&reps=\(myReps)&bodypartid=\(myBodyPart)&painbefore=\(Int(myPainBefore))&painafter=\(Int(myPainAfter))&cooloff=\(String(describing: myCoolOff))"
                print("post String = \(postString)")
                request.httpBody = postString.data(using: String.Encoding.utf8)
                let task = URLSession.shared.dataTask(with:request as URLRequest){
                    data, response, error in
                    
                    if error != nil{
                    }
                    do {
                        if let convertedJsonIntoDict = try JSONSerialization.jsonObject(with: data!, options: .mutableContainers) as? NSArray {
                            if convertedJsonIntoDict.count > 0{
                                let emailValue = (convertedJsonIntoDict[0] as! NSDictionary)["email"] as? String
                                if emailValue != nil{
                                    DispatchQueue.global().async {
                                        DispatchQueue.main.async {
                                            self.dismiss(animated: true, completion: {
                                                UserDefaults.standard.set("session saved", forKey: "issessionsaved")
                                                
                                                
                                                
                                                
                                                
                                            })
                                            UserDefaults.standard.set("Session Saved", forKey: "loginMessage")
                                        }
                                    }
                                }
                                else{
                                    UserDefaults.standard.set("Error Saving Session", forKey: "loginMessage")
                                    self.SendToMainQeue()
                                }
                            }
                            else{
                                UserDefaults.standard.set("Error Saving Session", forKey: "loginMessage")
                                self.SendToMainQeue()
                            }
                        }
                        else{
                            UserDefaults.standard.set("Error Saving Session", forKey: "loginMessage")
                            self.SendToMainQeue()
                        }
                    }
                    catch let error as NSError {
                        print(error.localizedDescription)
                    }
                }
                task.resume()
            }
        }
    }
    
    override func viewDidLoad() {
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
    
    func SendToMainQeue(){
        DispatchQueue.global().async {
            DispatchQueue.main.async {
                self.SendErrorInfo()
            }
        }
    }
    
    func SendErrorInfo(){
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        let vc:UIViewController = storyBoard.instantiateViewController(withIdentifier: "alertview") as UIViewController
        self.present(vc,animated:true,completion: nil)
    }
}

protocol triggerSaveSessionComplete{
    func triggerMySession(data:String)
}
