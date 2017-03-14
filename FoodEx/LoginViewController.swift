//
//  LoginViewController.swift
//  FoodEx
//
//  Created by Divya on 2/4/17.
//  Copyright © 2017 Apple. All rights reserved.
//

import UIKit
import LocalAuthentication

class LoginViewController: UIViewController, UITextFieldDelegate {

    // MARK: Properties
    let laContext = LAContext()

    // MARK: IBOutlets
    @IBOutlet weak var userNameField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var signInButton: UIButton!
    @IBOutlet weak var touchIDButton: UIButton!

    // MARK: View Controller Life Cycle

    // Evaluates and presents Touch ID Auth if device and user setup supports it.
    override func viewDidLoad() {
        super.viewDidLoad()

        if let defaultUser = AppDataManager.shared.registeredUsers.first(where: { (element) -> Bool in
            return (element["Default"] as? String) == "1"
        }) {
            userNameField.text = defaultUser["ID"] as? String
            touchIDButton.isEnabled = true
        } else {
            touchIDButton.isEnabled = false
        }

        // Disable SignIn initially
        signInButton.isEnabled = false

        var authError : NSError? = nil

        if (laContext.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &authError)) {

            performTouchIDAuth(self)

        } // else continue displaying login view controller for users to perform traditional login
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {

        super.touchesBegan(touches, with: event)

        view.endEditing(true)
    }

    // MARK: Segues

    // Validate username and password values and allow segue to application view controller
    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {

        var shouldPerform = false

        if (identifier == "ShowAppNavController") {

            let userName = userNameField.text!.trimmingCharacters(in: .whitespaces).lowercased()
            let password = passwordField.text!

            // Validate the login credentials against registered users data mart

            if let matchingUser = AppDataManager.shared.registeredUsers.first(where: { (element) -> Bool in
                return ((element["ID"] as? String)?.lowercased() == userName && (element["Password"] as? String) == password)
            }), let loggedInUser = User(dictionary: matchingUser) {

                    AppDataManager.shared.user = loggedInUser
                    shouldPerform = true

            } else {

                let alert = UIAlertController(title: "User Authentication Error", message: "Incorrect Username or Password. Please try again.", preferredStyle: .alert)

                alert.addAction(UIAlertAction(title: "OK", style: .default))

                present(alert, animated: true)
            }
        }

        return shouldPerform
    }

    // Segue to application view controller
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {

        if (segue.identifier == "ShowAppNavController") {
            segue.destination.modalPresentationStyle = .fullScreen
            segue.destination.modalTransitionStyle = .flipHorizontal
        }
    }

    @IBAction func signOutUnwindAction(unwindSegue: UIStoryboardSegue) {

        func syncUserDefaults() -> Void {

            let userKey = AppDataManager.shared.user.id
            let userSessionInfo = AppDataManager.shared.user.dictionaryRepresentation()

            if userSessionInfo.keys.count > 0 {
                UserDefaults.standard.set(userSessionInfo, forKey: userKey)
            } else {
                UserDefaults.standard.removeObject(forKey: userKey)
            }
            
            UserDefaults.standard.synchronize()
            
        }

        // Update User specific information to UserDefaults
        syncUserDefaults()
        // Wipe off logged in user
        AppDataManager.shared.user = nil
        // Clear password
        passwordField.text = nil
    }

    // MARK: IBActions

    // Initiates Touch ID Auth
    @IBAction func performTouchIDAuth(_ sender: Any) {

        let userName = self.userNameField.text!.trimmingCharacters(in: .whitespaces).lowercased()

        // Validate the login credentials against registered users data mart
        if let matchingUser = AppDataManager.shared.registeredUsers.first(where: { (element) -> Bool in
            return ((element["ID"] as? String)?.lowercased() == userName)
        }) {
            laContext.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: "Sign in with Touch ID or cancel to enter password.") { (success, evaluateError) in

                if (success) {

                    if let loggedInUser = User(dictionary: matchingUser) {

                        AppDataManager.shared.user = loggedInUser

                        // Proceed with segue to application view controller
                        DispatchQueue.main.async {
                            self.performSegue(withIdentifier: "ShowAppNavController", sender: self)
                        }
                    } else {

                        DispatchQueue.main.async {
                            let alert = UIAlertController(title: "User Authentication Error", message: "Invalid Username. Please try again.", preferredStyle: .alert)

                            alert.addAction(UIAlertAction(title: "OK", style: .default))
                            self.present(alert, animated: true)
                        }
                    }

                } else {

                    // Handle auth failure and appropriate display user alert
                    self.handleTouchIDAuthFailure(LAError(_nsError: evaluateError as! NSError).code)
                }
            }

        } else {

            let alert = UIAlertController(title: "User Authentication Error", message: "Invalid Username. Please try again.", preferredStyle: .alert)

            alert.addAction(UIAlertAction(title: "OK", style: .default))
            present(alert, animated: true)
        }
    }

    // Validates username and password values to enable Sign In button
    @IBAction func enableSignIn(_ sender: UITextField) {

        let userName = userNameField.text!.trimmingCharacters(in: .whitespaces)
        let password = passwordField.text!.trimmingCharacters(in: .whitespaces)

        // Enable Sign In button only if there are valid values in username and password fields
        if ((userName.characters.count > 0) && (password.characters.count > 0)) {
            signInButton.isEnabled = true
        } else {
            signInButton.isEnabled = false
        }

        // Enable Touch ID button only if there are valid values in username field
        if (userName.characters.count > 0) {
            touchIDButton.isEnabled = true
        } else {
            touchIDButton.isEnabled = false
        }

    }

    // MARK: Utils Functions

    // Handles the Touch ID Auth failure and decides to alert the user when required
    func handleTouchIDAuthFailure(_ errorCd: LAError.Code) -> Void {

        var userErrorInfo = ""
        var shouldDisplayAlert = false

        switch errorCd {

        case .authenticationFailed:
            userErrorInfo = "Touch ID Auth failed. Please enter valid credentials to sign in."
            shouldDisplayAlert = true

        case .userCancel:
            userErrorInfo = "Touch ID Auth cancelled by user."

        case .userFallback:
            userErrorInfo = "Touch ID Auth ignored and user fallsback to manual sign in."

        case .systemCancel:
            userErrorInfo = "Touch ID Auth cancelled by system."

        case .passcodeNotSet:
            userErrorInfo = "Touch ID Auth failed as passcode was not set in the device. Please enter valid credentials to sign in."
            shouldDisplayAlert = true

        case .touchIDNotAvailable:
            userErrorInfo = "Touch ID Auth not supported in the device."

        case .touchIDNotEnrolled:
            userErrorInfo = "Touch ID Auth not enrolled in the device."

        default:
            userErrorInfo = "Touch ID Auth failed due to unknown reasons. Please enter valid credentials to sign in."
            shouldDisplayAlert = true
        }

        if shouldDisplayAlert {

            DispatchQueue.main.async {
                let alert = UIAlertController(title: "User Authentication Error", message: userErrorInfo, preferredStyle: .alert)

                alert.addAction(UIAlertAction(title: "OK", style: .default))

                self.present(alert, animated: true)
            }
        }
    }

    // MARK: UITextFieldDelegate

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        view.endEditing(true)

        return true
    }
}

