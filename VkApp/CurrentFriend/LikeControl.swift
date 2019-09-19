//
//  LikeControl.swift
//  VkApp
//
//  Created by Anton Fomkin on 29/05/2019.
//  Copyright © 2019 Anton Fomkin. All rights reserved.
//

import UIKit

class LikeControl: UIControl {
 
    var isLiked : Bool = false

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setupView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.setupView()
    }
 
    override func draw(_ rect: CGRect) {
        super.draw(rect)
    
    
        // MARK: Рисуем сердечко
        let sideOne = rect.height * 0.4
        let sideTwo = rect.height * 0.3
        let arcRadius = sqrt(sideOne*sideOne + sideTwo*sideTwo)/2
        
        let path = UIBezierPath()
        
        path.addArc(withCenter: CGPoint(x: rect.height * 0.3, y: rect.height * 0.35), radius: arcRadius, startAngle: 135.degreesToRadians, endAngle: 315.degreesToRadians, clockwise: true)
        path.addArc(withCenter: CGPoint(x: rect.height * 0.7, y: rect.height * 0.35), radius: arcRadius, startAngle: 225.degreesToRadians, endAngle: 45.degreesToRadians, clockwise: true)
        path.addLine(to: CGPoint(x: rect.height * 0.5, y: rect.height * 0.95))
        
        path.close()
       
        UIColor.gray.setStroke()
        UIColor.gray.setFill()
        // MARK: Запуск анимации по условию
        if self.isLiked {
         
            UIColor.red.setStroke()
            UIColor.red.setFill()
            path.fill()
            let animation = CABasicAnimation(keyPath: #keyPath(CALayer.opacity))
            animation.beginTime = CACurrentMediaTime()
            animation.fromValue = 0.5
            animation.toValue = 0.2
            animation.duration = 1
            animation.autoreverses = true
            self.layer.add(animation, forKey: nil)
        } else {
            path.stroke()
        }
        
    }
        
    private func setupView() {
        DispatchQueue.main.async {
            self.addTarget(self, action: #selector(self.selectLike), for: .touchUpInside)
            self.backgroundColor = UIColor.white
            self.layer.cornerRadius = min(self.bounds.height, self.bounds.width) / 5
            self.clipsToBounds = true
        }
    }

    func deselectLike() {
       
        self.isLiked = false
        self.setNeedsDisplay()
    
    }
    //MARK: Обработка нажатия
    @objc func selectLike() {
        
        self.isLiked.toggle()
        self.sendActions(for: .valueChanged)
        self.setNeedsDisplay()
     
    }
    
}

extension Int {
    var degreesToRadians: CGFloat { return CGFloat(self) * .pi / 180 }
}

