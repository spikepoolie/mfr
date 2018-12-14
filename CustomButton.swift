//
//  CustomButton.swift
//  mfr
//
//  Created by Rodrigo Schreiner on 1/23/17.
//  Copyright © 2017 Rodrigo Schreiner. All rights reserved.
//

import UIKit
@IBDesignable
class CustomButton: UIButton {
    @IBInspectable var cornerRadius:CGFloat=0{
        didSet{
            layer.cornerRadius=cornerRadius
        }
    }
    
    @IBInspectable var borderWidth:CGFloat=0.0{
        didSet{
            self.layer.borderWidth = borderWidth
        }
    }
    
    @IBInspectable var borderColor:UIColor=UIColor.clear{
        didSet{
            self.layer.borderColor = borderColor.cgColor
        }
    }
}
