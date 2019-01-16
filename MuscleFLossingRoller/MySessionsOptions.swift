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
    var pageToGo = ""
    
    @IBOutlet weak var myView: UIImageView!
    
    @IBOutlet weak var btnDate: UIButton!
    @IBOutlet weak var btnMuscle: UIButton!
    @IBOutlet weak var btnBack: UIButton!
    @IBOutlet weak var btnFavorite: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        centerX = Double(self.myView.center.x * 1)
        centerY = Double(self.myView.center.y * 1)
        self.getDevice()
       
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // Show the Navigation Bar
        navigationController?.setNavigationBarHidden(true, animated: false)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // Show the Navigation Bar
        navigationController?.setNavigationBarHidden(false, animated: true)
    }
    
  
    func getDevice() {
        if UIDevice().userInterfaceIdiom == .phone {
            switch Int(UIScreen.main.nativeBounds.height){
            case 1334: // 7 & 8
                self.setButtomClicable(x: 0.58, y: 0.58, btn: btnMuscle)
                self.setButtomClicable(x: 1.22, y: 0.58, btn: btnFavorite)
                self.setButtomClicable(x: 0.58, y: 0.87, btn: btnDate)
                self.setButtomClicable(x: 1.22, y: 0.87, btn: btnBack)
            case 1920: // My Iphone
                self.setButtomClicable(x: 0.60, y: 0.65, btn: btnMuscle)
                self.setButtomClicable(x: 1.39, y: 0.65, btn: btnFavorite)
                self.setButtomClicable(x: 0.60, y: 0.95, btn: btnDate)
                self.setButtomClicable(x: 1.39, y: 0.95, btn: btnBack)
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
            case 1792: // XR & XMAX
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

    @IBAction func workedMuscles(_ sender: Any) {
        self.pageToGo = "workedmuscles"
        self.goToReports(option: self.pageToGo)
        
    }

    @IBAction func favoriteMuscles(_ sender: Any) {
        self.pageToGo = "favorites"
        self.goToReports(option: self.pageToGo)
    }
    
    @IBAction func dateMuscles(_ sender: Any) {
        self.pageToGo = "date"
        self.goToReports(option: self.pageToGo)
    }
    
    func goToReports(option: String){
        var vc = storyboard?.instantiateViewController(withIdentifier: "dateslist") as! UIViewController
        if option == "workedmuscles" {
           UserDefaults.standard.set("muscles", forKey: "pagefrom")
           vc = storyboard?.instantiateViewController(withIdentifier: "musclelist") as! MuscleList
        } else if option == "favorites" {
           UserDefaults.standard.set("muscles", forKey: "pagefrom")
            vc = storyboard?.instantiateViewController(withIdentifier: "musclelist") as! MuscleList
        } else {
            UserDefaults.standard.set("date", forKey: "pagefrom")
            vc = storyboard?.instantiateViewController(withIdentifier: "dateslist") as! DatesList
        }
        self.present(vc,animated:true,completion: nil)
        
    }

}


