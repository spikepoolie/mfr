//
//  TextFieldWithImage.swift
//  mfr
//
//  Created by Rodrigo Schreiner on 1/22/17.
//  Copyright © 2017 Rodrigo Schreiner. All rights reserved.
//

import UIKit
@IBDesignable
class TextFieldWithImage: UITextField {
    
    @IBInspectable var cornerRadius:CGFloat=0{
        didSet{
            layer.cornerRadius=cornerRadius
        }
    }
    
    @IBInspectable var rightImage:UIImage?{
        didSet{
            updateView()
        }
    }
    
    @IBInspectable var leftImage:UIImage?{
        didSet{
            updateView()
        }
    }
    
    @IBInspectable var rightPadding: CGFloat = 0{
        didSet{
            updateView()
        }
    }
    
    @IBInspectable var leftPadding: CGFloat = 0{
        didSet{
            updateView()
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
    
    func updateView(){
        //        if let image = rightImage{
        //            rightViewMode = .always
        //            let imageView = UIImageView(frame:CGRect(x:-rightPadding,y:0,width:20,height:20))
        //
        //            imageView.image=image
        //            imageView.tintColor = tintColor
        //
        //            var width = rightPadding + 20
        //
        //            if borderStyle == UITextBorderStyle.none || borderStyle == UITextBorderStyle.line{
        //                width = width + 5
        //            }
        //
        //            let view = UIView(frame:CGRect(x:0,y:0,width:width,height:20))
        //            view.addSubview(imageView)
        //            rightView=view
        //        }
        //        else{
        //            rightViewMode = .never
        //        }
        
        if let limage = leftImage{
            leftViewMode = .always
            let imageViewL = UIImageView(frame:CGRect(x:leftPadding,y:0,width:20,height:20))
            
            imageViewL.image=limage
            imageViewL.tintColor = tintColor
            
            var width = leftPadding + 20
            
            if borderStyle == UITextField.BorderStyle.none || borderStyle == UITextField.BorderStyle.line{
                width = width + 5
            }
            
            let view = UIView(frame:CGRect(x:0,y:0,width:width,height:20))
            view.addSubview(imageViewL)
            leftView=view
        }
        else{
            leftViewMode = .never
        }
        
        attributedPlaceholder = NSAttributedString(string: placeholder != nil ? placeholder! : "", attributes: [NSAttributedString.Key.foregroundColor:tintColor])
    }
}
