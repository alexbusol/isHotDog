//
//  ViewController.swift
//  isHotDog
//
//  Created by Alex Busol on 7/7/18.
//  Copyright © 2018 Alex Busol. All rights reserved.
//

import UIKit
import CoreML
import Vision //helps to process images more easily.

class ViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    @IBOutlet weak var imageFromCamera: UIImageView!
    
    let imagePicker = UIImagePickerController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        imagePicker.delegate = self
        //imagePicker.sourceType = .camera //brings up an image picker that allows the user to take an image --USE WHEN TESTING ON THE DEVICE
        imagePicker.sourceType = .photoLibrary //allows the user to load a picture from their photo library -- USE IN SIMULATOR
        imagePicker.allowsEditing = false //dont allow the user to edit an image he or she took
    }
    
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) { //trigers once the user picked an image to work with.
        if  let userImage = info[UIImagePickerControllerOriginalImage] as? UIImage {//access the image that the user has taken
            imageFromCamera.image = userImage
        }
        
        imagePicker.dismiss(animated: true, completion: nil)
    }
    
    
    @IBAction func cameraPressed(_ sender: UIBarButtonItem) {
        present(imagePicker, animated: true, completion: nil)
    }
    
   

    
    
}

