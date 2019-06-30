//
//  CurrentFriendController.swift
//  VkApp
//
//  Created by Anton Fomkin on 23/05/2019.
//  Copyright © 2019 Anton Fomkin. All rights reserved.
//

import UIKit


class CurrentFriendController: UICollectionViewController {
   
    var currentFoto: UIImage!
    
    // MARK: Работаем с табличным представлением
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }

    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 1
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {

        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CurrentFriendCell", for: indexPath) as! CurrentFriendCell
        cell.currentFriendFoto.image = currentFoto

        return cell
    }

}

