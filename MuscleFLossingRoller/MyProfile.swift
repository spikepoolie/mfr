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
    var canClick = false
    var profileImageUrl: String!
    var hasProfileImage = false
    var mydata = Data()
    
    @IBOutlet weak var myImageProfile: UIImageView!
    
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
        
        let myUser = defaults.integer(forKey: "myuserid")
        let imageProfile = defaults.data(forKey: "imageProfile")! as NSData
        self.myImageProfile.image = UIImage(data: imageProfile as Data)
        
//        if !hasProfileImage {
//            downloadImage(from: NSURL(string:profileImageUrl)! as URL)
//        } else {
//            self.myImageProfile.image = UIImage(data: mydata)!
//        }
        
    }
    
    func downloadImage(from url: URL) {
        getData(from: url) { data, response, error in
            guard let data = data, error == nil else { return }
            DispatchQueue.main.async() {
                self.mydata = data
                self.myImageProfile.image = UIImage(data: data)!
                self.canClick = true
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
        if canClick{
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "viewsideoptions") as! ViewOptions
            vc.myImageData = self.mydata
            self.present(vc, animated: true, completion: nil)
        }
        
        
     
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
