//
//  MyGroupCell.swift
//  VkApp
//
//  Created by Anton Fomkin on 23/05/2019.
//  Copyright © 2019 Anton Fomkin. All rights reserved.
//

import UIKit

class MyGroupCell: UITableViewCell {

    static var reuseIdentifier = "MyGroupCell"    
    @IBOutlet weak var groupName: UILabel!
    @IBOutlet weak var groupFoto: AvatarImage!
    
    override func prepareForReuse() {
        groupFoto.avatarImage.image = nil
        groupName.text = nil
    }
}
