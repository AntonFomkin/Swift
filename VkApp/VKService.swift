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

enum TypeOfRequest {
    
    case getGroups
    case getFriends
    case getNews
    case getSwiftGroup
    case getFindGroups
    case getPhotoAlbumCurrentFriend
}

func getCurrentSession (findGroupsToName: String?,typeOfContent: TypeOfRequest) -> (URLSession,URLRequest) {
    
    let auth = Session.instance
    let configuration = URLSessionConfiguration.default
    let session =  URLSession(configuration: configuration)
    
    var urlComponents = URLComponents()
    urlComponents.scheme = "https"
    urlComponents.host = "api.vk.com"
    
    switch typeOfContent {
        
    case .getGroups:
        
        urlComponents.path = "/method/groups.get"
        urlComponents.queryItems = [
            URLQueryItem(name: "user_id", value: auth.userId),
            URLQueryItem(name: "access_token", value: auth.token),
            URLQueryItem(name: "extended", value: "1"),
            URLQueryItem(name: "v", value: "5.100")
        ]
        
    case .getFriends:
        
        urlComponents.path = "/method/friends.get"
        urlComponents.queryItems = [
            URLQueryItem(name: "user_id", value: auth.userId),
            URLQueryItem(name: "access_token", value: auth.token),
            URLQueryItem(name: "fields", value: "domain,photo_200_orig"),
            URLQueryItem(name: "order", value: "name"),
            URLQueryItem(name: "v", value: "5.100")
        ]
        
    case .getNews:
        
        urlComponents.path = "/method/newsfeed.get"
        urlComponents.queryItems = [
            URLQueryItem(name: "user_id", value: auth.userId),
            URLQueryItem(name: "access_token", value: auth.token),
            URLQueryItem(name: "filters", value: "post,photo"),
            URLQueryItem(name: "v", value: "5.100")
        ]
        
    case .getSwiftGroup:
        urlComponents.path = "/method/groups.search"
        urlComponents.queryItems = [
            URLQueryItem(name: "user_id", value: auth.userId),
            URLQueryItem(name: "access_token", value: auth.token),
            URLQueryItem(name: "q", value: "apple swift"),
            URLQueryItem(name: "v", value: "5.100")
        ]
    case .getFindGroups:
        urlComponents.path = "/method/groups.search"
        urlComponents.queryItems = [
            URLQueryItem(name: "user_id", value: auth.userId),
            URLQueryItem(name: "access_token", value: auth.token),
            URLQueryItem(name: "q", value: findGroupsToName),
            URLQueryItem(name: "v", value: "5.100")
        ]
    case .getPhotoAlbumCurrentFriend:
        urlComponents.path = "/method/photos.getAll"
        urlComponents.queryItems = [
            URLQueryItem(name: "user_id", value: auth.userId),
            URLQueryItem(name: "access_token", value: auth.token),
            URLQueryItem(name: "owner_id", value: "15571026"),
            URLQueryItem(name: "extended", value: "0"),
            URLQueryItem(name: "skip_hidden", value: "1"),
            URLQueryItem(name: "no_service_albums", value: "0"),
            URLQueryItem(name: "photo_sizes", value: "0"),
            URLQueryItem(name: "count", value: "5"),
            URLQueryItem(name: "v", value: "5.101")
        ]
    }
    
    let request = URLRequest(url: urlComponents.url!)
    return (session, request)
}

/*
 func getGroups(completionBlock: @escaping ([CellPresenter]) -> ()) {
 
 //var arr : [GroupVK] = []
 var cellPresenters: [CellPresenter] = []
 
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
 
 let currentSession = getCurrentSession(typeOfContent: .getGroups)
 let session = currentSession.0
 let request = currentSession.1
 
 let requestTask = session.dataTask(with: request) { (data: Data?, response: URLResponse?, error: Error?) in
 
 guard let data = data, error == nil else { return }
 DispatchQueue.global().async() {
 let json = try? JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.allowFragments)
 
 let startPoint = json as? [String: AnyObject]
 let responce = startPoint?["response"] as? [String: AnyObject]
 let finalObject = responce?["items"] as? [Any]
 
 for myGroup in finalObject! {
 let myGroup  = myGroup as! [String: Any]
 let groupName = myGroup["name"] as! String
 // let fotoUrl = URL(string: myGroup["photo_100"] as! String)
 let urlFoto = myGroup["photo_100"] as! String
 /*
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
 */
 let cellPresenter = CellPresenter(text: groupName,widthPhoto: 0, heightPhoto: 0, imageURLString: urlFoto)
 cellPresenters.append(cellPresenter)
 
 DispatchQueue.main.async {
 completionBlock(cellPresenters)
 }
 
 
 }
 }
 }
 requestTask.resume()
 }
 */

func parseJSONGroupsVK (for startPoint : [String: AnyObject]?) -> [CellPresenter] {
    
    var cellPresenters : [CellPresenter] = []
    
    let responce = startPoint?["response"] as? [String: AnyObject]
    let finalObject = responce?["items"] as? [Any]
    
    guard let finalObj = finalObject else { return cellPresenters }
    
    for myGroup in finalObj {
        let myGroup  = myGroup as! [String: Any]
        let groupName = myGroup["name"] as! String
        // let fotoUrl = URL(string: myGroup["photo_100"] as! String)
        let urlFoto = myGroup["photo_100"] as! String
        /*
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
         */
        let cellPresenter = CellPresenter(text: groupName,widthPhoto: 0, heightPhoto: 0, imageURLString: urlFoto)
        cellPresenters.append(cellPresenter)
    }
    return cellPresenters
}


func parseJSONNewsVK (for startPoint : [String: AnyObject]?) -> [CellPresenter] {
    
    var cellPresenters : [CellPresenter] = []
    let screenWidth = Int(UIScreen.main.bounds.width)
    let responce = startPoint?["response"] as? [String: AnyObject]
    let arrItems = responce?["items"] as? [AnyObject]
    
    for valueItem in arrItems!  {
        
        var widthFoto : Int = 0
        var heightFoto : Int = 0
        var urlFoto : String = ""
        let valueItem  = valueItem as! [String: Any]
        
        if  valueItem["text"] == nil {continue}
        let textNews = valueItem["text"] as! String
        if textNews == "" {continue}
        
        if !valueItem.keys.contains("attachments") {continue}
        
        let arrAttachments = valueItem["attachments"] as! [AnyObject]
        
        for valueAtt in arrAttachments {
            let valueAtt = valueAtt as! [String: Any]
            let typeAtt = valueAtt["type"] as! String
            
            if typeAtt == "photo" {
                let photo = valueAtt["photo"] as! [String: Any]
                let sizesPhoto = photo["sizes"] as! [AnyObject]
                
                for currentFoto in sizesPhoto {
                    let currentFoto = currentFoto as! [String: Any]
                    let uFoto = currentFoto["url"] as! String
                    let wFoto = currentFoto["width"] as! Int
                    let hFoto = currentFoto["height"] as! Int
                    
                    if wFoto <= screenWidth {
                        if wFoto > widthFoto {
                            widthFoto = wFoto
                            heightFoto = hFoto
                            urlFoto = uFoto
                        }
                    }
                }
                let cellPresenter = CellPresenter(text: textNews,widthPhoto: widthFoto, heightPhoto: heightFoto, imageURLString: urlFoto)
                cellPresenters.append(cellPresenter)
                
                break //arrAttachments
            }
        }
    }
    
    return cellPresenters
}


func parseJSONFriendsVK (for startPoint : [String: AnyObject]?) -> ([CellPresenter],[UsersVK]) {
    
    var cellPresenters : [CellPresenter] = []
    var arr : [UsersVK] = []
    
    let responce = startPoint?["response"] as? [String: AnyObject]
    let finalObject = responce?["items"] as? [Any]
  
    for myUsers in finalObject! {
        let myUsers  = myUsers as! [String: Any]
        let firstName = myUsers["first_name"] as? String
        let lastName = myUsers["last_name"] as? String
        /*let fotoUrl = URL(string: myUsers["photo_100"] as! String)*/
        let urlFoto = myUsers["photo_200_orig"] as! String
        
        arr.append(UsersVK(name: firstName! + " " + lastName!, foto: nil))
        /*
         getImage(url: fotoUrl!) {  (image) in
         let image : UIImage = image
         arr.append(UsersVK(name: firstName! + " " + lastName!, foto: image))
         /*
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
         */
         completionBlock(arr);
         }
         */
        let cellPresenter = CellPresenter(text: firstName! + " " + lastName!,widthPhoto: 0, heightPhoto: 0, imageURLString: urlFoto)
        cellPresenters.append(cellPresenter)
        
    }
    
    return (cellPresenters,arr)
}

func parseJSONPhotoCurrentFriend (for startPoint : [String: AnyObject]?) -> [CellPresenter] {
    
    var cellPresenters : [CellPresenter] = []
    let screenWidth = Int(UIScreen.main.bounds.width)
    let responce = startPoint?["response"] as? [String: AnyObject]
    let arrItems = responce?["items"] as? [AnyObject]
    
   guard let _ = responce, let _ = arrItems else {return cellPresenters}
    
    for valueItem in arrItems!  {
        
        var widthFoto : Int = 0
        var heightFoto : Int = 0
        var urlFoto : String = ""
        let valueItem  = valueItem as! [String: Any]
      /*
        if  valueItem["text"] == nil {continue}
        let textNews = valueItem["text"] as! String
        if textNews == "" {continue}
      */
        
        if !valueItem.keys.contains("sizes") {continue}
        
        let arrAttachments = valueItem["sizes"] as! [AnyObject]
        
        for valueAtt in arrAttachments {
            let valueAtt = valueAtt as! [String: Any]

            let uFoto = valueAtt["url"] as! String
            let wFoto = valueAtt["width"] as! Int
            let hFoto = valueAtt["height"] as! Int
           
            if wFoto <= screenWidth {
                if wFoto > widthFoto {
                    widthFoto = wFoto
                    heightFoto = hFoto
                    urlFoto = uFoto
                }
            }
        }
                let cellPresenter = CellPresenter(text: "",widthPhoto: widthFoto, heightPhoto: heightFoto, imageURLString: urlFoto)
                cellPresenters.append(cellPresenter)
    }
    
    return cellPresenters
}


func getDataFromVK (findGroupsToName: String?, typeOfContent: TypeOfRequest, completionBlock: @escaping ([CellPresenter],[UsersVK]) -> ()) {
    
    var arr : [UsersVK] = []
    var cellPresenters : [CellPresenter] = []
    /*
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
     */
    let currentSession = getCurrentSession(findGroupsToName: findGroupsToName, typeOfContent: typeOfContent)
    let session = currentSession.0
    let request = currentSession.1
    
    let requestTask = session.dataTask(with: request) { (data: Data?, response: URLResponse?, error: Error?) in
        guard let data = data, error == nil else { return }
        print("REQUEST = \(request)")
        DispatchQueue.global().async() {
            
            let json = try? JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.allowFragments)
            let startPoint = json as? [String: AnyObject]
            print(json!)
            switch typeOfContent {
                
            case .getFriends:
                
                let parseJSONFriends = parseJSONFriendsVK(for: startPoint)
                cellPresenters = parseJSONFriends.0
                arr = parseJSONFriends.1
                
            case .getGroups, .getSwiftGroup, .getFindGroups:
                
                cellPresenters = parseJSONGroupsVK(for: startPoint)
                
                
            case .getNews:
                
                cellPresenters = parseJSONNewsVK(for: startPoint)
                
            case .getPhotoAlbumCurrentFriend:
                cellPresenters = parseJSONPhotoCurrentFriend(for: startPoint)
                
            } //switchEnd
            
            DispatchQueue.main.async {
                completionBlock(cellPresenters,arr)
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

/*
 func getNews(completionBlock: @escaping ([CellPresenter]) -> ()) {
 
 var cellPresenters: [CellPresenter] = []
 let screenWidth = Int(UIScreen.main.bounds.width)
 
 let auth = Session.instance
 
 let configuration = URLSessionConfiguration.default
 let session =  URLSession(configuration: configuration)
 
 var urlComponents = URLComponents()
 urlComponents.scheme = "https"
 urlComponents.host = "api.vk.com"
 urlComponents.path = "/method/newsfeed.get"
 urlComponents.queryItems = [
 URLQueryItem(name: "user_id", value: auth.userId),
 URLQueryItem(name: "access_token", value: auth.token),
 URLQueryItem(name: "filters", value: "post,photo"),
 URLQueryItem(name: "v", value: "5.100")
 ]
 let request = URLRequest(url: urlComponents.url!)
 
 let currentSession = getCurrentSession(typeOfContent: .getNews)
 let session = currentSession.0
 let request = currentSession.1
 
 let requestTask = session.dataTask(with: request)  { (data: Data?, response: URLResponse?, error: Error?)  in
 
 guard let data = data, error == nil else { return }
 DispatchQueue.global().async() {
 let json = try? JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.allowFragments)
 let startPoint = json as? [String: AnyObject]
 let responce = startPoint?["response"] as? [String: AnyObject]
 let arrItems = responce?["items"] as? [AnyObject]
 
 for valueItem in arrItems!  {
 
 var widthFoto : Int = 0
 var heightFoto : Int = 0
 var urlFoto : String = ""
 let valueItem  = valueItem as! [String: Any]
 
 if  valueItem["text"] == nil {continue}
 let textNews = valueItem["text"] as! String
 if textNews == "" {continue}
 
 if !valueItem.keys.contains("attachments") {continue}
 
 let arrAttachments = valueItem["attachments"] as! [AnyObject]
 
 for valueAtt in arrAttachments {
 let valueAtt = valueAtt as! [String: Any]
 let typeAtt = valueAtt["type"] as! String
 
 if typeAtt == "photo" {
 let photo = valueAtt["photo"] as! [String: Any]
 let sizesPhoto = photo["sizes"] as! [AnyObject]
 
 for currentFoto in sizesPhoto {
 let currentFoto = currentFoto as! [String: Any]
 let uFoto = currentFoto["url"] as! String
 let wFoto = currentFoto["width"] as! Int
 let hFoto = currentFoto["height"] as! Int
 
 if wFoto <= screenWidth {
 if wFoto > widthFoto {
 widthFoto = wFoto
 heightFoto = hFoto
 urlFoto = uFoto
 }
 }
 }
 let cellPresenter = CellPresenter(text: textNews,widthPhoto: widthFoto, heightPhoto: heightFoto, imageURLString: urlFoto)
 cellPresenters.append(cellPresenter)
 
 DispatchQueue.main.async {
 completionBlock(cellPresenters)
 }
 
 break //arrAttachments
 }
 }
 }
 }
 }
 requestTask.resume()
 }
 */
