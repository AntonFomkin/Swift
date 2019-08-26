//
//  NewsModel.swift
//  VkApp
//
//  Created by Anton Fomkin on 12/06/2019.
//  Copyright © 2019 Anton Fomkin. All rights reserved.
//

import UIKit

struct FotoAlbum {
 
    let imageOne : UIImage
    let imageTwo : UIImage
}


class CellPresenter {
    let imageURLString: String
    
    var cell: UITableViewCell?
    
    var image: UIImage?
    var text : String
    var widthPhoto, heightPhoto : Int
    
    init(text : String,widthPhoto: Int, heightPhoto : Int, imageURLString : String) {
        self.text = text
        self.imageURLString = imageURLString
        self.widthPhoto = widthPhoto
        self.heightPhoto = heightPhoto
    }
    
    
    
    func downloadImage(completion: @escaping () -> ()) {
        DispatchQueue.global(qos: .utility).async {
            let url = URL(string: self.imageURLString)!
            let data = try? Data(contentsOf: url)
            let image = UIImage(data: data!)
            DispatchQueue.main.async {
                self.image = image
      //          self.cell?.imageView?.image = image
                completion()
            }
        }
    }
}
