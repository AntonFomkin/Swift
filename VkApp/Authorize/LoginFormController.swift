//
//  LoginFormController.swift
//  VkApp
//
//  Created by Anton Fomkin on 16/05/2019.
//  Copyright © 2019 Anton Fomkin. All rights reserved.
//

import UIKit


class LoginFormController: UIViewController {

    
    // MARK: Outlets
    @IBOutlet weak var loginText: UITextField!
    @IBOutlet weak var passwordText: UITextField!
    @IBOutlet weak var scroll: UIScrollView!
    
    // MARK: Actions
    @IBAction func loginButtonPressed(_ sender: UIButton) {
        checkLoginAndPassword()
    }
    
    // MARK: Check User
    func checkLoginAndPassword ()  {
        
        let login = loginText.text!
        let password = passwordText.text!
        
        if login == "admin" && password == "123456" {
            performSegue(withIdentifier: "gotoTabBar", sender: nil)
            print("успешная авторизация")
        } else {
            showLoginError()
            print("неуспешная авторизация")
        }
    }
 
    func showLoginError() {
        // Создаем контроллер
        let alter = UIAlertController(title: "Ошибка", message: "Введены не верные данные пользователя", preferredStyle: .alert)
        // Создаем кнопку для UIAlertController
        let action = UIAlertAction(title: "OK", style: .cancel, handler: nil)
        // Добавляем кнопку на UIAlertController
        alter.addAction(action)
        // Показываем UIAlertController
        present(alter, animated: true, completion: nil)
    }

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // жест нажатия
        let hideKeyboardGesture = UITapGestureRecognizer(target: self, action: #selector(hideKeyboard))
        // присваиваем его UIScrollVIew
        scroll?.addGestureRecognizer(hideKeyboardGesture)
     
       // MARK: Настройка дизайна Navigator & TabBar
        let navigationBarAppearance = UINavigationBar.appearance()
        navigationBarAppearance.tintColor = UIColor.white
//        navigationBarAppearance.barTintColor = UIColor(red: 87.0/255.0, green: 188.0/255.0, blue: 95.0/255.0, alpha: 1.0)
        navigationBarAppearance.barTintColor = UIColor.appTitleButton
       
        
        
        let tabBarAppearance = UITabBar.appearance()
        tabBarAppearance.tintColor = UIColor.white
        tabBarAppearance.barTintColor = UIColor.appTitleButton

        
    }

   
    // MARK: Keyboard
    // Когда клавиатура появляется
    @objc func keyboardWasShown(notification: Notification) {
        
        // Получаем размер клавиатуры
        let info = notification.userInfo! as NSDictionary
        let kbSize = (info.value(forKey: UIResponder.keyboardFrameEndUserInfoKey) as! NSValue).cgRectValue.size
        let contentInsets = UIEdgeInsets(top: 0.0, left: 0.0, bottom: kbSize.height, right: 0.0)
        
        // Добавляем отступ внизу UIScrollView, равный размеру клавиатуры
        self.scroll?.contentInset = contentInsets
        scroll?.scrollIndicatorInsets = contentInsets
    }
    
    //Когда клавиатура исчезает
    @objc func keyboardWillBeHidden(notification: Notification) {
        // Устанавливаем отступ внизу UIScrollView, равный 0
        let contentInsets = UIEdgeInsets.zero
        scroll?.contentInset = contentInsets
        scroll?.scrollIndicatorInsets = contentInsets
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Подписываемся на два уведомления: одно приходит при появлении клавиатуры
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWasShown), name: UIResponder.keyboardWillShowNotification, object: nil)
        // Второе -- когда она пропадает
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillBeHidden(notification:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    @objc func hideKeyboard() {
        self.scroll?.endEditing(true)
    }

}


