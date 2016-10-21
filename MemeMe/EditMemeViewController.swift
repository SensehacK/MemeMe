//
//  ViewController.swift
//  MemeMe
//
//  Created by Sensehack on 07/10/16.
//  Copyright © 2016 Sensehack. All rights reserved.
//

import UIKit




class EditMemeViewController: UIViewController , UIImagePickerControllerDelegate,
UINavigationControllerDelegate ,UITextFieldDelegate

{
    //outlet connections
    @IBOutlet weak var imagePickedView: UIImageView!
   // @IBOutlet weak var cameraButton: UIButton!
    @IBOutlet weak var topText: UITextField!
    @IBOutlet weak var bottomText: UITextField!
    @IBOutlet weak var shareButton: UIBarButtonItem!
    @IBOutlet weak var toolbar: UIToolbar!
    @IBOutlet weak var navigationBar: UINavigationBar!
    @IBOutlet weak var cancelButton: UIBarButtonItem!
    @IBOutlet weak var cameraSystemButton: UIBarButtonItem!
    
    //variable declaration
    var topTextEdit : Bool = false
    var bottomTextEdit : Bool = false
    var bottomText2 : Bool = false
    var memedImage : UIImage?
    var genimage : UIImage?
    var memesArr : Meme!
    
    
    
    //Meme attributes assigned
    
    

    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view, typically from a nib.
        //Camera icon & Gallery Icon imported from icons8.com <a href="https://icons8.com">Icon pack by Icons8</a>
        cameraSystemButton.isEnabled = UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.camera) // Simulator doesnt have Camera access , so checking if the end device has camera hardware or not.
        
        
        let memeTextAttributes = [
            NSStrokeColorAttributeName :  UIColor.black , //TODO: Fill in appropriate UIColor,
            NSForegroundColorAttributeName : UIColor.white , //TODO: Fill in UIColor,
            NSFontAttributeName : UIFont(name: "HelveticaNeue-CondensedBlack", size: 40)!,
            NSStrokeWidthAttributeName : -3.0 //TODO: Fill in appropriate Float
            ] as [String : Any]
        
        
        shareButton.isEnabled = false  //disable the share button
        //default attributes assigned
        topText.defaultTextAttributes = memeTextAttributes
        bottomText.defaultTextAttributes = memeTextAttributes
        
        //initialized text delegates
        self.topText.delegate = self
        self.bottomText.delegate = self
    }
    
    
    // View will reload after the Gallery file / photo file is selected.
    override func viewWillAppear(_ animated: Bool)
    {
        super.viewWillAppear(animated)
        subscribeToKeyboardNotifications()
        topText.text = "Top text test"  // placeholder
        bottomText.text = "Bottom text test" // placeholder
        topText.textAlignment = .center
        bottomText.textAlignment = .center
        
    }

    override func viewWillDisappear(_ animated: Bool)
    {
        super.viewWillDisappear(animated)
        unsubscribeFromKeyboardNotifications()
    }
    
    
    func pick(source:UIImagePickerControllerSourceType){
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = source
        present(imagePicker, animated: true, completion: nil)
    }
    
    
    @IBAction func pickImage(_ sender: AnyObject)
    {
        pick( source: .photoLibrary)
        //enable the share button
        shareButton.isEnabled = true
        //extra alignment
        topText.textAlignment = .center
        bottomText.textAlignment = .center
    }
    
    @IBAction func pickImageCamera(_ sender: AnyObject)
    {
        pick(source: .camera)
    }
    
    @IBAction func shareActivity(_ sender: AnyObject)
    {
        //Get Image with Both Texts as a MemeImage
        let image = generateMemedImage()
        genimage = image
        let activity = UIActivityViewController(activityItems: [image], applicationActivities: nil)
        present(activity, animated: true, completion: nil)
        
        activity.completionWithItemsHandler =
            {
            (type, completed ,returnedItems , errors) in
                if completed
                {
                self.save()
                }
            }
    }
    
    
    @IBAction func topTextEditing(_ sender: AnyObject)
    {
        topTextEdit = true
        view.frame.origin.y = 0
    }
    
    @IBAction func bottomTextEditing(_ sender: AnyObject)
    {
        bottomTextEdit = true
        view.frame.origin.y = 0
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo: [String : Any])
    {
       // let showsCameraControls: Bool = true
        //var UIImagePickerControllerOriginalImage: String?
        let tempImage = didFinishPickingMediaWithInfo[UIImagePickerControllerOriginalImage] as! UIImage
        imagePickedView.image = tempImage
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_: UIImagePickerController)
    {
        dismiss(animated: true, completion: nil)
    }
    
    
    // MARK: Keyboard  text field functions
    // code for keyboard return & clear text entered by default.
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool
    {
        
        return true
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool
    {
        textField.resignFirstResponder()
        textField.endEditing(true)
        
        topTextEdit = true
        bottomTextEdit = true
        return true
       
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField)
    {
        
        if (topTextEdit || bottomTextEdit == false)
        {
            textField.text = ""
        }
        
    }
 
    
    
    func save()
    {
        //Create the meme
        let meme = Meme( topText: topText.text!, bottomText : bottomText.text! ,image:
            imagePickedView.image, memedImage: genimage)
        
        
        //Storing it in App Delegate File for easy Access
        let object = UIApplication.shared.delegate
        let appDelegate = object as! AppDelegate
        appDelegate.memes.append(meme)
        print(meme.topText)
    }
    
    
    //generates the screen meme
    func generateMemedImage() -> UIImage
    {
        
        // Hide toolbar
        
        self.navigationController?.setNavigationBarHidden(true, animated: true)
        toolbar.isHidden = true
        navigationBar.isHidden = true
        
        // Render view to an image
        UIGraphicsBeginImageContext(self.view.frame.size)
        view.drawHierarchy(in: self.view.frame,
                                     afterScreenUpdates: true)
        let memedImage : UIImage =
            UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        
        //Show toolbar
        navigationController?.hidesBarsOnTap = false
        self.navigationController?.setNavigationBarHidden(false, animated: true)
         toolbar.isHidden = false
        navigationBar.isHidden = false
        
        return memedImage
    }
    
 
    // MARK: Keyboard slide up function.
    // code for sliding up the keyboard when editing the bottom text
    
    func keyboardWillShow(notification: NSNotification)
    {
        if (bottomText.isFirstResponder)
        {
        view.frame.origin.y = -getKeyboardHeight(notification: notification)
        }
    }
    
    func keyboardWillHide(notification : NSNotification)
    {
        view.frame.origin.y = 0
        
    }
    
    func getKeyboardHeight(notification: NSNotification) -> CGFloat
    {
        let userInfo = notification.userInfo
        let keyboardSize = userInfo![UIKeyboardFrameEndUserInfoKey] as! NSValue // of CGRect
        return keyboardSize.cgRectValue.height
    }

    
    func subscribeToKeyboardNotifications()
    {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow) , name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        
    }
    
    func unsubscribeFromKeyboardNotifications()
    {
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillHide, object: nil)
       NotificationCenter.default.removeObserver(self, name:
            NSNotification.Name.UIKeyboardWillShow, object: nil)
 
    }
    
    
    
    @IBAction func cancelPressed(_ sender: AnyObject) {
        
        dismiss(animated: true, completion: nil)
    }
    
    
    
    
}

