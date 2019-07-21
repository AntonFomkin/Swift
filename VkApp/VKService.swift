//
//  VKService.swift
//  VkApp
//
//  Created by Anton Fomkin on 08/07/2019.
//  Copyright © 2019 Anton Fomkin. All rights reserved.
//

import UIKit
import RealmSwift

func getImage(url : URL, completionBlock: @escaping (UIImage) -> ()){
    
    let configuration = URLSessionConfiguration.default
    let getFoto =  URLSession(configuration: configuration)
    
    let taskGetFoto = getFoto.dataTask(with: url) { (data, response, error) in
        guard let data = data, error == nil else { return }
        DispatchQueue.main.async() {
            let image: UIImage? = UIImage(data: data)
            completionBlock(image!)
        }
        
    }
    
    taskGetFoto.resume()
}

func getGroups(completionBlock: @escaping ([GroupVK]) -> ()) {
    
    var arr : [GroupVK] = []
    
    let auth = Session.instance
    
    let configuration = URLSessionConfiguration.default
    let session =  URLSession(configuration: configuration)
    
    var urlComponents = URLComponents()
    urlComponents.scheme = "https"
    urlComponents.host = "api.vk.com"
    urlComponents.path = "/method/groups.get"
    urlComponents.queryItems = [
        URLQueryItem(name: "user_id", value: auth.userId),
        URLQueryItem(name: "access_token", value: auth.token),
        URLQueryItem(name: "extended", value: "1"),
        URLQueryItem(name: "v", value: "5.100")
    ]
    let request = URLRequest(url: urlComponents.url!)
    
    
    let requestTask = session.dataTask(with: request) { (data: Data?, response: URLResponse?, error: Error?) in
        
        guard let data = data, error == nil else { return }
        DispatchQueue.main.async() {
            let json = try? JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.allowFragments)
            
            let startPoint = json as? [String: AnyObject]
            let responce = startPoint?["response"] as? [String: AnyObject]
            let finalObject = responce?["items"] as? [Any]
            
            for myGroup in finalObject! {
                let myGroup  = myGroup as! [String: Any]
                let groupName = myGroup["name"] as? String
                let fotoUrl = URL(string: myGroup["photo_100"] as! String)
                
                
                
                getImage(url: fotoUrl!) {  (image) in
                    let image : UIImage = image
                    arr.append(GroupVK(name: groupName!, foto: image))
               
                    // MARK: - Пишем в Realm
                    let obj = RealmGroup()
                    obj.name = groupName!
                    obj.foto = image.pngData()//! as Data?
                    if obj.foto == nil {return}
                    do {
                        let realm = try Realm()
                     //   print(realm.configuration.fileURL)
                        try realm.write {
                            realm.add(obj)
                        }
                        
                        
                    } catch {
                        print(error)
                    }
                 
                    completionBlock(arr);
                }
            }
        }
    }
    requestTask.resume()
}


func getFriends(completionBlock: @escaping ([UsersVK]) -> ()) {
    
    var arr : [UsersVK] = []
    
    let auth = Session.instance
    
    let configuration = URLSessionConfiguration.default
    let session =  URLSession(configuration: configuration)
    
    var urlComponents = URLComponents()
    urlComponents.scheme = "https"
    urlComponents.host = "api.vk.com"
    urlComponents.path = "/method/friends.get"
    urlComponents.queryItems = [
        URLQueryItem(name: "user_id", value: auth.userId),
        URLQueryItem(name: "access_token", value: auth.token),
        URLQueryItem(name: "fields", value: "domain,photo_100"),
        URLQueryItem(name: "order", value: "name"),
        URLQueryItem(name: "v", value: "5.100")
    ]
    let request = URLRequest(url: urlComponents.url!)
    
    
    let requestTask = session.dataTask(with: request) { (data: Data?, response: URLResponse?, error: Error?) in
        
        guard let data = data, error == nil else { return }
        DispatchQueue.main.async() {
            let json = try? JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.allowFragments)
            
            let startPoint = json as? [String: AnyObject]
            let responce = startPoint?["response"] as? [String: AnyObject]
            let finalObject = responce?["items"] as? [Any]
            
            for myUsers in finalObject! {
                let myUsers  = myUsers as! [String: Any]
                let firstName = myUsers["first_name"] as? String
                let lastName = myUsers["last_name"] as? String
                let fotoUrl = URL(string: myUsers["photo_100"] as! String)
                
                
                
                getImage(url: fotoUrl!) {  (image) in
                    let image : UIImage = image
                    arr.append(UsersVK(name: firstName! + " " + lastName!, foto: image))
                  
                    // MARK: - Пишем в Realm
                    let obj = RealmFriends()
                    obj.name = firstName! + " " + lastName!
                    obj.foto = image.pngData()//! as Data?
                    if obj.foto == nil {return}
                    do {
                        let realm = try Realm()
                        //   print(realm.configuration.fileURL)
                        try realm.write {
                            realm.add(obj)
                        }
                        
                        
                    } catch {
                        print(error)
                    }
                    
                    completionBlock(arr);
                }
            }
        }
    }
    requestTask.resume()
    
}

func getCurrentFoto(completionBlock: @escaping ([FotoCurrentUser]) -> ()) {
    
    var arr : [FotoCurrentUser] = []
    
    let auth = Session.instance
    
    let configuration = URLSessionConfiguration.default
    let session =  URLSession(configuration: configuration)
    
    var urlComponents = URLComponents()
    urlComponents.scheme = "https"
    urlComponents.host = "api.vk.com"
    urlComponents.path = "/method/friends.get"
    urlComponents.queryItems = [
        URLQueryItem(name: "user_id", value: auth.userId),
        URLQueryItem(name: "access_token", value: auth.token),
        URLQueryItem(name: "fields", value: "domain,photo_100"),
        URLQueryItem(name: "order", value: "name"),
        URLQueryItem(name: "v", value: "5.100")
    ]
    let request = URLRequest(url: urlComponents.url!)
    
    
    let requestTask = session.dataTask(with: request) { (data: Data?, response: URLResponse?, error: Error?) in
        
        guard let data = data, error == nil else { return }
        DispatchQueue.main.async() {
            let json = try? JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.allowFragments)
            
            let startPoint = json as? [String: AnyObject]
            let responce = startPoint?["response"] as? [String: AnyObject]
            let finalObject = responce?["items"] as? [Any]
            
            for myUsers in finalObject! {
                let myUsers  = myUsers as! [String: Any]
                let fotoUrl = URL(string: myUsers["photo_100"] as! String)
                
                getImage(url: fotoUrl!) {  (image) in
                    let image : UIImage = image
                    arr.append(FotoCurrentUser(foto: image))
                    completionBlock(arr);
                }
            }
        }
    }
    requestTask.resume()
    
}
