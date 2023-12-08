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

        let uploadTask = imageRef.putData(imageData, metadata: metadata) { (metadata, error) in
            guard let metadata = metadata else {
                let alert = self.makeAlert.makeAlert(titleInput: "Error", messageInput: error?.localizedDescription ?? "Error")
                self.present(alert, animated: true, completion: nil)
                return
            }
            // Yükleme işlemi başarıyla tamamlandı
            let alert = self.makeAlert.makeAlert(titleInput: "Success", messageInput: "Image Uploaded")
            self.present(alert, animated: true, completion: nil)
        }

        // İlerleme durumunu takip etmek için bir observer ekleyin (isteğe bağlı)
        uploadTask.observe(.progress) { snapshot in
            let percentComplete = 100.0 * Double(snapshot.progress!.completedUnitCount) / Double(snapshot.progress!.totalUnitCount)
            print("Yükleme tamamlandı: \(percentComplete)%")
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
