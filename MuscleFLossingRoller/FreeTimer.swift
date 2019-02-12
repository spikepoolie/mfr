//
//  FreeTimer.swift
//  MuscleFLossingRoller
//
//  Created by Rodrigo Schreiner on 2/11/19.
//  Copyright © 2019 MFR. All rights reserved.
//

import UIKit

class FreeTimer: UIViewController {

    let shapeLayer = CAShapeLayer()
    
    let percentageLabel: UILabel = {
        let label = UILabel()
        label.text = "Start"
        label.textAlignment = .center
        label.font = UIFont.boldSystemFont(ofSize: 32)
        return label
    }()
    
    var timer:Timer?
    var originalTime = 120
    var timeLeft = CGFloat(2/120)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(percentageLabel)
        percentageLabel.frame = CGRect(x: 0, y: 0, width: 100, height: 100)
        percentageLabel.center = view.center

        let ciruclarPath = UIBezierPath(arcCenter: .zero, radius: 100, startAngle: 0 , endAngle: 2 * CGFloat.pi, clockwise: true)
        
        let trackerLayer = CAShapeLayer()
        trackerLayer.path = ciruclarPath.cgPath
        trackerLayer.strokeColor = UIColor.lightGray.cgColor
        trackerLayer.lineWidth = 8
        trackerLayer.position = view.center
        trackerLayer.fillColor = UIColor.clear.cgColor
        view.layer.addSublayer(trackerLayer)
        
        shapeLayer.path = ciruclarPath.cgPath
        shapeLayer.strokeColor = UIColor.red.cgColor
        shapeLayer.lineWidth = 8
        shapeLayer.lineCap = CAShapeLayerLineCap.round
        shapeLayer.position = view.center
        shapeLayer.transform = CATransform3DMakeRotation(-CGFloat.pi / 2, 0, 0, 1)
        shapeLayer.fillColor = UIColor.clear.cgColor
        shapeLayer.strokeEnd = 0
        
        view.layer.addSublayer(shapeLayer)
        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleTap)))
       
    }
    
    private func startTimer() {
       timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(onTimerFires), userInfo: nil, repeats: true)
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
        startTimer()
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

  

}
