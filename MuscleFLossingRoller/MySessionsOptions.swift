//
//  MySessionsOptions.swift
//  MuscleFLossingRoller
//
//  Created by Rodrigo Schreiner on 1/10/19.
//  Copyright © 2019 MFR. All rights reserved.
//

import UIKit

class MySessionsOptions: UIViewController {
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    var centerX = 0.00
    var centerY = 0.00
    
    @IBOutlet weak var myView: UIImageView!
    
    @IBOutlet weak var btnDate: UIButton!
    @IBOutlet weak var btnMuscle: UIButton!
    @IBOutlet weak var btnBack: UIButton!
    @IBOutlet weak var btnFavorite: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print(Int(UIScreen.main.nativeBounds.height))
        centerX = Double(self.myView.center.x * 1)
        centerY = Double(self.myView.center.y * 1)
        self.getDevice()
       
        // Do any additional setup after loading the view.
    }
    /*
     
     btnMuscle
     XMAX -> 1-0.35 1-0.18
     XR -> 1-0.35 1-0.18
     X -> 1-0.39 1-0.27
     XS -> 1-0.39 1-0.27
     7+ -> 1-0.37 1-0.36
     8+ -> 1-0.37 1-0.36
     7 -> 1-0.40 1-0.42
     8 -> 1-0.40 1-0.42
     
     btnFavorite
     7 and 8 -> 1+ 0.27 1-0.37
     7+ and 8+ ->1+0.40 1-0.37
     X -> 1+0.27 1-0.25
     XS -> 1+0.27 1-0.25
     XR -> 1+0.35 1-0.17
     XMAX-> 1+0.35 1-0.17
     
     btnDate
     XMAX -> 1-0.35 1+0.16
     XR -> 1-0.35 1+0.16
     XS -> 1-0.37 1+0.05
     X-> 1-0.37 1+0.05
     8+ -> 1-0.37 1-0.05
     7+ -> 1-0.37 1-0.05
     8 -> 1-0.37 1-0.15
     7 -> 1-0.37 1-0.15
     
     btnBack
     7 -> 1+0.28 1-0.15
     8 -> 1+0.28 1-0.15
     8+ -> 1+0.35 1-0.05
     7+ -> 1+0.35 1-0.05
     X -> 1+0.25 1+0.05
     XS -> 1+0.25 1+0.05
     XR -> 1+0.35 1+0.16
     XMAX -> 1+0.35 1+0.16
     
 */
    
  
    func getDevice() {
        if UIDevice().userInterfaceIdiom == .phone {
            switch Int(UIScreen.main.nativeBounds.height){
            case 1334: // 7 & 8
                self.setButtomClicable(x: 0.58, y: 0.58, btn: btnMuscle)
                self.setButtomClicable(x: 1.22, y: 0.58, btn: btnFavorite)
                self.setButtomClicable(x: 0.58, y: 0.87, btn: btnDate)
                self.setButtomClicable(x: 1.22, y: 0.87, btn: btnBack)
            case 2208: // 7+ & 8+
                self.setButtomClicable(x: 0.60, y: 0.64, btn: btnMuscle)
                self.setButtomClicable(x: 1.38, y: 0.64, btn: btnFavorite)
                self.setButtomClicable(x: 0.60, y: 0.95, btn: btnDate)
                self.setButtomClicable(x: 1.38, y: 0.95, btn: btnBack)
            case 2436: // X & XS
                self.setButtomClicable(x: 0.59, y: 0.73, btn: btnMuscle)
                self.setButtomClicable(x: 1.22, y: 0.73, btn: btnFavorite)
                self.setButtomClicable(x: 0.59, y: 1.04, btn: btnDate)
                self.setButtomClicable(x: 1.22, y: 1.04, btn: btnBack)
            case 1792:
                self.setButtomClicable(x: 0.59, y: 0.82, btn: btnMuscle)
                self.setButtomClicable(x: 1.40, y: 0.82, btn: btnFavorite)
                self.setButtomClicable(x: 0.59, y: 1.16, btn: btnDate)
                self.setButtomClicable(x: 1.40, y: 1.16, btn: btnBack)
            default:
               return
            }
        }
    }
    
    func setButtomClicable(x: Float, y: Float, btn: UIButton) {
        btn.center.x = CGFloat(Float(centerX) * Float(x))
        btn.center.y = CGFloat(Float(centerY) * Float(y))
    }

}


