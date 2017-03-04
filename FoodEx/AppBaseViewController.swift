//
//  AppBaseViewController.swift
//  FoodEx
//
//  Created by Nana on 3/3/17.
//  Copyright © 2017 Apple. All rights reserved.
//

import UIKit

class AppBaseViewController: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        let cartButton = UIButton(frame: CGRect(x: 0, y: 0, width: 30, height: 30))
        cartButton.setBackgroundImage(UIImage(named: "Cart"), for: .normal)
        cartButton.addTarget(self, action: #selector(presentOrderDetails), for: .touchDown)

        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: cartButton)
    }

    func presentOrderDetails() -> Void {
        print("Displaying Cart View")

        let destination = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "OrderDetailsViewController")

        if let source = navigationController?.viewControllers.first as? DashboardViewController {

            source.navigationController?.pushViewController(destination, animated: true)
        }
    }
}
