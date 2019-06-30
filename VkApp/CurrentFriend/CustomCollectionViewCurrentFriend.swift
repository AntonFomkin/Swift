//
//  CustomCollectionViewCurrentFriend.swift
//  VkApp
//
//  Created by Anton Fomkin on 19/06/2019.
//  Copyright © 2019 Anton Fomkin. All rights reserved.
//

import UIKit

class CustomCollectionViewCurrentFriend: UICollectionView {

    var redraw : Bool = false {
        didSet {
            setNeedsDisplay()
        }
    }
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: 150, height: 150)
        layout.sectionInset = UIEdgeInsets(top: 20, left: (self.frame.width / 2) - (layout.itemSize.width / 2) , bottom: 0, right: (self.frame.width / 2) - (layout.itemSize.width / 2))
        layout.minimumInteritemSpacing = 0
        layout.minimumLineSpacing = 0
        collectionViewLayout = layout
        
        redraw.toggle()
    }
}
