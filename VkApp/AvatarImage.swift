//
//  AvatarImage.swift
//  VkApp
//
//  Created by Anton Fomkin on 17/06/2019.
//  Copyright © 2019 Anton Fomkin. All rights reserved.
//

import UIKit

class AvatarImage: UIControl {
    
    var avatarImage : UIImageView!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setupView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.setupView()
    }
    
    
    override func layoutSubviews() {
        super.layoutSubviews()
    }
    
    
    private func setupView() {
        self.addTarget(self, action: #selector(touchUp), for: .touchUpInside)
        self.addTarget(self, action: #selector(touchDown), for: .touchDown)
        self.backgroundColor = UIColor.white
        self.avatarImage = UIImageView(frame: CGRect(x: 0, y: 0, width: self.frame.height, height: self.frame.height))
        //  self.avatarImage.contentMode = .center
        self.addSubview(avatarImage!)
        
    }
    // MARK: Обработка нажатий
    @objc func touchUp () {
        imageDownSpringsAnimation()
        setNeedsDisplay()
    }
    
    
    @objc func touchDown () {
        imageUpAnimation()
        setNeedsDisplay()
    }
    
    // MARK: Анимация картинки по нажатию
    func imageUpAnimation () {
        DispatchQueue.global().async {
            let animation = CABasicAnimation(keyPath: "transform.scale")
            animation.fromValue = 1
            animation.toValue = 0.5
            animation.duration = 0.2
            animation.fillMode = .forwards
            animation.isRemovedOnCompletion = false
            
            DispatchQueue.main.async {
                self.avatarImage.layer.add(animation, forKey: nil)
            }
            animation.isRemovedOnCompletion = true
        }
    }
    
    func imageDownSpringsAnimation () {
        DispatchQueue.global().async {
            let animation = CASpringAnimation(keyPath: "transform.scale")
            animation.fromValue = 0.5
            animation.toValue = 1
            animation.stiffness = 200
            animation.mass = 2
            animation.duration = 1
            animation.fillMode = .forwards
            animation.isRemovedOnCompletion = false
            
            DispatchQueue.main.async {
                self.avatarImage.layer.add(animation, forKey: nil)
            }
            animation.isRemovedOnCompletion = true
        }
    }
}
