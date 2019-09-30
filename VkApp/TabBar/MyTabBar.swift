//
//  MyTabBar.swift
//  VkApp
//
//  Created by Anton Fomkin on 19/05/2019.
//  Copyright © 2019 Anton Fomkin. All rights reserved.
//

import UIKit

final class MyTabBar: UITabBarController {

    override func viewDidLoad() {
        DispatchQueue.main.async { [weak self] in
  
            let myTabBarItem1 = (self?.tabBar.items?[0])! as UITabBarItem
            myTabBarItem1.image = UIImage(named: "friend")?.withRenderingMode(UIImage.RenderingMode.alwaysOriginal)
            myTabBarItem1.selectedImage = UIImage(named: "friend")?.withRenderingMode(UIImage.RenderingMode.alwaysOriginal)
            myTabBarItem1.title = "Друзья"
            myTabBarItem1.imageInsets = UIEdgeInsets(top: 0, left: 0, bottom: -6, right: 0)

            let myTabBarItem2 = (self?.tabBar.items?[1])! as UITabBarItem
            myTabBarItem2.image = UIImage(named: "group")?.withRenderingMode(UIImage.RenderingMode.alwaysOriginal)
            myTabBarItem2.selectedImage = UIImage(named: "group")?.withRenderingMode(UIImage.RenderingMode.alwaysOriginal)
            myTabBarItem2.title = "Группы"
            myTabBarItem2.imageInsets = UIEdgeInsets(top: 0, left: 0, bottom: -6, right: 0)
            
            let myTabBarItem3 = (self?.tabBar.items?[2])! as UITabBarItem
            myTabBarItem3.image = UIImage(named: "news")?.withRenderingMode(UIImage.RenderingMode.alwaysOriginal)
            myTabBarItem3.selectedImage = UIImage(named: "news")?.withRenderingMode(UIImage.RenderingMode.alwaysOriginal)
            myTabBarItem3.title = "Новости"
            myTabBarItem3.imageInsets = UIEdgeInsets(top: 0, left: 0, bottom: -6, right: 0)
        }
    }
}
