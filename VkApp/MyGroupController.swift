//
//  MyGroupController.swift
//  VkApp
//
//  Created by Anton Fomkin on 23/05/2019.
//  Copyright © 2019 Anton Fomkin. All rights reserved.
//

import UIKit

class MyGroupController: UITableViewController {

    @IBOutlet weak var searchBar: UISearchBar!
 /*
    var groupList : [Group] = [
        Group(name: "Птицы", foto: UIImage(imageLiteralResourceName: "bird.png")),
        Group(name: "Бабочки", foto: UIImage(imageLiteralResourceName: "butterfly.png")),
        Group(name: "Рыбы", foto: UIImage(imageLiteralResourceName: "fish.png")),
        Group(name: "Жуки", foto: UIImage(imageLiteralResourceName: "ladybird.png"))
    ]
  */
 
    var friendList : [UsersVK] = []
    var groupList : [GroupVK] = []
    var searchGroup : [GroupVK] = []
    var searching = false
    
   
    override func viewDidLoad() {

        getGroups() { [weak self] (groupList) in
            self?.groupList = groupList
            self?.tableView?.reloadData()
        } 
    }
  
    func getFindGroups(findText:String) {
        
        let auth = Session.instance
        let configuration = URLSessionConfiguration.default
        let session =  URLSession(configuration: configuration)
        
        var urlComponents = URLComponents()
        urlComponents.scheme = "https"
        urlComponents.host = "api.vk.com"
        urlComponents.path = "/method/groups.search"
        urlComponents.queryItems = [
            URLQueryItem(name: "user_id", value: auth.userId),
            URLQueryItem(name: "access_token", value: auth.token),
            URLQueryItem(name: "q", value: findText),
            URLQueryItem(name: "v", value: "5.100")
        ]
        
        var request = URLRequest(url: urlComponents.url!)
        
        request.httpMethod = "GET"
        let task = session.dataTask(with: request) { (data, response, error) in
            
            let json = try? JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions.allowFragments)
            print("FindGroupJSON = \(json!)")
        }
        
        task.resume()
    }
    
    
    // MARK: - Работаем с табличным представлением
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
       
        if searching {
            return searchGroup.count
        } else {
            return groupList.count
        }
    }
  
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
       
        let cell = tableView.dequeueReusableCell(withIdentifier: "MyGroupCell", for: indexPath) as! MyGroupCell
        if searching {
            let group = searchGroup[indexPath.row].name
            let foto = searchGroup[indexPath.row].foto
            cell.groupName.text = group
            cell.groupFoto.avatarImage.image = foto
        } else {
            let group = groupList[indexPath.row].name
            let foto = groupList[indexPath.row].foto
            cell.groupName.text = group
            cell.groupFoto.avatarImage.image = foto
        }

        return cell
    }
    
    // MARK: Обработка удаления ячейки из табличного представления
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {

        if editingStyle == .delete {
            groupList.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }
    
    
    // MARK: - Navigation
    @IBAction func addGroup(segue: UIStoryboardSegue) {
     
        // Проверяем идентификатор перехода, чтобы убедиться, что это нужный
        if segue.identifier == "addGroup" {
            // Получаем ссылку на контроллер, с которого осуществлен переход
                guard let NewGroupController = segue.source as? NewGroupController else { return }
            // Получаем индекс выделенной ячейки
                if let indexPath = NewGroupController.tableView.indexPathForSelectedRow {
                        // Получаем город по индексу
                        let newGroupName = NewGroupController.newGroupList[indexPath.row].name
                        let newGroupFoto = NewGroupController.newGroupList[indexPath.row].foto
                        // Проверяем, что такого города нет в списке
                        let newGroup = GroupVK(name: newGroupName, foto: newGroupFoto)
                    
                            if !groupList.contains(newGroup) {
                                groupList.append(newGroup)
                                tableView.reloadData()
                            }
                }
        }
    }

    
}

// MARK: Добавляем делегат UISearchBar в контроллер
extension MyGroupController: UISearchBarDelegate {
    
    func searchBar( _ searchBar : UISearchBar, textDidChange searchText : String) {
        
        searchGroup = groupList.filter({$0.name.lowercased().prefix(searchText.count) == searchText.lowercased()})
        searching = true
        tableView.reloadData()
        getFindGroups(findText: searchText)
        
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
     
        searching = false
        searchBar.text = ""
        tableView.reloadData()
    }
}
