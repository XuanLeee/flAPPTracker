//
//  ViewController.swift
//  FlapTracker
//
//  Created by Amy Chung on 2017-04-28.
//  Copyright © 2017 Amy Chung. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    
    @IBOutlet weak var ImageView: UIImageView!
    @IBOutlet weak var Camera: UIButton!
    @IBOutlet weak var Photo: UIButton!
    
    
    @IBAction func CameraA(_ sender: UIButton) {
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.sourceType = .camera
        
        present(picker, animated: true, completion: nil)
        
    }
    
    
    @IBAction func PhotoA(_ sender: UIButton) {
        
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.sourceType = .photoLibrary
        
        present(picker, animated: true, completion: nil)
    }

    
// Documents Directory Work
// End of Document Directory  Work
    
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let image = info[UIImagePickerControllerOriginalImage] as? UIImage
            
        {ImageView.image = image
        }
            
        else {
            
            //ERROR
        }
        
        self.dismiss(animated: true, completion: nil)
     
    }
    
// Save the Image to Camera Roll
    
    @IBAction func SavePhoto(_ sender: Any) {
        let ImageData = UIImagePNGRepresentation(ImageView.image!)
        let compressedImage = UIImage(data: ImageData!)
        UIImageWriteToSavedPhotosAlbum(compressedImage!, nil, nil, nil)

        // put a call back
        
        
        let alert = UIAlertController(title: "Saved", message:"Your image has been saved", preferredStyle: .alert)
        
        let okayAction = UIAlertAction(title: "Okay", style: . default, handler: nil)
        alert.addAction(okayAction)
        self.present(alert, animated: true, completion: nil)
        

        
    }

// Function to Save Image into Documet Directory
// End of the Code to save to Directory
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

