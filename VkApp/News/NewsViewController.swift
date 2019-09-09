//
//  NewsViewController.swift
//  VkApp
//
//  Created by Anton Fomkin on 12/06/2019.
//  Copyright © 2019 Anton Fomkin. All rights reserved.
//

import UIKit


class NewsViewController: UITableViewController {
   /*
    let textNews : [String] =
        ["Арт-директор фестиваля — Борис Гребенщиков, собирает в живописном саду в самом центре города разнообразных музыкантов со всего света, которых зачарованно слушают тысячи любителей необычной, душевной, этнической и самой редкой музыки",
         "Билеты на концерт на Крестовском острове - здесь: https://spb.ponominalu.ru/event/akvarium/03.07/20:00 ",
         "Гитарист легендарной группы «Кино» сыграл песню для юного музыканта из Калининграда"
        ]
    
    var fotoAlbumNews : [FotoAlbum] =
        [
        FotoAlbum(imageOne: UIImage(imageLiteralResourceName: "bg1.png"), imageTwo: UIImage(imageLiteralResourceName: "man1.png")),
        FotoAlbum(imageOne: UIImage(imageLiteralResourceName: "bg2.png"), imageTwo: UIImage(imageLiteralResourceName: "man1.png")),
        FotoAlbum(imageOne: UIImage(imageLiteralResourceName: "kasp.png"), imageTwo: UIImage(imageLiteralResourceName: "man1.png"))
        ]
     */
    private var cellPresenters : [CellPresenter] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
      
        tableView.register(UINib(nibName: "NewsCell", bundle: nil), forCellReuseIdentifier:  NewsCell.reuseId)
        
        /* theCap - просто заглушка */
        getDataFromVK(findGroupsToName: nil,typeOfContent: .getNews) { [weak self] (cellPresenters, theCap) in
            
            self?.cellPresenters = cellPresenters
           
            let dispatchGroup = DispatchGroup()
            for cellPresenter in cellPresenters {
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
        return self.cellPresenters.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let cell = tableView.dequeueReusableCell(withIdentifier: "NewsCell", for: indexPath) as! NewsCell
       
        if cell.reuseIdentifier! == "NewsCell" {
            self.configure(cell: cell, at: indexPath)
        }
        return cell
    }
 
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return newsRowHeight
    }

 }

extension NewsViewController {
    
    func configure(cell: NewsCell, at indexPath: IndexPath) {
        
        let cellPresenter = self.cellPresenters[indexPath.row]
        cell.newsText?.text =  self.cellPresenters[indexPath.row].text
        
        cellPresenter.cell = cell
        
        if let image = cellPresenter.image {
            cell.newsFotoOne?.image = image
        } else {
            cellPresenter.downloadImage(completion: {})
        }
    }
}


