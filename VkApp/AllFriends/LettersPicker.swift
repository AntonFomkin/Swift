//
//  LettersPicker.swift
//  VkApp
//
//  Created by Anton Fomkin on 02/06/2019.
//  Copyright © 2019 Anton Fomkin. All rights reserved.
//

import UIKit

class LettersPicker: UIControl {
 
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
        
        for (_,values) in friendList.enumerated() {
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

        if isSearch {
        } else {
            firstLetter()
        }

        buttons = []
        if stackView != nil {
            stackView.removeFromSuperview()
        }
        
        for (_ , value ) in arrayFirstLetters.enumerated() {
           
            let button = UIButton(type: .system)
            button.setTitle(String(value!), for: .normal)
            button.setTitleColor(.blue, for: .normal)
            button.setTitleColor(.white, for: .selected)
            button.addTarget(self, action: #selector(selectLetters(_:)), for: .touchUpInside)
            self.buttons.append(button)
        }
        
        stackView = UIStackView(arrangedSubviews: self.buttons)
        self.addSubview(stackView)
        
        stackView.spacing = 8
        stackView.axis = .vertical
        stackView.alignment = .center
        stackView.distribution = .fillEqually
    }
    
    
    override func layoutSubviews() {
        super.layoutSubviews()

        stackView.frame = bounds
    }

    private func updateSelectedLetter() {
        for (index, button) in self.buttons.enumerated() {
            guard let letter : Character = arrayFirstLetters[index] else { continue }
            button.isSelected = letter == self.selectedLetter
        }
    }
  
    @objc private func selectLetters(_ sender: UIButton) {
        guard let index = self.buttons.firstIndex(of: sender) else { return }  /* index */
        guard let letter : Character = arrayFirstLetters[index] else { return }
        self.selectedLetter = letter
        myIndexPath.section = index
        selectTableView.scrollToRow(at: myIndexPath, at: .bottom, animated: true)
    }
}
