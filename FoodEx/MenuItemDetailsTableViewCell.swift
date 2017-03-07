//
//  MenuItemDetailsTableViewCell.swift
//  FoodEx
//
//  Created by Nana on 2/28/17.
//  Copyright © 2017 Apple. All rights reserved.
//

import UIKit

class MenuItemTableViewCell: UITableViewCell {

    @IBOutlet weak var menuItemImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var detailsLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!

}

class CartItemTableViewCell: MenuItemTableViewCell {
    @IBOutlet weak var quantityField: UITextField!

}
