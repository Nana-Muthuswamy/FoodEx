//
//  CartViewController.swift
//  FoodEx
//
//  Created by Nana on 3/6/17.
//  Copyright © 2017 Apple. All rights reserved.
//

import UIKit

class CartViewController: UITableViewController {

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

        if (orderDetails != nil) {
            return OrderDetailsSections.totalSections()
        } else {
            return 1
        }
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        switch section {

        case OrderDetailsSections.Summary:
            if (orderDetails) != nil {
                return 2
            } else {
                return 1
            }

        case OrderDetailsSections.MenuItem:
            if let count = orderDetails?.items.count {
                return count
            } else {
                return 0
            }

//        case OrderDetailsSections.Total:
//            if (orderDetails) != nil {
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

        case OrderDetailsSections.Summary:

            var tableCell: UITableViewCell

            if (orderDetails != nil) {
                tableCell = tableView.dequeueReusableCell(withIdentifier: "OrderTitle")!
            } else {
                tableCell = tableView.dequeueReusableCell(withIdentifier: "EmptyCart")!
            }

            return tableCell

        case OrderDetailsSections.MenuItem:

            let tableCell = tableView.dequeueReusableCell(withIdentifier: "MenuDetails") as! MenuItemDetailsTableViewCell

            let menuItem = orderDetails.items[indexPath.row]

            tableCell.nameLabel.text = menuItem.name
            tableCell.detailsLabel.text = "@" + menuItem.restaurantName
            tableCell.priceLabel.text = menuItem.formattedPrice
            tableCell.menuItemImageView.image = UIImage(named: menuItem.imageName)

            return tableCell

//        case OrderDetailsSections.Total:
//
//            let tableCell = tableView.dequeueReusableCell(withIdentifier: "OrderItemDetail")!
//
//            if indexPath.row == 0 {
//                tableCell.textLabel?.text = "Sub Total"
//                tableCell.detailTextLabel?.text = orderDetails.formattedSubTotal
//            } else if indexPath.row == 1 {
//                tableCell.textLabel?.text = "Grand Total (tax incl.)"
//                tableCell.detailTextLabel?.text = orderDetails.formattedGrandTotal
//            }
//
//            return tableCell

        default:
            return UITableViewCell()
        }
    }

    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {

        switch section {

        case OrderDetailsSections.Summary:
            if (orderDetails != nil) {
                return "Summary"
            } else {
                return ""
            }
        case OrderDetailsSections.MenuItem:
            if let count = orderDetails?.items.count, count > 0 {
                return "Items"
            } else {
                return ""
            }
//        case OrderDetailsSections.Total:
//            return "Total"
        default:
            return ""
        }
    }

    // MARK: UITableViewDelegate
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        switch indexPath.section {

        case OrderDetailsSections.Summary:
            if (orderDetails != nil) {
                return 44
            } else {
                return 300
            }

        case OrderDetailsSections.MenuItem:
            return 70

        default:
            return 44
        }
    }

}
