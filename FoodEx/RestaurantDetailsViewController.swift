//
//  RestaurantDetailsViewController.swift
//  FoodEx
//
//  Created by Nana on 2/28/17.
//  Copyright © 2017 Apple. All rights reserved.
//

import UIKit

class RestaurantDetailsViewController: AppBaseViewController {

    var restaurantSynopsis = Dictionary<String, String>()
    var menuList = [Dictionary<String, String>]()

    struct DetailsSection {
        static let Synopsis = 0
        static let Menu = 1
    }

    // MARK: UITableViewDataSource

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        switch section {

        case DetailsSection.Synopsis:
            return 1
        case DetailsSection.Menu:
            return menuList.count
        default:
            return 0
        }
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        switch indexPath.section {

        case DetailsSection.Synopsis:

            let tableCell = tableView.dequeueReusableCell(withIdentifier: "RestaurantSynopsis")! as! RestaurantSynopsisTableViewCell

            tableCell.nameLabel.text = restaurantSynopsis["Name"]
            tableCell.subTitleLabel.text = restaurantSynopsis["Description"] ?? "No description available."
            tableCell.distanceLabel.text = "\(restaurantSynopsis["Distance"]!) mi."
            tableCell.addressLabel.text = restaurantSynopsis["Address"]

            if let imageFileNameTypeComponents = restaurantSynopsis["Image"]?.components(separatedBy: ".") {
                tableCell.symbolImageView.image = UIImage(named: imageFileNameTypeComponents.first!)
            }

            if let reviewCount = Int(restaurantSynopsis["Reviews"] ?? "0") {
                tableCell.setReviewStars(count: reviewCount)
            }

            if let costCount = Int(restaurantSynopsis["Cost"] ?? "0") {
                tableCell.setCostDollars(count: costCount)
            }
            
            return tableCell

        case DetailsSection.Menu:

            let tableCell = tableView.dequeueReusableCell(withIdentifier: "MenuDetails")! as! MenuItemDetailsTableViewCell

            let menuItemDetail = menuList[indexPath.row]

            tableCell.nameLabel.text = menuItemDetail["Name"]
            tableCell.detailsLabel.text = menuItemDetail["Details"]
            tableCell.priceLabel.text = menuItemDetail["Price"]

            if let imageFileNameTypeComponents = menuItemDetail["Image"]?.components(separatedBy: ".") {
                tableCell.menuItemImageView.image = UIImage(named: imageFileNameTypeComponents.first!)
            }

            return tableCell

        default:
            return UITableViewCell()
        }
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }

    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {

        switch section {

        case DetailsSection.Synopsis:

            var headerTitle: String?

            if let cuisineType = restaurantSynopsis["Cuisine"] {
                headerTitle = "\(cuisineType) Cuisine"
            }

            return headerTitle

        case DetailsSection.Menu:
            return "Menu"

        default:
            return ""
        }
    }

    override func tableView(_ tableView: UITableView, titleForFooterInSection section: Int) -> String? {

        switch section {

        case DetailsSection.Synopsis:

            var footerTitle: String?

            if let operationHours = restaurantSynopsis["OperationHours"] {
                footerTitle = "Hours Today: \(operationHours)"
            }

            return footerTitle

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

            let rowAction = UITableViewRowAction(style: .default, title: "Add to Cart", handler: { (rowAction, indexPath) in
                // TDO: Add the menuList[indexPath.row] to Order.menuList
                print("Menu Item added to Cart")
            })
            rowAction.backgroundColor = UIColor.green

            return [rowAction]

        default:
            return nil
        }

    }


}
