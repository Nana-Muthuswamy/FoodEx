//
//  CartViewController.swift
//  FoodEx
//
//  Created by Nana on 3/6/17.
//  Copyright © 2017 Apple. All rights reserved.
//

import UIKit
import PassKit

class CartViewController: UITableViewController, UITextFieldDelegate, CartItemTableViewCellDelegate {

    var cart: Cart {
        return AppDataManager.shared.cart
    }

    struct CartDetailsSections {
        static let Summary = 0
        static let Items = 1
        static let Total = 2

        static func totalSections() -> Int {
            return 3
        }
    }

    // MARK: ---- Life Cycle ----

    override func viewDidLoad() {
        super.viewDidLoad()

        // Adding Tap Gesture Recognizer to end editing mode when tapping elsewhere in Table View
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTap))
        tableView.addGestureRecognizer(tapGesture)
    }

    // MARK: ---- Gesture Recognizer ----

    func handleTap(recognizer: UITapGestureRecognizer) -> Void {
        view.endEditing(true)
    }

    // MARK: ---- UITableViewDataSource ----

    override func numberOfSections(in tableView: UITableView) -> Int {

        if cart.items.count > 0 {
            return CartDetailsSections.totalSections()
        } else {
            return 1
        }
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        switch section {

        case CartDetailsSections.Summary:
            return 1

        case CartDetailsSections.Items:
            return cart.items.count

        case CartDetailsSections.Total:
            if cart.items.count > 0 {
                return 3
            } else {
                return 0
            }

        default:
            return 0
        }
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        switch indexPath.section {

        case CartDetailsSections.Summary:

            var tableCell: UITableViewCell

            if cart.items.count > 0 {
                tableCell = tableView.dequeueReusableCell(withIdentifier: "OrderTitle")!

                if let title = cart.title, let titleField = tableCell.viewWithTag(1) as? UITextField {
                    titleField.text = title
                }

            } else {
                tableCell = tableView.dequeueReusableCell(withIdentifier: "EmptyCart")!
            }

            return tableCell

        case CartDetailsSections.Items:

            let tableCell = tableView.dequeueReusableCell(withIdentifier: "CartItem") as! CartItemTableViewCell

            let menuItem = cart.items[indexPath.row]

            tableCell.nameLabel.text = menuItem.name
            tableCell.detailsLabel.text = "@" + menuItem.restaurantName
            tableCell.quantityField.text = String(menuItem.quantity)
            tableCell.priceLabel.text = menuItem.formattedTotalPrice
            tableCell.menuItemImageView.image = UIImage(named: menuItem.imageName)

            tableCell.delegate = self

            return tableCell

        case CartDetailsSections.Total:

            let tableCell: UITableViewCell

            if indexPath.row < 2 {
                tableCell = tableView.dequeueReusableCell(withIdentifier: "CartTotal")!
            } else {
                tableCell = tableView.dequeueReusableCell(withIdentifier: "SubmitCart")!
            }

            if indexPath.row == 0 {
                tableCell.textLabel?.text = "Sub Total"
                tableCell.detailTextLabel?.text = cart.formattedSubTotal
            } else if indexPath.row == 1 {
                tableCell.textLabel?.text = "Grand Total (tax incl.)"
                tableCell.detailTextLabel?.text = cart.formattedGrandTotal
            } else if indexPath.row == 2 {

                let paymentButton = PKPaymentButton(type: .plain, style: .black)

                paymentButton.addTarget(self, action: #selector(initiateApplePay), for: .touchUpInside)

                paymentButton.sizeToFit()
                paymentButton.translatesAutoresizingMaskIntoConstraints = false

                tableCell.contentView.addSubview(paymentButton)

                let paymentButtonConstraints = [NSLayoutConstraint(item: paymentButton, attribute: .centerX, relatedBy: .equal, toItem: tableCell.contentView, attribute: .centerX, multiplier: 1.0, constant: 0.0),NSLayoutConstraint(item: paymentButton, attribute: .centerY, relatedBy: .equal, toItem: tableCell.contentView, attribute: .centerY, multiplier: 1.0, constant: 0.0)]

                tableCell.contentView.addConstraints(paymentButtonConstraints)
            }

            return tableCell

        default:
            return UITableViewCell()
        }
    }

    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {

        switch section {

        case CartDetailsSections.Summary:
            if cart.items.count > 0 {
                return "Summary"
            } else {
                return ""
            }
        case CartDetailsSections.Items:
            if cart.items.count > 0 {
                return "Items"
            } else {
                return ""
            }
        case CartDetailsSections.Total:
            if cart.items.count > 0 {
                return "Total"
            } else {
                return ""
            }
        default:
            return ""
        }
    }

    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {

        switch indexPath.section {
        case CartDetailsSections.Items:
            return true
        default:
            return false
        }
    }

    // MARK: ---- UITableViewDelegate ----
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        switch indexPath.section {

        case CartDetailsSections.Summary:
            if cart.items.count > 0 {
                return 44
            } else {
                return 300
            }

        case CartDetailsSections.Items:
            return 70

        default:
            return 44
        }
    }

    override func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {

        switch indexPath.section {
        case CartDetailsSections.Items:

            let rowAction = UITableViewRowAction(style: .default, title: "Remove", handler: { (rowAction, indexPath) in
                // Remove the cart item in the current index
                AppDataManager.shared.cart.removeItem(at: indexPath.row)

                // End editing
                tableView.setEditing(false, animated: true)

                if AppDataManager.shared.cart.items.count > 0 {
                    // Delete row with animation
                    tableView.deleteRows(at: [indexPath], with: .fade)
                    // Update Totals
                    let indexSet = IndexSet(arrayLiteral:CartDetailsSections.Total)
                    tableView.reloadSections(indexSet, with: .fade)

                } else {
                    tableView.reloadData()
                }

            })

            rowAction.backgroundColor = UIColor.red

            
            return [rowAction]
            
        default:
            return nil
        }
        
    }

    // MARK: ---- UITextFieldDelegate ----

    func textFieldDidEndEditing(_ textField: UITextField) {
        // Update cart title
        AppDataManager.shared.cart.title = textField.text
    }

    // MARK: ---- CartItemTableViewCellDelegate ----

    func tableViewCell(_ tableCell: UITableViewCell, quantityDidChange newValue: Int) {

        if let indexPath = tableView.indexPath(for: tableCell), cart.items.count > indexPath.row {

            let existingValue = cart.items[indexPath.row].quantity

            if (existingValue != newValue) {

                if newValue > 0 {
                    cart.items[indexPath.row].quantity = newValue
                    tableView.reloadRows(at: [indexPath], with: .automatic)
                    // Update Totals
                    let indexSet = IndexSet(arrayLiteral:CartDetailsSections.Total)
                    tableView.reloadSections(indexSet, with: .automatic)

                } else {

                    // Remove the cart item in the current index
                    AppDataManager.shared.cart.removeItem(at: indexPath.row)

                    if AppDataManager.shared.cart.items.count > 0 {
                        // Delete row with animation
                        tableView.deleteRows(at: [indexPath], with: .fade)
                        // Update Totals
                        let indexSet = IndexSet(arrayLiteral:CartDetailsSections.Total)
                        tableView.reloadSections(indexSet, with: .fade)

                    } else {
                        tableView.reloadData()
                    }
                }
            }
        }
    }

    // MARK: ---- Apple Pay ----

    func initiateApplePay() -> Void {
        print("Lets say, completed ApplePay Payment")

        displayOrderConfirmation()
    }

    func displayOrderConfirmation() -> Void {



        print("Displaying Order confirmation")

        performSegue(withIdentifier: "ShowOrderConfirmationView", sender: self)
    }

    // MARK: ---- Segue ----

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {

        if segue.identifier == "ShowOrderConfirmationView" {
            print("Preparing Order confirmation view")

        }
    }
}
