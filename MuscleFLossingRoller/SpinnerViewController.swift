//
//  SpinnerViewController.swift
//  MyFitLabSolutions
//
//  Created by Rodrigo Schreiner on 5/12/18.
//  Copyright © 2018 Rodrigo Schreiner. All rights reserved.
//

import UIKit

class SpinnerViewController: UIViewController {
    var spinner = UIActivityIndicatorView(style: .whiteLarge)
    
    override func viewDidLoad() {
        view = UIView()
        view.backgroundColor = UIColor(white: 0, alpha: 0.7)
        
        spinner.translatesAutoresizingMaskIntoConstraints = false
        spinner.startAnimating()
        view.addSubview(spinner)
        
        spinner.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        spinner.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
    }
    override func loadView() {
        
        
        
    }
}
