//
//  ViewOptions.swift
//  MFR
//
//  Created by Rodrigo Schreiner on 5/27/17.
//  Copyright © 2017 Up2SpeedTraining. All rights reserved.
//

import UIKit

class ViewOptions: UIViewController {
    
    @IBOutlet weak var sideviewoptions: UIImageView!
  
    var myImageData = Data()
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
   
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let rightSwipe = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipe(sender:)))
        rightSwipe.direction = .right
       
        view.addGestureRecognizer(rightSwipe)
       
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    @IBAction func goToBackView(_ sender: Any) {
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        
        
        let vc:UIViewController = storyBoard.instantiateViewController(withIdentifier: "backview") as UIViewController
        self.present(vc,animated:true,completion: nil)
        
    }
    
    @IBAction func goToFrontView(_ sender: Any) {
        
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "frontview") as! FrontView
        vc.myImage = myImageData
        self.present(vc, animated: true, completion: nil)
    }
   
    @IBAction func GoBack(_ sender: Any) {
       // let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
         goBackToThePreviousScreen()
        
        
    }
    
    @objc func handleSwipe(sender: UISwipeGestureRecognizer) {
        
        if sender.state == .ended {
            switch sender.direction {
                case .right:
                    goBackToThePreviousScreen()
                default:
                    goBackToThePreviousScreen()
                break
            }
        }
    }
    
    func goBackToThePreviousScreen() {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "myprofile") as! MyProfile
        vc.hasProfileImage = true
        vc.mydata = self.myImageData
        vc.canClick = true
        self.present(vc, animated: true, completion: nil)
    }
}
