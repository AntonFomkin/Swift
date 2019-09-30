//
//  FriendPhotoGalleryViewController.swift
//  VkApp
//
//  Created by Anton Fomkin on 19/06/2019.
//  Copyright © 2019 Anton Fomkin. All rights reserved.
//

import UIKit

final class FriendPhotoGalleryViewController: UIViewController {
    
    
    @IBOutlet weak var descriptionPhoto: UILabel!
    @IBOutlet weak var displayedPhoto: UIImageView!
    @IBOutlet weak var previousPhoto: UIImageView!
    @IBOutlet weak var nextPhoto: UIImageView!
    private var currentIndex : Int = 0
  
    var cellPresenters : [CellPresenter] = []

    var idFriend: String? = nil
    
    override func viewDidLoad () {
        super.viewDidLoad()
        
        descriptionPhoto.isHidden = true
        
        getDataFromVK(idFriend: idFriend,findGroupsToName: nil ,typeOfContent: .getPhotoAlbumCurrentFriend) { [weak self] (cellPresenters,theCap) in
            
            self?.cellPresenters = cellPresenters
            
            let dispatchGroup = DispatchGroup()
            for cellPresenter in cellPresenters {
                dispatchGroup.enter()
               /*
                cellPresenter.downloadImage(completion: {
                    dispatchGroup.leave()
                })
                */
                let imageDownload = ImageDownloader(url: cellPresenter.imageURLString)
                imageDownload.getImage (completion: {
                    cellPresenter.image = imageDownload.image
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
                            //cellPresenter.downloadImage(completion: {})
                            let imageDownload = ImageDownloader(url: cellPresenter.imageURLString)
                            imageDownload.getImage (completion: {
                                cellPresenter.image = imageDownload.image
                            })
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
      
    private func setupView() {
        DispatchQueue.main.async {
 
            let leftSwipe = UISwipeGestureRecognizer(target : self, action : #selector (self.swippedLeft( _:)))
            leftSwipe.direction = .left
            self.displayedPhoto.addGestureRecognizer(leftSwipe)
            
            let rigthSwipe = UISwipeGestureRecognizer(target : self, action : #selector (self.swippedRigth( _:)))
            rigthSwipe.direction = .right
            self.displayedPhoto.addGestureRecognizer(rigthSwipe)
            
            self.displayedPhoto.isUserInteractionEnabled = true
        }
        
    }
    // MARK: Обработчики жестов Swipe
    @objc private func swippedLeft(_ gesture : UISwipeGestureRecognizer) {
        DispatchQueue.main.async { [weak self] in
            
            if  self?.currentIndex != (self?.cellPresenters.count)! - 1 {
                self?.previousPhoto.image = nil
                self?.nextPhoto.center.x += (self?.nextPhoto.frame.width)!
                self?.nextPhoto.image = self?.configure(currentIndex: self!.currentIndex + 1)
                
                
                UIView.animateKeyframes(withDuration: 1, delay: 0, options: [], animations : {
                    
                    UIView.addKeyframe(withRelativeStartTime: 0 , relativeDuration: 1, animations: {
                        self?.displayedPhoto.transform = CGAffineTransform(scaleX : 0.001 , y: 0.001)
                    })
                    
                    UIView.addKeyframe(withRelativeStartTime: 0, relativeDuration: 1,  animations : {
                        self?.displayedPhoto.center.x -= 150
                    })
                    
                    UIView.addKeyframe(withRelativeStartTime: 0, relativeDuration: 1,  animations : {
                        self?.nextPhoto.transform = CGAffineTransform(scaleX : 1 , y: 1)
                    })
                    
                    UIView.addKeyframe(withRelativeStartTime: 0, relativeDuration: 1, animations : {
                        self?.nextPhoto.center.x -= (self?.nextPhoto.frame.width)!
                    })
                    
                }, completion: { _ in
                    
                    self?.currentIndex += 1
                    self?.displayedPhoto.image = self?.configure(currentIndex: self!.currentIndex)
                    self?.displayedPhoto.transform = .identity
                    self?.displayedPhoto.center.x += 150
                    self?.nextPhoto.transform = .identity
                    self?.nextPhoto.image = nil
                })
            }
        }
    }
    
    
    
    
    @objc private func swippedRigth(_ gesture : UISwipeGestureRecognizer) {
        DispatchQueue.main.async { [weak self] in
            
            if  self?.currentIndex != 0 {
                self?.nextPhoto.image = nil
                self?.previousPhoto.image = self?.configure(currentIndex: self!.currentIndex - 1)
                self?.previousPhoto.center.x -= (self?.previousPhoto.frame.width)!
                
                UIView.animateKeyframes(withDuration: 1, delay: 0, options: [], animations : {
                    
                    UIView.addKeyframe(withRelativeStartTime: 0 , relativeDuration: 1, animations: {
                        self?.displayedPhoto.transform = CGAffineTransform(scaleX : 0.001 , y: 0.001)
                    })
                    UIView.addKeyframe(withRelativeStartTime: 0, relativeDuration: 1,  animations : {
                        self?.displayedPhoto.center.x += 150
                    })
                    UIView.addKeyframe(withRelativeStartTime: 0, relativeDuration: 1,  animations : {
                        self?.previousPhoto.transform = CGAffineTransform(scaleX : 1 , y: 1)
                    })
                    UIView.addKeyframe(withRelativeStartTime: 0, relativeDuration: 1, animations : {
                        self?.previousPhoto.center.x += (self?.previousPhoto.frame.width)!
                    })
                }, completion: { _ in
                    
                    self?.currentIndex -= 1
                    self?.displayedPhoto.image = self?.configure(currentIndex: self!.currentIndex)
                    self?.displayedPhoto.transform = .identity
                    self?.displayedPhoto.center.x -= 150
                    self?.previousPhoto.transform = .identity
                    self?.previousPhoto.image = nil
                })
            }
        }
    }
}

extension FriendPhotoGalleryViewController {
    
    private func configure (currentIndex: Int) -> UIImage {
        let cellPresenter = cellPresenters[currentIndex]
        var photo: UIImage? = nil
        if let image = cellPresenter.image {
            photo = image
        } else {
            let imageDownload = ImageDownloader(url: cellPresenter.imageURLString)
            imageDownload.getImage (completion: {
            cellPresenter.image = imageDownload.image
            })
        }
        return photo!
        
    }
    
}
