//
//  NewsCell.swift
//  VkApp
//
//  Created by Anton Fomkin on 12/06/2019.
//  Copyright © 2019 Anton Fomkin. All rights reserved.
//

import UIKit
var newsRowHeight : CGFloat = 0.0

class NewsCell: UITableViewCell {
    
    static var reuseId: String = "NewsCell"
    var newsTextHeight : CGFloat? = nil
    var likeButtonHeight : CGFloat? = nil
    
    @IBOutlet weak var newsText: UILabel! {
        didSet {
            if (newsTextHeight == nil) && (likeButtonHeight != nil) {
                newsTextHeight = self.newsText.frame.height
                newsRowHeight = self.newsTextHeight! + self.likeButtonHeight! + UIScreen.main.bounds.width
            }
        }
    }
    
    @IBOutlet weak var newsFotoOne: UIImageView! {
        didSet {
            //   self.newsFotoOne.layer.borderColor = UIColor.red.cgColor
            //  self.newsFotoOne.layer.borderWidth = 2
        }
    }
    
    
    @IBOutlet weak var likeButton: LikeControl! {
        didSet {
            if likeButtonHeight == nil {
                likeButtonHeight = self.likeButton.frame.height
            }
        }
    }
    
    @IBOutlet weak var progressView: ProgressBar!
    @IBOutlet weak var countLike: UILabel!
    
    override func awakeFromNib() {
        likeButton.addTarget(self, action: #selector(likeButtonDidTapped), for: .valueChanged)
    }
    override func prepareForReuse() {
        super.prepareForReuse()
        newsText.text = nil
        newsFotoOne.image = nil
        
        likeButton.deselectLike()
        
        if likeButton.isLiked != true  {
            countLike?.text = "0"
            countLike.textColor = .gray
        }
    }
    
    override func layoutIfNeeded() {
        super.layoutIfNeeded()
        
        self.newsFotoOne.clipsToBounds = true
        self.newsFotoOne.layer.cornerRadius = 20
        self.progressView.updateProgressBar()
    }
    
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        if likeButton.isLiked != true {
            countLike.text = "0"
            countLike.textColor = .gray
            
        }
    }
    
    //MARK: Запуск анимации
    @objc func likeButtonDidTapped() {
        if likeButton.isLiked {
            
            UIView.transition(with: countLike,
                              duration: 1,
                              options: .transitionFlipFromLeft,
                              animations: {
                                self.countLike.text = "1"
            })
            countLike.textColor = .red
            
        }  else {
            
            UIView.transition(with: countLike,
                              duration: 1,
                              options: .transitionFlipFromRight,
                              animations: {
                                self.countLike.text = "0"
            })
            countLike.textColor = .gray
        }
        
    }
    
}
