//
//  OrderViewController.swift
//  FoodEx
//
//  Created by Nana on 3/4/17.
//  Copyright © 2017 Apple. All rights reserved.
//

import UIKit

class OrderViewController: UITableViewController {

    var orderDetails: Order!

    struct OrderDetailsSections {
        static let Summary = 0
        static let MenuItem = 1
        static let Total = 2

        static func totalSections() -> Int {
            return 3
        }
    }

    // MARK: UITableViewDataSource

    override func numberOfSections(in tableView: UITableView) -> Int {
        return OrderDetailsSections.totalSections()
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        switch section {

        case OrderDetailsSections.Summary:
            if (orderDetails) != nil {
                return 2
            } else {
                return 0
            }

        case OrderDetailsSections.MenuItem:
            if orderDetails.couponIncluded {
                return orderDetails.items.count + 1
            } else {
                return orderDetails.items.count
            }

        case OrderDetailsSections.Total:
            if (orderDetails) != nil {
                return 4
            } else {
                return 0
            }

        default:
            return 0
        }
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        switch indexPath.section {

        case OrderDetailsSections.Summary:

            let tableCell = tableView.dequeueReusableCell(withIdentifier: "OrderItemDetail")!

            if indexPath.row == 0 {
                tableCell.textLabel?.text = "Title"

                let detailTextPrefix = orderDetails.title.characters.count > 0 ? "\(orderDetails.title)" : "Order"
                tableCell.detailTextLabel?.text = detailTextPrefix + " @ " + orderDetails.date

            } else if indexPath.row == 1 {
                tableCell.textLabel?.text = "Reference #"
                tableCell.detailTextLabel?.text = orderDetails.reference
            }

            return tableCell

        case OrderDetailsSections.MenuItem:

            if indexPath.row == orderDetails.items.count {

                return tableView.dequeueReusableCell(withIdentifier: "Coupon")!

            } else {

                let tableCell = tableView.dequeueReusableCell(withIdentifier: "MenuItem") as! MenuItemTableViewCell

                let menuItem = orderDetails.items[indexPath.row]

                tableCell.nameLabel.text = menuItem.name
                tableCell.detailsLabel.text = "@" + menuItem.restaurantName
                tableCell.priceLabel.text = menuItem.formattedPrice
                tableCell.quantityInfoLabel.text = menuItem.formattedQuantity
                tableCell.menuItemImageView.image = UIImage(named: menuItem.imageName)
                
                return tableCell
            }

        case OrderDetailsSections.Total:

            let tableCell = tableView.dequeueReusableCell(withIdentifier: "OrderItemDetail")!

            if indexPath.row == 0 {
                tableCell.textLabel?.text = "Sub Total"
                tableCell.detailTextLabel?.text = orderDetails.formattedSubTotal
            } else if indexPath.row == 1 {
                tableCell.textLabel?.text = "Tax (8.75%)"
                tableCell.detailTextLabel?.text = orderDetails.formattedTax
            } else if indexPath.row == 2 {
                tableCell.textLabel?.text = "Delivery"
                tableCell.detailTextLabel?.text = orderDetails.formattedDeliveryCharge
            } else if indexPath.row == 3 {
                tableCell.textLabel?.text = "Grand Total"
                tableCell.detailTextLabel?.text = orderDetails.formattedGrandTotal
            }

            return tableCell

        default:
            return UITableViewCell()
        }
    }

    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {

        switch section {

        case OrderDetailsSections.Summary:
            return "Summary"
        case OrderDetailsSections.MenuItem:
            return "Items"
        case OrderDetailsSections.Total:
            return "Total"
        default:
            return ""
        }
    }

    // MARK: UITableViewDelegate

    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {

        switch indexPath.section {

        case OrderDetailsSections.MenuItem:

            if indexPath.row == orderDetails.items.count {
                return 44
            } else {
                return 70
            }
        default:
            return 44
        }
    }
}
