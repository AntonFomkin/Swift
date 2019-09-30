//
//  NewsViewController.swift
//  VkApp
//
//  Created by Anton Fomkin on 12/06/2019.
//  Copyright © 2019 Anton Fomkin. All rights reserved.
//

import UIKit


class NewsViewController: UITableViewController {
 
    private var cellPresenters : [CellPresenter] = []
    var rowHeight: CGFloat = 0.0
    override func viewDidLoad() {
        super.viewDidLoad()
      
        tableView.register(UINib(nibName: "NewsCell", bundle: nil), forCellReuseIdentifier:  NewsCell.reuseId)
        
        /* theCap - просто заглушка */
        getDataFromVK(idFriend: nil,findGroupsToName: nil,typeOfContent: .getNews) { [weak self] (cellPresenters, theCap) in
            
            self?.cellPresenters = cellPresenters
           
            let dispatchGroup = DispatchGroup()
            for cellPresenter in cellPresenters {
                dispatchGroup.enter()

                let imageDownload = ImageDownloader(url: cellPresenter.imageURLString)
                imageDownload.getImage (completion: {
                    cellPresenter.image = imageDownload.image
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
    // MARK: Работаем с табличным представлением

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.cellPresenters.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let cell = tableView.dequeueReusableCell(withIdentifier: "NewsCell", for: indexPath) as! NewsCell
        self.rowHeight = cell.newsRowHeight

        if cell.reuseIdentifier! == "NewsCell" {
            self.configure(cell: cell, at: indexPath)
        }
        return cell
    }
 
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return self.rowHeight
    }

 }

extension NewsViewController {
    
    private func configure(cell: NewsCell, at indexPath: IndexPath) {
        
        let cellPresenter = self.cellPresenters[indexPath.row]
        cell.newsText?.text =  self.cellPresenters[indexPath.row].text
        
        cellPresenter.cell = cell
        
        if let image = cellPresenter.image {
            cell.newsFotoOne?.image = image
        } else {
         
            let imageDownload = ImageDownloader(url: cellPresenter.imageURLString)
            imageDownload.getImage (completion: {
                cellPresenter.image = imageDownload.image
            })
        }
    }
}


