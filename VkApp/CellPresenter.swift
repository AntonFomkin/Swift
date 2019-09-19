//
//  CellPresenter.swift
//  VkApp
//
//  Created by Anton Fomkin on 06/09/2019.
//  Copyright © 2019 Anton Fomkin. All rights reserved.
//

import Foundation
import UIKit

class CellPresenter: Equatable {
    static func == (lhs: CellPresenter, rhs: CellPresenter) -> Bool {
        return lhs.text == rhs.text
    }
    
    let imageURLString: String
    let imageLargeURLString: String?
    
    var cell: UITableViewCell?
    var idFriend: String?
    var image: UIImage?
    var imageLarge: UIImage?
    var text : String
    var widthPhoto, heightPhoto : Int
    
    init(idFriend: String, text: String,widthPhoto: Int, heightPhoto: Int, imageURLString: String, imageLargeURLString: String?) {
        self.idFriend = idFriend
        self.text = text
        self.imageURLString = imageURLString
        self.imageLargeURLString = imageLargeURLString
        self.widthPhoto = widthPhoto
        self.heightPhoto = heightPhoto
    }
}

class ImageDownloader {
    
    var image: UIImage?
    let imageURL: String?
    
    private func saveFileFromCache(fileName: String,data: Data) {
        let filePath = self.filePath(fileName: fileName)
        if false == FileManager.default.fileExists(atPath: filePath) {
            FileManager.default.createFile(atPath: filePath, contents: data, attributes: nil)
           // print("Создан \(fileName)")
        }
    }
    
    private func loadFileFromCache(fileName: String) -> Data? {
        var data: Data?
        let filePath = self.filePath(fileName: fileName)
        if FileManager.default.fileExists(atPath: filePath) {
            let url = URL(fileURLWithPath: filePath)
            data = try? Data.init(contentsOf: url)
        }
        return data
    }
    
    private func filePath(fileName: String) -> String {
        let cachesDirectory = FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask).first
        
        let fileURL = cachesDirectory?.appendingPathComponent("\(fileName).png")
        return fileURL?.path ?? ""
    }
    
    func getImage(completion: @escaping () -> ())  {
        DispatchQueue.global(qos: .utility).async {
            
            let url = URL(string: self.imageURL!)
            guard let _ = url else {return}
            let filename = url!.lastPathComponent
            
            var image: UIImage?
            if let data = self.loadFileFromCache(fileName: filename) {
                image = UIImage(data: data)
            } else {
                let data = try? Data(contentsOf: url!)
                
                if let data = data {
                    image = UIImage(data: data)
                    self.saveFileFromCache(fileName: filename, data: data)
                }
            }
            
            DispatchQueue.main.async {
                self.image = image
                completion()
            }
        }
    }
    init(url: String) {
        self.imageURL = url
    }
    
}


