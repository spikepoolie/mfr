//
//  NewLogin.swift
//  MFR
//
//  Created by Rodrigo Schreiner on 5/20/17.
//  Copyright © 2017 Up2SpeedTraining. All rights reserved.
//

import UIKit
import FirebaseDatabase
import FirebaseStorage

extension UIImage {
    func resized(img: UIImage, size: CGSize) -> UIImage? {
        UIGraphicsBeginImageContext(size)
        img.draw(in: CGRect(origin: .zero, size: size))
        let scaledImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return scaledImage
    }
}

extension UIImage {
    
    /// Returns a image that fills in newSize
    func resizedImage(newSize: CGSize) -> UIImage {
        // Guard newSize is different
        guard self.size != newSize else { return self }
        let canvasSize = CGSize(width: size.width, height: size.height)
        UIGraphicsBeginImageContextWithOptions(newSize, false, 0.0);
        self.draw(in: CGRect(origin: .zero, size: canvasSize))
        let newImage: UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        return newImage
    }
    
    /// Returns a resized image that fits in rectSize, keeping it's aspect ratio
    /// Note that the new image size is not rectSize, but within it.
}

extension UIView {
    func shake() {
        let animation = CAKeyframeAnimation(keyPath: "transform.translation.x")
        animation.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.linear)
        animation.duration = 0.6
        animation.values = [-20.0, 20.0, -20.0, 20.0, -10.0, 10.0, -5.0, 5.0, 0.0 ]
        layer.add(animation, forKey: "shake")
    }
}


class NewLogin: UIViewController, UITextFieldDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    var ref: DatabaseReference?
    var storageRef: StorageReference?
    
    
    
    let defaults = UserDefaults.standard
    
    var myUsername = ""
    var myPassword = ""
    var myName = ""
    var myCell = ""
    var myEighteen = 1
    var hasAccountCreated = 0
    
    
    @IBOutlet weak var userImageButton: CustomButton!
    
    @IBOutlet weak var btnLogin: UIButton!
    
    @IBOutlet weak var eighteenLbl: UILabel!
    
    @IBOutlet weak var myUserImage: UIImageView!
    
    @IBOutlet weak var username: TextFieldWithImage!
    
    @IBOutlet weak var password: TextFieldWithImage!
    
    @IBOutlet weak var fullname: TextFieldWithImage!
    
    @IBOutlet weak var cellphone: TextFieldWithImage!
    
    @IBOutlet weak var hasAccount: UISwitch!
    
    
    
    @IBAction func hasAccount(_ sender: Any) {
        if hasAccount.isOn{
            hasAccountCreated = 1
            let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
            let vc:UIViewController = storyBoard.instantiateViewController(withIdentifier: "logmein") as UIViewController
            
            self.present(vc,animated:true,completion: nil)
        }
        else{
            hasAccountCreated = 0
        }
    }
    
    @IBAction func submitForm(_ sender: Any) {
        self.view.endEditing(true)
        let defaults = UserDefaults.standard
        if isValidEmail(testStr: username.text!){
            if username.text! == "" || password.text! == "" || fullname.text! == "" || cellphone.text! == ""{
                defaults.set("All fields are required", forKey: "loginMessage")
                ShowErrorMessage()
            }
            else{
                myUsername = (username.text)!
                myPassword = (password.text)!
                myName = (fullname.text)!
                myCell = (cellphone.text)!
                sendLoginInfo(myUsername,password: myPassword,fullname: myName, cellphone:myCell)
            }
        }
        else{
            defaults.set("Invalid email address", forKey: "loginMessage")
            ShowErrorMessage()
        }
    }
    
    @IBAction func resetForm(_ sender: Any) {
        username.text=""
        fullname.text=""
        password.text=""
        cellphone.text=""
    }
    
    @IBAction func resetForm1(_ sender: Any) {
        username.text=""
        fullname.text=""
        password.text=""
        cellphone.text=""
    }
    @IBAction func callFacebook(_ sender: Any) {
    }
    
    @IBAction func callTwitter(_ sender: Any) {
        
    }
    
    @IBAction func callYouTube(_ sender: Any) {
    }
    
    
    @IBAction func btnLogin1(_ sender: Any) {
        // submitForm(<#Any#>)
    }
    
    @IBAction func btnLogin(_ sender: Any) {
        //  submitForm(<#Any#>)
    }
    
    @IBAction func btnReset1(_ sender: Any) {
        ClearForm()
    }
    
    @IBAction func btnReset(_ sender: Any) {
        ClearForm()
    }
    
    func ClearForm(){
        username.text=""
        fullname.text=""
        password.text=""
        cellphone.text=""
    }
    
    func DoLogin(){
        let defaults = UserDefaults.standard
        if isValidEmail(testStr: username.text!){
            if username.text! == "" || password.text! == "" || fullname.text! == "" || cellphone.text == ""{
                defaults.set("All fields are required", forKey: "loginMessage")
                ShowErrorMessage()
            }
            else{
                myUsername = (username.text)!
                myPassword = (password.text)!
                myName = (fullname.text)!
                myCell = (cellphone.text)!
                sendLoginInfo(myUsername,password: myPassword,fullname: myName, cellphone: myCell)
            }
        }
        else{
            defaults.set("Invalid email address", forKey: "loginMessage")
            ShowErrorMessage()
        }
        //UploadImage()
    }
    
    
    @IBAction func PickMyUserImage(_ sender: Any) {
        let myImagePicker = UIImagePickerController()
        myImagePicker.delegate = self
        myImagePicker.sourceType = .savedPhotosAlbum
        self.present(myImagePicker,animated:true,completion: nil)
    }
    
    override func viewDidLoad() {
        ref = Database.database().reference().child("Users")
        super.viewDidLoad()
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        myUserImage.layer.cornerRadius=10
        myUserImage.clipsToBounds = true
        userImageButton.layer.cornerRadius=10
        userImageButton.clipsToBounds=true
        myUserImage.layer.borderColor=UIColor.lightGray.cgColor
        myUserImage.layer.borderWidth=1
        
        fullname.delegate=self
        password.delegate=self
        username.delegate=self
        cellphone.delegate=self
        
    }
    
    func sendLoginInfo(_ username: String, password: String, fullname: String, cellphone: String){
        
        if let url = URL(string: "http://www.up2speedtraining.com/mobile/php/up2speed_check_login.php"){
            let request = NSMutableURLRequest(url:url)
            request.httpMethod = "POST";// Compose a query string
            let postString = "email=\(myUsername)"
            request.httpBody = postString.data(using: String.Encoding.utf8)
            let task = URLSession.shared.dataTask(with:request as URLRequest){
                data, response, error in
                
                if error != nil{
                    
                }
                do {
                    if let convertedJsonIntoDict = try JSONSerialization.jsonObject(with: data!, options: .allowFragments) as? NSArray {
                        if convertedJsonIntoDict.count > 0{
                            let emailValue = (convertedJsonIntoDict[0] as! NSDictionary)["email"] as? String
                            if emailValue != nil{
                                DispatchQueue.global().async {
                                    DispatchQueue.main.async {
                                        self.btnLogin.isEnabled=true
                                        self.defaults.set("Email already exists", forKey: "loginMessage")
                                        self.ShowErrorMessage()
                                    }
                                }
                            }
                            else{
                                self.btnLogin.isEnabled=true
                                //self.SendToMainQeue()
                            }
                        }
                        else{
                            self.SendToMainQeue()
                        }
                    }
                    else{
                        self.clearDefaults()
                    }
                }
                catch let error as NSError {
                    self.btnLogin.isEnabled=true
                    print(error.localizedDescription)
                }
            }
            task.resume()
        }
    }
    
    func SendToMainQeue(){
        DispatchQueue.global().async {
            DispatchQueue.main.async {
                self.CreateAccount(self.myUsername,password: self.myPassword,name: self.myName, cellphone:self.myCell)
            }
        }
    }
    
    func clearDefaults(){
        self.btnLogin.isEnabled=true
        //UserDefaults.standard.set("blank", forKey: "username")
        //UserDefaults.standard.set("blank", forKey: "password")
        //UserDefaults.standard.set("blank", forKey: "fullname")
        //UserDefaults.standard.set("blank", forKey: "cellphone")
        //self.SendToMainQeue()
    }
    
    func SendErrorInfo(){
        DispatchQueue.global().async {
            DispatchQueue.main.async {
                self.username.shake()
                self.password.shake()
            }
        }
    }
    
    func CreateAccount(_ username: String, password: String, name: String, cellphone: String){
        
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        let vc:UIViewController = storyBoard.instantiateViewController(withIdentifier: "watingtoload") as UIViewController
        self.present(vc,animated:true,completion: nil)
        self.view.endEditing(true)
       

        let profileImage = myUserImage.image
        
        
//        let myImage = profileImage?.resizeWithPercent(percentage: 50)!
        let imageName = NSUUID().uuidString
        let myImage =  self.resizeImage(image: profileImage!, targetSize: CGSize(width: 500.0, height:500.0))
        let storageRef = Storage.storage().reference().child("\(imageName).png")
        if let uploadData = myImage.pngData() {
            storageRef.putData(uploadData, metadata: nil, completion : {
                (metadata, error) in
                
                if (( error) != nil) {
                    print(error!)
                    return
                }
                
                if let profileImageUrl = metadata?.downloadURL()?.absoluteString {
                    self.view.endEditing(true)
                    let key = self.ref?.childByAutoId().key
                    let newUser = [
                        "username" : username,
                        "password" : password,
                        "name" : name,
                        "cellphone" : cellphone,
                        "profileImageUrl" : profileImageUrl,
                        "user_key": "\(username)_\(password)"
                    ]
                    self.ref?.child(key!).setValue( newUser )
                    self.dismiss(animated: true, completion: nil)
                } else {
                    print("herer")
                }
            })
            
        }
       
    }
    
    func resizeImage(image: UIImage, targetSize: CGSize) -> UIImage {
        let size = image.size
        
        let widthRatio  = targetSize.width  / size.width
        let heightRatio = targetSize.height / size.height
        
        // Figure out what our orientation is, and use that to form the rectangle
        var newSize: CGSize
        if(widthRatio > heightRatio) {
            newSize = CGSize(width: size.width * heightRatio, height: size.height * heightRatio)
        } else {
            newSize = CGSize(width: size.width * widthRatio,  height: size.height * widthRatio)
        }
        
        // This is the rect that we've calculated out and this is what is actually used below
        let rect = CGRect(x: 0, y: 0, width: newSize.width, height: newSize.height)
        
        // Actually do the resizing to the rect using the ImageContext stuff
        UIGraphicsBeginImageContextWithOptions(newSize, false, 1.0)
        image.draw(in: rect)
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return newImage!
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
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
        //}
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        // if Int(self.view.frame.size.height) < 569{ // iphone 5 or older
        moveTextField(textField: textField, moveDistance: -250, up: false)
        // }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        //selected image
        if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            myUserImage.image = image
        } else{
            print("Something went wrong")
        }
        self.dismiss(animated: true, completion: nil)
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
    
    func generateBoundaryString() -> String {
        return "Boundary-\(NSUUID().uuidString)"
    }
   
}
