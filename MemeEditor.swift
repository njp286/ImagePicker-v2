//
//  MemeEditor.swift
//  ImagePicker
//
//  Created by Nathaniel PiSierra on 2/8/16.
//  Copyright © 2016 Nathaniel PiSierra. All rights reserved.
//

import UIKit
import MobileCoreServices


class MemeEditor: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextFieldDelegate, UIToolbarDelegate {

    @IBOutlet var bottomToolBar: UIToolbar!
    @IBOutlet var topToolBar: UIToolbar!
    @IBOutlet var shareButton: UIBarButtonItem!
    var newMedia: Bool?
    @IBOutlet var bottomText: UITextField!
    @IBOutlet var topText: UITextField!
    @IBOutlet var memeImage: UIImageView!
    @IBOutlet var camera: UIBarButtonItem!
    var activeTextField = UITextField()
    var memedImage: UIImage!
    var meme: Meme!

  
    let memeTextAttributes = [
        NSStrokeColorAttributeName : UIColor.blackColor(),
        NSForegroundColorAttributeName : UIColor.whiteColor(),
        NSFontAttributeName : UIFont(name: "HelveticaNeue-CondensedBlack", size: 40)!,
        NSStrokeWidthAttributeName : -3.7
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //if there is no camer--> disable camera button
        camera.enabled = UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.Camera)
        shareButton.enabled = false
        
        bottomText.delegate = self
        topText.delegate = self
        topToolBar.delegate = self
        
        
        bottomText.defaultTextAttributes = memeTextAttributes
        topText.defaultTextAttributes = memeTextAttributes
        bottomText.textAlignment = .Center
        topText.textAlignment = .Center
     
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("keyboardWillShow:"), name: UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("keyboardWillHide:"), name: UIKeyboardWillHideNotification, object: nil)
        
    }
    
    
    func positionForBar(bar: UIBarPositioning) -> UIBarPosition {
        return .TopAttached
    }
    
    //set whicch text field is active
    func textFieldDidBeginEditing(textField: UITextField) {
        activeTextField = textField
    }

    
    func keyboardWillShow(notification: NSNotification) {
        //if bottom being edited
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.CGRectValue()  where activeTextField == bottomText{
            view.frame.origin.y = keyboardSize.height * -1
        }
    }
    
    func keyboardWillHide(notification: NSNotification) {
        //if bottom editing ending
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.CGRectValue() where activeTextField == bottomText{
            view.frame.origin.y += keyboardSize.height
        }
    }
    
    //cancel button pressed
    @IBAction func cancelPressed(sender: UIBarButtonItem) {
        //set memeImage to nil
        memeImage.image = nil
        bottomText.text = "BOTTOM"
        topText.text = "TOP"
        shareButton.enabled = false
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    //action for when camera button is pressed
    @IBAction func cameraPressed(sender: AnyObject) {
        imagePickerHelper(UIImagePickerControllerSourceType.Camera, isNewMedia: true)
    }
    
    //action for when album button is pressed
    @IBAction func albumPressed(sender: UIBarButtonItem) {
        imagePickerHelper(UIImagePickerControllerSourceType.PhotoLibrary, isNewMedia: false)
    }
    
    //helper function to creaet imagepickercontroller/ camera controller
    func imagePickerHelper(source: UIImagePickerControllerSourceType, isNewMedia media: Bool){
        //create imagePicker view controller
        let imagePicker = UIImagePickerController()
        //set delagate as self
        imagePicker.delegate = self
        //set sourcetype to photolibrary
        imagePicker.sourceType = source
        //imagetype equal to kUTTypeImage
        imagePicker.mediaTypes = [kUTTypeImage as String]
        //editing not allowed
        imagePicker.allowsEditing = false
        //present imagepicker
        presentViewController(imagePicker, animated: true, completion: nil)
        //not a new image being taken by phone
        newMedia = media
    }
    
    //when imagepicker is done picking edia
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        
        
        //set mediaType to be the image
        let mediaType = info[UIImagePickerControllerMediaType] as! String
        
        //dismiss pickerview
        dismissViewControllerAnimated(true, completion: nil)
        
        //if its a kuTTpeImage
        if mediaType == (kUTTypeImage as String) {
            let image = info[UIImagePickerControllerOriginalImage] as! UIImage
            
            //set memeimage to the chosen/ taken image
            memeImage.image = image
            
            shareButton.enabled = true
            
            //if a new photo
            if (newMedia == true) {
                //save photo to photoalbum
                UIImageWriteToSavedPhotosAlbum(image, self, "image:didFinishSavingWithError:contextInfo:", nil)
            }
            
        }
        

    }
    
    //if error in image present error alert
    func image(image: UIImage, didFinishSavingWithError error: NSErrorPointer, contextInfo:UnsafePointer<Void>) {
        
        if error != nil {
            let alert = UIAlertController(title: "Save Failed",
                message: "Failed to save image",
                preferredStyle: UIAlertControllerStyle.Alert)
            
            let cancelAction = UIAlertAction(title: "OK",
                style: .Cancel, handler: nil)
            
            alert.addAction(cancelAction)
            presentViewController(alert, animated: true,
                completion: nil)
        }
    }
    
    //dismiss image picker
    func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    //when return is pressed dismiss keyboard on text fields
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        view.endEditing(true)
        return false
    }
    
    //save meme struct
    func save() {
        //Create the meme
        let text = topText.text! + bottomText.text!
        meme = Meme(text: text, image:memeImage.image!, memedImage: memedImage)
        MemeStorage.instance.add(self.meme)
        /*
        //save meme to appdelegate
        let object = UIApplication.sharedApplication().delegate
        let appDelegate = object as! AppDelegate
        appDelegate.memes.append(meme)
        print("saved adn added, \(appDelegate.memes.count) memes ares in the system")
        */
    }
    
    
    //generate Memed image
    func generateMemedImage() -> UIImage {
        // get size of image view
        UIGraphicsBeginImageContextWithOptions(self.memeImage.frame.size, false, 0)
        // get snapshot of image view and nothing else
        view.drawViewHierarchyInRect(CGRectMake(-self.memeImage.frame.origin.x,-self.memeImage.frame.origin.y,view.bounds.size.width,view.bounds.size.height), afterScreenUpdates: true)
        let memedImage : UIImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return memedImage
    }
    
    //share button pressed
    @IBAction func sharePressed(sender: UIBarButtonItem) {
        memedImage = generateMemedImage()
        let vc = UIActivityViewController(activityItems: [memedImage], applicationActivities: [])
        vc.completionWithItemsHandler = { activity, success, items, error in
            if success {
                self.save()
                self.dismissViewControllerAnimated(true, completion: nil)
            }
        }
        presentViewController(vc, animated: true, completion: nil)
    }
    

}

