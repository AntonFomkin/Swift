//
//  CircleProgressBar.swift
//  VkApp
//
//  Created by Anton Fomkin on 16/06/2019.
//  Copyright © 2019 Anton Fomkin. All rights reserved.
//

import UIKit

class CircleProgressBar: UIView {
 
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        
        self.layer.cornerRadius = self.layer.bounds.width / 2
        self.layer.backgroundColor = UIColor(red: 198/255, green: 185/255, blue: 171/255, alpha: 1.0).cgColor
        self.clipsToBounds = true
    }
}
