//
//  RollerTracker.swift
//  MyFitLabSolutions
//
//  Created by Rodrigo Schreiner on 6/15/18.
//  Copyright © 2018 Rodrigo Schreiner. All rights reserved.
//

import UIKit
import Social
import AVFoundation
import AVKit


class RollerTracker: UIViewController {
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    

    @IBOutlet weak var animattedGif: UIImageView!
    @IBOutlet var rollerview: UIView!
    var timer: Timer?
    var imageName: String = ""
    var bodyImageName: String = ""
    var sessionTimer: Timer?
    var hasPaused = 0
    var currentTimer = 0
    var player: AVAudioPlayer?
    var repCounter = 0
    var sounds = 0
    var soundCounter = 1000
    var systemTimer:Timer!
    var END_TIME = 5.0
    var playerVideo: AVPlayer?
    var avpController = AVPlayerViewController()
    let zoomImageView = UIImageView()
    let startFrame = CGRect(x: -3, y: -3, width: 1, height: 5)
    var dynamicView = UIView()
    var isExpanded: Bool = true
    let defaults = UserDefaults.standard
    var bodypartname:String?
    var myWorkout:String = ""
    var myMinutes=1
    var myRepetitions=1
    var mybodyPart=""
    var colloff=0
    var myCoolOff=0
    var pageFrom = ""
    var hasTimerStarted = false;
    var bodypartid=0
    
    @IBOutlet weak var lblBodyPartName: UILabel!
    @IBOutlet weak var bodyPartImageViewer: UIImageView!
    
    @IBAction func SendBackToBodyPart(_ sender: Any) {
        if playerVideo != nil {
            playerVideo?.pause()
            playerVideo = nil
        }
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        //let whereToGo = defaults.string(forKey: "fronwhichside")
        if self.pageFrom == "frontview"{
            let vc:UIViewController = storyBoard.instantiateViewController(withIdentifier: "front_view") as UIViewController
            self.present(vc,animated:true,completion: nil)
        }
        else if self.pageFrom == "backview"{
            dismiss(animated: true, completion: nil)
        }
        else if self.pageFrom == "fromdates"{
            dismiss(animated: true, completion: nil)
        }
        else if self.pageFrom == "fromdates"{
            dismiss(animated: true, completion: nil)
        }
        else{
            let vc:UIViewController = storyBoard.instantiateViewController(withIdentifier: "back_view") as UIViewController
            self.present(vc,animated:true,completion: nil)
        }
    }
    
    @IBAction func showMeHow(_ sender: Any) {
        self.playerVideo?.play()
    }
    
   
    @IBOutlet weak var lblRepetionsCompleted: UILabel!
    
    
    @IBOutlet weak var btnView: UIView!
    @IBOutlet weak var topView: UIView!

    @IBOutlet weak var lblTimeRemaining: UILabel!
    @IBOutlet weak var setupSessionView: UIView!
    @IBOutlet weak var lblBodyPart: UILabel!
    
    @IBOutlet weak var btnStop: CustomButton!
    @IBOutlet weak var startTimer: UIButton!
    @IBOutlet weak var bodyPartImageView: UIImageView!
    @IBOutlet weak var timeLeftLabel: UILabel!
    @IBOutlet weak var btnReset: CustomButton!
   // @IBOutlet weak var btnStop: UIImageView!
    @IBOutlet weak var btnStart: CustomButton!
    @IBOutlet weak var btnPlayPause: UIImageView!
    @IBOutlet weak var lblBreakInterval: UILabel!
    @IBOutlet weak var lblRepetitionsCompleted: UILabel!
    @IBOutlet weak var lblMinutes: UILabel!
    @IBOutlet weak var lblNumberOfReps: UILabel!
    @IBOutlet weak var minuteSlider: UISlider!
    @IBOutlet weak var breakSlider: UISlider!
    @IBOutlet weak var repSlider: UISlider!
    
    @IBAction func startTimers(_ sender: Any) {
        hasTimerStarted = true
        if isExpanded == false{
            ExpandImage()
            isExpanded = true
        }else{
            if self.repCounter < Int(self.repSlider.value){
                lblTimeRemaining.text = "Time Remaining"
                if(startTimer.currentTitle! == "Pause"){
                    btnPlayPause.image = UIImage(named:"playPlayer")
                    resetTimerButton()
                }
                else{
                    if hasPaused == 0{
                        currentTimer =  Int(minuteSlider.value) * 60
                        hasPaused = 1
                    }
                    startTimer.setTitleColor(UIColor.black, for: UIControl.State.normal)
                    startTimer.backgroundColor = UIColor.yellow
                    startTimer.setTitle("Pause",for: UIControl.State.normal)
                    btnPlayPause.image = UIImage(named:"pausePlayer")
                    
                }
                
                if timer != nil{
                    timer?.invalidate()
                    timer = nil
                }
                else{
                    self.currentTimer=5
                    timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true){ _ in
                        if self.currentTimer > 0{
                            if(Int(self.repSlider.value) > 0) {
                                self.lblRepetionsCompleted.isHidden=false
                                self.lblRepetionsCompleted.text = "\(self.repCounter) of \(Int(self.repSlider.value)) reps completed  "
                                if self.repCounter == Int(self.repSlider.value){
                                    self.hasTimerStarted = false
                                    UserDefaults.standard.set(Int(self.minuteSlider.value), forKey: "minutesrolling")
                                    UserDefaults.standard.set(Int(self.repSlider.value), forKey: "repsdone")
                                    UserDefaults.standard.set(Int(self.breakSlider.value), forKey: "cooloff")
                                    self.checkForSavedSession()
                                    let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
                                    let vc:UIViewController = storyBoard.instantiateViewController(withIdentifier: "savesession") as UIViewController
                                    
                                    
                                   
                                  
                                    self.performSegue(withIdentifier: "save_session", sender: self)
                                   
                                    
                                   
                                   
                                    
                                    //self.present(vc,animated:true,completion: nil)
                                }
                            }
                            self.currentTimer -= 1
                            let minutesPortion = String(format: "%02d", self.currentTimer / 60)
                            let secondsPortion = String(format: "%02d", self.currentTimer % 60)
                            self.timeLeftLabel.text = "\(minutesPortion):\(secondsPortion)"
                        }
                        else{
                            // self.resetTimerButton()
                            self.timer?.invalidate()
                            self.timer = nil
                            self.timeLeftLabel.text = "00:00"
                            self.hasPaused = 0
                            let systemSoundID: SystemSoundID = SystemSoundID(1005)
                            let handle = self.setInterval(interval: 1, block: { () -> Void in
                                AudioServicesPlaySystemSound (systemSoundID)
                            })
                            let when = DispatchTime.now() + 2 // change 2 to desired number of seconds
                            DispatchQueue.main.asyncAfter(deadline: when) {
                                handle.invalidate()
                            }
                            
                            if Int(self.repSlider.value) > 0{
                                self.repCounter += 1
                                self.lblRepetionsCompleted.text = "\(self.repCounter) of \(Int(self.repSlider.value)) reps completed  "
                                if self.repCounter < Int(self.repSlider.value){
                                    self.showCoolOff(myHandle: handle)
                                }
                                else{
                                    if self.repCounter == Int(self.repSlider.value){
                                        let when = DispatchTime.now() + 3
                                        UserDefaults.standard.set(Int(self.minuteSlider.value), forKey: "minutesrolling")
                                        UserDefaults.standard.set(Int(self.repSlider.value), forKey: "repsdone")
                                        UserDefaults.standard.set(Int(self.breakSlider.value), forKey: "cooloff")
                                        self.hasTimerStarted = false
                                        DispatchQueue.main.asyncAfter(deadline: when) {
                                            self.checkForSavedSession()
//                                            let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
//                                            let vc:UIViewController = storyBoard.instantiateViewController(withIdentifier: "savesession") as UIViewController
//                                            self.present(vc,animated:true,completion: nil)
                                            self.performSegue(withIdentifier: "save_session", sender: self)
                                        }
                                    }
                                    
                                }
                            }
                        }
                    }
                }
            }
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        if let saveSessionVC = segue.destination as?  SaveSessions{
//            saveSessionVC.bodyPartId = self.bodypartid
//        }
    }
    
    @IBAction func goToYouTube(_ sender: Any) {
        // self.performSegue(withIdentifier: "howtovideo", sender: self)
    }
    
    @IBAction func minuteSliderRange(_ sender: Any) {
        let currentMinuteValue = Int(minuteSlider.value)
        lblMinutes.text = "\(currentMinuteValue)"
    }
    
    @IBAction func sliderNumberOfReps(_ sender: Any) {
        let currentRepValue = Int(repSlider.value)
        lblNumberOfReps.text = "\(currentRepValue)"
    }
    
    @IBAction func breakIntervalSlider(_ sender: Any) {
        let currentBreakValue = Int(breakSlider.value)
        if currentBreakValue == 0{
            lblBreakInterval.text = "30 sec"
        }
        else{
            lblBreakInterval.text = "\(currentBreakValue)"
        }
    }
    
    func setTimeout(delay:TimeInterval, block:@escaping ()->Void) -> Timer {
        return Timer.scheduledTimer(timeInterval: delay, target: BlockOperation(block: block), selector: #selector(Operation.main), userInfo: nil, repeats: false)
    }
    
    func setInterval(interval:TimeInterval, block:@escaping ()->Void) -> Timer {
        return Timer.scheduledTimer(timeInterval: interval, target: BlockOperation(block: block), selector: #selector(Operation.main), userInfo: nil, repeats: true)
    }
    
    @IBAction func loadData(sender:AnyObject!){
        
    }
    
    func timerCall(){
        self.startTimers(self.startTimer)
    }
    
    func playVideo() {
        let url:NSURL = NSURL(string: "http://up2speedtraining.com/mobile/uploads/quads.mp4")!
        let demoPlayer = AVPlayerItem(url: url as URL)
        self.playerVideo = AVPlayer(playerItem: demoPlayer)
        self.avpController = AVPlayerViewController()
        self.avpController.player = self.playerVideo
        //let myX = bodyPartImageViewer.frame.origin.x + bodyPartImageViewer.frame.width + 25
//        dynamicView = UIView(frame: CGRect(x: myX, y: topView.frame.origin.y + 10, width: HowToVideoView.frame.width - 10, height: bodyPartImageViewer.frame.height - 20))
//        self.view.addSubview(dynamicView)
        
        avpController.view.frame = dynamicView.frame
        
        self.addChild(avpController)
        self.view.addSubview(avpController.view)
    }
    
    func loopVideo(_ videoPlayer: AVPlayer) {
        NotificationCenter.default.addObserver(forName: NSNotification.Name.AVPlayerItemDidPlayToEndTime, object: nil, queue: nil) { notification in
            //if(!self.isStopped){
            
            videoPlayer.seek(to: CMTime.zero)
            videoPlayer.play()
            
            // }
        }
    }
    
    
    
    @IBAction func ShowShareOptions(_ sender: Any) {
        
        let shareText = ""
        let activityViewController = UIActivityViewController(activityItems: [shareText,"http://up2speedtraining.com/mobile/uploads/glut.mp4"], applicationActivities: nil)
        self.present(activityViewController,animated:true, completion:nil)
        
    }
    
    func showAlertError(service:String){
        
        let alert = UIAlertController(title:"Warning", message:"You are not conneced to \(service)", preferredStyle: .alert)
        let action = UIAlertAction(title:"Dismiss",style: .cancel, handler:nil)
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
        
    }
    
    func showCoolOff(myHandle:AnyObject){
        startTimer.backgroundColor = UIColor.gray
        startTimer.setTitleColor(UIColor.darkGray, for: UIControl.State.normal)
        startTimer.isEnabled = false
        lblTimeRemaining.text = "Next rep starts in"
        let collOffTime = Int(breakSlider.value)
        if collOffTime == 0{
            self.currentTimer = 30
        }
        else{
            self.currentTimer = collOffTime * 60
            
        }
        self.currentTimer=5
        
        timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true){ _ in
            if self.currentTimer > 0{
                self.currentTimer -= 1
                let minutesPortion = String(format: "%02d", self.currentTimer / 60)
                let secondsPortion = String(format: "%02d", self.currentTimer % 60)
                self.timeLeftLabel.text = "\(minutesPortion):\(secondsPortion)"
            }
            else{
                self.resetTimerButton()
                self.timer?.invalidate()
                self.timer = nil
                self.timeLeftLabel.text = "00:00"
                let systemSoundID: SystemSoundID = SystemSoundID(1010)
                let handle = self.setInterval(interval: 1, block: { () -> Void in
                    AudioServicesPlaySystemSound (systemSoundID)
                })
                
                let when = DispatchTime.now() + 5.5
                DispatchQueue.main.asyncAfter(deadline: when) {
                    handle.invalidate()
                }
                
                if Int(self.repSlider.value) > 0{
                    
                    //self.repCounter += 1
                    self.lblRepetionsCompleted.text = "\(self.repCounter) of \(Int(self.repSlider.value)) reps completed  "
                    
                    let when = DispatchTime.now() + 2
                    DispatchQueue.main.asyncAfter(deadline: when) {
                        self.startTimer.isEnabled = true
                        self.startTimers(self.startTimer)
                    }
                }
            }
        }
    }
    
    @IBAction func returnToPopUpOptions(_ sender: Any) {
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        
        
        let vc:UIViewController = storyBoard.instantiateViewController(withIdentifier: "bodyparts") as UIViewController
        self.present(vc,animated:true,completion: nil)
    }
    
    @IBAction func resetTimer(_ sender: Any) {
        hasTimerStarted = false
        if isExpanded == false{
            ExpandImage()
            isExpanded = true
        }else{
            //handle.invalidate()
            btnPlayPause.image = UIImage(named:"playPlayer")
            timeLeftLabel.textColor = UIColor.white
            //let systemSoundID: SystemSoundID = SystemSoundID(soundCounter)
            
            // to play sound
            //AudioServicesPlaySystemSound (systemSoundID)
            
            // print(soundCounter)
            //soundCounter += 1
            
            //self.lblRepetionsCompleted.isHidden=true
             self.lblRepetionsCompleted.text = "0 reps completed"
            timer?.invalidate()
            repCounter = 0
            self.hasPaused = 0
            timer = nil
            startTimer.isEnabled = true
            resetTimerButton()
            self.currentTimer=0
            self.timeLeftLabel.text = "00:00"
        }
    }
    
    @objc func setupSession(){
        if isExpanded == false{
            ExpandImage()
            isExpanded = true
        }
    }
    
    @IBAction func stopWatch(_ sender: Any) {
        hasTimerStarted = false
        if isExpanded == false{
            ExpandImage()
            isExpanded = true
        }else{
            timer?.invalidate()
            timer = nil
            currentTimer = 0
            startTimer.backgroundColor = UIColor.gray
            startTimer.setTitleColor(UIColor.darkGray, for: UIControl.State.normal)
            startTimer.isEnabled = false
        }
    }
    
    
    
    override func viewDidLoad() {
        //let defaults:UserDefaults = UserDefaults.standard
        super.viewDidLoad()
       
        bodyImageName = (bodypartname?.replacingOccurrences(of: " ", with: "_").lowercased())!
        
        if bodyImageName == "left_abs" || bodyImageName == "middle_abs" || bodyImageName == "right_abs" {
            bodyImageName = "left_abs";
        } else if bodyImageName == "left_knee" || bodyImageName == "right_knee" || bodyImageName == "right_chin" || bodyImageName == "left_chin" {
            bodyImageName = "right_knee"
        }
       
        //animattedGif.loadGif(name: myGiftImage)
        animattedGif.image = UIImage(named: bodyImageName)
       // HowToVideoView.loadGif(name:"rightthigh.gif")
        //let jeremyGif = UIImage.gif("rightthigh")
        
        //timeLeftLabel.font = UIFont(name: "DBLCDTempBlack-Thin", size: 10.0)
        //timeLeftLabel.font = UIFont(name: "DBLCDTempBlack", size:60.0)
        if bodypartname != "" &&  bodypartname != nil {
            imageName = (bodypartname?.replacingOccurrences(of: " ", with: ""))!
            bodyPartImageViewer.image = UIImage(named: imageName)
            let gestureRecognizer = UITapGestureRecognizer(target:self, action:#selector(ExpandImage))
            gestureRecognizer.numberOfTapsRequired = 1
            let gestureRecognizerResetBtn = UITapGestureRecognizer(target:self, action:#selector(resetTimer))
            let gestureRecognizerStartBtn = UITapGestureRecognizer(target:self, action:#selector(startTimers))
            let gestureRecognizerStopBtn = UITapGestureRecognizer(target:self, action:#selector(stopWatch))
            let gestureRecognizerSetupSession = UITapGestureRecognizer(target:self, action:#selector(setupSession))
            let gestureRecognizerBtnView = UITapGestureRecognizer(target:self, action:#selector(setupSession))
            //  let gestureRecognizerVideoHolder = UITapGestureRecognizer(target:self, action:#selector(setupSession))
            let gestureRecognizerTopView = UITapGestureRecognizer(target:self, action:#selector(setupSession))
            
            bodyPartImageViewer.addGestureRecognizer(gestureRecognizer)
            btnReset.addGestureRecognizer(gestureRecognizerResetBtn)
            btnStart.addGestureRecognizer(gestureRecognizerStartBtn)
            btnStop.addGestureRecognizer(gestureRecognizerStopBtn)
            setupSessionView.addGestureRecognizer(gestureRecognizerSetupSession)
            btnView.addGestureRecognizer(gestureRecognizerBtnView)
            // videoHolder.addGestureRecognizer(gestureRecognizerVideoHolder)
            topView.addGestureRecognizer(gestureRecognizerTopView)
            bodyPartImageViewer.addGestureRecognizer(gestureRecognizer)
            lblBodyPartName.text = self.bodypartname
            minuteSlider.value = Float(myMinutes)
            breakSlider.value = Float(myCoolOff)
            repSlider.value = Float(myRepetitions)
            lblMinutes.text = String(myMinutes)
            lblNumberOfReps.text = String(myRepetitions)
            lblBreakInterval.text = "\( myCoolOff == 0 ? "30 secs" :  (myCoolOff>1 ? "\( myCoolOff)" : "\( myCoolOff)"))"

            //playVideo()

            zoomImageView.frame=startFrame
            zoomImageView.backgroundColor = UIColor.red
            view.addSubview(zoomImageView)

            if bodypartid == 0 {
                if let bodypartname = defaults.string(forKey: "bodypartname"){
                    lblBodyPart.text = bodypartname
                }
            }
            bodyPartImageViewer.addGestureRecognizer(gestureRecognizer)
            btnStart.layer.cornerRadius=10
            btnStart.layer.masksToBounds=true
            btnStop.layer.cornerRadius=10
            btnStop.layer.masksToBounds=true
            btnReset.layer.cornerRadius=10
            btnReset.layer.masksToBounds=true
            setupSessionView.layer.borderWidth=2
            setupSessionView.layer.borderColor=UIColor.white.cgColor
            setupSessionView.layer.cornerRadius=10
            setupSessionView.layer.masksToBounds=true

            btnView.layer.borderWidth=2
            btnView.layer.borderColor=UIColor.white.cgColor
            btnView.layer.cornerRadius=10
            btnView.layer.masksToBounds=true

            topView.layer.borderWidth=2
            topView.layer.borderColor=UIColor.white.cgColor
            topView.layer.cornerRadius=10
            topView.layer.masksToBounds=true
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func checkTime() {
        if (self.player?.currentTime)! >= END_TIME {
            self.player?.stop()
            systemTimer.invalidate()
        }
    }
    
    
    func checkForSavedSession(){
        sessionTimer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true){ _ in
            if let savedsession = self.defaults.string(forKey: "issessionsaved"){
                if savedsession == "session saved"{
                    let alertController = UIAlertController(title: "Success", message: "Your seesion is saved", preferredStyle: .alert)
                    
                    self.present(alertController, animated: true, completion:nil)
                    let OKAction = UIAlertAction(title: "OK", style: .default)
                    alertController.addAction(OKAction)
                    self.sessionTimer?.invalidate()
                    self.sessionTimer = nil
                    UserDefaults.standard.set("session not saved", forKey: "issessionsaved")
                }
            }
        }
    }
    
    var OriginalFrameSize:CGRect = CGRect.zero
    @objc func ExpandImage(){
        if !hasTimerStarted {
            self.zoomImageView.isHidden=false
            if OriginalFrameSize.equalTo(CGRect.zero) == true {
                OriginalFrameSize = CGRect(x: topView.frame.origin.x+4, y: topView.frame.origin.y+3, width: bodyPartImageViewer.frame.width-3, height: bodyPartImageViewer.frame.height-10)
            }
            
            UIView.animate(withDuration: 0.5, delay: 0.0, options: UIView.AnimationOptions.curveEaseOut, animations: {
                self.zoomImageView.image = UIImage(named: self.imageName)
                self.zoomImageView.contentMode = .scaleToFill
                self.zoomImageView.clipsToBounds = true
                if self.isExpanded == true{
                    self.zoomImageView.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height)
                    self.isExpanded = false
                }
                else{
                    self.zoomImageView.frame = self.OriginalFrameSize
                    self.isExpanded = true
                }
                
            }, completion: { finished in
                if self.isExpanded{
                    self.zoomImageView.isHidden=true
                }
                else{
                    self.zoomImageView.isHidden=false
                }
            })
        }
    }
    
    func refreshList(notification: NSNotification){
        
        // print("parent method is called")
    }
    
    func resetTimerButton(){
//        startTimer.backgroundColor = UIColor.universalBlue
//        startTimer.setTitleColor(UIColor.white, for: UIControl.State.normal)
//        startTimer.setTitle("Start",for: UIControl.State.normal)
    }
    
    func playSound(som: String){
        let url = Bundle.main.url(forResource: som, withExtension: "mp3")!
        
        do {
            player = try AVAudioPlayer(contentsOf: url)
            guard let player = player else { return }
            
            player.prepareToPlay()
            player.play()
        } catch let error {
            print(error.localizedDescription)
        }
    }
}
