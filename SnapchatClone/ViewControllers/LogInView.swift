//
//  ViewController.swift
//  SnapchatClone
//
//  Created by Melik Demiray on 8.12.2023.
//

import UIKit
import Firebase
import FirebaseAuth


class LogInView: UIViewController {

    @IBOutlet weak var mailText: UITextField!
    @IBOutlet weak var userNameText: UITextField!
    @IBOutlet weak var passwordText: UITextField!

    let makeAlert = MakeAlert()


    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    @IBAction func logInButtonClicked(_ sender: Any) {

        if let mail = mailText.text, let password = passwordText.text {

            Auth.auth().signIn(withEmail: mail, password: password) { (authResult, error) in
                if let error = error {
                    let alert = self.makeAlert.makeAlert(titleInput: "Error", messageInput: error.localizedDescription)
                    self.present(alert, animated: true, completion: nil)
                } else {
                    //let alert = self.makeAlert.makeAlert(titleInput: "Success", messageInput: "User Created")
                    //self.present(alert, animated: true, completion: nil)
                    self.performSegue(withIdentifier: "toTabBar", sender: nil)
                }
            }
        }
    }


    @IBAction func registerButtonClicked(_ sender: Any) {

        if let mail = mailText.text, let password = passwordText.text, let userName = userNameText.text {

            Auth.auth().createUser(withEmail: mail, password: password) { (authResult, error) in
                if let error = error {
                    let alert = self.makeAlert.makeAlert(titleInput: "Error", messageInput: error.localizedDescription)
                    self.present(alert, animated: true, completion: nil)
                } else {

                    let firestore = Firestore.firestore()
                    let userDictionary = ["email": mail, "username": userName] as [String: Any]

                    firestore.collection("UserInfo").addDocument(data: userDictionary) { (error) in
                        if let error = error {
                            let alert = self.makeAlert.makeAlert(titleInput: "Error", messageInput: error.localizedDescription)
                            self.present(alert, animated: true, completion: nil)
                        }
                    }

                    let alert = self.makeAlert.makeAlert(titleInput: "Success", messageInput: "User Created")
                    self.present(alert, animated: true, completion: nil)
                    self.performSegue(withIdentifier: "toTabBar", sender: nil)
                }
            }
        }




    }

}

