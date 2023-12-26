//
//  DetailViewController.swift
//  MyAlbum
//
//  Created by Yogesh Rathore on 26/12/23.
//

import UIKit
import CoreData

class DetailViewController: UIViewController {

    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var locationTextField: UITextField!
    @IBOutlet weak var dateTextField: UITextField!
    @IBOutlet weak var saveButton: UIButton!
    
    var choosenAlbum = ""
    var choosenAlbumId = UUID()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        fetchData()
        
        let hideKeyboardGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(hideKeyBoard))
        self.view.addGestureRecognizer(hideKeyboardGestureRecognizer)
        
        imageView.isUserInteractionEnabled = true
        let imageViewTapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(selectImagePicker))
        imageView.addGestureRecognizer(imageViewTapGestureRecognizer)
    }
    
    func fetchData() {
        if choosenAlbum != "" {
            // Fetch from Core Data
            
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            let context = appDelegate.persistentContainer.viewContext
            
            let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Album")
            let idString = choosenAlbumId.uuidString
            fetchRequest.predicate = NSPredicate(format: "id = %@", idString)
            fetchRequest.returnsObjectsAsFaults = false
            
            do {
                let results = try context.fetch(fetchRequest)
                
                if results.count > 0 {
                    
                    for result in results as! [NSManagedObject] {
                        
                        if let name = result.value(forKey: "name") as? String {
                            nameTextField.text = name
                        }
                        
                        if let location = result.value(forKey: "location") as? String {
                            locationTextField.text = location
                        }
                        
                        if let date = result.value(forKey: "date") as? String {
                            dateTextField.text = date
                        }
                        
                        if let imageData = result.value(forKey: "image") as? Data {
                            let image = UIImage(data: imageData)
                            imageView.image = image
                        }
                    }
                }
            } catch {
                
            }
        } else {
            nameTextField.text = ""
            locationTextField.text = ""
            dateTextField.text = ""
        }
    }
    
    @objc func hideKeyBoard() {
        self.view.endEditing(true)
    }
    
    @objc func selectImagePicker() {
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.sourceType = .photoLibrary
        picker.allowsEditing = true
        present(picker, animated: true, completion: nil)
    }
    
    @IBAction func saveButtonDidTap(_ sender: Any) {
        print("Save")
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        
        let newAlbum = NSEntityDescription.insertNewObject(forEntityName: "Album", into: context)
        
        // insert Attribute
        
        newAlbum.setValue(nameTextField.text!, forKey: "name")
        newAlbum.setValue(locationTextField.text!, forKey: "location")
        newAlbum.setValue(dateTextField.text, forKey: "date")
        newAlbum.setValue(UUID(), forKey: "id")
        
        let data = imageView.image?.jpegData(compressionQuality: 0.5)
        newAlbum.setValue(data, forKey: "image")
        
        do {
            try context.save()
            print("Success")
        } catch {
            print("Error")
        }
        
        NotificationCenter.default.post(name: NSNotification.Name("newAlbumData"), object: nil, userInfo: nil)
        self.navigationController?.popViewController(animated: true)
    }

}

extension DetailViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        imageView.image = info[.originalImage] as? UIImage
        self.dismiss(animated: true)
    }
}
