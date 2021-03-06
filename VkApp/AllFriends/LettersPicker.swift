//
//  LettersPicker.swift
//  VkApp
//
//  Created by Anton Fomkin on 02/06/2019.
//  Copyright © 2019 Anton Fomkin. All rights reserved.
//

import UIKit

class LettersPicker: UIControl {
    @IBOutlet weak var tableView: UITableView!
    var selectedLetter: Character? = nil {
        didSet {
            self.updateSelectedLetter()
            self.sendActions(for: .valueChanged)
        }
    }
    
    private var buttons: [UIButton] = []
    private var stackView: UIStackView!
    var arrayFirstLetters : [Character?] = []
    var friendList : [UsersVK] = []
    var myIndexPath : IndexPath = IndexPath.init(row: 0, section: 0)
    var rowCountToSection: [Int:Int] = [:]
    var sectionDictonary : [Int: [CellPresenter]] = [:]
    var cellPresenters : [CellPresenter] = []
    
    func addToFriendlist(arr: [UsersVK]) {
        friendList = arr
    }
    
    func addToArrayFirstLetters(newElement: Character?) {
        arrayFirstLetters.append(newElement)
    }
    
    func addToArrayCellPresenters(arr: [CellPresenter]) {
        cellPresenters = arr
    }
    
    func clearArrayFirstLetters() {
        arrayFirstLetters.removeAll()
    }
    
    func calcMyIndexPath(indexPath: IndexPath) {
        myIndexPath = indexPath
    }
    
    // MARK: - Создание массива первых букв от фамилии
    func firstLetter() {
       DispatchQueue.main.async { [weak self] in
        for (_,values) in (self?.friendList.enumerated())! {
                for (index,value) in values.name.enumerated() {
                    if value == " " {
                        if !(self?.arrayFirstLetters.contains(values.name[values.name.index(values.name.startIndex, offsetBy: index+1)]))! {
                            self?.arrayFirstLetters.append(values.name[values.name.index(values.name.startIndex, offsetBy: index+1)])
                            break
                        }
                    }
                }
            }
        for (index, _) in (self?.arrayFirstLetters.enumerated())! {
            self?.rowCountToSection[index] = self?.friendList.filter({$0.name[ $0.name.index(after: $0.name.firstIndex(of: " ")!)] == self?.arrayFirstLetters[index]!}).count
            self?.sectionDictonary[index] = self?.cellPresenters.filter({$0.text[ $0.text.index(after: $0.text.firstIndex(of: " ")!)] == self?.arrayFirstLetters[index]!})
            }
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setupView(isSearch: false)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.setupView(isSearch: false)
    }
    
    func setupView(isSearch : Bool) {
        
        DispatchQueue.global().async { [weak self] in
            if (isSearch) {
            } else {
                self?.firstLetter()
            }
            
            self?.buttons = []
            
            DispatchQueue.main.async { [weak self] in
                if self?.stackView != nil {
                    self?.stackView.removeFromSuperview()
                }
                
                for (_ , value ) in (self?.arrayFirstLetters.enumerated())! {
                    
                    let button = UIButton(type: .system)
                    button.setTitle(String(value!), for: .normal)
                    button.setTitleColor(UIColor.appTitleButton, for: .normal)
                    button.setTitleColor(.white, for: .selected)
                    button.addTarget(self, action: #selector(self?.selectLetters(_:)), for: .touchUpInside)
                    self?.buttons.append(button)
                }
                
                self?.stackView = UIStackView(arrangedSubviews: self!.buttons)
                self?.addSubview(self!.stackView)
                 
                self?.stackView.spacing = 8
                self?.stackView.axis = .vertical
                self?.stackView.alignment = .center
                self?.stackView.distribution = .fillEqually
            }
        }
    }
    
    
    override func layoutSubviews() {
        super.layoutSubviews()
        DispatchQueue.main.async { [weak self] in
        self?.stackView.frame = self?.bounds ?? CGRect.zero
        }
    }
    
    private func updateSelectedLetter() {
        DispatchQueue.global().async { [weak self] in
            
            for (index, button) in (self?.buttons.enumerated())! {
                guard let letter : Character = self?.arrayFirstLetters[index] else { continue }
                DispatchQueue.main.async { [weak self] in
                    button.isSelected = letter == self?.selectedLetter
                }
            }
        }
    }
    
    @objc private func selectLetters(_ sender: UIButton) {
        DispatchQueue.global().async { [weak self] in
            
            guard let index = self?.buttons.firstIndex(of: sender) else { return }  /* index */
            guard let letter : Character = self?.arrayFirstLetters[index] else { return }
            
            self?.myIndexPath.section = index
            self?.myIndexPath.row = 0
            DispatchQueue.main.async {
                self?.selectedLetter = letter
                self?.tableView.scrollToRow(at: (self?.myIndexPath)!, at: .middle, animated: true)
            }
        }
    }
}


