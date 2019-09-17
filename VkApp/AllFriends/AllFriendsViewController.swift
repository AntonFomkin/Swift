//
//  AllFriendsViewController.swift
//  VkApp
//
//  Created by Anton Fomkin on 01/06/2019.
//  Copyright © 2019 Anton Fomkin. All rights reserved.
//

import UIKit
import RealmSwift

class RealmFriends: Object {
    @objc dynamic var name = ""
    @objc dynamic var foto : Data? = nil
}

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
var myIndexPath : IndexPath = IndexPath.init(row: 0, section: 0)

class AllFriendsViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var lettersPicker: LettersPicker!
    @IBOutlet weak var searchBar: UISearchBar!
    
    var friendList : [UsersVK] = []
    //   var searchUser : [UsersVK] = []
    lazy var searchUser: [CellPresenter] = []
    var searching = false
    var cellPresenters : [CellPresenter] = []
    var token: NotificationToken?
    var getData : Results<RealmFriends>? = nil
    lazy var currentPhotoFriend: UIImage? = nil
    lazy var currentNameFriend: String? = nil
    lazy var idFriend: String? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // MARK: Подгружаем прототип ячейки
        tableView.register(UINib(nibName: "HeaderCell", bundle: nil), forHeaderFooterViewReuseIdentifier:  HeaderCellSectionTableView.reuseId)
        
        getDataFromVK(idFriend: nil,findGroupsToName: nil,typeOfContent: .getFriends) { [weak self] (cellPresenters,friendList) in
            
            self?.cellPresenters = cellPresenters
            self?.friendList = friendList
            
            self?.friendList = friendList.sorted(by: { $0.name[ $0.name.index(after: $0.name.firstIndex(of: " ")!)] < $1.name [$1.name.index(after: $1.name.firstIndex(of: " ")!)] } )
            
            self?.cellPresenters = cellPresenters.sorted(by: { $0.text[ $0.text.index(after: $0.text.firstIndex(of: " ")!)] < $1.text [$1.text.index(after: $1.text.firstIndex(of: " ")!)] } )
            
            friendListTwo = self!.friendList
            arrayFirstLetters = []
            self?.lettersPicker.setupView(isSearch: false)
            
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
                })
                
                let imageDownloadLargePhoto = ImageDownloader(url: cellPresenter.imageLargeURLString!)
                imageDownloadLargePhoto.getImage (completion: {
                    cellPresenter.imageLarge = imageDownloadLargePhoto.image
                    dispatchGroup.leave()
                })
            }
            
            dispatchGroup.notify(queue: DispatchQueue.main) {
                DispatchQueue.main.async {
                    self?.tableView?.reloadData()
                }
            }
            
        }
        /*
         // MARK: - Читаем из Realm
         do {
         let realm = try Realm()
         getData = realm.objects(RealmFriends.self)
         
         for value in Array(getData!) {
         let image = UIImage(data: value.foto!)
         friendList.append(UsersVK(name: value.name, foto: image! ))
         }
         
         
         /*
         self.token = getData?.observe {  (changes: RealmCollectionChange) in
         switch changes {
         
         case .initial:
         self.friendList = self.friendList.sorted(by: { $0.name[ $0.name.index(after: $0.name.firstIndex(of: " ")!)] < $1.name [$1.name.index(after: $1.name.firstIndex(of: " ")!)] } )
         friendListTwo = self.friendList
         arrayFirstLetters = []
         self.lettersPicker.setupView(isSearch: false)
         self.tableView.reloadData()
         
         case .update(_, let deletions, let insertions, let modifications):
         print("No Ok")
         /*
         self.tableView.beginUpdates()
         self.tableView.insertRows(at: insertions.map({ IndexPath(row: $0, section: 0) }),
         with: .automatic)
         self.tableView.deleteRows(at: deletions.map({ IndexPath(row: $0, section: 0)}),
         with: .automatic)
         self.tableView.reloadRows(at: modifications.map({ IndexPath(row: $0, section: 0) }),
         with: .automatic)
         
         /*
         Здесь, вероятно, нужно оформить что то подобное
         
         let section = IndexSet(0...arrayFirstLetters.count)
         self.tableView.reloadSections(section, with: .automatic)
         
         но у меня не получилось - соответственно сразу вопрос преподавателю - как ?
         */
         
         
         self.tableView.endUpdates()
         */
         case .error(let error):
         print(error)
         }
         print("данные изменились")
         }
         */
         } catch {
         print(error)
         }
         */
    }
    
    
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        let destinationVC = segue.destination as! CurrentFriendController
        destinationVC.currentFoto  = currentPhotoFriend
        destinationVC.title = currentNameFriend
        destinationVC.idFriend = idFriend
    }
    
    // MARK: - Отслеживаем ориентацию устройства
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        
        debugPrint("viewWillTransition to \(size) with \(coordinator)")
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
        headerCell.backgroundColor = UIColor.white
        headerCell.nameLetter.textColor = UIColor(red: 29.0, green: 40.0, blue: 161.0, alpha: 1.0)
        return headerCell
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return arrayFirstLetters.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    
        if searching {
            return self.searchUser.filter({$0.text[$0.text.index(after: $0.text.firstIndex(of: " ")!)] == arrayFirstLetters[section]!}).count
        } else {
            return self.friendList.filter({$0.name[ $0.name.index(after: $0.name.firstIndex(of: " ")!)] == arrayFirstLetters[section]!}).count
        }
    }
       
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "AllFriendsCell", for: indexPath) as! AllFriendsCell
        
        if searching {
            DispatchQueue.global().async {
                let friendListForCurrentSection = self.searchUser.filter({$0.text[ $0.text.index(after: $0.text.firstIndex(of: " ")!)] == arrayFirstLetters[indexPath.section]!})
                let friend = friendListForCurrentSection[indexPath.row].text
                let foto = friendListForCurrentSection[indexPath.row].image
                DispatchQueue.main.async {
                    cell.friendName.text = friend
                    cell.friendFoto.avatarImage.image = foto
                }
            }
            
        } else {
            /*
             let friendListForCurrentSection = friendList.filter({$0.name[ $0.name.index(after: $0.name.firstIndex(of: " ")!)] == arrayFirstLetters[indexPath.section]!})
             let friend = friendListForCurrentSection[indexPath.row].name
             let foto = friendListForCurrentSection[indexPath.row].foto
             cell.friendName.text = friend
             cell.friendFoto.avatarImage.image = foto
             */
            
            /*
             let friendListForCurrentSection = Array(getData!).filter({$0.name[ $0.name.index(after: $0.name.firstIndex(of: " ")!)] == arrayFirstLetters[indexPath.section]!})
             let friend = friendListForCurrentSection[indexPath.row].name
             let foto = friendListForCurrentSection[indexPath.row].foto
             
             cell.friendName?.text = friend
             cell.friendFoto?.avatarImage.image = UIImage(data: foto!)
             */
            //  let friendListForCurrentSection = friendList.filter({$0.name[ $0.name.index(after: $0.name.firstIndex(of: " ")!)] == arrayFirstLetters[indexPath.section]!})
            //  let friend = friendListForCurrentSection[indexPath.row].name
            ///  let foto = friendListForCurrentSection[indexPath.row].foto
            //   cell.friendName.text = friend
            //   cell.friendFoto.avatarImage.image = foto
            
            DispatchQueue.global().async {
                let cellPresentersForCurrentSection = self.cellPresenters.filter({$0.text[ $0.text.index(after: $0.text.firstIndex(of: " ")!)] == arrayFirstLetters[indexPath.section]!})
                
                    DispatchQueue.main.async {
                        self.configure(cell: cell, at: indexPath, presenters : cellPresentersForCurrentSection )
                }
                myIndexPath = indexPath
            }
        }
        return cell
    }
}

extension AllFriendsViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        DispatchQueue.main.async {
    
            myIndexPath = indexPath
            let cell = tableView.cellForRow(at: indexPath) as! AllFriendsCell
            self.currentNameFriend = cell.friendName.text
            //    currentPhotoFriend = cell.friendFoto.avatarImage.image
            
            
            let cellPresentersForCurrentSection = self.cellPresenters.filter({$0.text[ $0.text.index(after: $0.text.firstIndex(of: " ")!)] == arrayFirstLetters[indexPath.section]!})
            self.idFriend = cellPresentersForCurrentSection[indexPath.row].idFriend
            self.currentPhotoFriend = cellPresentersForCurrentSection[indexPath.row].imageLarge
            self.performSegue(withIdentifier: "gotoCurrentFriend", sender: nil)
        }
    }
}


extension AllFriendsViewController: UISearchBarDelegate {
    
    func searchBar( _ searchBar : UISearchBar, textDidChange searchText : String) {
        searchContext(isSearch: true, searchText: searchText)
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        if searchBar.text != "" {
            searchContext(isSearch: true, searchText: nil)
        }
        searchBar.text = ""
        
    }
    
    
}

extension AllFriendsViewController {
    
    func searchContext(isSearch: Bool, searchText: String?) {
        DispatchQueue.global().async {
            //  searchUser = friendList.filter({$0.name.lowercased().prefix(searchText.count) == searchText.lowercased()})
            arrayFirstLetters = []
            let srchText: String
            if searchText != nil {
                srchText = searchText!
            } else {
                srchText = ""
            }
            self.searchUser = self.cellPresenters.filter({$0.text.lowercased().prefix(srchText.count) == srchText.lowercased()})
            
            for (_,values) in self.searchUser.enumerated() {
                for (index,value) in values.text.enumerated() {
                    
                    if value == " " {
                        if !arrayFirstLetters.contains(values.text[values.text.index(values.text.startIndex, offsetBy: index+1)]) {
                            arrayFirstLetters.append(values.text[values.text.index(values.text.startIndex, offsetBy: index+1)])
                            break
                        }
                    }
                }
            }
            
            self.searching = isSearch
            DispatchQueue.main.async {
                self.lettersPicker.setupView(isSearch: isSearch)
                self.tableView.reloadData()
            }
        }
    }
    
    func configure(cell: AllFriendsCell, at indexPath: IndexPath, presenters : [CellPresenter]) {
        
        let cellPresenter = self.cellPresenters[indexPath.row]
        cell.friendName?.text = presenters[indexPath.row].text
        
        cellPresenter.cell = cell
        
        if let image = presenters[indexPath.row].image {
            cell.friendFoto.avatarImage.image = image
        } else {
            // cellPresenter.downloadImage(completion: {})
            
            let imageDownload = ImageDownloader(url: cellPresenter.imageURLString)
            imageDownload.getImage (completion: {
                cellPresenter.image = imageDownload.image
            })
        }
    }
}
