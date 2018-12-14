//
//  LoginAlert.swift
//  popup
//
//  Created by Rodrigo Schreiner on 1/18/17.
//  Copyright © 2017 Rodrigo Schreiner. All rights reserved.
//

import UIKit

class LoginAlert: UIViewController {

   
    
   
    @IBOutlet weak var redview: UIView!
    @IBOutlet weak var loginAlert: UIView!
    @IBOutlet weak var lblMessage: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loginAlert.layer.cornerRadius=15
        loginAlert.layer.masksToBounds=true
        loginAlert.layer.borderWidth=2
        loginAlert.layer.borderColor=UIColor.red.cgColor
        
        let defaults = UserDefaults.standard
        if let name = defaults.string(forKey: "loginMessage") {
            lblMessage.text = name
            
        }
        

        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        loginAlert.transform = CGAffineTransform(scaleX: 1.5, y: 1.5)
        self.loginAlert.backgroundColor=UIColor.red
        UIView.animate(withDuration: 2, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 0.5, options: .allowUserInteraction, animations:{
            
            self.loginAlert.transform = CGAffineTransform.identity
            // loginAlert.layer.backgroundColor=originalColor
            self.loginAlert.backgroundColor=UIColor.black
            //btnLogin.setTitle("Creating Account",for: .normal)
        }, completion: nil)

    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    @IBAction func closePanel(_ sender: Any) {
         dismiss(animated: true, completion: nil)
    }
}
