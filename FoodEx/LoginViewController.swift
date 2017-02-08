//
//  LoginViewController.swift
//  FoodEx
//
//  Created by Nana on 2/4/17.
//  Copyright © 2017 Apple. All rights reserved.
//

import UIKit
import LocalAuthentication

class LoginViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.

        let myContext = LAContext()
        var authError : NSError? = nil

        if (myContext.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &authError)) {

            myContext.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: "Sign in with your fingerprint or cancel to login manually") { (success, evaluateError) in

                if (success) {

                    print("Touch ID success")

                } else {

                    print("Touch ID failure: \(evaluateError)")
                    self.handleTouchIDAuthFailure(LAError(_nsError: evaluateError as! NSError).code)
                }
            }

        } else {

            print("Touch ID authentication not possible.")
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: Utils Functions

    func handleTouchIDAuthFailure(_ errorCd: LAError.Code) -> Void {

        var userErrorInfo = ""

        switch errorCd {

        case .authenticationFailed:
            userErrorInfo = "Touch ID Auth failed."
        case .userCancel:
            userErrorInfo = "Touch ID Auth cancelled by user."
        case .userFallback:
            userErrorInfo = "Touch ID Auth ignored and user fallsback to manual sign in."
        case .systemCancel:
            userErrorInfo = "Touch ID Auth cancelled by system."
        case .passcodeNotSet:
            userErrorInfo = "Touch ID Auth failed as passcode was not set in the device."
        case .touchIDNotAvailable:
            userErrorInfo = "Touch ID Auth not supported in the device."
        case .touchIDNotEnrolled:
            userErrorInfo = "Touch ID Auth not enrolled in the device."
        default:
            userErrorInfo = "Touch ID Auth failed due to unknown reasons."
        }

        let alert = UIAlertController(title: "User Authentication Error", message: userErrorInfo, preferredStyle: .alert)

        alert.addAction(UIAlertAction(title: "OK", style: .default))

        present(alert, animated: true)

    }

}

