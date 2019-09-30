//
//  VKService.swift
//  VkApp
//
//  Created by Anton Fomkin on 08/07/2019.
//  Copyright © 2019 Anton Fomkin. All rights reserved.
//

import UIKit
import RealmSwift

fileprivate func getImage(url : URL, completionBlock: @escaping (UIImage) -> ()){
    
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

fileprivate func getCurrentSession (idFriend: String?,findGroupsToName: String?,typeOfContent: TypeOfRequest) -> (URLSession,URLRequest) {
    
    let auth = Session.instance
    let configuration = URLSessionConfiguration.default
    let session =  URLSession(configuration: configuration)
    
    var urlComponents = URLComponents()
    urlComponents.scheme = "https"
    urlComponents.host = "api.vk.com"
    let apiVKVersion = URLQueryItem(name: "v", value: "5.101")
    
    switch typeOfContent {
        
    case .getGroups:
        
        urlComponents.path = "/method/groups.get"
        urlComponents.queryItems = [
            URLQueryItem(name: "user_id", value: auth.userId),
            URLQueryItem(name: "access_token", value: auth.token),
            URLQueryItem(name: "extended", value: "1"),
            apiVKVersion
        ]
        
    case .getFriends:
        
        urlComponents.path = "/method/friends.get"
        urlComponents.queryItems = [
            URLQueryItem(name: "user_id", value: auth.userId),
            URLQueryItem(name: "access_token", value: auth.token),
            URLQueryItem(name: "fields", value: "domain,photo_100,photo_200_orig"),
            URLQueryItem(name: "order", value: "name"),
            apiVKVersion
        ]
        
    case .getNews:
        
        urlComponents.path = "/method/newsfeed.get"
        urlComponents.queryItems = [
            URLQueryItem(name: "user_id", value: auth.userId),
            URLQueryItem(name: "access_token", value: auth.token),
            URLQueryItem(name: "filters", value: "post,photo"),
            apiVKVersion
        ]
        
    case .getSwiftGroup:
        urlComponents.path = "/method/groups.search"
        urlComponents.queryItems = [
            URLQueryItem(name: "user_id", value: auth.userId),
            URLQueryItem(name: "access_token", value: auth.token),
            URLQueryItem(name: "q", value: "apple swift"),
            apiVKVersion
        ]
    case .getFindGroups:
        urlComponents.path = "/method/groups.search"
        urlComponents.queryItems = [
            URLQueryItem(name: "user_id", value: auth.userId),
            URLQueryItem(name: "access_token", value: auth.token),
            URLQueryItem(name: "q", value: findGroupsToName),
            apiVKVersion
        ]
    case .getPhotoAlbumCurrentFriend:
        urlComponents.path = "/method/photos.getAll"
        urlComponents.queryItems = [
            URLQueryItem(name: "user_id", value: auth.userId),
            URLQueryItem(name: "access_token", value: auth.token),
            URLQueryItem(name: "owner_id", value: idFriend), //"15571026"
            URLQueryItem(name: "extended", value: "0"),
            URLQueryItem(name: "skip_hidden", value: "1"),
            URLQueryItem(name: "no_service_albums", value: "0"),
            URLQueryItem(name: "photo_sizes", value: "0"),
            apiVKVersion
        ]
    }
    
    let request = URLRequest(url: urlComponents.url!)
    return (session, request)
}


func parseJSONGroupsVK (for startPoint : [String: AnyObject]?) -> [CellPresenter] {
    
    var cellPresenters : [CellPresenter] = []
    
    let responce = startPoint?["response"] as? [String: AnyObject]
    guard responce != nil else { return cellPresenters }
    
    let finalObject = responce?["items"] as? [Any]
    guard let finalObj = finalObject else { return cellPresenters }
    
    for myGroup in finalObj {
        let myGroup  = myGroup as? [String: Any]
        let groupName = myGroup?["name"] as? String
        guard groupName != nil else { return cellPresenters }
        let urlFoto = myGroup?["photo_100"] as? String
        guard urlFoto != nil else { return cellPresenters }
 
        let cellPresenter = CellPresenter(idFriend: "", text: groupName!,widthPhoto: 0, heightPhoto: 0, imageURLString: urlFoto!, imageLargeURLString: nil)
        cellPresenters.append(cellPresenter)
    }
    return cellPresenters
}


fileprivate func parseJSONNewsVK (for startPoint : [String: AnyObject]?) -> [CellPresenter] {
    
    var cellPresenters : [CellPresenter] = []
    let screenWidth = Int(UIScreen.main.bounds.width)
    let responce = startPoint?["response"] as? [String: AnyObject]
    guard responce != nil else { return cellPresenters }
    
    let arrItems = responce?["items"] as? [AnyObject]
    guard arrItems != nil else { return cellPresenters }
    
    for valueItem in arrItems!  {
        
        var widthFoto : Int = 0
        var heightFoto : Int = 0
        var urlFoto : String? = nil
        let valueItem  = valueItem as? [String: Any]
        guard valueItem != nil else { return cellPresenters }
        
        if  valueItem?["text"] == nil {continue}
        let textNews = valueItem?["text"] as? String
        if  textNews == nil {continue}
               
        if  !(valueItem?.keys.contains("attachments"))! {continue}
        
        let arrAttach = valueItem?["attachments"] as? [AnyObject]
        guard let arrAttachments = arrAttach else { return cellPresenters }
        
        for valueAtt in arrAttachments {
            let valueAtt = valueAtt as? [String: Any]
            guard valueAtt != nil else { return cellPresenters }
            let typeAtt = valueAtt?["type"] as? String
            guard typeAtt != nil else { return cellPresenters }
            
            if typeAtt == "photo" {
                let photo = valueAtt?["photo"] as? [String: Any]
                guard photo != nil else { return cellPresenters }
            
                let sizesPh = photo?["sizes"] as? [AnyObject]
                guard let sizesPhoto = sizesPh else { return cellPresenters }
                
                for currentFoto in sizesPhoto {
                    let currentFoto = currentFoto as? [String: Any]
                    guard currentFoto != nil else { return cellPresenters }
                    let uFoto = currentFoto?["url"] as? String
                    let wFoto = currentFoto?["width"] as? Int
                    let hFoto = currentFoto?["height"] as? Int
                    guard uFoto != nil && wFoto != nil && hFoto != nil  else { return cellPresenters }
                    
                    if wFoto == 0 && hFoto == 0 {continue}
                     
                    if wFoto! <= screenWidth {
                        if wFoto! > widthFoto {
                            widthFoto = wFoto!
                            heightFoto = hFoto!
                            urlFoto = uFoto!
                        }
                    }
                }
                guard let urlPhoto = urlFoto else {continue}
                let cellPresenter = CellPresenter(idFriend: "",text: textNews!,widthPhoto: widthFoto, heightPhoto: heightFoto, imageURLString: urlPhoto, imageLargeURLString: nil)
                cellPresenters.append(cellPresenter)
                
                break //arrAttachments
            }
        }
    }
    
    return cellPresenters
}


fileprivate func parseJSONFriendsVK (for startPoint : [String: AnyObject]?) -> ([CellPresenter],[UsersVK]) {
    
    var cellPresenters : [CellPresenter] = []
    var arr : [UsersVK] = []
    
    let responce = startPoint?["response"] as? [String: AnyObject]
    guard responce != nil else { return (cellPresenters,arr) }
    let finalObj = responce?["items"] as? [Any]
    guard let finalObject = finalObj else { return (cellPresenters,arr) }
  
    for myUsers in finalObject {
        let myUsers  = myUsers as? [String: Any]
        guard myUsers != nil else { return (cellPresenters,arr) }
         
        let firstName = myUsers?["first_name"] as? String
        guard firstName != nil else { return (cellPresenters,arr) }
        let lastName = myUsers?["last_name"] as? String
        guard lastName != nil else { return (cellPresenters,arr) }
        let idFriend = myUsers?["id"] as? Int
        
        guard idFriend != nil else { return (cellPresenters,arr) }
        let urlPhoto = myUsers?["photo_100"] as? String
        guard urlPhoto != nil else { return (cellPresenters,arr) }
        let urlLargePhoto = myUsers?["photo_200_orig"] as? String
        guard urlLargePhoto != nil else { return (cellPresenters,arr) }
        
        arr.append(UsersVK(name: firstName! + " " + lastName!, foto: nil))

        let cellPresenter = CellPresenter(idFriend: String(idFriend!),text: firstName! + " " + lastName!,widthPhoto: 0, heightPhoto: 0, imageURLString: urlPhoto!, imageLargeURLString: urlLargePhoto)
        cellPresenters.append(cellPresenter)
        
    }
    
    return (cellPresenters,arr)
}

fileprivate func parseJSONPhotoCurrentFriend (for startPoint : [String: AnyObject]?) -> [CellPresenter] {
    
    var cellPresenters : [CellPresenter] = []
    let screenWidth = Int(UIScreen.main.bounds.width)
    let responce = startPoint?["response"] as? [String: AnyObject]
    let arrItems = responce?["items"] as? [AnyObject]
    
   guard let _ = responce, let _ = arrItems else {return cellPresenters}
    
    for valueItem in arrItems!  {
                  
        var widthFoto : Int = 0
        var heightFoto : Int = 0
        var urlFoto : String? = nil
        let valueItem  = valueItem as? [String: Any]
        guard valueItem != nil else { return cellPresenters }
         
        if !(valueItem?.keys.contains("sizes"))! {continue}
        
        let arrAttach = valueItem?["sizes"] as? [AnyObject]
        guard let arrAttachments = arrAttach else { return cellPresenters }
        
        for valueAtt in arrAttachments {
            let valueAtt = valueAtt as? [String: Any]
            guard valueAtt != nil else { return cellPresenters }

            let uFoto = valueAtt?["url"] as? String
            let wFoto = valueAtt?["width"] as? Int
            let hFoto = valueAtt?["height"] as? Int
            guard uFoto != nil && wFoto != nil && hFoto != nil  else { return cellPresenters }
            
            if wFoto == 0 && hFoto == 0 {continue}
            
            if wFoto! <= screenWidth {
                if wFoto! > widthFoto {
                    widthFoto = wFoto!
                    heightFoto = hFoto!
                    urlFoto = uFoto!
                }
            }
        }
        guard let urlPhoto = urlFoto else {continue}
        let cellPresenter = CellPresenter(idFriend: "",text: "",widthPhoto: widthFoto, heightPhoto: heightFoto, imageURLString: urlPhoto,imageLargeURLString: nil)
                cellPresenters.append(cellPresenter)
    }
    
    return cellPresenters
}


func getDataFromVK (idFriend: String?,findGroupsToName: String?, typeOfContent: TypeOfRequest, completionBlock: @escaping ([CellPresenter],[UsersVK]) -> ()) {
    
    var arr : [UsersVK] = []
    var cellPresenters : [CellPresenter] = []

    let currentSession = getCurrentSession(idFriend: idFriend,findGroupsToName: findGroupsToName, typeOfContent: typeOfContent)
    let session = currentSession.0
    let request = currentSession.1
    
    let requestTask = session.dataTask(with: request) { (data: Data?, response: URLResponse?, error: Error?) in
        guard let data = data, error == nil else { return }
        
        DispatchQueue.global().async() { 
            
            let jsn = try? JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.allowFragments)
            guard let json = jsn else { return }
            
            let startPoint = json as? [String: AnyObject]
            guard startPoint != nil else { return }
            
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

fileprivate func getCurrentFoto(completionBlock: @escaping ([FotoCurrentUser]) -> ()) {
    
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

