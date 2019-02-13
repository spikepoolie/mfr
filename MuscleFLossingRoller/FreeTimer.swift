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

    @IBOutlet var myView: UIView!
    @IBOutlet weak var lblNumberReps: UILabel!
    @IBOutlet weak var lblInterval: UILabel!
    @IBOutlet weak var lblDuration: UILabel!
    @IBOutlet weak var repsSlider: UISlider!
    @IBOutlet weak var intervalSlider: UISlider!
    @IBOutlet weak var durationSlider: UISlider!
    
    @IBOutlet weak var btnResetTimer: CustomButton!
    @IBOutlet weak var btnStartTimer: CustomButton!
    
    @IBOutlet weak var lblRepsCompleted: UILabel!
    
    let shapeLayer = CAShapeLayer()
    
    let percentageLabel: UILabel = {
        let label = UILabel()
        label.text = ""
        label.textAlignment = .center
        label.font = UIFont.boldSystemFont(ofSize: 32)
        return label
    }()
    
    
    var timer:Timer?
    var originalTime = 120
    var timeLeft = CGFloat(2/120)
    var hasTimerStarted = false
    var repCounter = 0
    var hasPaused = 0
    var currentTimer = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let myPosition = CGPoint(x: myView.layer.bounds.midX, y: myView.layer.bounds.midY + 60)
        view.addSubview(percentageLabel)
        percentageLabel.frame = CGRect(x: 0, y: 0, width: 100, height: 100)
        percentageLabel.center = myPosition
        
        let ciruclarPath = UIBezierPath(arcCenter: .zero, radius: 100, startAngle: 0 , endAngle: 2 * CGFloat.pi, clockwise: true)
        
        let trackerLayer = CAShapeLayer()
        trackerLayer.path = ciruclarPath.cgPath
        trackerLayer.strokeColor = UIColor.white.cgColor
        trackerLayer.lineWidth = 12
        trackerLayer.position = myPosition
        trackerLayer.fillColor = UIColor.clear.cgColor
        view.layer.addSublayer(trackerLayer)
        
        shapeLayer.path = ciruclarPath.cgPath
        shapeLayer.strokeColor = UIColor.red.cgColor
        shapeLayer.lineWidth = 12
        shapeLayer.lineCap = CAShapeLayerLineCap.round
       // shapeLayer.position = view.center
        //shapeLayer.position = CGPoint(x: myView.layer.bounds.midX, y: 600)
        shapeLayer.transform = CATransform3DMakeRotation(-CGFloat.pi / 2, 0, 0, 1)
        shapeLayer.fillColor = UIColor.clear.cgColor
        shapeLayer.strokeEnd = 0
        
        view.layer.addSublayer(shapeLayer)
        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleTap)))
       
    }
    
    private func startTimer() {
//       timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(onTimerFires), userInfo: nil, repeats: true)
        lblRepsCompleted.text = "\(repCounter) of \(Int(repsSlider.value)) completed"
        hasTimerStarted = true
       
            if self.repCounter < Int(self.repsSlider.value){
                percentageLabel.text = "Time Remaining"
                if(btnStartTimer.currentTitle! == "Pause"){
                    //  btnPlayPause.image = UIImage(named:"playPlayer")
                    resetTimerButton()
                }
                else{
                    if hasPaused == 0{
                        currentTimer =  Int(durationSlider.value) * 60
                        hasPaused = 1
                    }
                    btnStartTimer.setTitleColor(UIColor.white, for: UIControl.State.normal)
                    btnStartTimer.backgroundColor = UIColor.darkGray
                    btnStartTimer.setTitle("Pause",for: UIControl.State.normal)
                    //  btnPlayPause.image = UIImage(named:"pausePlayer")
                    
                }
                
                if timer != nil{
                    timer?.invalidate()
                    timer = nil
                }
                else{
                    self.currentTimer=5
                    timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true){ _ in
                        if self.currentTimer > 0{
                            if(Int(self.repsSlider.value) > 0) {
                                self.lblRepsCompleted.isHidden=false
                                self.lblRepsCompleted.text = "\(self.repCounter) of \(Int(self.repsSlider.value)) reps completed  "
                                if self.repCounter == Int(self.repsSlider.value){
                                    self.hasTimerStarted = false
                                }
                            }
                            self.currentTimer -= 1
                            let minutesPortion = String(format: "%02d", self.currentTimer / 60)
                            let secondsPortion = String(format: "%02d", self.currentTimer % 60)
                            self.percentageLabel.text = "\(minutesPortion):\(secondsPortion)"
                        }
                        else{
                            // self.resetTimerButton()
                            self.timer?.invalidate()
                            self.timer = nil
                            self.percentageLabel.text = "00:00"
                            self.hasPaused = 0
                            let systemSoundID: SystemSoundID = SystemSoundID(1005)
//                            let handle = self.setInterval(interval: 1, block: { () -> Void in
//                                AudioServicesPlaySystemSound (systemSoundID)
//                            })
                            let when = DispatchTime.now() + 2 // change 2 to desired number of seconds
//                            DispatchQueue.main.asyncAfter(deadline: when) {
//                                handle.invalidate()
//                            }
                            
                            if Int(self.repsSlider.value) > 0{
                                self.repCounter += 1
                                self.lblRepsCompleted.text = "\(self.repCounter) of \(Int(self.repsSlider.value)) reps completed  "
                                if self.repCounter < Int(self.repsSlider.value){
                                   // self.showCoolOff(myHandle: handle)
                                }
                                else{
                                    if self.repCounter == Int(self.repsSlider.value){
                                        self.hasTimerStarted = false
                                    }
                                }
                            }
                        }
                    }
                }
            
        }
    }
    
    func resetTimerButton(){
        btnStartTimer.backgroundColor = UIColor(red: 0, green: 0.4784, blue: 1, alpha: 1.0)
        btnStartTimer.setTitleColor(UIColor.white, for: UIControl.State.normal)
        btnStartTimer.setTitle("Start",for: UIControl.State.normal)
    }
    
    
    fileprivate func animateTimer () {
        let basicAnimation = CABasicAnimation(keyPath: "strokeEnd")
        //basicAnimation.toValue = 1
        //basicAnimation.duration = 5
        basicAnimation.fillMode = CAMediaTimingFillMode.forwards
        basicAnimation.isRemovedOnCompletion = false
        shapeLayer.add(basicAnimation, forKey: "timing")
    }
    
    @objc private func handleTap() {
        //startTimer()
      //  animateTimer()
        
    }
    
    @objc func onTimerFires()
    {
        shapeLayer.strokeEnd = 0
        timeLeft += CGFloat(0.01)
        shapeLayer.strokeEnd = CGFloat(timeLeft)
        print("\(timeLeft) seconds left")
        percentageLabel.text = String(self.originalTime - 1)
        if timeLeft >= 1 {
            timer!.invalidate()
            timer = nil
        }
    }

    
    @IBAction func setDuration(_ sender: Any) {
        let currentMinuteValue = Int(durationSlider.value)
        lblDuration.text = "\(currentMinuteValue)"
        
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
        
    }
    
    @IBAction func resetTimer(_ sender: Any) {
        timer!.invalidate()
        timer = nil
        percentageLabel.text = ""
        shapeLayer.strokeEnd = 0
    }
}
