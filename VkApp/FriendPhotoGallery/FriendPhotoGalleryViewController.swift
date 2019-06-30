//
//  FriendPhotoGalleryViewController.swift
//  VkApp
//
//  Created by Anton Fomkin on 19/06/2019.
//  Copyright © 2019 Anton Fomkin. All rights reserved.
//

import UIKit

class FriendPhotoGalleryViewController: UIViewController {

    @IBOutlet weak var displayedPhoto: UIImageView!
    @IBOutlet weak var previousPhoto: UIImageView!
    @IBOutlet weak var nextPhoto: UIImageView!
    var currentIndex : Int = 0
   
    
    var galleryFoto : [UIImage] =
        [
            UIImage(imageLiteralResourceName: "foto1.png"),
            UIImage(imageLiteralResourceName: "foto2.png"),
            UIImage(imageLiteralResourceName: "foto3.png"),
            UIImage(imageLiteralResourceName: "foto4.png"),
            UIImage(imageLiteralResourceName: "foto5.png"),
            UIImage(imageLiteralResourceName: "foto6.png")
    ]
    
    override func viewDidLoad () {
        super.viewDidLoad()
        
        displayedPhoto.image = galleryFoto[currentIndex]
        setupView()
    }
    
    func setupView() {
        
        let leftSwipe = UISwipeGestureRecognizer(target : self, action : #selector (swippedLeft( _:)))
        leftSwipe.direction = .left
        displayedPhoto.addGestureRecognizer(leftSwipe)
        
        let rigthSwipe = UISwipeGestureRecognizer(target : self, action : #selector (swippedRigth( _:)))
        rigthSwipe.direction = .right
        displayedPhoto.addGestureRecognizer(rigthSwipe)
        
        displayedPhoto.isUserInteractionEnabled = true
        
    }
    // MARK: Обработчики жестов Swipe
    @objc func swippedLeft(_ gesture : UISwipeGestureRecognizer) {
        if currentIndex != galleryFoto.count - 1 {
            previousPhoto.image = nil
            nextPhoto.image = galleryFoto[currentIndex + 1]
            nextPhoto.center.x += nextPhoto.frame.width
            
            UIView.animateKeyframes(withDuration: 1, delay: 0, options: [], animations : {
                
                UIView.addKeyframe(withRelativeStartTime: 0 , relativeDuration: 1, animations: {
                    self.displayedPhoto.transform = CGAffineTransform(scaleX : 0.001 , y: 0.001)
                })
                UIView.addKeyframe(withRelativeStartTime: 0, relativeDuration: 1,  animations : {
                    self.displayedPhoto.center.x -= 150
                })
                UIView.addKeyframe(withRelativeStartTime: 0, relativeDuration: 1,  animations : {
                    self.nextPhoto.transform = CGAffineTransform(scaleX : 1 , y: 1)
                })
                UIView.addKeyframe(withRelativeStartTime: 0, relativeDuration: 1, animations : {
                    self.nextPhoto.center.x -= self.nextPhoto.frame.width
                })
            }, completion: { _ in
                
                self.currentIndex += 1
                self.displayedPhoto.transform = .identity
                self.displayedPhoto.center.x += 150
                self.nextPhoto.transform = .identity
                self.nextPhoto.center.x += self.nextPhoto.frame.width
                
                self.displayedPhoto.image = self.galleryFoto[self.currentIndex]
            })
        }
    }
    
    
    
    
    @objc func swippedRigth(_ gesture : UISwipeGestureRecognizer) {
        
        if currentIndex != 0 {
            nextPhoto.image = nil
            previousPhoto.image = galleryFoto[currentIndex - 1]
            previousPhoto.center.x -= previousPhoto.frame.width
            
            UIView.animateKeyframes(withDuration: 1, delay: 0, options: [], animations : {
                
                UIView.addKeyframe(withRelativeStartTime: 0 , relativeDuration: 1, animations: {
                    self.displayedPhoto.transform = CGAffineTransform(scaleX : 0.001 , y: 0.001)
                })
                UIView.addKeyframe(withRelativeStartTime: 0, relativeDuration: 1,  animations : {
                    self.displayedPhoto.center.x += 150
                })
                UIView.addKeyframe(withRelativeStartTime: 0, relativeDuration: 1,  animations : {
                    self.previousPhoto.transform = CGAffineTransform(scaleX : 1 , y: 1)
                })
                UIView.addKeyframe(withRelativeStartTime: 0, relativeDuration: 1, animations : {
                    self.previousPhoto.center.x += self.nextPhoto.frame.width
                })
            }, completion: { _ in
                
                self.currentIndex -= 1
                self.displayedPhoto.image = self.galleryFoto[self.currentIndex]
                self.displayedPhoto.transform = .identity
                self.displayedPhoto.center.x -= 150
                self.previousPhoto.transform = .identity
                self.previousPhoto.center.x -= self.nextPhoto.frame.width
            })
        }
    }


}
