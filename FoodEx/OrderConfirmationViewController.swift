//
//  OrderConfirmationViewController.swift
//  FoodEx
//
//  Created by Nana on 3/9/17.
//  Copyright © 2017 Apple. All rights reserved.
//

import UIKit

class OrderConfirmationViewController: UIViewController {

    @IBOutlet weak var orderNumberLabel: UILabel!
    @IBOutlet weak var emailLabel: UILabel!

    var order: Order!

    // MARK: Life Cycle

    override func viewDidLoad() {
        super.viewDidLoad()

        orderNumberLabel.text = order.reference
        // TDO: Extract email for the logged in user

        AppDataManager.shared.saveOrder(order)
    }
}
