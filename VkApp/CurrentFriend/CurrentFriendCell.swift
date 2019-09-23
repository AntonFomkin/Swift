//
//  CurrentFriendCell.swift
//  VkApp
//
//  Created by Anton Fomkin on 23/05/2019.
//  Copyright © 2019 Anton Fomkin. All rights reserved.
//

import UIKit

final class CurrentFriendCell: UICollectionViewCell {
    
    static var reuseIdentifier = "CurrentFriendCell" 
    @IBOutlet weak var likeButton: LikeControl!
    @IBOutlet weak var countLike: UILabel!
    @IBOutlet weak var currentFriendFoto: UIImageView!
    
    override func awakeFromNib() {
        likeButton.addTarget(self, action: #selector(likeButtonDidTapped), for: .valueChanged)
    }
    
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        DispatchQueue.main.async {
            self.layer.cornerRadius = 25
            self.layer.borderWidth = 2
            self.layer.borderColor = UIColor.orange.cgColor
            self.layer.backgroundColor = UIColor.white.cgColor
            self.layer.masksToBounds = true
            
            self.currentFriendFoto.layer.cornerRadius = self.currentFriendFoto.layer.frame.width / 2
            
            self.countLike.text = "0"
            self.countLike.textColor = .gray
        }
    }
    // MARK: Изменяем состояние свойства контрола countLike, по уведомлению нажатия на сердечко
    @objc private func likeButtonDidTapped() {
        DispatchQueue.main.async {
            
            if self.likeButton.isLiked {
                self.countLike.text = "1"
                self.countLike.textColor = .red
            }  else {
                self.countLike.text = "0"
                self.countLike.textColor = .gray
            }
        }
    }
}

