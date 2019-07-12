//
//  GroupModel.swift
//  VkApp
//
//  Created by Anton Fomkin on 19/06/2019.
//  Copyright © 2019 Anton Fomkin. All rights reserved.
//

import UIKit

struct Group : Equatable {
  
    static func == (lhs: Group, rhs: Group ) -> Bool {
        return lhs.name == rhs.name
    }
    
    var name : String
    var foto : UIImage
}

class GroupVK : Equatable {
    static func == (lhs: GroupVK, rhs: GroupVK) -> Bool {
        return lhs.name == rhs.name
    }
    
    var name : String
    var foto : UIImage
    init(name : String, foto : UIImage) {
        self.name = name
        self.foto = foto
    }
}
