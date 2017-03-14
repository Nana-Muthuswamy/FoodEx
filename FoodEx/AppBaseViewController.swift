//
//  AppBaseViewController.swift
//  FoodEx
//
//  Created by Divya on 3/3/17.
//  Copyright © 2017 Apple. All rights reserved.
//

import UIKit

class AppBaseViewController: UITableViewController {

    private var cartButton: BadgeButton!

    override func viewDidLoad() {
        super.viewDidLoad()

        cartButton = BadgeButton(frame: CGRect(x: 0, y: 0, width: 30, height: 30))
        cartButton.setBackgroundImage(UIImage(named: "Cart"), for: .normal)
        cartButton.addTarget(self, action: #selector(presentCartViewController), for: .touchDown)
        cartButton.badgeEdgeInsets = UIEdgeInsetsMake(10, 0, 0, 0)

        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: cartButton)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        updateCartBadge()
    }

    func presentCartViewController() -> Void {

        let destination = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "CartViewController") as! CartViewController

        if let source = navigationController?.viewControllers.first as? DashboardViewController {

            source.navigationController?.pushViewController(destination, animated: true)
        }
    }

    func updateCartBadge() -> Void {

        let cartCount = AppDataManager.shared.user.cart.items.count
        cartButton?.badgeString = cartCount > 0 ? String(cartCount) : ""
    }

}
