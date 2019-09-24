//
//  CustomCollectionViewCurrentFriend.swift
//  VkApp
//
//  Created by Anton Fomkin on 19/06/2019.
//  Copyright © 2019 Anton Fomkin. All rights reserved.
//

import UIKit

final class CustomCollectionViewCurrentFriend: UICollectionView {

    private var redraw : Bool = false {
        didSet {
            setNeedsDisplay()
        }
    }
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        DispatchQueue.main.async {
            let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
            layout.itemSize = CGSize(width: 250, height: 250)
          
            layout.sectionInset = UIEdgeInsets(top: 20, left: (self.frame.width / 2) - (layout.itemSize.width / 2) , bottom: 0, right: (self.frame.width / 2) - (layout.itemSize.width / 2))

            layout.minimumInteritemSpacing = 0
            layout.minimumLineSpacing = 0
            self.collectionViewLayout = layout
            self.redraw.toggle()
        }
    }
}
