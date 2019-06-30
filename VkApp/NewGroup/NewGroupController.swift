//
//  NewGroupController.swift
//  VkApp
//
//  Created by Anton Fomkin on 23/05/2019.
//  Copyright © 2019 Anton Fomkin. All rights reserved.
//

import UIKit

class NewGroupController: UITableViewController {

    var newGroupList : [Group] = [
        Group(name: "Львы", foto: UIImage(imageLiteralResourceName: "lion.png")),
        Group(name: "Кролики", foto: UIImage(imageLiteralResourceName: "rabbit.png")),
        Group(name: "Черепахи", foto: UIImage(imageLiteralResourceName: "turtle.png"))
    ]
    
    // MARK: Работаем с табличным представлением
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return newGroupList.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let cell = tableView.dequeueReusableCell(withIdentifier:
        "NewGroupCell", for: indexPath) as! NewGroupCell
        
        let group = newGroupList[indexPath.row].name
        let foto = newGroupList[indexPath.row].foto
        cell.newGroupName.text = group
        cell.newGroupFoto.avatarImage.image = foto
   
        return cell
    }
  
}
