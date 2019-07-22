//
//  ShadowView.swift
//  VkApp
//
//  Created by Anton Fomkin on 01/06/2019.
//  Copyright © 2019 Anton Fomkin. All rights reserved.
//

import UIKit

class ShadowView: UIView {

    @IBOutlet weak var friendFoto: AvatarImage!
    
    var redraw : Bool = false {
        didSet {
            setNeedsDisplay()
        }
    }
    
    @IBInspectable var opacityShadow: Float = 0.9
    @IBInspectable var radiusShadow: CGFloat = 0.3
    @IBInspectable var colorShadow: UIColor = .gray
    @IBInspectable var colorBackground: UIColor = .white
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
   
        friendFoto.layer.cornerRadius = friendFoto.avatarImage.frame.height / 2
        friendFoto.layer.borderWidth = 1
        friendFoto.layer.borderColor = UIColor.orange.cgColor
        friendFoto.layer.backgroundColor = colorBackground.cgColor
        friendFoto.layer.masksToBounds = true 
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        let shadowLayer = CAShapeLayer()
        shadowLayer.shadowPath = UIBezierPath(roundedRect: bounds, cornerRadius: frame.size.height / 2).cgPath
        shadowLayer.shadowColor = colorShadow.cgColor
        shadowLayer.shadowRadius = radiusShadow
        shadowLayer.shadowOpacity = opacityShadow
        shadowLayer.shadowOffset = CGSize(width: 2, height: 2)
        layer.insertSublayer(shadowLayer, at: 0)
        
        redraw.toggle()
    }
}
