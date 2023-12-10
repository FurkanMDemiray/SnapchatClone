//
//  UploadViewController.swift
//  SnapchatClone
//
//  Created by Melik Demiray on 8.12.2023.
//

import UIKit
import Firebase
import FirebaseStorage

class UploadViewController: UIViewController, UIImagePickerControllerDelegate & UINavigationControllerDelegate {

    @IBOutlet weak var imageView: UIImageView!
    let makeAlert = MakeAlert()


    override func viewDidLoad() {
        super.viewDidLoad()

        imageView.isUserInteractionEnabled = true
        let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(chooseImage))
        imageView.addGestureRecognizer(gestureRecognizer)
        getUserInfo()
    }


    @IBAction func uploadButtonClilcked(_ sender: Any) {

        guard let imageData = imageView.image!.jpegData(compressionQuality: 0.5) else {
            let alert = self.makeAlert.makeAlert(titleInput: "Error", messageInput: "Image Error")
            self.present(alert, animated: true, completion: nil)
            return
        }

        let storage = Storage.storage()
        let storageRef = storage.reference()

        // Resim için benzersiz bir isim oluşturun
        let imageName = UUID().uuidString
        let imageRef = storageRef.child("images/\(imageName).jpg")

        // Resmi Storage'a yükleyin

        let metadata = StorageMetadata()
        metadata.contentType = "image/jpeg"

        imageRef.putData(imageData, metadata: metadata) { (metadata, error) in
            if let metadata = metadata {
                imageRef.downloadURL { url, error in
                    if let error = error {
                        let alert = self.makeAlert.makeAlert(titleInput: "Error", messageInput: error.localizedDescription)
                        self.present(alert, animated: true, completion: nil)
                    } else {
                        let imageUrl = url?.absoluteString
                        let db = Firestore.firestore()

                        db.collection("Snaps").whereField("snapOwner", isEqualTo: UserSingleton.sharedUserInfo.username).getDocuments { snapshot, error in
                            if let error = error {
                                let alert = self.makeAlert.makeAlert(titleInput: "Error", messageInput: error.localizedDescription)
                                self.present(alert, animated: true, completion: nil)
                            } else {

                                if snapshot?.isEmpty == false && snapshot != nil {

                                    for document in snapshot!.documents {

                                        let documentId = document.documentID

                                        if var imageUrlArray = document.get("imageUrlArray") as? [String] {
                                            imageUrlArray.append(imageUrl!)

                                            let additionalDictionary = ["imageUrlArray": imageUrlArray] as [String: Any]

                                            db.collection("Snaps").document(documentId).setData(additionalDictionary, merge: true) { error in
                                                if let error = error {
                                                    let alert = self.makeAlert.makeAlert(titleInput: "Error", messageInput: error.localizedDescription)
                                                    self.present(alert, animated: true, completion: nil)
                                                } else {

                                                }
                                            }
                                        }
                                    }
                                } else {
                                    let snapDictionary = [
                                        "imageUrlArray": [imageUrl!],
                                        "snapOwner": UserSingleton.sharedUserInfo.username,
                                        "date": FieldValue.serverTimestamp(),
                                        "email": Auth.auth().currentUser!.email!,
                                        "timeDifference": FieldValue.serverTimestamp()] as [String: Any]

                                    db.collection("Snaps").addDocument(data: snapDictionary) { (error) in
                                        if error != nil {
                                            let alert = self.makeAlert.makeAlert(titleInput: "Error", messageInput: error?.localizedDescription ?? "Error")
                                            self.present(alert, animated: true, completion: nil)
                                        } else {
                                            self.tabBarController?.selectedIndex = 0
                                            //self.imageView.image = UIImage(named: "select.png")
                                        }

                                    }
                                }

                            }
                        }
                    }
                }
            }
            else {
                let alert = self.makeAlert.makeAlert(titleInput: "Error", messageInput: error?.localizedDescription ?? "Error")
                self.present(alert, animated: true, completion: nil)
            }
            // Yükleme işlemi başarıyla tamamlandı
            let alert = self.makeAlert.makeAlert(titleInput: "Success", messageInput: "Image Uploaded")
            self.present(alert, animated: true, completion: nil)
        }
    }

    func getUserInfo() {

        let firestoreDb = Firestore.firestore()

        firestoreDb.collection("UserInfo").whereField("email", isEqualTo: Auth.auth().currentUser!.email!).getDocuments { snapshot, error in

            if let error = error {
                let alert = self.makeAlert.makeAlert(titleInput: "Error", messageInput: error.localizedDescription)
                self.present(alert, animated: true, completion: nil)
            } else {

                if snapshot?.isEmpty == false && snapshot != nil {

                    for document in snapshot!.documents {

                        if let userName = document.get("username") as? String {

                            UserSingleton.sharedUserInfo.username = userName
                            UserSingleton.sharedUserInfo.email = Auth.auth().currentUser!.email!
                        }

                    }

                }

            }
        }

    }

    @objc func chooseImage() {
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.sourceType = .photoLibrary
        self.present(picker, animated: true, completion: nil)

    }

    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {

        imageView.image = info[.originalImage] as? UIImage
        self.dismiss(animated: true, completion: nil)
    }

}
