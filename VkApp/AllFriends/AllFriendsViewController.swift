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


class AllFriendsViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var lettersPicker: LettersPicker!
    @IBOutlet weak var searchBar: UISearchBar!
    
    lazy var searchUser: [CellPresenter] = []
    private var searching = false
    private var token: NotificationToken?
    private var getData : Results<RealmFriends>? = nil
    lazy private var currentPhotoFriend: UIImage? = nil
    lazy private var currentNameFriend: String? = nil
    lazy private var idFriend: String? = nil
  
    
    private func arrayFirstLetters() -> [Character?] {
        return lettersPicker.arrayFirstLetters
    }
    
    private func friendList() -> [UsersVK] {
        return lettersPicker.friendList
    }
    
    private func myIndexPath() -> IndexPath {
        return lettersPicker.myIndexPath
    }
    
    private func sectionDict() -> [Int:Int] {
        return lettersPicker.rowCountToSection
    }
    
    private func cellPresenters() -> [CellPresenter] {
        lettersPicker.cellPresenters
    }
    
    private func sectionDictonary() -> [Int:[CellPresenter]] {
        return lettersPicker.sectionDictonary
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
            
        // MARK: Подгружаем прототип ячейки
        tableView.register(UINib(nibName: "HeaderCell", bundle: nil), forHeaderFooterViewReuseIdentifier:  HeaderCellSectionTableView.reuseId)
        
        getDataFromVK(idFriend: nil,findGroupsToName: nil,typeOfContent: .getFriends) { [weak self] (cellPresenters,friendList) in
            
            self?.lettersPicker.addToArrayCellPresenters(arr: cellPresenters.sorted(by: { $0.text[ $0.text.index(after: $0.text.firstIndex(of: " ")!)] < $1.text [$1.text.index(after: $1.text.firstIndex(of: " ")!)] } ))
            
            self?.lettersPicker.addToFriendlist(arr: friendList.sorted(by: { $0.name[ $0.name.index(after: $0.name.firstIndex(of: " ")!)] < $1.name [$1.name.index(after: $1.name.firstIndex(of: " ")!)] } ) )

            self?.lettersPicker.setupView(isSearch: false)
            
            let dispatchGroup = DispatchGroup()
            for cellPresenter in cellPresenters {
                dispatchGroup.enter()
                
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
                DispatchQueue.main.async { [weak self] in
                    self?.tableView?.reloadData()
                }
            }
        }
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
        
        headerCell.nameLetter.text = String(arrayFirstLetters()[section]!)
        headerCell.backgroundColor = UIColor.white
        headerCell.nameLetter.textColor = UIColor(red: 29.0, green: 40.0, blue: 161.0, alpha: 1.0)
        
        return headerCell
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return arrayFirstLetters().count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if searching {
            return self.searchUser.filter({$0.text[$0.text.index(after: $0.text.firstIndex(of: " ")!)] == arrayFirstLetters()[section]!}).count
        } else {
            return sectionDict()[section]!
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "AllFriendsCell", for: indexPath) as! AllFriendsCell
        
        if searching {
            DispatchQueue.global().async { [weak self] in
                let friendListForCurrentSection = self?.searchUser.filter({$0.text[ $0.text.index(after: $0.text.firstIndex(of: " ")!)] == self?.arrayFirstLetters()[indexPath.section]!})
                let friend = friendListForCurrentSection?[indexPath.row].text
                let foto = friendListForCurrentSection?[indexPath.row].image
                DispatchQueue.main.async {
                    cell.friendName.text = friend
                    cell.friendFoto.avatarImage.image = foto
                }
            }
            
        } else {
          
            DispatchQueue.global().async { [weak self] in

                let cellPresentersForCurrentSection = self?.sectionDictonary()[indexPath.section]
                DispatchQueue.main.async { [weak self] in
                    self?.configure(cell: cell, at: indexPath, presenters : cellPresentersForCurrentSection! )
                }
                self?.lettersPicker.calcMyIndexPath(indexPath: indexPath)
            }
        }
        return cell
    }
}

extension AllFriendsViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        DispatchQueue.main.async { [weak self] in
            
            self?.lettersPicker.calcMyIndexPath(indexPath: indexPath)
            let cell = tableView.cellForRow(at: indexPath) as! AllFriendsCell
            self?.currentNameFriend = cell.friendName.text

            let cellPresentersForCurrentSection = self?.cellPresenters().filter({$0.text[ $0.text.index(after: $0.text.firstIndex(of: " ")!)] == self?.arrayFirstLetters()[indexPath.section]!})
            self?.idFriend = cellPresentersForCurrentSection?[indexPath.row].idFriend
            self?.currentPhotoFriend = cellPresentersForCurrentSection?[indexPath.row].imageLarge
            self?.performSegue(withIdentifier: "gotoCurrentFriend", sender: nil)
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
        DispatchQueue.global().async { [weak self] in
            
            self?.lettersPicker.clearArrayFirstLetters()
            let srchText: String
            if searchText != nil {
                srchText = searchText!
            } else {
                srchText = ""
            }
            self?.searchUser = (self?.cellPresenters().filter({$0.text.lowercased().prefix(srchText.count) == srchText.lowercased()}))!
            
            for (_,values) in (self?.searchUser.enumerated())! {
                for (index,value) in values.text.enumerated() {
                    
                    if value == " " {
                        if !(self?.arrayFirstLetters().contains(values.text[values.text.index(values.text.startIndex, offsetBy: index+1)]))! {
                            self?.lettersPicker.addToArrayFirstLetters(newElement: values.text[values.text.index(values.text.startIndex, offsetBy: index+1)])
                            break
                        }
                    }
                }
            }
            
            self?.searching = isSearch
            DispatchQueue.main.async {
                self?.lettersPicker.setupView(isSearch: isSearch)
                self?.tableView.reloadData()
            }
        }
    }
    
    private func configure(cell: AllFriendsCell, at indexPath: IndexPath, presenters : [CellPresenter]) {
        
        let cellPresenter = self.cellPresenters()[indexPath.row]
        cell.friendName?.text = presenters[indexPath.row].text
        
        cellPresenter.cell = cell
        
        if let image = presenters[indexPath.row].image {
            cell.friendFoto.avatarImage.image = image
        } else {

            let imageDownload = ImageDownloader(url: cellPresenter.imageURLString)
            imageDownload.getImage (completion: {
                cellPresenter.image = imageDownload.image
            })
        }
    }
}
