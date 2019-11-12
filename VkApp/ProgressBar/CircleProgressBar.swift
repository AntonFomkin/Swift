//
//  CircleProgressBar.swift
//  VkApp
//
//  Created by Anton Fomkin on 16/06/2019.
//  Copyright © 2019 Anton Fomkin. All rights reserved.
//

import UIKit

final class CircleProgressBar: UIView {
 
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        
        self.layer.cornerRadius = self.layer.bounds.width / 2
        self.layer.backgroundColor = UIColor.appCicleProgressBar.cgColor
        self.clipsToBounds = true
    }
}
