//
//  SettingsViewController.swift
//  SnapchatClone
//
//  Created by Melik Demiray on 8.12.2023.
//

import UIKit
import Firebase

class SettingsViewController: UIViewController {

    let makeAlert = MakeAlert()

    override func viewDidLoad() {
        super.viewDidLoad()


    }


    @IBAction func logOutClicked(_ sender: Any) {

        do {

            try Auth.auth().signOut()
            performSegue(withIdentifier: "toSignInVC", sender: nil)

        } catch {

            let alert = makeAlert.makeAlert(titleInput: "Error", messageInput: "Error")
            self.present(alert, animated: true, completion: nil)
        }


    }
}
