//
//  AllFriendsViewController.swift
//  VkApp
//
//  Created by Anton Fomkin on 01/06/2019.
//  Copyright © 2019 Anton Fomkin. All rights reserved.
//

import UIKit

var selectedItem : Int = 0
/*
    var friendList : [User] = [
        User(name: "Маша Пронина", foto: UIImage(imageLiteralResourceName: "women1.png")),
        User(name: "Петя Синицын", foto: UIImage(imageLiteralResourceName: "man1.png")),
        User(name: "Коля Обломов", foto: UIImage(imageLiteralResourceName: "man2.png")),
        User(name: "Зина Иванова", foto: UIImage(imageLiteralResourceName: "women2.png")),
        User(name: "Ольга Паранина", foto: UIImage(imageLiteralResourceName: "women2.png")),
        User(name: "Маша Антонова", foto: UIImage(imageLiteralResourceName: "women1.png")),
        User(name: "Петя Горшков", foto: UIImage(imageLiteralResourceName: "man1.png")),
        User(name: "Коля Денисов", foto: UIImage(imageLiteralResourceName: "man2.png")),
        User(name: "Зина Козлова", foto: UIImage(imageLiteralResourceName: "women2.png")),
        User(name: "Ольга Елкина", foto: UIImage(imageLiteralResourceName: "women2.png"))
    ].sorted(by: { $0.name[ $0.name.index(after: $0.name.firstIndex(of: " ")!)] < $1.name [$1.name.index(after: $1.name.firstIndex(of: " ")!)] } )
*/


//let friendList = requestVKUser().sorted(by: { $0.name[ $0.name.index(after: $0.name.firstIndex(of: " ")!)] < $1.name [$1.name.index(after: $1.name.firstIndex(of: " ")!)] } )

var friendListTwo : [UsersVK] = []
var arrayFirstLetters : [Character?] = []
var selectTableView : UITableView! = nil
var myIndexPath : IndexPath = IndexPath.init(row: 0, section: 0)


class AllFriendsViewController: UIViewController {
  
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var lettersPicker: LettersPicker!
    @IBOutlet weak var searchBar: UISearchBar!
    
    var friendList : [UsersVK] = []
    var searchUser : [UsersVK] = []
    var searching = false
    
  
override func viewDidLoad() {
    super.viewDidLoad()

        // MARK: Подгружаем прототип ячейки
        tableView.register(UINib(nibName: "HeaderCell", bundle: nil), forHeaderFooterViewReuseIdentifier:  HeaderCellSectionTableView.reuseId)
        
        getFriends() { [weak self] (friendList) in
            
            self?.friendList = friendList.sorted(by: { $0.name[ $0.name.index(after: $0.name.firstIndex(of: " ")!)] < $1.name [$1.name.index(after: $1.name.firstIndex(of: " ")!)] } )
            
            friendListTwo = self!.friendList
            arrayFirstLetters = []
            self?.lettersPicker.setupView(isSearch: false)
            self?.tableView?.reloadData()
        }
}
    
   
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        let destinationVC = segue.destination as! CurrentFriendController
        let friendListForCurrentSection = friendList.filter({$0.name[ $0.name.index(after: $0.name.firstIndex(of: " ")!)] == arrayFirstLetters[myIndexPath.section]!})
    
        destinationVC.currentFoto  = friendListForCurrentSection[myIndexPath.row].foto
        destinationVC.title = friendListForCurrentSection[myIndexPath.row].name
      
    }
}

extension AllFriendsViewController: UITableViewDataSource {

    // MARK: Работаем с табличным представлением
    private func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 120
    }
   
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {

        let headerCell = tableView.dequeueReusableHeaderFooterView(withIdentifier: HeaderCellSectionTableView.reuseId) as! HeaderCellSectionTableView
        headerCell.nameLetter.text = String(arrayFirstLetters[section]!)
        
        return headerCell
    }
    
     func numberOfSections(in tableView: UITableView) -> Int {
    
        selectTableView = tableView
        return arrayFirstLetters.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        if searching {
            return searchUser.filter({$0.name[ $0.name.index(after: $0.name.firstIndex(of: " ")!)] == arrayFirstLetters[section]!}).count
        } else {
            return friendList.filter({$0.name[ $0.name.index(after: $0.name.firstIndex(of: " ")!)] == arrayFirstLetters[section]!}).count
        }
    }
    
    
     func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
       
        let cell = tableView.dequeueReusableCell(withIdentifier: "AllFriendsCell", for: indexPath) as! AllFriendsCell

        if searching {
  
            let friendListForCurrentSection = searchUser.filter({$0.name[ $0.name.index(after: $0.name.firstIndex(of: " ")!)] == arrayFirstLetters[indexPath.section]!})
            let friend = friendListForCurrentSection[indexPath.row].name
            let foto = friendListForCurrentSection[indexPath.row].foto
            cell.friendName.text = friend
            cell.friendFoto.avatarImage.image = foto
        
        } else {
            
            let friendListForCurrentSection = friendList.filter({$0.name[ $0.name.index(after: $0.name.firstIndex(of: " ")!)] == arrayFirstLetters[indexPath.section]!})
            let friend = friendListForCurrentSection[indexPath.row].name
            let foto = friendListForCurrentSection[indexPath.row].foto
            cell.friendName.text = friend
            cell.friendFoto.avatarImage.image = foto
        }

        myIndexPath = indexPath
        return cell
    }
}

extension AllFriendsViewController: UITableViewDelegate {
   
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
            myIndexPath = indexPath
            performSegue(withIdentifier: "gotoCurrentFriend", sender: nil)
    }
}

extension AllFriendsViewController: UISearchBarDelegate {
   
    func searchBar( _ searchBar : UISearchBar, textDidChange searchText : String) {
        
        searchUser = friendList.filter({$0.name.lowercased().prefix(searchText.count) == searchText.lowercased()})
        arrayFirstLetters = []
       
        for (_,values) in searchUser.enumerated() {
            for (index,value) in values.name.enumerated() {
              
                if value == " " {
                    if !arrayFirstLetters.contains(values.name[values.name.index(values.name.startIndex, offsetBy: index+1)]) {
                        arrayFirstLetters.append(values.name[values.name.index(values.name.startIndex, offsetBy: index+1)])
                        break
                    }
                }
            }
        }
        
            searching = true
            lettersPicker.setupView(isSearch: true)
            tableView.reloadData()
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
   
        searching = false
        searchBar.text = ""
        arrayFirstLetters = []
        lettersPicker.setupView(isSearch: false)
        tableView.reloadData()
    }
}

