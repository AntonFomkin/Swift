//
//  MyGroupController.swift
//  VkApp
//
//  Created by Anton Fomkin on 23/05/2019.
//  Copyright © 2019 Anton Fomkin. All rights reserved.
//

import UIKit
import RealmSwift

class RealmGroup: Object {
    @objc dynamic var name = ""
    @objc dynamic var foto : Data? = nil
}

class MyGroupController: UITableViewController {
    
    @IBOutlet weak var addButton: UIBarButtonItem!
    @IBOutlet weak var searchBar: UISearchBar!
    /*
     var groupList : [Group] = [
     Group(name: "Птицы", foto: UIImage(imageLiteralResourceName: "bird.png")),
     Group(name: "Бабочки", foto: UIImage(imageLiteralResourceName: "butterfly.png")),
     Group(name: "Рыбы", foto: UIImage(imageLiteralResourceName: "fish.png")),
     Group(name: "Жуки", foto: UIImage(imageLiteralResourceName: "ladybird.png"))
     ]
     */
    
    private var friendList : [UsersVK] = []
    private var groupList : [GroupVK] = []
    private var searchGroup : [GroupVK] = []
    private var searching = false
    var cellPresenters : [CellPresenter] = []
    
    private var token: NotificationToken?
    private var getData : Results<RealmGroup>? = nil
    
    private func getData(isSearhing: Bool, searchText: String?) {
        
        let typeOfContent: TypeOfRequest
        
        if isSearhing {
            typeOfContent = .getFindGroups
        } else {
            typeOfContent = .getGroups
        }
        
        getDataFromVK(idFriend: nil,findGroupsToName: searchText,typeOfContent: typeOfContent) { [weak self] (cellPresenters,theCap) in
            
            self?.cellPresenters = cellPresenters
            
            let dispatchGroup = DispatchGroup()
            for cellPresenter in cellPresenters {
                dispatchGroup.enter()
                /*
                 cellPresenter.downloadImage(completion: {
                 dispatchGroup.leave()
                 })
                 */
                let imageDownload = ImageDownloader(url: cellPresenter.imageURLString)
                imageDownload.getImage (completion: {
                    cellPresenter.image = imageDownload.image
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
    
    /* theCap - просто заглушка */
    override func viewDidLoad() {
        
        self.getData(isSearhing: false,searchText: nil)
        // MARK: - Читаем из Realm
        /*
         do {
         let realm = try Realm()
         /* Теперь TableView cвязан с Results, оставлю это как предыдущий вариант
         var getData = Array(realm.objects(RealmGroup.self))
         */
         getData = realm.objects(RealmGroup.self)
         
         self.token = getData?.observe {  (changes: RealmCollectionChange) in
         switch changes {
         
         case .initial:
         self.tableView.reloadData()
         
         case .update(_, let deletions, let insertions, let modifications):
         self.tableView.beginUpdates()
         self.tableView.insertRows(at: insertions.map({ IndexPath(row: $0, section: 0) }),
         with: .automatic)
         self.tableView.deleteRows(at: deletions.map({ IndexPath(row: $0, section: 0)}),
         with: .automatic)
         self.tableView.reloadRows(at: modifications.map({ IndexPath(row: $0, section: 0) }),
         with: .automatic)
         self.tableView.endUpdates()
         
         case .error(let error):
         print(error)
         }
         
         print("данные изменились")
         }
         
         /* Теперь TableView cвязан с Results, оставлю это как предыдущий вариант
         for value in Array(getData!) {
         let image = UIImage(data: value.foto!)
         groupList.append(GroupVK(name: value.name, foto: image! ))
         }
         */
         
         } catch {
         print(error)
         }
         /* Теперь TableView cвязан с Results, оставлю это как предыдущий вариант
         self.tableView.reloadData()
         */
         */
        
        
    }
    
    /*
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
     */
    
    // MARK: - Работаем с табличным представлением
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return cellPresenters.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "MyGroupCell", for: indexPath) as! MyGroupCell
        if searching {
            self.configure(cell: cell, at: indexPath)
            /*
             let group = searchGroup[indexPath.row].name
             let foto = searchGroup[indexPath.row].foto
             cell.groupName.text = group
             cell.groupFoto.avatarImage.image = foto
             */
        } else {
            /* Теперь TableView cвязан с Results, оставлю это как предыдущий вариант
             let group = groupList[indexPath.row].name
             let foto = groupList[indexPath.row].foto
             cell.groupName.text = group
             cell.groupFoto.avatarImage.image = foto
             */
            /*
             let image = UIImage(data: (getData?[indexPath.row].foto)!)
             cell.groupName?.text = getData?[indexPath.row].name ?? ""
             cell.groupFoto?.avatarImage.image = image!
             */
            
            self.configure(cell: cell, at: indexPath)
        }
        
        
        return cell
    }
    
    
    // MARK: Обработка удаления ячейки из табличного представления
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        
        if editingStyle == .delete {
            //  groupList.remove(at: indexPath.row)
            DispatchQueue.main.async {
                self.cellPresenters.remove(at: indexPath.row)
                tableView.beginUpdates()
                tableView.deleteRows(at: [indexPath], with: .fade)
                tableView.reloadData()
                tableView.endUpdates()
            }
        }
    }
    
    
    // MARK: - Navigation
    @IBAction func addGroup(segue: UIStoryboardSegue) {
        DispatchQueue.main.async {
            
            // Проверяем идентификатор перехода, чтобы убедиться, что это нужный
            if segue.identifier == "addGroup" {
                // Получаем ссылку на контроллер, с которого осуществлен переход
                guard let NewGroupController = segue.source as? NewGroupController else { return }
                // Получаем индекс выделенной ячейки
                if let indexPath = NewGroupController.tableView.indexPathForSelectedRow {
                    // Получаем город по индексу
                    let newGroupName = NewGroupController.cellPresentersAddGroup[indexPath.row].text
                    let newGroupFotoURL = NewGroupController.cellPresentersAddGroup[indexPath.row].imageURLString
                    // Проверяем, что такого города нет в списке
                    let newGroup = CellPresenter(idFriend: "", text: newGroupName,widthPhoto: 0, heightPhoto: 0, imageURLString: newGroupFotoURL, imageLargeURLString: nil)
                    // GroupVK(name: newGroupName, foto: newGroupFoto)
                    newGroup.image = NewGroupController.cellPresentersAddGroup[indexPath.row].image
                    
                    if !self.cellPresenters.contains(newGroup) {
                        self.cellPresenters.append(newGroup)
                        self.tableView.reloadData()
                    }
                    
                    /*
                     if !groupList.contains(newGroup) {
                     groupList.append(newGroup)
                     tableView.reloadData()
                     }
                     */
                }
            }
        }
    }
    
    
}

// MARK: Добавляем делегат UISearchBar в контроллер
extension MyGroupController: UISearchBarDelegate {
    
    func searchBar( _ searchBar : UISearchBar, textDidChange searchText : String) {
        /*
         searchGroup = groupList.filter({$0.name.lowercased().prefix(searchText.count) == searchText.lowercased()})
         searching = true
         tableView.reloadData()
         getFindGroups(findText: searchText)
         */
        //  searching = true
        //  addButton.isEnabled = false
        // self.getData(isSearhing: true,searchText: searchText)
        //  tableView.reloadData()
        if searchText != "" {
            self.searchContext(isSearh: true, searchText: searchText)
        } else {
            self.searchContext(isSearh: false, searchText: nil)
        }
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        if searchBar.text != "" {
            self.searchContext(isSearh: false, searchText: nil)
            searchBar.text = ""
        }
    }
}

extension MyGroupController {
    
    func searchContext(isSearh: Bool, searchText: String?) {
        
        searching = isSearh
        addButton.isEnabled = !isSearh
        self.getData(isSearhing: isSearh,searchText: searchText)
    }
    
    private func configure(cell: MyGroupCell, at indexPath: IndexPath) {
        
        let cellPresenter = self.cellPresenters[indexPath.row]
        cell.groupName?.text =  self.cellPresenters[indexPath.row].text
        
        cellPresenter.cell = cell
        
        if let image = cellPresenter.image {
            cell.groupFoto.avatarImage?.image = image
        } else {
            let imageDownload = ImageDownloader(url: cellPresenter.imageURLString)
            imageDownload.getImage (completion: {
                cellPresenter.image = imageDownload.image
            })
        }
    }
}
