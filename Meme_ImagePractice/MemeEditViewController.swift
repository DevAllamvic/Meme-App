//
//  MemeEditViewController.swift
//  Meme_ImagePractice
//
//  Created by OSAMA ALLAM on 05/26/19.

//

import UIKit

class MemeEditViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextFieldDelegate {
    
    @IBOutlet weak var imagePickerView: UIImageView!
    @IBOutlet weak var cameraButton: UIBarButtonItem!
    @IBOutlet weak var topTextField: UITextField!
    @IBOutlet weak var bottomTextField: UITextField!
    @IBOutlet weak var topToolBar: UIToolbar!
    @IBOutlet weak var bottomToolbar: UIToolbar!
    @IBOutlet weak var shareButton: UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        prepareTextField(textField: topTextField, defaultText: "TOP")
        prepareTextField(textField: bottomTextField, defaultText: "BOTTOM")
        shareButton.isEnabled = false
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        cameraButton.isEnabled = UIImagePickerController.isSourceTypeAvailable(.camera)
        signUpForNotifications()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        removeNotifications()
    }

    @IBAction func pickAnImage(_ sender: Any) {
        pick(sourceType: .photoLibrary)
    }
    
    @IBAction func pickAnImageUsingCamera(_ sender: Any) {
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            pick(sourceType: .camera)
        }
    }
    
    func pick(sourceType: UIImagePickerController.SourceType) {
        let pickerController = UIImagePickerController()
        pickerController.delegate = self
        pickerController.sourceType = sourceType
        present(pickerController, animated: true, completion: nil)        
    }
    
    func prepareTextField(textField: UITextField, defaultText: String) {
        textField.text = defaultText
        textField.borderStyle = .none
        textField.defaultTextAttributes = convertToNSAttributedStringKeyDictionary(memeTextAttributes)
        textField.delegate = self
        textField.textAlignment = .center
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
// Local variable inserted by Swift 4.2 migrator.
let info = convertFromUIImagePickerControllerInfoKeyDictionary(info)

        if let chosenImage = info[convertFromUIImagePickerControllerInfoKey(UIImagePickerController.InfoKey.originalImage)] as? UIImage {
            imagePickerView.image = chosenImage
            dismiss(animated: true, completion: nil)
            imagePickerView.contentMode = .scaleAspectFit
            shareButton.isEnabled = true
        }
        
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
        }
    }

    func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField.text == "TOP" || textField.text == "BOTTOM" {
            textField.text = ""
            }
        }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func signUpForNotifications() {
        let center: NotificationCenter = NotificationCenter.default
        center.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        center.addObserver(self, selector: #selector(keyBoardWillHide(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    func removeNotifications() {
        let center: NotificationCenter = NotificationCenter.default
        center.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        center.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    func getKeyboardHeight(_ notification:Notification) -> CGFloat {
        let userInfo = notification.userInfo
        let keyboardSize = userInfo![UIResponder.keyboardFrameEndUserInfoKey] as! NSValue // of CGRect
        return keyboardSize.cgRectValue.height
    }
    
    @objc func keyboardWillShow(_ notification:Notification) {
        if bottomTextField.isFirstResponder {
            view.frame.origin.y -= getKeyboardHeight(notification)
        }
    }
    
    @objc func keyBoardWillHide(_ notification: Notification) {
        if bottomTextField.isFirstResponder {
            view.frame.origin.y = 0
        }
    }
    
    let memeTextAttributes: [String:Any] = [
        NSAttributedString.Key.strokeColor.rawValue: UIColor.black,
        NSAttributedString.Key.foregroundColor.rawValue: UIColor.white,
        NSAttributedString.Key.font.rawValue: UIFont(name: "Impact", size: 40)!,
        NSAttributedString.Key.strokeWidth.rawValue: -4.0,
    ]
    
    func toolBarStatus(status: Bool) {
        topToolBar.isHidden = status
        bottomToolbar.isHidden = status
    }
    
    func generateMemedImage() -> UIImage {
        toolBarStatus(status: true)
        UIGraphicsBeginImageContext(self.view.frame.size)
        view.drawHierarchy(in: self.view.frame, afterScreenUpdates: true)
        let memedImage: UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        toolBarStatus(status: false)
        return memedImage
    }
    
    func save() {
        let meme = Meme(topText: topTextField.text!, bottomText: bottomTextField.text!, originalImage: imagePickerView.image!, memedImage:generateMemedImage())
        // Add to AppDelegate array
        let object = UIApplication.shared.delegate
        let appDelegate = object as! AppDelegate
        appDelegate.memes.append(meme)
    }
    
    @IBAction func shareButton(_ sender: Any) {
        let memeToShare = generateMemedImage()
        let activityViewController = UIActivityViewController(activityItems: [memeToShare], applicationActivities: nil)
        activityViewController.completionWithItemsHandler =
            { (activityType: UIActivity.ActivityType?, completed: Bool, returnedItems: [Any]?, error: Error?) in
                if completed {
                    self.save()
                    self.dismiss(animated: true, completion: nil)
                    self.navigationController?.popViewController(animated: true)
                }
        }
        self.present(activityViewController, animated: true, completion: nil)
    }
    
    @IBAction func dismiss(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
}

// Helper function inserted by Swift 4.2 migrator.
fileprivate func convertFromUIImagePickerControllerInfoKeyDictionary(_ input: [UIImagePickerController.InfoKey: Any]) -> [String: Any] {
	return Dictionary(uniqueKeysWithValues: input.map {key, value in (key.rawValue, value)})
}

// Helper function inserted by Swift 4.2 migrator.
fileprivate func convertToNSAttributedStringKeyDictionary(_ input: [String: Any]) -> [NSAttributedString.Key: Any] {
	return Dictionary(uniqueKeysWithValues: input.map { key, value in (NSAttributedString.Key(rawValue: key), value)})
}

// Helper function inserted by Swift 4.2 migrator.
fileprivate func convertFromUIImagePickerControllerInfoKey(_ input: UIImagePickerController.InfoKey) -> String {
	return input.rawValue
}
