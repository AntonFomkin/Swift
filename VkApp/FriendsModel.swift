//
//  friendsModel.swift
//  VkApp
//
//  Created by Anton Fomkin on 22/05/2019.
//  Copyright © 2019 Anton Fomkin. All rights reserved.
//

import UIKit

struct User {
    
    private var name : String
    private var foto : UIImage
}


final class UsersVK {
    
    var name : String
    var foto : UIImage?
    
    init(name : String, foto : UIImage?) {
        self.name = name
        self.foto = foto
    }
}
