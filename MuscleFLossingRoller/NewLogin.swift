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
    var isSwitchEighteenOn = 1
    
    @IBOutlet weak var waiting: UIActivityIndicatorView!
    
    @IBOutlet weak var userImageButton: CustomButton!
    
    @IBOutlet weak var btnLogin: UIButton!
    
    @IBOutlet weak var eighteenLbl: UILabel!
    
    @IBOutlet weak var myUserImage: UIImageView!
    
    @IBOutlet weak var username: TextFieldWithImage!
    
    @IBOutlet weak var password: TextFieldWithImage!
    
    @IBOutlet weak var fullname: TextFieldWithImage!
    
    @IBOutlet weak var cellphone: TextFieldWithImage!
    
    
    @IBOutlet weak var switchEighteen: UISwitch!
    
    @IBAction func switchEighteen(_ sender: Any) {
        if switchEighteen.isOn{
            isSwitchEighteenOn = 1
            myEighteen=1
            eighteenLbl.textColor = UIColor.red
        }
        else{
            isSwitchEighteenOn = 0
            myEighteen=0
            eighteenLbl.textColor = UIColor.gray
        }
    }
    
    @IBAction func submitForm(_ sender: Any) {
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
        myUserImage.layer.cornerRadius=46
        myUserImage.layer.masksToBounds=true
        userImageButton.layer.cornerRadius=46
        userImageButton.layer.masksToBounds=true
        
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
         self.view.endEditing(true)
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        let vc:UIViewController = storyBoard.instantiateViewController(withIdentifier: "watingtoload") as UIViewController
        self.present(vc,animated:true,completion: nil)
        let profileImage = myUserImage.image
        let imageName = NSUUID().uuidString
         let storageRef = Storage.storage().reference().child("\(imageName).png")
        if let uploadData = profileImage!.pngData() {
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
                        "key" : key,
                        "username" : username,
                        "password" : password,
                        "name" : name,
                        "cellphone" : cellphone,
                        "profileImageUrl" : profileImageUrl
                    ]
                    self.ref?.child(key!).setValue( newUser )
                    self.dismiss(animated: true, completion: nil)
                } else {
                    print("herer")
                }
            })
            
        } else {
            print("didn't work")
        }
       
//        if let url = URL(string: "http://up2speedtraining.com/mobile/php/up2speed_create_account.php"){
//            let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
//            let vc:UIViewController = storyBoard.instantiateViewController(withIdentifier: "watingtoload") as UIViewController
//            self.present(vc,animated:true,completion: nil)
//            let request = NSMutableURLRequest(url:url)
//            request.httpMethod = "POST";
//            let param = [
//                "email"     : myUsername,
//                "password"  : myPassword,
//                "fullname"  : myName,
//                "cellphone" : myCell
//                ] as [String : Any]
//
//            let boundary = generateBoundaryString()
//
//            request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
//            let myPicture = myUserImage.image
//            let myUserImageProfile = myPicture?.resized(img: myPicture!, size: CGSize(width: 200, height: 200))
//            let imageData = myUserImageProfile!.pngData()
//
//            if(imageData==nil)  { return; }
//
//            request.httpBody = createBodyWithParameters(parameters: (param as! [String : String]), filePathKey: "file", imageDataKey: imageData! as NSData, boundary: boundary) as Data
//
//            let task = URLSession.shared.dataTask(with:request as URLRequest){
//                data, response, error in
//
//                if error != nil{
//                    print(error as Any)
//                }
//                do {
//                    if let convertedJsonIntoDict = try JSONSerialization.jsonObject(with: data!, options: .allowFragments) as? NSArray {
//                        if convertedJsonIntoDict.count > 0{
//                            print(convertedJsonIntoDict)
//                            let emailValue = (convertedJsonIntoDict[0] as! NSDictionary)["email"] as? String
//                            let myuserid = (convertedJsonIntoDict[0] as! NSDictionary)["userid"] as? Int
//                            UserDefaults.standard.set(myuserid, forKey: "myuserid")
//
//                            // UserDefaults.standard.set("mypfrofileimage_\(myuserid)", forKey: "myprofilepicture")
//                            if emailValue != nil{
//
//                                DispatchQueue.global().async {
//                                    DispatchQueue.main.async {
//
//                                        // self.UploadImage(email:emailValue!)
//                                    }
//                                }
//                                self.dismiss(animated: true, completion: nil)
//                                UserDefaults.standard.set(self.myUsername, forKey: "username")
//
//                                UserDefaults.standard.set(1, forKey: "hasaccount")
//                                let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
//                                let vc:UIViewController = storyBoard.instantiateViewController(withIdentifier: "myprofile") as UIViewController
//
//                                self.present(vc,animated:true,completion: nil)
//
//                            }
//                            else{
//                                self.btnLogin.isEnabled=true
//                            }
//                        }
//                        else{
//                            self.btnLogin.isEnabled=true
//                            self.SendErrorInfo()
//                        }
//                    }
//                    else{
//                        self.btnLogin.isEnabled=true
//                    }
//                }
//                catch let error as NSError {
//                    print(error as Any)
//                }
//            }
//            task.resume()
//        }
        // to be removed later
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
    
    func UploadImage(email:String){
        let myUrl = NSURL(string: "http://www.up2speedtraining.com/mobile/php/up2speed_create_account.php");
        let request = NSMutableURLRequest(url:myUrl! as URL);
        request.httpMethod = "POST";
        
        let param = ["userId":email]
        
        let boundary = generateBoundaryString()
        
        request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
        let myPicture = myUserImage.image
        let myUserImageProfile = myPicture?.resized(img: myPicture!, size: CGSize(width: 110, height: 110))
        let imageData = myUserImageProfile!.pngData()
        
        if(imageData==nil)  { return; }
        
        request.httpBody = createBodyWithParameters(parameters: param, filePathKey: "file", imageDataKey: imageData! as NSData, boundary: boundary) as Data
        
        let task = URLSession.shared.dataTask(with: request as URLRequest) {
            data, response, error in
            
            if error != nil {
                print(error as Any)
                self.dismiss(animated: true, completion: nil)
                return
            }
            
            do {
                _ = try JSONSerialization.jsonObject(with: data!, options: []) as? NSDictionary
                
                DispatchQueue.global().async {
                    DispatchQueue.main.async {
                        
                        UserDefaults.standard.set(email, forKey: "username")
                        UserDefaults.standard.set(1, forKey: "hasaccount")
                        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
                        let vc:UIViewController = storyBoard.instantiateViewController(withIdentifier: "myprofile") as UIViewController
                        
                        self.present(vc,animated:true,completion: nil)
                    }
                }
            }
            catch let error as NSError {
                print("error")
                self.dismiss(animated: true, completion: nil)
                //self.btnLogin.alpha=1
                print(error.localizedDescription)
            }
        }
        
        task.resume()
    }
    
    func createBodyWithParameters(parameters: [String: String]?, filePathKey: String?, imageDataKey: NSData, boundary: String) -> NSData {
        let body = NSMutableData();
        
//        if parameters != nil {
//            for (key, value) in parameters! {
//                body.appendString(string: "--\(boundary)\r\n")
//                body.appendString(string: "Content-Disposition: form-data; name=\"\(key)\"\r\n\r\n")
//                body.appendString(string: "\(value)\r\n")
//            }
//        }
//        let filename = "user-profile.png"
//        let mimetype = "image/png"
//
//        body.appendString(string: "--\(boundary)\r\n")
//        body.appendString(string: "Content-Disposition: form-data; name=\"\(filePathKey!)\"; filename=\"\(filename)\"\r\n")
//        body.appendString(string: "Content-Type: \(mimetype)\r\n\r\n")
//        body.append(imageDataKey as Data)
//        body.appendString(string: "\r\n")
//        body.appendString(string: "--\(boundary)--\r\n")
        
        return body
    }
}
