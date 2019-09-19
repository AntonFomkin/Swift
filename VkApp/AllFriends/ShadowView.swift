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
        DispatchQueue.main.async {
            
            self.friendFoto.layer.cornerRadius = self.friendFoto.avatarImage.frame.height / 2
            self.friendFoto.layer.borderWidth = 1
            self.friendFoto.layer.borderColor = UIColor.orange.cgColor
            self.friendFoto.layer.backgroundColor = self.colorBackground.cgColor
            self.friendFoto.layer.masksToBounds = true
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        DispatchQueue.main.async {
            let shadowLayer = CAShapeLayer()
            shadowLayer.shadowPath = UIBezierPath(roundedRect: self.bounds, cornerRadius: ceil(self.frame.size.height / 2)).cgPath
            shadowLayer.shadowColor = self.colorShadow.cgColor
            shadowLayer.shadowRadius = self.radiusShadow
            shadowLayer.shadowOpacity = self.opacityShadow
            shadowLayer.shadowOffset = CGSize(width: 2, height: 2)
            self.layer.insertSublayer(shadowLayer, at: 0)
            
            self.redraw.toggle()
        }
    }
}
