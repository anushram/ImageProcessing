//
//  struct.swift
//  CheckImageColor
//
//  Created by Ramkumar J on 11/07/22.
//

import Foundation
import UIKit
@IBDesignable
class DashedLineView: UIView {
    
    override func awakeFromNib() {
        super.awakeFromNib()
        DrawShadows()
    }
    override var bounds: CGRect { didSet { DrawShadows() } }
    @IBInspectable var cornerRadius: Float = 10 {    didSet { DrawShadows() } }
    @IBInspectable var ShadowOpacity: Float = 0 { didSet { DrawShadows() } }
    @IBInspectable var ShadowRadius: Float = 1.75 { didSet { DrawShadows() } }
    @IBInspectable var ShadowColor: UIColor = UIColor.black { didSet { DrawShadows() } }
    @IBInspectable var borderWidth: Float = 0.0 { didSet { DrawShadows() }}
    @IBInspectable var borderColor: UIColor = UIColor.systemGreen { didSet { DrawShadows() } }
    @IBInspectable var maskToBounds: Int = -1 { didSet { DrawShadows() } }
    
    func DrawShadows() {
        //draw shadow & rounded corners for offer cell
        self.layer.cornerRadius = CGFloat(cornerRadius)
        self.layer.shadowColor = ShadowColor.cgColor
        self.layer.shadowOpacity = ShadowOpacity
        self.layer.shadowOffset = CGSize.zero
        self.layer.shadowRadius = CGFloat(ShadowRadius)
        self.layer.borderWidth = CGFloat(borderWidth)
        self.layer.borderColor = borderColor.cgColor
        if maskToBounds != -1 {
            self.layer.masksToBounds = maskToBounds == 1
            //self.layer.masksToBounds = false
        } else {
            self.layer.masksToBounds = false
        }
        let rect = CGRect.init(x: 0, y: 0, width: self.bounds.width, height: self.bounds.height + 2)
        self.layer.shadowPath = UIBezierPath(roundedRect: rect, cornerRadius: self.layer.cornerRadius).cgPath
        
    }

    override func draw(_ rect: CGRect) {
        //self.setGradientBackground()
        let path = UIBezierPath(roundedRect: rect, cornerRadius: 0)

        //UIColor.lightGray.setFill()
        UIColor.init(red: 245.0/255.0, green: 245.0/255.0, blue: 245.0/255.0, alpha: 1.0).setFill()
        //UIColor.init(patternImage: UIImage.init(named: "gradient")!).setFill()
        path.fill()
        UIColor.init(red: 173.0/255.0, green: 216.0/255.0, blue: 230.0/255.0, alpha: 1.0).setStroke()
        //UIColor.init(patternImage: UIImage.init(named: "rainbow")!).setStroke()
        //UIColor..setStroke()
        path.lineWidth = 3
        
        let dashPattern : [CGFloat] = [5, 2]
        path.setLineDash(dashPattern, count: 2, phase: 0)
        path.stroke()
        
    }
    
    func setGradientBackground() {
        let colorTop =  UIColor(red: 255.0/255.0, green: 149.0/255.0, blue: 0.0/255.0, alpha: 1.0).cgColor
        let colorBottom = UIColor(red: 255.0/255.0, green: 94.0/255.0, blue: 58.0/255.0, alpha: 1.0).cgColor
                    
        let gradientLayer = CAGradientLayer()
        //gradientLayer.colors = [colorTop, colorBottom]
        gradientLayer.colors = [UIColor.red.cgColor, UIColor.blue.cgColor]
        //gradientLayer.startPoint = CGPoint(x: 0.1, y: 0.1)
        //gradientLayer.endPoint = CGPoint(x: 0.9, y: 0.9)
        //gradientLayer.colors = [UIColor.green.cgColor, UIColor.white.cgColor]
        gradientLayer.locations = [0.0, 1.0]
        gradientLayer.frame = self.bounds
                
        self.layer.insertSublayer(gradientLayer, at:0)
    }
}
//Shadow Class reused all throughout this app.
@IBDesignable
class ShadowView: UIView {
    override func awakeFromNib() {
        super.awakeFromNib()
        DrawShadows()
    }
    override var bounds: CGRect { didSet { DrawShadows() } }
    @IBInspectable var cornerRadius: Float = 10 { didSet { DrawShadows() } }
    @IBInspectable var iPadcornerRadius: Float = 10
    @IBInspectable var ShadowOpacity: Float = 0 { didSet { DrawShadows() } }
    @IBInspectable var ShadowRadius: Float = 1.75 { didSet { DrawShadows() } }
    @IBInspectable var ShadowColor: UIColor = UIColor.black { didSet { DrawShadows() } }
    @IBInspectable var borderWidth: Float = 0.0 { didSet { DrawShadows() }}
    @IBInspectable var borderColor: UIColor = UIColor.black { didSet { DrawShadows() } }
    @IBInspectable var maskToBounds: Int = -1 { didSet { DrawShadows() } }
    
    func DrawShadows() {
        //draw shadow & rounded corners for offer cell
        if IS_IPAD {
            self.layer.cornerRadius = CGFloat(iPadcornerRadius)
        }else{
            self.layer.cornerRadius = CGFloat(cornerRadius)
        }
        self.layer.shadowColor = ShadowColor.cgColor
        self.layer.shadowOpacity = ShadowOpacity
        self.layer.shadowOffset = CGSize.zero
        self.layer.shadowRadius = CGFloat(ShadowRadius)
        self.layer.borderWidth = CGFloat(borderWidth)
        self.layer.borderColor = borderColor.cgColor
        if maskToBounds != -1 {
            self.layer.masksToBounds = maskToBounds == 1
            //self.layer.masksToBounds = false
        } else {
            self.layer.masksToBounds = false
        }
        let rect = CGRect.init(x: 0, y: 0, width: self.bounds.width, height: self.bounds.height + 2)
        self.layer.shadowPath = UIBezierPath(roundedRect: rect, cornerRadius: self.layer.cornerRadius).cgPath
        
    }
}
let IS_IPAD = (UI_USER_INTERFACE_IDIOM() == .pad)
let IS_IPHONE = (UI_USER_INTERFACE_IDIOM() == .phone)
let IS_RETINA = (UIScreen.main.scale >= 2.0)
let SCREEN_WIDTH = (UIScreen.main.bounds.size.width)
let SCREEN_HEIGHT = (UIScreen.main.bounds.size.height)
let SCREEN_MAX_LENGTH = (max(SCREEN_WIDTH, SCREEN_HEIGHT))
let SCREEN_MIN_LENGTH = (min(SCREEN_WIDTH, SCREEN_HEIGHT))
let IS_IPHONE_4_OR_LESS = (IS_IPHONE && SCREEN_MAX_LENGTH < 568.0)
let IS_IPHONE_5 = (IS_IPHONE && SCREEN_MAX_LENGTH == 568.0)
let IS_IPHONE_6 = (IS_IPHONE && SCREEN_MAX_LENGTH == 667.0)
let IS_IPHONE_6P = (IS_IPHONE && SCREEN_MAX_LENGTH == 736.0)
let IS_IPHONE_X = (IS_IPHONE && SCREEN_MAX_LENGTH == 812.0)
let IS_IPHONE_XMAS = (IS_IPHONE && SCREEN_MAX_LENGTH == 896.0)

public struct PixelData {
    var r:UInt8
    var g:UInt8
    var b:UInt8
    var a:UInt8
}
