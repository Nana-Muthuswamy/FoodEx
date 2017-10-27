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
    @IBOutlet weak var quantityInfoLabel: UILabel!

}

class CartItemTableViewCell: MenuItemTableViewCell, UITextFieldDelegate {
    @IBOutlet weak var quantityField: UITextField!

    weak var delegate: CartItemTableViewCellDelegate?
    
    // MARK: UITextFieldDelegate

    func textFieldDidEndEditing(_ textField: UITextField) {

        if let newText = textField.text, var newQuantity = Int(newText) {

            // Hack for limiting the quantity within 100 ;-) Who would order any item more than 100 times!
            newQuantity = newText.characters.count > 2 ? newQuantity/Int(pow(10, Double(newText.characters.count-2))) : newQuantity
            textField.text = String(newQuantity)

            delegate?.tableViewCell(self, quantityDidChange: newQuantity)
        } else {
            let newQuantity = 0
            textField.text = String(newQuantity)

            delegate?.tableViewCell(self, quantityDidChange: newQuantity)
        }
    }
}

protocol CartItemTableViewCellDelegate: class {

    func tableViewCell(_ tableCell: UITableViewCell, quantityDidChange newValue: Int) -> Void
}
