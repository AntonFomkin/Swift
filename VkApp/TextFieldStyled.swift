//
//  TextFieldStyled.swift
//  VkApp
//
//  Created by Anton Fomkin on 19/06/2019.
//  Copyright © 2019 Anton Fomkin. All rights reserved.
//

import UIKit

final class TextFieldStyled: UITextField {

    var redraw : Bool = false {
        didSet {
            setNeedsDisplay()
        }
    }
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        
        layer.cornerRadius = 10
        layer.borderWidth = 1
        layer.borderColor = UIColor.orange.cgColor
        layer.masksToBounds = true
        
        redraw.toggle()
        
        
    }
}
