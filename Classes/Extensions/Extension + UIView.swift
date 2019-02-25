//
//  Extension + UIView.swift
//  MWR
//
//  Created by Chinmay Patel on 20/11/18.
//  Copyright © 2018 Chinmay Patel . All rights reserved.
//

import Foundation
import UIKit

extension UIView {
    func addGradientWithColor(colorTop: UIColor , colorBottom : UIColor) {
        let gradient = CAGradientLayer()
        gradient.frame = self.bounds
        gradient.colors = [colorTop.cgColor, colorBottom.cgColor]
        gradient.locations = [0.0 , 1.0]
        self.layer.insertSublayer(gradient, at: 0)
    }
    
    func addRoundCornerToBottomLeftAndRight(){
        let path = UIBezierPath(roundedRect:self.bounds, byRoundingCorners:[.bottomLeft, .bottomRight], cornerRadii: CGSize(width: 10, height: 10))
        let maskLayer = CAShapeLayer()
        
        maskLayer.path = path.cgPath
        self.layer.mask = maskLayer
    }
    
    func blend(from: UIColor, to: UIColor, percent: Double) -> UIColor {
        var fR : CGFloat = 0.0
        var fG : CGFloat = 0.0
        var fB : CGFloat = 0.0
        var tR : CGFloat = 0.0
        var tG : CGFloat = 0.0
        var tB : CGFloat = 0.0
        
        from.getRed(&fR, green: &fG, blue: &fB, alpha: nil)
        to.getRed(&tR, green: &tG, blue: &tB, alpha: nil)
        
        let dR = tR - fR
        let dG = tG - fG
        let dB = tB - fB
        
        let rR = fR + dR * CGFloat(percent)
        let rG = fG + dG * CGFloat(percent)
        let rB = fB + dB * CGFloat(percent)
        
        return UIColor(red: rR, green: rG, blue: rB, alpha: 1.0)
    }
    
    // Pass in the scroll percentage to get the appropriate color
    func scrollColor(percent: Double) -> UIColor {
        var start : UIColor
        var end : UIColor
        var perc = percent
        if percent < 0.5 {
            // If the scroll percentage is 0.0..<0.5 blend between yellow and green
            start = hexStringToUIColor(hex: GRADIENT_BOTTOM_COLOR)
            end = hexStringToUIColor(hex: GRADIENT_TOP_COLOR)
        } else {
            // If the scroll percentage is 0.5..1.0 blend between green and blue
            start = hexStringToUIColor(hex: GRADIENT_TOP_COLOR)
            end = hexStringToUIColor(hex: GRADIENT_BOTTOM_COLOR)
            perc -= 0.5
        }
        
        return blend(from: start, to: end, percent: perc * 2.0)
    }
}

func hexStringToUIColor (hex:String) -> UIColor {
    var cString:String = hex.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()
    
    if (cString.hasPrefix("#")) {
        cString.remove(at: cString.startIndex)
    }
    
    if ((cString.count) != 6) {
        return UIColor.gray
    }
    
    var rgbValue:UInt32 = 0
    Scanner(string: cString).scanHexInt32(&rgbValue)
    
    return UIColor(
        red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
        green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
        blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
        alpha: CGFloat(1.0)
    )
}

