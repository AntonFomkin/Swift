//
//  NewsViewController.swift
//  VkApp
//
//  Created by Anton Fomkin on 12/06/2019.
//  Copyright © 2019 Anton Fomkin. All rights reserved.
//

import UIKit

class NewsViewController: UITableViewController {

    
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

     
   
    override func viewDidLoad() {
        super.viewDidLoad()
       
        tableView.register(UINib(nibName: "NewsCell", bundle: nil), forCellReuseIdentifier:  NewsCell.reuseId)
    }

 
    
    
    // MARK: Работаем с табличным представлением

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return textNews.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let cell = tableView.dequeueReusableCell(withIdentifier: "NewsCell", for: indexPath) as! NewsCell
        cell.newsText.text = textNews[indexPath.row]
        cell.newsFotoOne.image = fotoAlbumNews[indexPath.row].imageOne
        cell.frame = CGRect(x: 0, y: 0, width: cell.frame.width, height: 250)
   
        return cell
    }
 
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return newsRowHeight
    }

 }
