//
//  WaitingToLoad.swift
//  FitLab
//
//  Created by Rodrigo Schreiner on 9/26/17.
//  Copyright © 2017 Up2SpeedTraining. All rights reserved.
//

import UIKit

class WaitingToLoad: UIViewController {

    @IBOutlet weak var myView: UIView!
    override func viewDidLoad() {
        super.viewDidLoad()
        myView.layer.cornerRadius=5
        myView.layer.shadowOpacity=0.3
        myView.layer.borderWidth=1.5
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
