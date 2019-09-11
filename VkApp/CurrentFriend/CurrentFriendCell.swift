//
//  CurrentFriendCell.swift
//  VkApp
//
//  Created by Anton Fomkin on 23/05/2019.
//  Copyright © 2019 Anton Fomkin. All rights reserved.
//

import UIKit

class CurrentFriendCell: UICollectionViewCell {
    
    static var reuseIdentifier = "CurrentFriendCell" 
    @IBOutlet weak var likeButton: LikeControl!
    @IBOutlet weak var countLike: UILabel!
    @IBOutlet weak var currentFriendFoto: UIImageView!
    
    override func awakeFromNib() {
        likeButton.addTarget(self, action: #selector(likeButtonDidTapped), for: .valueChanged)
    }
   
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        
        layer.cornerRadius = 25
        layer.borderWidth = 2
        layer.borderColor = UIColor.orange.cgColor
        layer.backgroundColor = UIColor.white.cgColor
        layer.masksToBounds = true
        
        currentFriendFoto.layer.cornerRadius = currentFriendFoto.layer.frame.width / 2 
        
        countLike.text = "0"
        countLike.textColor = .gray
    }
    // MARK: Изменяем состояние свойства контрола countLike, по уведомлению нажатия на сердечко
    @objc func likeButtonDidTapped() {
       
        if likeButton.isLiked {
                countLike.text = "1"
                countLike.textColor = .red
        }  else {
                countLike.text = "0"
                countLike.textColor = .gray
        }
    }
}

