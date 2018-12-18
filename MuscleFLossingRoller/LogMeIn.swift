//
//  LoginViewController.swift
//  mfr
//
//  Created by Rodrigo Schreiner on 1/13/17.
//  Copyright © 2017 Rodrigo Schreiner. All rights reserved.
//

import UIKit

class LogMeIn: UIViewController , UITextFieldDelegate{
    @IBOutlet weak var txtPassword: UITextField!
    @IBOutlet weak var txtEmailAddress: UITextField!
    @IBOutlet weak var btnLogin: UIButton!
    @IBOutlet weak var waitToLogIn: UIActivityIndicatorView!
    
    var myUsername = ""
    var myPassword = ""
    
    override var prefersStatusBarHidden: Bool {
        return true
    }

    @IBOutlet var logmeview: UIView!
   
    let defaults = UserDefaults.standard
    
    @IBAction func btnLogin(_ sender: Any) {
        waitToLogIn.startAnimating()
        var emailOk = 1
        var passwordOk = 1
        //let defaults = UserDefaults.standard
        if isValidEmail(testStr: txtEmailAddress.text!){
            if txtEmailAddress.text!.characters.count == 0 || txtEmailAddress.text == " "{
                emailOk = 0
                waitToLogIn.stopAnimating()
                txtEmailAddress.shake()
            }
            else{
                emailOk = 1
            }
            if txtPassword.text!.count == 0 || txtPassword.text == " "{
                passwordOk = 0
                waitToLogIn.stopAnimating()
            }
            else{
                passwordOk = 1
            }
            
            if emailOk == 1 && passwordOk == 1{
                myUsername = (txtEmailAddress.text)!
                myPassword = (txtPassword.text)!
                sendLoginInfo(username: myUsername,password: myPassword)
            }
        }
        else{
            waitToLogIn.stopAnimating()
        }
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        btnLogin.layer.cornerRadius=10
        btnLogin.layer.masksToBounds=true
        txtPassword.delegate=self
        txtEmailAddress.delegate=self
       // txtEmailAddress.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        //txtPassword.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        txtPassword.text="a"
        txtEmailAddress.text="a@a.com"
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func ShowErrorMessage(){
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        
        let vc:UIViewController = storyBoard.instantiateViewController(withIdentifier: "alertview") as UIViewController
        self.present(vc,animated:true,completion: nil)
    }
    
    func isValidEmail(testStr:String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
        
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailTest.evaluate(with: testStr)
    }
    
    func SendToMainQeue(){
        DispatchQueue.global().async {
            DispatchQueue.main.async {
                self.waitToLogIn.stopAnimating()
                self.txtEmailAddress.shake()
                self.txtPassword.shake()
                //self.CreateAccount()
                
                 let defaults = UserDefaults.standard
                 defaults.set("Wrong email or password", forKey: "loginMessage")
                 self.txtEmailAddress.shake()
                 self.txtPassword.shake()
                 self.btnLogin.isEnabled=true
                 //self.btnLogin.alpha=1
                
            }
        }
    }
    
    func SendToMainQeue1(){
        DispatchQueue.global().async {
            DispatchQueue.main.async {
                //self.txtEmailAddress.shake()
                //self.txtPassword.shake()
            }
        }
    }
    
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        return true
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
       // if Int(self.view.frame.size.height) < 569{ // iphone 5 or older
            moveTextField(textField: textField, moveDistance: -250, up: true)
       // }
    }
    
    
    func textFieldDidEndEditing(_ textField: UITextField) {
       // if Int(self.view.frame.size.height) < 569{ // iphone 5 or older
            moveTextField(textField: textField, moveDistance: -250, up: false)
       // }
        if txtEmailAddress.text?.characters.count == 0 || txtPassword.text?.characters.count == 0{
            //btnLogin.isEnabled = false
            //btnLogin.backgroundColor = UIColor.darkGray.withAlphaComponent(0.5)
            //btnLogin.setTitleColor(UIColor.gray , for: .normal)
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func sendLoginInfo(username: String, password: String){
        
        if let url = URL(string: "http://www.up2speedtraining.com/mobile/php/up2speed_login.php"){
            let request = NSMutableURLRequest(url:url)
            request.httpMethod = "POST";// Compose a query string
            let postString = "email=\(myUsername)&password=\(myPassword)"
            request.httpBody = postString.data(using: String.Encoding.utf8)
            let task = URLSession.shared.dataTask(with:request as URLRequest){
                data, response, error in
                
                if error != nil{
                }
                do {
                    if let convertedJsonIntoDict = try JSONSerialization.jsonObject(with: data!, options: .mutableContainers) as? NSArray {
                        if convertedJsonIntoDict.count > 0{
                            let emailValue = (convertedJsonIntoDict[0] as! NSDictionary)["email"] as? String
                            let myuserid = (convertedJsonIntoDict[0] as! NSDictionary)["userid"] as? Int
                            UserDefaults.standard.set(myuserid, forKey: "myuserid")
                            if emailValue != nil{
                                UserDefaults.standard.set(self.myUsername, forKey: "username")
                                
                                DispatchQueue.global().async {
                                    DispatchQueue.main.async {
                                        self.btnLogin.isEnabled=true
                                        self.waitToLogIn.stopAnimating()
                                        UserDefaults.standard.set(self.myUsername, forKey: "username")
                                        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
                                       
                                        let vc:UIViewController = storyBoard.instantiateViewController(withIdentifier: "myprofile") as UIViewController
                                        self.present(vc,animated:true,completion: nil)
                                      
                                    }
                                }
                            }
                            else{
                                self.btnLogin.isEnabled=true
                                self.SendToMainQeue()
                            }
                        }
                        else{
                            self.btnLogin.isEnabled=true
                            UserDefaults.standard.set("blank", forKey: "username")
                            UserDefaults.standard.set("blank", forKey: "password")
                            UserDefaults.standard.set("blank", forKey: "name")
                            self.SendToMainQeue()
                        }
                    }
                    else{
                        self.btnLogin.isEnabled=true
                        UserDefaults.standard.set("blank", forKey: "username")
                        UserDefaults.standard.set("blank", forKey: "password")
                        UserDefaults.standard.set("blank", forKey: "name")
                        self.SendToMainQeue()
                    }
                }
                catch let error as NSError {
                    self.btnLogin.isEnabled=true
                    //self.btnLogin.alpha=1
                    print(error.localizedDescription)
                }
            }
            task.resume()
        }
    }
    
    func moveTextField(textField: UITextField, moveDistance: Int, up:Bool){
        let moveDuration = 0.3
        let movement : CGFloat = CGFloat(up ? moveDistance:-moveDistance)
        UIView.beginAnimations("animateTextField", context: nil)
        UIView.setAnimationBeginsFromCurrentState(true)
        UIView.setAnimationDuration(moveDuration)
        self.view.frame = self.view.frame.offsetBy(dx: 0,dy: movement)
        UIView.commitAnimations()
    }
}
