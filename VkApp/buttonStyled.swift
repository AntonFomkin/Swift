//
//  ButtonStyled.swift
//  VkApp
//
//  Created by Anton Fomkin on 19/06/2019.
//  Copyright © 2019 Anton Fomkin. All rights reserved.
//

import UIKit

final class ButtonStyled: UIButton {

    override func draw(_ rect: CGRect) {
        super.draw(rect)
        
        layer.cornerRadius = 10
        layer.masksToBounds = true
    }

}
