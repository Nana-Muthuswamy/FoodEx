//
//  RestaurantViewController.swift
//  FoodEx
//
//  Created by Nana on 2/28/17.
//  Copyright © 2017 Apple. All rights reserved.
//

import UIKit

class RestaurantViewController: AppBaseViewController {

    var restaurant: Restaurant!

    struct DetailsSection {
        static let Synopsis = 0
        static let Menu = 1

        static func totalSections() -> Int {
            return 2
        }
    }

    // MARK: View Life-cycle

    override func viewDidLoad() {
        super.viewDidLoad()

        // Add the restaurant to the last viewed list
        if let currentRestaurant = restaurant {
            AppDataManager.shared.user.saveViewedRestaurant(currentRestaurant)
        }
    }

    // MARK: UITableViewDataSource

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        switch section {

        case DetailsSection.Synopsis:
            return 1
        case DetailsSection.Menu:
            if restaurant != nil {
                return restaurant.menu.count
            } else {
                return 0
            }
        default:
            return 0
        }
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        switch indexPath.section {

        case DetailsSection.Synopsis:

            let tableCell = tableView.dequeueReusableCell(withIdentifier: "RestaurantSynopsis")! as! RestaurantSynopsisTableViewCell

            tableCell.nameLabel.text = restaurant.name
            tableCell.subTitleLabel.text = restaurant.description
            tableCell.distanceLabel.text = restaurant.formattedDistance
            tableCell.addressLabel.text = restaurant.address
            tableCell.symbolImageView.image = UIImage(named: restaurant.imageName)
            tableCell.setReviewStars(count: restaurant.reviewRating)
            tableCell.setCostDollars(count: restaurant.costRating)

            return tableCell

        case DetailsSection.Menu:

            let tableCell = tableView.dequeueReusableCell(withIdentifier: "MenuItem")! as! MenuItemTableViewCell

            let menuItem = restaurant.menu[indexPath.row]

            tableCell.nameLabel.text = menuItem.name
            tableCell.detailsLabel.text = menuItem.details
            tableCell.priceLabel.text = menuItem.formattedPrice
            tableCell.menuItemImageView.image = UIImage(named: menuItem.imageName)

            return tableCell

        default:
            return UITableViewCell()
        }
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        return DetailsSection.totalSections()
    }

    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {

        switch section {

        case DetailsSection.Synopsis:
            return "\(restaurant.cuisine) Cuisine"

        case DetailsSection.Menu:
            return "Menu"

        default:
            return ""
        }
    }

    override func tableView(_ tableView: UITableView, titleForFooterInSection section: Int) -> String? {

        switch section {

        case DetailsSection.Synopsis:
            return "Hours Today: \(restaurant.operationHours)"

        default:
            return ""
        }
    }

    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {

        switch indexPath.section {
        case DetailsSection.Menu:
            return true
        default:
            return false
        }
    }

    // MARK: UITableViewDelegate

    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        switch indexPath.section {

        case DetailsSection.Synopsis:
            return 100.0
        case DetailsSection.Menu:
            return 70.0
        default:
            return 0
        }
    }

    override func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {

        switch indexPath.section {
        case DetailsSection.Menu:

            let rowAction: UITableViewRowAction

            if let existingIndex = AppDataManager.shared.user.cart.items.index(where: { (item) -> Bool in
                return (item.restaurantName == restaurant.name &&
                    item.name == restaurant.menu[indexPath.row].name)
            }) {

                rowAction = UITableViewRowAction(style: .default, title: "Remove", handler: { (rowAction, indexPath) in
                    // Remove the cart item in the existing index
                    AppDataManager.shared.user.cart.removeItem(at: existingIndex)
                    // Update Cart Badge
                    self.updateCartBadge()
                    // End editing
                    tableView.setEditing(false, animated: true)
                })

                rowAction.backgroundColor = UIColor.red

            } else {

                rowAction = UITableViewRowAction(style: .default, title: "Add to Cart", handler: { (rowAction, indexPath) in
                    // Create Cart Item from selected menu item and add it to Cart
                    if let newCartItem = CartItem(from: self.restaurant, itemIndex: indexPath.row) {
                        AppDataManager.shared.user.cart.add(item: newCartItem)
                    }

                    // Update Cart Badge
                    self.updateCartBadge()
                    // End editing
                    tableView.setEditing(false, animated: true)
                })
                rowAction.backgroundColor = UIColor.green
            }

            return [rowAction]

        default:
            return nil
        }

    }

}
