//
//  AddPostViewController.swift
//  DevConGram
//
//  Created by Antoine Bellanger on 06.04.18.
//  Copyright © 2018 Antoine Bellanger. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabase
import FirebaseStorage

class AddPostViewController: UIViewController, UITextFieldDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    @IBOutlet var titleTextField: UITextField!
    @IBOutlet var previewImageView: UIImageView!
    @IBOutlet var choosePictureButton: UIButton!
    
    var imagePickerController = UIImagePickerController()
    var pickedImage = UIImage()
    
    var imageChosen = false

    override func viewDidLoad() {
        super.viewDidLoad()

        titleTextField.placeholder = " Post Title"
        titleTextField.delegate = self
        
        navigationController?.navigationBar.tintColor = UIColor(red: 3/255, green: 104/255, blue: 55/255, alpha: 1)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK: UITextDelegate
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        textField.text! = " "
        
        return true
    }
    
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        if textField.text! == "" {
            textField.text! = " "
        }
        
        return true
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        
        return true
    }
    
    //MARK: UIImagePickerControllerDelegate
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let image = info[UIImagePickerControllerEditedImage] as? UIImage {
            pickedImage = image
            previewImageView.image = image
            imageChosen = true
            }
        
        dismiss(animated: true, completion: nil)
    }
    
    //MARK: IBAction
    
    @IBAction func choosePicture(_ sender: UIButton) {
        imagePickerController = UIImagePickerController()
        imagePickerController.allowsEditing = true
        imagePickerController.sourceType = .photoLibrary
        imagePickerController.delegate = self
        present(imagePickerController, animated: true, completion: nil)
    }
    
    @IBAction func publish(_ sender: UIBarButtonItem) {
        
        if imageChosen != true {
            let alertController = UIAlertController(title: "Hey !", message: "Please add a picture !", preferredStyle: .alert)
            alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(alertController, animated: true, completion: nil)
            return
        }
        
        //1. Store the image
        let storage = Storage.storage()
        
        var imageURL: URL!
        
        var data = Data()
        data = UIImagePNGRepresentation(pickedImage)!
        
        let storageReference = storage.reference()
        let imageRef = storageReference.child("images/\(UUID()).jpg")
        imageRef.putData(data, metadata: nil) { (metadata, error) in
            guard let metadata = metadata else {
                // Uh-oh, an error occurred!
                return
            }
            
            imageURL = metadata.downloadURL()
            
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "h:mm a"
            let currentDate = dateFormatter.string(from: Date())
            
            let ref = Database.database().reference()
            ref.child("posts").childByAutoId().setValue(["title": self.titleTextField.text ?? "No Caption", "image_url": String(describing: imageURL!), "email": Auth.auth().currentUser?.email!, "emojis": [:], "published_at": currentDate])
        
            self.performSegue(withIdentifier: "unwindToPostsViewController", sender: self)
  
        }
        
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
