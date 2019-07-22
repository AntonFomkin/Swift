//
//  HeaderCellSectionTableView.swift
//  VkApp
//
//  Created by Anton Fomkin on 09/06/2019.
//  Copyright © 2019 Anton Fomkin. All rights reserved.
//

import UIKit

class HeaderCellSectionTableView: UITableViewHeaderFooterView {

    static var reuseId: String = "HeaderCell"
    @IBOutlet weak var nameLetter: UILabel!
    
    override func prepareForReuse() {
        super.prepareForReuse()
        nameLetter.text? = ""
    }    
}


