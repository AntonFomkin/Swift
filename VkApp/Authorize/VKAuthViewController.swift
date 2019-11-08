//
//  VKAuthViewController.swift
//  VkApp
//
//  Created by Anton Fomkin on 01/07/2019.
//  Copyright © 2019 Anton Fomkin. All rights reserved.
//

import UIKit
import WebKit


class Session {
    
    static let instance = Session()
    
    private init(){}
    
    var token : String? = nil
    var userId : String? = nil
}


class VKAuthViewController: UIViewController {
    
    @IBOutlet weak var webview: WebView! {
        didSet  {
            webview.navigationDelegate = self
        }
    }
    
    let userDefaults = UserDefaults.standard
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // logoutVK()
        authorize()
        
        // MARK: Настройка дизайна Navigator & TabBar
        let navigationBarAppearance = UINavigationBar.appearance()
        navigationBarAppearance.tintColor = UIColor.white
        navigationBarAppearance.barTintColor = UIColor.appNavBarTintColor
        
        
        let tabBarAppearance = UITabBar.appearance()
        tabBarAppearance.tintColor = UIColor.white
        tabBarAppearance.barTintColor = UIColor.appNavBarTintColor
    }
    
    
    // MARK: Получаем данные через API VK (авторизация)
    private func authorize() {
        
        var urlComponents = URLComponents()
        urlComponents.scheme = "https"
        urlComponents.host = "oauth.vk.com"
        urlComponents.path = "/authorize"
        urlComponents.queryItems = [
            URLQueryItem(name: "client_id", value: "7052320" ), //"7052738"// "7052320"//"7039872"
            URLQueryItem(name: "display", value: "mobile"),
            URLQueryItem(name: "redirect_uri", value: "https://oauth.vk.com/blank.html"),
            URLQueryItem(name: "scope", value: "wall,friends,photos"), /*262150, */
            URLQueryItem(name: "response_type", value: "token"),
            URLQueryItem(name: "state", value: "123456")//,

        ]
        
        let request = URLRequest(url: urlComponents.url!)
        webview.load(request)
    }
    
    private func logoutVK() {
        let dataStore = WKWebsiteDataStore.default()
        dataStore.fetchDataRecords(ofTypes: WKWebsiteDataStore.allWebsiteDataTypes()) { records in
            dataStore.removeData(
                ofTypes: WKWebsiteDataStore.allWebsiteDataTypes(),
                for: records.filter { $0.displayName.contains("vk")},
                completionHandler: { }
            )
        }
        
    }
    
}

extension VKAuthViewController: WKNavigationDelegate {
    func webView(_ webView: WKWebView, decidePolicyFor navigationResponse: WKNavigationResponse, decisionHandler: @escaping (WKNavigationResponsePolicy) -> Void) {
        
        guard let url = navigationResponse.response.url, url.path == "/blank.html", let fragment = url.fragment  else {
            decisionHandler(.allow)
            return
        }
        
        let params = fragment
            .components(separatedBy: "&")
            .map { $0.components(separatedBy: "=") }
            .reduce([String: String]()) { result, param in
                var dict = result
                let key = param[0]
                let value = param[1]
                dict[key] = value
                return dict
        }
        
        let token = params["access_token"]
        let idUser = params["user_id"]
        let auth = Session.instance
        auth.token = token
        auth.userId = idUser!
        userDefaults.set(auth.userId, forKey: "userId")
        let userId : String? = userDefaults.string(forKey: "userId")
        print("userId = \(userId!)")
        
        KeychainWrapper.standard.set(token!, forKey: "myToken")
        let myToken : String? = KeychainWrapper.standard.string(forKey: "myToken")
        print("token = \(myToken!)")
        
        decisionHandler(.cancel)
        performSegue(withIdentifier: "gotoTab", sender: nil)
    }
}

