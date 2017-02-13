//
//  LoginViewController.swift
//  FoodEx
//
//  Created by Nana on 2/4/17.
//  Copyright © 2017 Apple. All rights reserved.
//

import LocalAuthentication

class LoginViewController: UIViewController {

    // MARK: Properties
    let laContext = LAContext()

    // MARK: IBOutlets
    @IBOutlet weak var userNameField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var signInButton: UIButton!

    // MARK: View Controller Life Cycle

    // Evaluates and presents Touch ID Auth if device and user setup supports it.
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.

        // Disable SignIn initially
        signInButton.isEnabled = false

        var authError : NSError? = nil

        if (laContext.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &authError)) {

            performTouchIDAuth(self)

        } else {

            print("Touch ID authentication not possible.")
        }
    }

    // Memory Management
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: Segues

    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {

        var shouldPerform = false

        if (identifier == "displayAppNavController") {

            let userName = userNameField.text!.trimmingCharacters(in: .whitespaces).lowercased()
            let password = passwordField.text!

            // Validate the login credentials against registered users data mart
            if let registeredUsersDataMart = AppDelegate().globals.registeredUsers {

                shouldPerform = (registeredUsersDataMart[userName] == password)
                
            }

            if (shouldPerform == false) {

                let alert = UIAlertController(title: "User Authentication Error", message: "Incorrect Username or Password. Please try again.", preferredStyle: .alert)

                alert.addAction(UIAlertAction(title: "OK", style: .default))

                present(alert, animated: true)
            }
        }

        return shouldPerform
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {

        if (segue.identifier == "displayAppNavController") {
            // TODO: Need to setup data for display

            segue.destination.modalPresentationStyle = .fullScreen
            segue.destination.modalTransitionStyle = .flipHorizontal
        }
    }

    // MARK: IBActions

    // Kick starts Touch ID Auth
    @IBAction func performTouchIDAuth(_ sender: Any) {

        laContext.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: "Sign in with Touch ID or cancel to enter password.") { (success, evaluateError) in

            if (success) {

                print("TouchID Auth Success.")
                // Proceed displaying application dashboard
                self.performSegue(withIdentifier: "displayAppNavController", sender: self)

            } else {

                print("Touch ID failure: \(evaluateError)")
                self.handleTouchIDAuthFailure(LAError(_nsError: evaluateError as! NSError).code)
            }
        }
    }

    @IBAction func enableSignIn(_ sender: UITextField) {

        let userName = userNameField.text!.trimmingCharacters(in: .whitespaces)
        let password = passwordField.text!.trimmingCharacters(in: .whitespaces)

        if ((userName.characters.count > 0) && (password.characters.count > 0)) {
            signInButton.isEnabled = true
        } else {
            signInButton.isEnabled = false
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

            let alert = UIAlertController(title: "User Authentication Error", message: userErrorInfo, preferredStyle: .alert)

            alert.addAction(UIAlertAction(title: "OK", style: .default))

            present(alert, animated: true)
        }
    }

}

