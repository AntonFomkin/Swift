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
    
    // MARK: - Создание массива первых букв от фамилии
    func firstLetter() {
        
        for (_,values) in friendListTwo.enumerated() {
            for (index,value) in values.name.enumerated() {
                if value == " " {
                    if !arrayFirstLetters.contains(values.name[values.name.index(values.name.startIndex, offsetBy: index+1)]) {
                        arrayFirstLetters.append(values.name[values.name.index(values.name.startIndex, offsetBy: index+1)])
                        break
                    }
                }
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
        
        DispatchQueue.global().async {
            if (isSearch) {
            } else {
                self.firstLetter()
            }
            
            self.buttons = []
            
            DispatchQueue.main.async {
                if self.stackView != nil {
                    self.stackView.removeFromSuperview()
                }
                
                for (_ , value ) in arrayFirstLetters.enumerated() {
                    
                    let button = UIButton(type: .system)
                    button.setTitle(String(value!), for: .normal)
                    button.setTitleColor(UIColor(red: 56.0/255, green: 54.0/255, blue: 152.0/255, alpha: 1.0), for: .normal)
                    button.setTitleColor(.white, for: .selected)
                    button.addTarget(self, action: #selector(self.selectLetters(_:)), for: .touchUpInside)
                    self.buttons.append(button)
                }
                
                self.stackView = UIStackView(arrangedSubviews: self.buttons)
                self.addSubview(self.stackView)
                
                self.stackView.spacing = 8
                self.stackView.axis = .vertical
                self.stackView.alignment = .center
                self.stackView.distribution = .fillEqually
            }
        }
    }
    
    
    override func layoutSubviews() {
        super.layoutSubviews()
        DispatchQueue.main.async {
            self.stackView.frame = self.bounds
        }
    }
    
    private func updateSelectedLetter() {
        DispatchQueue.global().async {
            
            for (index, button) in self.buttons.enumerated() {
                guard let letter : Character = arrayFirstLetters[index] else { continue }
                DispatchQueue.main.async {
                    button.isSelected = letter == self.selectedLetter
                }
            }
        }
    }
    
    @objc private func selectLetters(_ sender: UIButton) {
        DispatchQueue.global().async {
            
            guard let index = self.buttons.firstIndex(of: sender) else { return }  /* index */
            guard let letter : Character = arrayFirstLetters[index] else { return }
            
            myIndexPath.section = index
            myIndexPath.row = 0
            DispatchQueue.main.async {
                self.selectedLetter = letter
                self.tableView.scrollToRow(at: myIndexPath, at: .middle, animated: true)
            }
        }
    }
}


