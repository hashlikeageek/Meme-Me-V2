//
//  ViewController.swift
//  Meme
//
//  Created by Ashutosh Kumar Sai on 12/12/16.
//  Copyright © 2016 Ashish Rajendra Kumar Sai. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITextFieldDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    
    //outlets
    //Outlets for Navigation Bar
    @IBOutlet weak var share: UIBarButtonItem!
    @IBOutlet weak var cancel: UIBarButtonItem!
    //Outlets for Tollbar
    @IBOutlet weak var camera: UIBarButtonItem!
    @IBOutlet weak var gal: UIBarButtonItem!
    //Outlets for Image View
    @IBOutlet weak var imageView: UIImageView!
    //Outlets for texts
    @IBOutlet weak var topText: UITextField!
    @IBOutlet weak var bottomText: UITextField!

    
    override func viewDidLoad() {
        super.viewDidLoad()
        //here we set the initial value of all the textField 
        topText.text = "TOP"
        topText.defaultTextAttributes = memeTextAttributes
        topText.textAlignment = .center
        topText.delegate = self
        //we do the same thing for bottomText
        bottomText.text = "BOTTOM"
        bottomText.defaultTextAttributes = memeTextAttributes
        bottomText.textAlignment = .center
        bottomText.delegate = self
    }
    
    //we use viewWillAppear for keyboard thing
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        subscribeToKeyboardNotifications()
    }
    
    //we use viewWillDisappeaer for Keyboard thing 
    override func viewWillDisappear(_ animated: Bool) {
         super.viewWillDisappear(animated)
         unsubscribeFromKeyboardNotifications()
    }
    
    //textAttribute file that we will use in viewDidload
    let memeTextAttributes:[String:Any] = [
        NSStrokeColorAttributeName: UIColor.black,
        NSForegroundColorAttributeName: UIColor.white,
        NSFontAttributeName: UIFont(name: "HelveticaNeue-CondensedBlack", size: 32)!,
        NSStrokeWidthAttributeName: -3.0]
    
    //imagePicker controller that we will use to pick image.
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        if let image = info[UIImagePickerControllerOriginalImage] as? UIImage {
            imageView.image = image
        }
        
        dismiss(animated: true, completion: nil)
        }
   //We use this method when we cancel the picker
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
    //IBAction for the camera NOTE- We yse sourceType here which is the sole diffrence between this and gal
    @IBAction func cameraAction(_ sender: Any) {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = .camera
        present(imagePicker, animated: true, completion: nil)
        
        camera.isEnabled = UIImagePickerController.isSourceTypeAvailable(.camera)
        }
    //IBAction for gal icon
    @IBAction func galAction(_ sender: Any) {
        let controller = UIImagePickerController()
        controller.delegate = self
        
        present(controller, animated: true, completion: nil)
    }
    
    //This method is used to reset all the values and image
    @IBAction func cancelAction(_ sender: Any) {
        imageView.image = nil
        topText.text = "TOP"
        bottomText.text = "BOTTOM"
    }
    
    //All the methods related to Keyboard 
    
    func subscribeToKeyboardNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(ViewController.keyboardWillShow(_:))    , name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(ViewController.keyboardWillHide(_:))    , name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
    
    func unsubscribeFromKeyboardNotifications() {
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
    
    func keyboardWillShow(_ notification: Notification) {
        if bottomText.isFirstResponder {
            view.frame.origin.y -= getKeyboardHeight(notification)
        }
    }
    
    func keyboardWillHide(_ notification: Notification) {
        if bottomText.isFirstResponder {
            view.frame.origin.y += getKeyboardHeight(notification)
        }
    }
    
    func getKeyboardHeight(_ notification: Notification) -> CGFloat {
        let userInfo = notification.userInfo
        let keyboardSize = userInfo![UIKeyboardFrameEndUserInfoKey] as! NSValue // of CGRect
        return keyboardSize.cgRectValue.height
    }


}


