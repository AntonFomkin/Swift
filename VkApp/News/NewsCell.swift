//
//  NewsCell.swift
//  VkApp
//
//  Created by Anton Fomkin on 12/06/2019.
//  Copyright © 2019 Anton Fomkin. All rights reserved.
//

import UIKit



final class NewsCell: UITableViewCell {
    
    static var reuseId: String = "NewsCell"
    private var newsTextHeight : CGFloat? = nil
    private var likeButtonHeight : CGFloat? = nil
    var newsRowHeight : CGFloat = 0.0
    
    @IBOutlet weak var newsText: UILabel! {
        didSet {
            if (self.newsTextHeight == nil) && (self.likeButtonHeight != nil) {
                self.newsTextHeight = self.newsText.frame.height
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
        
        self.newsText.text = nil
        self.newsFotoOne.image = nil
        
        self.likeButton.deselectLike()
        
        if self.likeButton.isLiked != true  {
            self.countLike?.text = "0"
            self.countLike?.textColor = .gray
            
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
    @objc private func likeButtonDidTapped() {
        
        DispatchQueue.main.async { [weak self] in
            
            if (self?.likeButton.isLiked)! {
                
                UIView.transition(with: self!.countLike,
                                  duration: 1,
                                  options: .transitionFlipFromLeft,
                                  animations: {
                                    self?.countLike.text = "1"
                })
                self?.countLike.textColor = .red
                
            }  else {
                
                UIView.transition(with: self!.countLike,
                                  duration: 1,
                                  options: .transitionFlipFromRight,
                                  animations: {
                                    self?.countLike.text = "0"
                })
                self?.countLike.textColor = .gray
            }
        }
    }
    
}
