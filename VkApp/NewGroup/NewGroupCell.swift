//
//  NewGroupCell.swift
//  VkApp
//
//  Created by Anton Fomkin on 23/05/2019.
//  Copyright © 2019 Anton Fomkin. All rights reserved.
//

import UIKit

final class NewGroupCell: UITableViewCell {

    static var reuseIdentifier = "NewGroupCell"
  
    @IBOutlet weak var newGroupFoto: AvatarImage!
    
    @IBOutlet weak var newGroupName: UILabel!
    
    override func prepareForReuse() {
        newGroupFoto.avatarImage.image = nil
        newGroupName.text = nil
    }
}
