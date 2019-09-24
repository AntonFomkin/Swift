//
//  AllFriendsCell.swift
//  VkApp
//
//  Created by Anton Fomkin on 22/05/2019.
//  Copyright © 2019 Anton Fomkin. All rights reserved.
//

import UIKit

final class AllFriendsCell: UITableViewCell {
    
    static var reuseIdentifier = "AllFriendsCell"
    @IBOutlet weak var friendName: UILabel!
    @IBOutlet weak var friendFoto: AvatarImage!
    
    override func prepareForReuse() {
        friendFoto.avatarImage.image = nil
        friendName.text = nil
    }
}
