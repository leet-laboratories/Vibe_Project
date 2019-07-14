//
//  RegisterTwoViewController.swift
//  Vibe
//
//  Created by Allan Frederick on 8/19/18.
//  Copyright © 2018 Allan Frederick. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase
import FirebaseStorage

class RegisterTwoViewController: UIViewController, UITextFieldDelegate{
    
    // Previous view controller data
    var name: String!
    var email: String!
    var password: String!
    
    // Define outlets
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var phoneNumberTextField: UITextField!
    @IBOutlet weak var registerButton: UIButton!
    
    // Store image
    var selectedImage: UIImage?
    
    // Vibe Status
    var vibeStatus = 0
    
    
    // Register user when button is pressed
    @IBAction func registerButton(_ sender: Any) {
        print("register button pressed")
        
        if let profilePhoto = self.selectedImage, let imageData = profilePhoto.jpegData(compressionQuality: 0.2){
            AuthService.signUp(name: name, username: usernameTextField.text!, email: email, password: password, phoneNumber: phoneNumberTextField.text!, vibeStatus: vibeStatus, imageData: imageData, onSuccess: {
                // Initiate segue after registration is complete
                self.performSegue(withIdentifier: "RegisterToPageCtl", sender: nil)
            }, onError: {(errorString) in
                print(errorString!)
                let notification = UIAlertController(title: "Error", message: "Oops! Something went wrong. Please make sure all the information you entered is valid.", preferredStyle: .alert)
                self.present(notification, animated: true, completion: nil)
                // Delay time of notification (1 = sec)
                let delay = DispatchTime.now() + 4
                DispatchQueue.main.asyncAfter(deadline: delay){
                    // Notification completed
                    notification.dismiss(animated: true, completion: nil)
                }
            })
        } else{
            print("Profile image can't be empty")
            let notification = UIAlertController(title: "Error", message: "Select a profile image to continue", preferredStyle: .alert)
            self.present(notification, animated: true, completion: nil)
            // Delay time of notification (1 = sec)
            let delay = DispatchTime.now() + 2
            DispatchQueue.main.asyncAfter(deadline: delay){
                // Notification completed
                notification.dismiss(animated: true, completion: nil)
            }
        }
    }
    
    // Goes back to Sign-in page
    @IBAction func backTosignIn(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        // Initially disable register button, until all input is valid
        registerButton.isUserInteractionEnabled = false
        // Round register button
        registerButton.layer.cornerRadius = registerButton.frame.size.width/6
        registerButton.clipsToBounds = true
        // Round image
        profileImage.layer.cornerRadius = profileImage.frame.size.width/2
        profileImage.clipsToBounds = true
        // User taps profile icon
        let TapGesture = UITapGestureRecognizer(target: self, action: #selector(RegisterTwoViewController.selectProfileImageView))
        profileImage.addGestureRecognizer(TapGesture)
        profileImage.isUserInteractionEnabled = true
        // Error checking for text fields
        handleTextField()
        usernameTextField.delegate = self
        phoneNumberTextField.delegate = self
    }
    
    // Error checking for text fields
    func handleTextField(){
        // Detect if user is editing text fields
        usernameTextField.addTarget(self, action: #selector(RegisterTwoViewController.textFieldDidChange), for: UIControl.Event.editingChanged)
        phoneNumberTextField.addTarget(self, action: #selector(RegisterTwoViewController.textFieldDidChange), for: UIControl.Event.editingChanged)
    }
    
    // Detect if all text fields are filled
    @objc func textFieldDidChange() {
        // Check if text fields is not empty. If empty, diable button. If valid, enable button.
        guard let username = usernameTextField.text, !username.isEmpty, let phoneNumber = phoneNumberTextField.text, !phoneNumber.isEmpty else {
            // Dim register button text if not all text fields are filled
            registerButton.setTitleColor(UIColor.lightGray, for: UIControl.State.normal)
            // Keep button disabled
            registerButton.isUserInteractionEnabled = false
            return
        }
        // Lighten register button text if all text fields are filled
        registerButton.setTitleColor(UIColor.darkGray, for: UIControl.State.normal)
        // Enable button
        registerButton.isUserInteractionEnabled = true
    }
    
    // Enables selection for profile image
    @objc func selectProfileImageView() {
        print("Tapped")
        let pickerController = UIImagePickerController()
        pickerController.delegate = self
        present(pickerController, animated: true, completion: nil)
    }
    
    // Takes keyboard down
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    func textFieldShouldReturn(_ textField : UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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


// Lets user select image from camera roll when profile icon is tapped
extension RegisterTwoViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
// Local variable inserted by Swift 4.2 migrator.
let info = convertFromUIImagePickerControllerInfoKeyDictionary(info)
        print("image selected")
        //profileImage.image = infoPhoto
        if let image = info["UIImagePickerControllerOriginalImage"] as? UIImage{
            selectedImage = image
            profileImage.image = image
        
        }
        dismiss(animated: true, completion: nil)
    }
}

// Helper function inserted by Swift 4.2 migrator.
fileprivate func convertFromUIImagePickerControllerInfoKeyDictionary(_ input: [UIImagePickerController.InfoKey: Any]) -> [String: Any] {
	return Dictionary(uniqueKeysWithValues: input.map {key, value in (key.rawValue, value)})
}
