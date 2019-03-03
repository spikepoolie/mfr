//
//  FreeTimer.swift
//  MuscleFLossingRoller
//
//  Created by Rodrigo Schreiner on 2/11/19.
//  Copyright © 2019 MFR. All rights reserved.
//

import UIKit
import Social
import AVFoundation
import AVKit

class FreeTimer: UIViewController {

    @IBOutlet weak var lblIntervalLabel: UILabel!
    @IBOutlet weak var lblDurationLabel: UILabel!
    @IBOutlet var myView: UIView!
    @IBOutlet weak var lblNumberReps: UILabel!
    @IBOutlet weak var lblInterval: UILabel!
    @IBOutlet weak var lblDuration: UILabel!
    @IBOutlet weak var lblRepsCompleted: UILabel!
    @IBOutlet weak var repsSlider: UISlider!
    @IBOutlet weak var intervalSlider: UISlider!
    @IBOutlet weak var durationSlider: UISlider!
    @IBOutlet weak var btnResetTimer: CustomButton!
    @IBOutlet weak var btnStartTimer: CustomButton!
    @IBOutlet weak var lblCoolOff: UILabel!

    
    
    let percentageLabel: UILabel = {
        let label = UILabel()
        label.text = "00:00"
        label.textAlignment = .center
        label.font = UIFont(name:"Digital-7Italic",size:62)
        label.textColor = .yellow
        return label
    }()
    
    var timer = Timer()
    var collOffTimer = Timer()
    var hasTimerStarted = false
    var hasStoped = false
    var repCounter = 0
    var hasPaused = 0
    var currentTimer = 0
    var timeLeft: TimeInterval = 30
    var sliderValue = 0
    var trackerTimer: Float = 0
    var timer2:Timer!
    let circularPath = UIBezierPath(arcCenter: .zero, radius: 100, startAngle: 0, endAngle: 2 * CGFloat.pi, clockwise: true)
    let trackerLayer = CAShapeLayer()
    let shapeLayer = CAShapeLayer()
    let pulseLayer = CAShapeLayer()
    let strokeIt = CABasicAnimation(keyPath: "strokeEnd")
    var timeLabel =  UILabel()
    var durationMinutesSelected = true
    var intervalMinutesSelected = true
   
    func addTimeLabel() {
        timeLabel = UILabel(frame: CGRect(x: view.frame.midX-50 ,y: view.frame.midY-25, width: 100, height: 50))
        timeLabel.textAlignment = .center
        view.addSubview(timeLabel)
    }
    
    func drawBgShape(myPosition: CGPoint) {
        shapeLayer.path = circularPath.cgPath
        shapeLayer.strokeColor = UIColor(white: 0.90, alpha: 1.0).cgColor
        shapeLayer.fillColor = UIColor.clear.cgColor
        shapeLayer.lineWidth = 15
        shapeLayer.position = getSpecificPosition()
        shapeLayer.transform = CATransform3DMakeRotation(-CGFloat.pi / 2, 0, 0, 1)
        view.layer.addSublayer(shapeLayer)
    }
    
    func drawTimeLeftShape(myPosition: CGPoint) {
        trackerLayer.path = circularPath.cgPath
        trackerLayer.strokeColor = UIColor.red.cgColor
        trackerLayer.fillColor = UIColor.clear.cgColor
        trackerLayer.lineWidth = 15
       // trackerLayer.lineCap = CAShapeLayerLineCap.round
        trackerLayer.position = myPosition
        trackerLayer.transform = CATransform3DMakeRotation(-CGFloat.pi / 2, 0, 0, 1)
        view.layer.addSublayer(trackerLayer)
    }
    
    func drawPulseLayer(myPosition: CGPoint) {
        pulseLayer.path = circularPath.cgPath
        pulseLayer.strokeColor = UIColor.pulsatingFillColor.cgColor
        pulseLayer.fillColor = UIColor.clear.cgColor
        pulseLayer.lineWidth = 15
        pulseLayer.position = getSpecificPosition()
        pulseLayer.transform = CATransform3DMakeRotation(-CGFloat.pi / 2, 0, 0, 1)
        
    }
    
    func setDurationUnitDelegate(str: Any) {
       print("I just got \(str)")
    }
    
    func animatePulseLayer() {
        let pulseAnimatioin = CABasicAnimation(keyPath: "transform.scale")
        pulseAnimatioin.toValue = 1.1
        pulseAnimatioin.duration = 0.8
        pulseAnimatioin.autoreverses = true
        pulseAnimatioin.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeOut)
        pulseAnimatioin.repeatCount = Float.infinity
        pulseLayer.add(pulseAnimatioin, forKey: "pulse")
    }
    
    func pauseTimer() {
        timer.invalidate()
        hasStoped = true
        hasPaused = 0
        let pausedTime = trackerLayer.convertTime(CACurrentMediaTime(), from: nil)
        trackerLayer.speed = 0.0
        trackerLayer.timeOffset = pausedTime
    }
    
    func restartTimer() {
        hasStoped = false
        setPauseButton()
        let pausedTime = trackerLayer.timeOffset
        trackerLayer.speed = 1.0
        trackerLayer.timeOffset = 0.0
        trackerLayer.beginTime = 0.0
        let timeSincePause = trackerLayer.convertTime(CACurrentMediaTime(), from: nil) - pausedTime
        trackerLayer.beginTime = timeSincePause
        timer = Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(self.updateTime), userInfo: nil, repeats: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let myPosition = getSpecificPosition()
        percentageLabel.frame = CGRect(x: 0, y: 0, width: 180, height: 180)
        drawPulseLayer(myPosition: myPosition)
        percentageLabel.center = myPosition
        drawBgShape(myPosition: myPosition)
       
        animatePulseLayer()
      
        view.addSubview(percentageLabel)
        strokeIt.fromValue = 0
        strokeIt.toValue = 1
    }
    
    @objc func updateTime() {
        if timeLeft > 0 {
            timeLeft -= 0.1
            let remainderTime = Int(timeLeft)
            let minutesPortion = String(format: "%02d", remainderTime / 60)
            let secondsPortion = String(format: "%02d", remainderTime % 60)
            self.percentageLabel.text = "\(minutesPortion):\(secondsPortion)"
          //  percentageLabel.text = String(timeLeft)
        } else {
            timeLabel.text = "00:00"
            timer.invalidate()
        }
    }
    
    func getSpecificPosition() -> CGPoint {
        return CGPoint(x: myView.layer.bounds.midX, y: myView.layer.bounds.midY + 60)
    }
    
   
    
    private func startTimer() {
        if Int(durationSlider.value) > 0 {
            lblRepsCompleted.textColor = .white
            lblCoolOff.text = ""
            let myPosition = getSpecificPosition()
            drawTimeLeftShape(myPosition: myPosition)
            if durationMinutesSelected {
                currentTimer = Int(durationSlider.value) * 60
                sliderValue = Int(durationSlider.value) / 60000
            } else {
                currentTimer = Int(durationSlider.value)
                sliderValue = Int(durationSlider.value) / 60000
            }
            trackerTimer = Float(sliderValue)
            lblRepsCompleted.text = "\(repCounter) of \(Int(repsSlider.value)) completed"
            hasTimerStarted = true
           
            if self.repCounter < Int(self.repsSlider.value){
                if(btnStartTimer.currentTitle! == "Pause"){
                    resetTimerButton()
                    hasStoped = true
                    pauseTimer()
                } else {
                    if hasStoped {
                        restartTimer()
                    } else {
                        if durationMinutesSelected {
                            strokeIt.duration = CFTimeInterval(Int(durationSlider.value) * 60)
                        } else {
                             strokeIt.duration = CFTimeInterval(Int(durationSlider.value))
                        }
                        trackerLayer.add(strokeIt, forKey: nil)
    //                    if hasPaused == 0{
    //                        currentTimer = Int(durationSlider.value) * 60
    //                        sliderValue = Int(durationSlider.value) / 60000
    //                        trackerTimer = Float(sliderValue)
    //                       // hasPaused = 1
    //                    }
                        setPauseButton()
                        if hasPaused == 0 {
                            timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true){ _ in
                                if self.currentTimer > 0{
                                    if(Int(self.repsSlider.value) > 0) {
                                        self.lblRepsCompleted.isHidden=false
                                        self.lblRepsCompleted.text = "\(self.repCounter) of \(Int(self.repsSlider.value)) reps completed  "
                                        if self.repCounter == Int(self.repsSlider.value){
                                            self.hasTimerStarted = false
                                        }
                                    }
                                    if Int(self.currentTimer) <= 5 && Int(self.currentTimer) != 0 {
                                        self.playAlertSound(soundid: 1313)
                                    } else {
                                        if Int(self.currentTimer) == 0  {
                                            self.timer.invalidate()
                                        }
                                    }
                                    
                                    self.currentTimer -= 1
                                    self.timeLeft = TimeInterval(self.currentTimer)
                                    self.trackerTimer +=  (0.1)
                                    let minutesPortion = String(format: "%02d", self.currentTimer / 60)
                                    let secondsPortion = String(format: "%02d", self.currentTimer % 60)
                                    self.percentageLabel.text = "\(minutesPortion):\(secondsPortion)"
                                }
                                else{
                                    self.timer.invalidate()
                                    self.percentageLabel.text = "00:00"
                                    self.hasPaused = 0
                //                        self.pulsingLayer.add(self.animation, forKey: "pulse")
                                   // self.playAlertSound(soundid: 1005)
                                    let when = DispatchTime.now() + 2.5
                                    
                                    if Int(self.repsSlider.value) > 0{
                                        self.repCounter += 1
                                        self.lblRepsCompleted.text = "\(self.repCounter) of \(Int(self.repsSlider.value)) reps completed  "
                                        if self.repCounter < Int(self.repsSlider.value){
                                            self.showCoolOff()
//                                            DispatchQueue.main.asyncAfter(deadline: when) {
//                                                self.timer.invalidate()
//                                                self.showCoolOff()
//                                            }
                                        }
                                        else{
                                            if self.repCounter == Int(self.repsSlider.value){
                                                self.hasTimerStarted = false
                                                DispatchQueue.main.asyncAfter(deadline: when) {
                                                    self.timer.invalidate()
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
        } else {
            let alert = UIAlertController(title:"Warning", message:"Set duration time first", preferredStyle: .alert)
            let action = UIAlertAction(title:"Dismiss",style: .cancel, handler:nil)
            alert.addAction(action)
            present(alert, animated: true, completion: nil)
        }
    }
    
    func showCoolOff(){
        lblRepsCompleted.textColor =  UIColor(white: 0.5, alpha: 0.7)
        lblCoolOff.textColor = .yellow
        lblCoolOff.text = "Cooling Off"
        btnStartTimer.backgroundColor = UIColor.gray
        btnStartTimer.setTitleColor(UIColor.darkGray, for: UIControl.State.normal)
        btnStartTimer.isEnabled = false
        //lblRepsCompleted.text = "Next rep starts in"
        let collOffTime = Int(intervalSlider.value)
//        if collOffTime == 0{
//            self.currentTimer = 5
//            strokeIt.duration = CFTimeInterval(Float(self.currentTimer))
//        }
//        else{
//            self.currentTimer = collOffTime * 60
//            strokeIt.duration = CFTimeInterval(Float(self.currentTimer))
//        }
        if intervalMinutesSelected {
            currentTimer = Int(intervalSlider.value) * 60
        } else {
            currentTimer = Int(intervalSlider.value)
        }
        strokeIt.duration = CFTimeInterval(Float(self.currentTimer))
        trackerLayer.add(strokeIt, forKey: nil)
        // self.pulsingLayer.add(self.animation, forKey: "pulse")
        //self.currentTimer=4
        
        collOffTimer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true){ _ in
            if self.currentTimer > 0{
                self.currentTimer -= 1
                let minutesPortion = String(format: "%02d", self.currentTimer / 60)
                let secondsPortion = String(format: "%02d", self.currentTimer % 60)
                self.percentageLabel.text = "\(minutesPortion):\(secondsPortion)"
            }
            else{
                self.resetTimerButton()
               
                self.collOffTimer.invalidate()
                self.percentageLabel.text = "00:00"
                self.playAlertSound(soundid: 1016)
            
                if Int(self.repsSlider.value) > 0{
                    self.lblRepsCompleted.text = "\(self.repCounter) of \(Int(self.repsSlider.value)) reps completed"
                    let when = DispatchTime.now() + 2.5
                    DispatchQueue.main.asyncAfter(deadline: when) {
                        self.collOffTimer.invalidate()
                        self.timer.invalidate()
                        self.btnStartTimer.isEnabled = true
                        self.startTimer()
                    }
                }
            }
        }
    }
    
    func setPauseButton() {
        btnStartTimer.setTitleColor(UIColor.white, for: UIControl.State.normal)
        btnStartTimer.backgroundColor = UIColor.darkGray
        btnStartTimer.setTitle("Pause",for: UIControl.State.normal)
    }
    
    func resetTimerButton(){
        btnStartTimer.backgroundColor = UIColor(red: 0, green: 0.4784, blue: 1, alpha: 1.0)
        btnStartTimer.setTitleColor(UIColor.white, for: UIControl.State.normal)
        btnStartTimer.setTitle("Start",for: UIControl.State.normal)
    }
    
    
    @IBAction func setDuration(_ sender: Any) {
        let currentMinuteValue = Int(durationSlider.value)
        lblDuration.text = "\(currentMinuteValue)"
        updateTimerLabel(durationValue: currentMinuteValue)
    }
    
    func updateTimerLabel(durationValue: Int) {
        var currentSelectedTime = 0
        if durationMinutesSelected {
            currentSelectedTime = durationValue * 60
        } else {
            currentSelectedTime = durationValue
        }
        let minutesPortion = String(format: "%02d", currentSelectedTime / 60)
        let secondsPortion = String(format: "%02d", currentSelectedTime % 60)
        self.percentageLabel.text = "\(minutesPortion):\(secondsPortion)"
        
    }
    
    @IBAction func setInterval(_ sender: Any) {
        let currentIntervalValue = Int(intervalSlider.value)
        lblInterval.text = "\(currentIntervalValue)"
        
    }
    
    @IBAction func setReps(_ sender: Any) {
        let currentRepsValue = Int(repsSlider.value)
        lblNumberReps.text = "\(currentRepsValue)"
    }
    
    @IBAction func startTimer(_ sender: Any) {
        startTimer()
    }
    
    @IBAction func stopTimer(_ sender: Any) {
        timer.invalidate()
        currentTimer = 0
       // trackerLayer.path = nil
        let pausedTime = trackerLayer.convertTime(CACurrentMediaTime(), from: nil)
        trackerLayer.speed = 0.0
        trackerLayer.timeOffset = pausedTime
    }
    
    @IBAction func setupTimerUnits(_ sender: Any) {
        let vc = storyboard?.instantiateViewController(withIdentifier: "timerunits") as! TimeUnits
        vc.unitDelegate = self
        
        if  durationMinutesSelected {
            vc.labelDuration = true
        } else {
            vc.labelDuration = false
        }
        
        if  intervalMinutesSelected {
            vc.labelInterval = true
        } else {
            vc.labelInterval = false
        }
        self.present(vc,animated:true,completion: nil)
    }
    
    @IBAction func resetTimer(_ sender: Any) {
        hasTimerStarted = false
        self.percentageLabel.textColor = UIColor.white
        self.lblRepsCompleted.text = "0 reps completed"
        timer.invalidate()
        repCounter = 0
        self.hasPaused = 0
        btnStartTimer.isEnabled = true
        resetTimerButton()
        self.currentTimer=0
        self.percentageLabel.text = "00:00"
        self.view.layer.removeAllAnimations()
        durationSlider.value = 0
        intervalSlider.value = 0
        repsSlider.value = 1
        lblDuration.text = "0"
        lblInterval.text = "0"
        lblNumberReps.text = "1"
        trackerLayer.path = nil
    }
    
    private func playAlertSound(soundid: Int) {
        let systemSoundId: SystemSoundID = SystemSoundID(soundid)  // to play apple's built in sound, no need for upper 3 lines
       // self.timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true, block: { (timer) in
            AudioServicesPlaySystemSound(systemSoundId)
       // })
    }
}

extension Int {
    var degreesToRadians : CGFloat {
        return CGFloat(self) * .pi / 180
    }
}

extension FreeTimer: UnitChoiceDelegate{
    
    func didChooseUnit(unit: String, whichTimer: String) {
        durationSlider.value = 0
        intervalSlider.value = 0
        lblInterval.text = "0"
        lblDuration.text = "0"
        self.percentageLabel.text = "00:00"
       
        if whichTimer == "duration" {
            if unit == "sec" {
                lblDurationLabel.text = "Duration (sec)"
                durationMinutesSelected = false
                durationSlider.value = 0
                lblDuration.text = "0"
                durationSlider.maximumValue = 60
                updateTimerLabel(durationValue: 0)
            } else {
                lblDurationLabel.text = "Duration (min)"
                durationMinutesSelected = true
                durationSlider.minimumValue = 0
                lblDuration.text = "0"
                durationSlider.value = 0
                durationSlider.maximumValue = 30
                 updateTimerLabel(durationValue: 0)
            }
        } else {
            if unit == "sec" {
                lblIntervalLabel.text = "Interval (sec)"
                intervalMinutesSelected = false
                intervalSlider.maximumValue = 60
            } else {
                lblIntervalLabel.text = "Interval (min)"
                intervalMinutesSelected = true
                intervalSlider.maximumValue = 20
            }
        }
    }
}
