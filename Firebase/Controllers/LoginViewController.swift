//
//  ViewController.swift
//  Firebase
//
//  Created by Денис on 19.08.2021.
//

import UIKit
import Firebase

class LoginViewController: UIViewController {
    

    
    @IBOutlet weak var logo: UIImageView!
    @IBOutlet weak var warnLabel: UILabel!
    @IBOutlet weak var emailTF: UITextField!
    @IBOutlet weak var passwordTF: UITextField!
    

    override func viewDidLoad() {
        super.viewDidLoad()
                
        NotificationCenter.default.addObserver(self, selector: #selector(kbDidShow), name: UIResponder.keyboardDidShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(kbDidHide), name: UIResponder.keyboardDidHideNotification, object: nil)
        warnLabel.alpha = 0
        
        Auth.auth().addStateDidChangeListener { [weak self] (auth, user) in
            self?.performSegue(withIdentifier: "tasksSegue", sender: nil)
        }
    }

    // delete entered texts
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        emailTF.text = ""
        passwordTF.text = ""
    }
    
    
    
    
    @objc func kbDidShow(notification: Notification) {
      
        guard let userInfo = notification.userInfo else { return }
     
        let kbFrameSize = (userInfo[UIResponder.keyboardFrameEndUserInfoKey] as! NSValue).cgRectValue
     
        (self.view as! UIScrollView).contentSize = CGSize(width: self.view.bounds.size.width, height: self.view.bounds.size.height + kbFrameSize.height)
        (self.view as! UIScrollView).scrollIndicatorInsets = UIEdgeInsets(top: 0, left: 0, bottom: kbFrameSize.height, right: 0)
        
    }
    
    @objc func kbDidHide() {
        (self.view as! UIScrollView).contentSize = CGSize(width: self.view.bounds.size.width, height: self.view.bounds.size.height)
    }
    
    
    @IBAction func loginTapped(_ sender: UIButton) {
        
        guard let email = emailTF.text, let password = passwordTF.text, email != "", password != "" else {
            
            displayWarningLabel(withText: "Неверные данные!")
            return
        }
        Auth.auth().signIn(withEmail: email, password: password, completion: { [weak self] (user, error) in
            if error != nil {
                self?.displayWarningLabel(withText: "Ошибка!")
                return
            }
            if user != nil {
                self?.performSegue(withIdentifier: "tasksSegue", sender: nil)
                return
            }
            self?.displayWarningLabel(withText: "Пользователь не существует!")
        })
    }
    
    func displayWarningLabel(withText text: String) {
        
        warnLabel.text = text
        UIView.animate(withDuration: 2, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .allowAnimatedContent, animations: { [weak self] in
            self?.warnLabel.alpha = 1
        }) { [weak self] complete in
            self?.warnLabel.alpha = 1
        }

        
    }
    
    
    @IBAction func registerTapped(_ sender: UIButton) {
        
        guard let email = emailTF.text, let password = passwordTF.text, email != "", password != "" else {
            
            displayWarningLabel(withText: "Неверные данные!")
            return
    }
    
        Auth.auth().createUser(withEmail: email, password: password, completion: { ( user, error) in
            if error == nil {
                if user != nil {
                } else {
                    print("Пользователь не создан!")
                }
            } else {
                print(error!.localizedDescription)
            }
        })
    
}
}

