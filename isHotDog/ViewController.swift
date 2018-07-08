//
//  ViewController.swift
//  isHotDog
//
//  Created by Alex Busol on 7/7/18.
//  Copyright © 2018 Alex Busol. All rights reserved.
//

import UIKit
import CoreML
import Vision //allows us to process images using a selected CoreML model

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
            
            //convert ui image into CIimage, which stands for core image. used by core ml
            guard let ciimage = CIImage(image: userImage) else {
                fatalError("Could not convert UIImage to CIIimage")
            }
            
            detect(image: ciimage) //pass the image from the gallery for ML classification. at this point, the model will return a bunch of classifications with different levels of confidence.
        }
        
        imagePicker.dismiss(animated: true, completion: nil)
    }
    
    func detect(image: CIImage) {
        //will use InceptionV3 Model

        guard let model = try? VNCoreMLModel(for: Inceptionv3().model) else { //new object of inception v3. getting its model properties loaded.
            fatalError("Loading InceptionV3 CoreML model failed")
        }
        
        let mlrequest = VNCoreMLRequest(model: model) { (request, error) in ///code in completion block - when the request completed.need to process the results
            guard let results = request.results as? [VNClassificationObservation] else { fatalError("Error processing an image") } //holds classification observations after the model has been run
            
            //print(results) -- prints the image processing results to the console
            if let firstResult = results.first {
                if firstResult.identifier.contains("hotdog") { //now we can check if an image is a hotdog.
                    self.navigationItem.title = "Hotdog!"
                } else {
                    self.navigationItem.title = "Not Hotdog!"
                }
            }
        }
        
        let handler = VNImageRequestHandler(ciImage: image)
        do {
        try handler.perform([mlrequest])
        } catch {
            print("\(error)")
        }
    }
    
    @IBAction func cameraPressed(_ sender: UIBarButtonItem) {
        present(imagePicker, animated: true, completion: nil)
    }
    
   

    
    
}

