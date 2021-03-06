//
//  SignUpVC.swift
//  Prey
//
//  Created by Javier Cala Uribe on 20/11/14.
//  Copyright (c) 2014 Fork Ltd. All rights reserved.
//

import UIKit

class SignUpVC: UIViewController {

    // MARK: Properties
    @IBOutlet weak var addDeviceButton: UIButton!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: Actions
    @IBAction func addDeviceAction(sender: UIButton) {

        // Check name length
        if nameTextField.text!.characters.count < 1 {
            displayErrorAlert("Name can't be blank".localized, titleMessage:"We have a situation!".localized)
            nameTextField.becomeFirstResponder()
            return
        }
        
        // Check password length
        if passwordTextField.text!.characters.count < 6 {
            displayErrorAlert("Password must be at least 6 characters".localized, titleMessage:"We have a situation!".localized)
            passwordTextField.becomeFirstResponder()
            return
        }
        
        // Check valid email
        if isInvalidEmail(emailTextField.text!, withPattern:emailRegExp) {
            displayErrorAlert("Enter a valid e-mail address".localized, titleMessage:"We have a situation!".localized)
            emailTextField.becomeFirstResponder()
            return
        }

        
        // Show ActivityIndicator
        let actInd              = UIActivityIndicatorView(activityIndicatorStyle:UIActivityIndicatorViewStyle.Gray)
        actInd.center           = self.view.center
        actInd.hidesWhenStopped = true
        self.view.addSubview(actInd)
        actInd.startAnimating()

        // SignUp to Panel Prey
        PreyUser.signUpToPrey(nameTextField.text!, userEmail:emailTextField.text!, userPassword:passwordTextField.text!, onCompletion: {(isSuccess: Bool) in
            
            // LogIn Success
            if isSuccess {
                
                // Add Device to Panel Prey
                PreyDevice.addDeviceWith({(isSuccess: Bool) in
                    
                    dispatch_async(dispatch_get_main_queue()) {
                        
                        // Add Device Success
                        if isSuccess {
                            if let resultController = self.storyboard!.instantiateViewControllerWithIdentifier("deviceSetUpStrbrd") as? DeviceSetUpVC {
                                self.presentViewController(resultController, animated: true, completion: nil)
                            }
                        }
                        else {
                            // Hide ActivityIndicator
                            actInd.stopAnimating()
                        }
                    }
                })
            } else {
                // Hide ActivityIndicator
                dispatch_async(dispatch_get_main_queue()) {
                    actInd.stopAnimating()
                }
            }
        })
   
    }
}
