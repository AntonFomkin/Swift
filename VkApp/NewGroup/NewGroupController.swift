//
//  NewGroupController.swift
//  VkApp
//
//  Created by Anton Fomkin on 23/05/2019.
//  Copyright © 2019 Anton Fomkin. All rights reserved.
//

import UIKit

class NewGroupController: UITableViewController {
    
    var cellPresentersAddGroup : [CellPresenter] = []
   /*
    var newGroupList : [GroupVK] = [
        GroupVK(name: "Львы", foto: UIImage(imageLiteralResourceName: "lion.png")),
        GroupVK(name: "Кролики", foto: UIImage(imageLiteralResourceName: "rabbit.png")),
        GroupVK(name: "Черепахи", foto: UIImage(imageLiteralResourceName: "turtle.png"))
    ]
    */
    override func viewDidLoad() {
        
        getDataFromVK(findGroupsToName: nil,typeOfContent: .getSwiftGroup) { [weak self] (cellPresenters,theCap) in
            
            self?.cellPresentersAddGroup = cellPresenters
            
            let dispatchGroup = DispatchGroup()
            for cellPresenter in cellPresenters{
                dispatchGroup.enter()
                cellPresenter.downloadImage(completion: {
                    dispatchGroup.leave()
                })
            }
            
            dispatchGroup.notify(queue: DispatchQueue.main) {
                DispatchQueue.main.async {
                    self?.tableView?.reloadData()
                }
            }
            
        }
    }
    
    // MARK: Работаем с табличным представлением
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.cellPresentersAddGroup.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier:
            "NewGroupCell", for: indexPath) as! NewGroupCell
        /*
         let group = newGroupList[indexPath.row].name
         let foto = newGroupList[indexPath.row].foto
         cell.newGroupName.text = group
         cell.newGroupFoto.avatarImage.image = foto
         */
        self.configure(cell: cell, at: indexPath)
        return cell
    }
    
}

extension NewGroupController {
    
    func configure(cell: NewGroupCell, at indexPath: IndexPath) {
        
        let cellPresenter = self.cellPresentersAddGroup[indexPath.row]
        cell.newGroupName?.text =  self.cellPresentersAddGroup[indexPath.row].text
        
        cellPresenter.cell = cell
        
        if let image = cellPresenter.image {
            cell.newGroupFoto?.avatarImage.image = image
        } else {
            cellPresenter.downloadImage(completion: {})
        }
        
    }
    
}
