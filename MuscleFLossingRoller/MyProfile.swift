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

    @IBOutlet weak var myImageProfile: UIImageView!
    var profileImageUrl: String!
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    
    @IBAction func GoToMyOptions(_ sender: Any) {
        defaults.set("myprofile", forKey: "fromwhichview")
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        let vc:UIViewController = storyBoard.instantiateViewController(withIdentifier: "viewoptions") as UIViewController
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
        downloadImage(from: NSURL(string:profileImageUrl)! as URL)
        myImageProfile.layer.cornerRadius=10
        myImageProfile.clipsToBounds = true
        myImageProfile.layer.cornerRadius=10
        myImageProfile.clipsToBounds=true
        myImageProfile.layer.borderColor=UIColor.lightGray.cgColor
        myImageProfile.layer.borderWidth=1
    }
    
    func downloadImage(from url: URL) {
        print("Download Started")
        getData(from: url) { data, response, error in
            guard let data = data, error == nil else { return }
            print(response?.suggestedFilename ?? url.lastPathComponent)
            print("Download Finished")
            DispatchQueue.main.async() {
                self.myImageProfile.image = UIImage(data: data)!
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
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        
        
         let vc:UIViewController = storyBoard.instantiateViewController(withIdentifier: "viewsideoptions") as UIViewController
        
        //let vc:UIViewController = storyBoard.instantiateViewController(withIdentifier: "popupoptions") as UIViewController
        self.present(vc,animated:true,completion: nil)
        
    }
    
    
    func getDataFromUrl(url: URL, completion: @escaping (_ data: Data?, _  response: URLResponse?, _ error: Error?) -> Void) {
        URLSession.shared.dataTask(with: url) {
            (data, response, error) in
            completion(data, response, error)
            }.resume()
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
    
    func downloadImage(url: URL) {
        getDataFromUrl(url: url) { (data, response, error)  in
            if data != nil{
                let image = UIImage(data:data!)
                if image != nil{
                    DispatchQueue.main.async(execute:{
                        self.myImageProfile.image = image
                        self.myImageProfile.layer.cornerRadius=58
                        self.myImageProfile.layer.masksToBounds=true
                    })
                }
            }
        }
    }
}
