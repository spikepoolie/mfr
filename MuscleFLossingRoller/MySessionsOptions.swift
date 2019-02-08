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
        UserDefaults.standard.set("f@f.com_ddddd", forKey: "myuserid")
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
    
    @IBAction func lastThree(_ sender: Any) {
        self.pageToGo = "lastthree"
        self.goToReports(option: self.pageToGo)
    }
    
    func goToReports(option: String){
        if option == "workedmuscles" {
           UserDefaults.standard.set("muscles", forKey: "pagefrom")
        } else if option == "favorites" {
            let vc = storyboard?.instantiateViewController(withIdentifier: "noselections") as? NoSelections
            UserDefaults.standard.set("favorites", forKey: "pagefrom")
            vc?.pageFrom = "favorites"
            vc?.bartitle = "Favorites"
            vc?.username = UserDefaults.standard.string(forKey: "myuserid")!
            self.present(vc!, animated: true, completion: nil)
        } else if option == "lastthrees" {
            let vc = storyboard?.instantiateViewController(withIdentifier: "noselections") as? NoSelections
            UserDefaults.standard.set("lastthree", forKey: "pagefrom")
            vc?.pageFrom = "lastthree"
            vc?.bartitle = "Last Three Sessions"
            vc?.username = UserDefaults.standard.string(forKey: "myuserid")!
            self.present(vc!, animated: true, completion: nil)
        } else {
            UserDefaults.standard.set("date", forKey: "pagefrom")
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        UserDefaults.standard.string(forKey: "myuserid")
       
        
        if segue.identifier == "favorites" {
           UserDefaults.standard.set("Favorites", forKey: "bartitle")
             UserDefaults.standard.set("favorites", forKey: "pagefrom")
        } else {
            UserDefaults.standard.set("Last 3 Sessions", forKey: "bartitle")
             UserDefaults.standard.set("lastthree", forKey: "pagefrom")
        }
    }
}


