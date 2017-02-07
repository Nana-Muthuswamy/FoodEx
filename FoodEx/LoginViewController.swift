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


}

