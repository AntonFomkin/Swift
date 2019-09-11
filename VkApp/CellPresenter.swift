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
    
    func saveFileFromCache(fileName: String,data: Data) {
        let filePath = self.filePath(fileName: fileName)
        if false == FileManager.default.fileExists(atPath: filePath) {
            FileManager.default.createFile(atPath: filePath, contents: data, attributes: nil)
            print("Создан \(fileName)")
        }
    }
    
    func loadFileFromCache(fileName: String) -> Data? {
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
        
        //let fileName = self.cryptoHelper.stringMD5(string: self.imageURLString)
        
        //        let url = URL(string: self.imageURLString)
        //        let fileName = url?.lastPathComponent ?? "\(index)"
        //        debugPrint("fileName \(fileName)")
        
        //  let fileName = "\(index)"
        
        let fileURL = cachesDirectory?.appendingPathComponent("\(fileName).png")
        return fileURL?.path ?? ""
    }
    
    
    func downloadImage(completion: @escaping () -> ()) {
        DispatchQueue.global(qos: .utility).async {
            let url = URL(string: self.imageURLString)!
            let filename = url.lastPathComponent
            
            var image: UIImage?
            if let data = self.loadFileFromCache(fileName: filename) {
                image = UIImage(data: data)
            } else {
                let data = try? Data(contentsOf: url)
                
                if let data = data {
                    image = UIImage(data: data)
                    self.saveFileFromCache(fileName: filename, data: data)
                }
            }
            
            DispatchQueue.main.async {
                self.image = image
                //          self.cell?.imageView?.image = image
                completion()
            }
        }
    }
}
