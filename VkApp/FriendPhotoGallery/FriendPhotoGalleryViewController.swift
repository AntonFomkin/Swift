//
//  FriendPhotoGalleryViewController.swift
//  VkApp
//
//  Created by Anton Fomkin on 19/06/2019.
//  Copyright © 2019 Anton Fomkin. All rights reserved.
//

import UIKit

class FriendPhotoGalleryViewController: UIViewController {
    
    
    @IBOutlet weak var descriptionPhoto: UILabel!
    @IBOutlet weak var displayedPhoto: UIImageView!
    @IBOutlet weak var previousPhoto: UIImageView!
    @IBOutlet weak var nextPhoto: UIImageView!
    var currentIndex : Int = 0
  //  var galleryFoto : [FotoCurrentUser] = []
    var cellPresenters : [CellPresenter] = []   /*
     var galleryFoto : [UIImage] =
     [
     UIImage(imageLiteralResourceName: "foto1.png"),
     UIImage(imageLiteralResourceName: "foto2.png"),
     UIImage(imageLiteralResourceName: "foto3.png"),
     UIImage(imageLiteralResourceName: "foto4.png"),
     UIImage(imageLiteralResourceName: "foto5.png"),
     UIImage(imageLiteralResourceName: "foto6.png")
     ]
     */
    
    override func viewDidLoad () {
        super.viewDidLoad()
        /*
         getCurrentFoto() { [weak self] (galleryFoto) in
         self?.galleryFoto = galleryFoto
         self?.displayedPhoto.image = self?.galleryFoto[self?.currentIndex ?? 0].foto
         self?.setupView()
         }*/
        descriptionPhoto.isHidden = true
        
        getDataFromVK(findGroupsToName: nil ,typeOfContent: .getPhotoAlbumCurrentFriend) { [weak self] (cellPresenters,theCap) in
            
            self?.cellPresenters = cellPresenters
            
            let dispatchGroup = DispatchGroup()
            for cellPresenter in cellPresenters {
                dispatchGroup.enter()
                cellPresenter.downloadImage(completion: {
                    dispatchGroup.leave()
                })
            }
            
            dispatchGroup.notify(queue: DispatchQueue.main) {
                DispatchQueue.main.async {
                    
                    if cellPresenters.count > 0 {
                        let cellPresenter = cellPresenters[(self?.currentIndex)!]
                        if let image = cellPresenter.image {
                            self?.displayedPhoto.image = image
                        } else {
                            cellPresenter.downloadImage(completion: {})
                        }
                        
                        self?.setupView()
                    } else {
                            self?.descriptionPhoto.isHidden = false
                            self?.displayedPhoto.center.x *= 2
                            self?.nextPhoto.center.x *= 2
                            self?.previousPhoto.center.x *= 2
                    }
                        
                    }
                }
            }
        
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
        if currentIndex != cellPresenters.count - 1 {
            previousPhoto.image = nil
            
            
            nextPhoto.center.x += nextPhoto.frame.width
            
            nextPhoto.image = configure(currentIndex: currentIndex + 1)
            
            
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
                self.displayedPhoto.image = self.configure(currentIndex: self.currentIndex)
                
                self.displayedPhoto.transform = .identity
                self.displayedPhoto.center.x += 150
                
                
                self.nextPhoto.transform = .identity
                self.nextPhoto.image = nil
            })
        }
    }
    
    
    
    
    @objc func swippedRigth(_ gesture : UISwipeGestureRecognizer) {
        
        if currentIndex != 0 {
            nextPhoto.image = nil
            previousPhoto.image = self.configure(currentIndex: self.currentIndex - 1)
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
                    self.previousPhoto.center.x += self.previousPhoto.frame.width
                })
            }, completion: { _ in
                
                self.currentIndex -= 1
                self.displayedPhoto.image = self.configure(currentIndex: self.currentIndex)
                self.displayedPhoto.transform = .identity
                self.displayedPhoto.center.x -= 150
                self.previousPhoto.transform = .identity
                self.previousPhoto.image = nil
            })
        }
    }
    
    
}
extension FriendPhotoGalleryViewController {
    
    func configure (currentIndex: Int) -> UIImage {
        let cellPresenter = cellPresenters[currentIndex]
        var photo: UIImage? = nil
        if let image = cellPresenter.image {
            photo = image
        } else {
            cellPresenter.downloadImage(completion: {})
        }
        return photo!
        
    }
    
}
