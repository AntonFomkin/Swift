//
//  ProgressBar.swift
//  VkApp
//
//  Created by Anton Fomkin on 16/06/2019.
//  Copyright © 2019 Anton Fomkin. All rights reserved.
//

import UIKit

class ProgressBar: UIControl {
    
    var circleOne : CircleProgressBar!
    var circleTwo : CircleProgressBar!
    var circleThree : CircleProgressBar!
    
    // MARK: Добавляем объекты анимации на View
    override func draw(_ rect: CGRect) {
        // Мне необходимо, чтобы анимация продолжала работать и после переиспользования ячейки
        DispatchQueue.main.async {
            if self.circleOne != nil { self.circleOne.removeFromSuperview()}
            
            self.circleOne = CircleProgressBar(frame: CGRect(x: 0, y: 0, width: self.frame.height, height: self.frame.height))
            self.addSubview(self.circleOne)
            
            if self.circleTwo != nil { self.circleTwo.removeFromSuperview() }
            
            self.circleTwo = CircleProgressBar(frame: CGRect(x: (self.frame.width / 2) - (self.frame.height / 2) , y: 0,  width: self.frame.height, height: self.frame.height))
            self.addSubview(self.circleTwo)
            
            if self.circleThree != nil { self.circleThree.removeFromSuperview()}
            
            self.circleThree = CircleProgressBar(frame: CGRect(x: self.frame.width - self.frame.height , y: 0, width: self.frame.height, height: self.frame.height))
            self.addSubview(self.circleThree)
        }
    }
    
    // MARK: Запуск анимаций
    override func layoutSubviews() {
        super.layoutSubviews()
        DispatchQueue.global().async {
            let animation = CABasicAnimation(keyPath: #keyPath(CALayer.opacity))
            animation.beginTime = CACurrentMediaTime()
            animation.fromValue = 1
            animation.toValue = 0
            animation.duration = 0.5
            animation.repeatCount = .infinity
            animation.autoreverses = true
            
            DispatchQueue.main.async {
                if self.circleOne != nil { self.circleOne.layer.add(animation, forKey: nil) }
                
                let animation2 = animation
                animation2.beginTime = CACurrentMediaTime() + 0.33
                if self.circleTwo != nil { self.circleTwo.layer.add(animation2, forKey: nil) }
                
                let animation3 = animation
                animation2.beginTime = CACurrentMediaTime() + 0.66
                if self.circleThree != nil { self.circleThree.layer.add(animation3, forKey: nil) }
            }
        }
    }
    
    func updateProgressBar() {
        setNeedsDisplay()
    }
    
}
