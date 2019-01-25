//
//  QuickSessions.swift
//  MyFitLabSolutions
//
//  Created by Rodrigo Schreiner on 6/15/18.
//  Copyright © 2018 Rodrigo Schreiner. All rights reserved.
//

import UIKit

class QuickSessions: UIViewController {
    override var prefersStatusBarHidden: Bool {
        return true
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let rightSwipe = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipe(sender:)))
        rightSwipe.direction = .right
        
        view.addGestureRecognizer(rightSwipe)
        
        let leftSwipe = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipe(sender:)))
        leftSwipe.direction = .left
        
        view.addGestureRecognizer(leftSwipe)
        
        let upSwipe = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipe(sender:)))
        upSwipe.direction = .up
        
        view.addGestureRecognizer(upSwipe)
        
        let downSwipe = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipe(sender:)))
        downSwipe.direction = .down
        
        view.addGestureRecognizer(downSwipe)

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func CloseQuickSession(_ sender: Any) {
        sendBack()
    }
    
    @objc func handleSwipe(sender: UISwipeGestureRecognizer) {
        
        if sender.state == .ended {
            sendBack()
        }
    }
    
    func sendBack() {
         self.dismiss(animated: true, completion: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "lastThree" {
            UserDefaults.standard.set("lastthree", forKey: "pagefrom")
            let destinationVC = storyboard?.instantiateViewController(withIdentifier: "musclereport") as? MuscleReport
            destinationVC?.bartitle = "favorites"
            UserDefaults.standard.string(forKey: "myuserid")!
        }
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
