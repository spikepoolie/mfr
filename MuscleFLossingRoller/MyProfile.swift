//
//  MyProfile.swift
//  MFR
//
//  Created by Rodrigo Schreiner on 5/16/17.
//  Copyright © 2017 Up2SpeedTraining. All rights reserved.
//

import UIKit

class MyProfile: UIViewController{

 
    let defaults = UserDefaults.standard
    var profileImageUrl: String!
    var hasProfileImage = false
    var mydata = Data()
    
    @IBOutlet weak var verticalLine: UIImageView!
    @IBOutlet weak var horizontalLine: UIImageView!
    @IBOutlet weak var btnChart: UIButton!
    @IBOutlet weak var myImageProfile: UIImageView!
    @IBOutlet weak var btnStreching: UIButton!
    @IBOutlet weak var btnPerson: UIButton!
    @IBOutlet weak var btnExercise: UIButton!
    
    @IBOutlet weak var lblTracker: UILabel!
    @IBOutlet weak var lblStreching: UILabel!
    @IBOutlet weak var lblRoller: UILabel!
    @IBOutlet weak var lblExercise: UILabel!
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
   
    @IBAction func GoToMyOptions(_ sender: Any) {
        defaults.set("myprofile", forKey: "fromwhichview")
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        let vc:UIViewController = storyBoard.instantiateViewController(withIdentifier: "viewsideoptions") as UIViewController
        
        self.present(vc,animated:true,completion: nil)
        
    }
    
    @IBAction func LogMeOut(_ sender: Any) {
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        let vc:UIViewController = storyBoard.instantiateViewController(withIdentifier: "logmein") as UIViewController
        self.present(vc,animated:true,completion: nil)

    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        btnExercise.alpha = 0.0
        btnPerson.alpha = 0.0
        btnStreching.alpha = 0.0
        btnChart.alpha = 0.0
        lblExercise.alpha = 0.0
        lblRoller.alpha = 0.0
        lblStreching.alpha = 0.0
        lblTracker.alpha = 0.0
        verticalLine.alpha = 0.0
        horizontalLine.alpha = 0.0
        
        if((defaults.data(forKey: "imageProfile")) != nil){
            let imageProfile = defaults.data(forKey: "imageProfile")! as NSData
            self.myImageProfile.image = UIImage(data: imageProfile as Data)
        } else {
            let imageProfile = UIImage(named: "userButtom")
            let myUserImageData: NSData = imageProfile!.pngData()! as NSData
            self.myImageProfile.image = UIImage(data: myUserImageData as Data)
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        let duration: Double = 0.2
        let delay: Double = 0.0
       // UIButton.animate(withDuration: duration,delay: delay, usingSpringWithDamping: 3.0, initialSpringVelocity: 1.5, options: .curveEaseIn, animations: {
//            self.moveIcons(btn: self.btnExercise)
//            self.moveIcons(btn: self.btnPerson)
//            self.moveIcons(btn: self.btnStreching)
//            self.moveIcons(btn: self.btnChart)
//        }) { (_) in
            
        UIButton.animate(withDuration: duration, delay: 0.0, options: UIButton.AnimationOptions.curveEaseIn, animations: {
            self.lblExercise.alpha = 1.0
            self.btnExercise.alpha = 1.0
        }, completion: nil)

        UIButton.animate(withDuration: duration, delay: 0.2, options: UIButton.AnimationOptions.curveEaseIn, animations: {
            self.btnPerson.alpha = 1.0
            self.lblRoller.alpha = 1.0
        }, completion: nil)
    
        UIButton.animate(withDuration: duration, delay: 0.4, options: UIButton.AnimationOptions.curveEaseIn, animations: {
            self.btnStreching.alpha = 1.0
            self.lblStreching.alpha = 1.0
        }, completion: nil)
    
        UIButton.animate(withDuration: duration, delay: 0.6, options: UIButton.AnimationOptions.curveEaseIn, animations: {
            self.lblTracker.alpha = 1.0
            self.btnChart.alpha = 1.0
        }, completion: nil)
    
        UIButton.animate(withDuration: 0.5, delay: 0.8, options: UIButton.AnimationOptions.curveEaseIn, animations: {
            self.verticalLine.alpha = 1.0
            self.horizontalLine.alpha = 1.0
        }, completion: nil)
        
        //}
    }
    
    func moveIcons(btn: UIButton) {
       // switch btn {
       // case btnExercise, btnChart:
           // btn.center.x = CGFloat(currentCoachtryoutPositon)
            
        //    break
       // default:
           // btn.center.x = CGFloat(currentPlayerResultsPositon)
        //}
    }
    
    func downloadImage(from url: URL) {
        getData(from: url) { data, response, error in
            guard let data = data, error == nil else { return }
            DispatchQueue.main.async() {
                self.mydata = data
                self.myImageProfile.image = UIImage(data: data)!
                self.myImageProfile.layer.cornerRadius=10
                self.myImageProfile.clipsToBounds = true
                self.myImageProfile.layer.cornerRadius=10
                self.myImageProfile.clipsToBounds=true
                self.myImageProfile.layer.borderColor=UIColor.lightGray.cgColor
               self.myImageProfile.layer.borderWidth=1
            }
        }
    }
    
    func getData(from url: URL, completion: @escaping (Data?, URLResponse?, Error?) -> ()) {
        URLSession.shared.dataTask(with: url, completionHandler: completion).resume()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func getFormattedData(inputDate:String)-> String{
        
        var outputDate = ""
        
        let formatter = DateFormatter()//2017-02-14 02:30:08
        formatter.dateFormat = "yyyy-MM-DD HH:mm:ss"
        
        if let dateObject = formatter.date(from: inputDate){
            formatter.setLocalizedDateFormatFromTemplate("EEEE, MMM d, yyyy hh:mm a")
            outputDate =  formatter.string(from: dateObject)
            
        }
        return outputDate
    }
    

    @IBAction func myTracker(_ sender: Any) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "mysessionsoptions") as! MySessionsOptions
        //vc.myImageData = self.mydata
        self.present(vc, animated: true, completion: nil)
    }
    
    
    @IBAction func btnFaceBook(_ sender: Any) {
        /*
        let url = URL(string: "https://www.apple.com")
        if #available(iOS 10.0, *) {
            UIApplication.shared.open(url!, options: [:], completionHandler: nil)
        } else {
            UIApplication.shared.openURL(url!)
        }
        */
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        let vc:UIViewController = storyBoard.instantiateViewController(withIdentifier: "webview") as UIViewController
        self.present(vc,animated:true,completion: nil)
    }
}
