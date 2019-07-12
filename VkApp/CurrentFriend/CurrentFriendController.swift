//
//  CurrentFriendController.swift
//  VkApp
//
//  Created by Anton Fomkin on 23/05/2019.
//  Copyright © 2019 Anton Fomkin. All rights reserved.
//

import UIKit



class CurrentFriendController: UICollectionViewController {
   
    var currentFoto: UIImage!
    
    override func viewDidLoad() {
        getAllFotoCurrentUser()
    }
    
    // MARK: Получаем данные через API VK
    func getAllFotoCurrentUser() {
        
        let auth = Session.instance
        let configuration = URLSessionConfiguration.default
        let session =  URLSession(configuration: configuration)
        
        var urlComponents = URLComponents()
        urlComponents.scheme = "https"
        urlComponents.host = "api.vk.com"
        urlComponents.path = "/method/photos.getAll"
        urlComponents.queryItems = [
            URLQueryItem(name: "user_id", value: auth.userId),
            URLQueryItem(name: "access_token", value: auth.token),
            URLQueryItem(name: "extended", value: "1"),
            URLQueryItem(name: "v", value: "5.100")
        ]
        
        var request = URLRequest(url: urlComponents.url!)
        
        request.httpMethod = "GET"
        let task = session.dataTask(with: request) { (data, response, error) in
            
            let json = try? JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions.allowFragments)
            print("AllFotoCurrentUserJSON = \(json!)")
        }
        
        task.resume()
    }
    
    // MARK: Работаем с табличным представлением
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }

    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 1
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {

        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CurrentFriendCell", for: indexPath) as! CurrentFriendCell
        cell.currentFriendFoto.image = currentFoto

        return cell
    }

}

