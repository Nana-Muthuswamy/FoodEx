//
//  CartViewController.swift
//  FoodEx
//
//  Created by Nana on 3/6/17.
//  Copyright © 2017 Apple. All rights reserved.
//

import UIKit

class CartViewController: UITableViewController {

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

    // MARK: UITableViewDataSource

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

//        case CartDetailsSections.Total:
//            if (cart) != nil {
//                return 2
//            } else {
//                return 0
//            }

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
            } else {
                tableCell = tableView.dequeueReusableCell(withIdentifier: "EmptyCart")!
            }

            return tableCell

        case CartDetailsSections.Items:

            let tableCell = tableView.dequeueReusableCell(withIdentifier: "CartItem") as! CartItemTableViewCell

            let menuItem = cart.items[indexPath.row]

            tableCell.nameLabel.text = menuItem.name
            tableCell.detailsLabel.text = "@" + menuItem.restaurantName
            tableCell.priceLabel.text = menuItem.formattedPrice
            tableCell.menuItemImageView.image = UIImage(named: menuItem.imageName)

            return tableCell

//        case CartDetailsSections.Total:
//
//            let tableCell = tableView.dequeueReusableCell(withIdentifier: "OrderItemDetail")!
//
//            if indexPath.row == 0 {
//                tableCell.textLabel?.text = "Sub Total"
//                tableCell.detailTextLabel?.text = cart.formattedSubTotal
//            } else if indexPath.row == 1 {
//                tableCell.textLabel?.text = "Grand Total (tax incl.)"
//                tableCell.detailTextLabel?.text = cart.formattedGrandTotal
//            }
//
//            return tableCell

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
//        case CartDetailsSections.Total:
//            return "Total"
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

    // MARK: UITableViewDelegate
    
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

}
