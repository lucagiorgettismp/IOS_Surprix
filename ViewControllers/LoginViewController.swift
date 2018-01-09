//
//  LoginViewController.swift
//  Surprix
//
//  Created by Administrator on 29/12/2017.
//  Copyright © 2017 Luca Giorgetti. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth

class LoginViewController: UIViewController {
    @IBOutlet weak var emailInput: UITextField!
    @IBOutlet weak var pwdInput: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if Auth.auth().currentUser != nil {
            let ref = Database.database().reference()
            let emailCod = Auth.auth().currentUser?.email?.replacingOccurrences(of: ".", with: ",")
            
            ref.child("emails").child(emailCod!).observeSingleEvent(of: .value, with: { (snap) in
                for child in snap.children.allObjects{
                    let c = child as! DataSnapshot
                    let username = c.key
                    Variables.username = username
                    let controller = self.storyboard?.instantiateViewController(withIdentifier: "TabBarController")
                    self.present(controller!, animated: true, completion: nil)
                }
            })
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func submitLogin(sender: AnyObject)   {
        let email = self.emailInput.text
        let pass = self.pwdInput.text
        
        Auth.auth().signIn(withEmail: email!, password: pass!, completion: { (user, err) in
            if (err == nil){
                print("Login ok")
                let ref = Database.database().reference()
                let emailCod = email?.replacingOccurrences(of: ".", with: ",")
                ref.child("emails").child(emailCod!).observeSingleEvent(of: .value, with: { (snap) in
                    for child in snap.children.allObjects{
                        let c = child as! DataSnapshot
                        let username = c.key
                        Variables.username = username
                        let controller = self.storyboard?.instantiateViewController(withIdentifier: "TabBarController")
                        self.present(controller!, animated: true, completion: nil)
                    }
                })
            }
            else {
                print("Bad login: email: " + email! + " pwd: " + pass!)
            }
        })
    }
}

