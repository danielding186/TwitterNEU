//
//  UsewrProfileViewController.swift
//  TwitterNEU
//
//  Created by Ashish on 11/7/19.
//  Copyright © 2019 Ashish. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseStorage

class UserProfileViewController: UIViewController , UIImagePickerControllerDelegate, UINavigationControllerDelegate{

    @IBOutlet weak var imgView: UIImageView!
    
    @IBOutlet weak var txtName: UITextField!
    
    @IBOutlet weak var txtEmail: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        txtName.text =  Auth.auth().currentUser?.displayName
        txtEmail.text = Auth.auth().currentUser?.email
        
        getProfilePicture()

        // Do any additional setup after loading the view.
    }
    func getProfilePicture(){
        guard let uid = Auth.auth().currentUser?.uid else {return}
        let profileImgReference = Storage.storage().reference().child("profile_image").child("\(uid).png")
       
        // Download in memory with a maximum allowed size of 1MB (1 * 1024 * 1024 bytes)
        profileImgReference.getData(maxSize: 10 * 1024 * 1024) { data, error in
          if let error = error {
            print("Error in getting file\(error)")
          } else {
            // Data for "images/island.jpg" is returned
            let image = UIImage(data: data!)
            self.imgView.image = image
          }
        }
        
    }
    
    @IBAction func addPicture(_ sender: Any) {
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerController.SourceType.photoLibrary) {
            let imagePicker = UIImagePickerController()
            imagePicker.delegate = self
            imagePicker.sourceType = UIImagePickerController.SourceType.photoLibrary
            imagePicker.allowsEditing = false
            self.present(imagePicker, animated: true, completion: nil)
        }
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        
        if let pickedImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            //imgView.contentMode = .scaleToFill
            imgView.image = pickedImage
        }
        picker.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func update(_ sender: Any) {
        uploadProfilePicture()
    }
    
   
    
    func uploadProfilePicture(){
           guard let image = imgView.image else {return }
           guard let uid = Auth.auth().currentUser?.uid else {return}
           guard let imageData = image.jpegData(compressionQuality: 0.5) else {return}
           let profileImgReference = Storage.storage().reference().child("profile_image").child("\(uid).png")
           let uploadTask = profileImgReference.putData(imageData, metadata: nil) { (metadata,error) in
               if let error = error {
                       print(error.localizedDescription)
               }else{
                    self.navigationController?.popViewController(animated: true)
               }
           }
//           uploadTask.observe(.progress, handler: { (snapshot) in
//            guard let imageURL = snapshot.metadata?.storageReference?.downloadURL(completion: { (url, error) in if error != nil {
//                    print(error as Any)
//                } else {
//
//                }
//            })
//                   else { return }
//
//           })
           
       }
}
