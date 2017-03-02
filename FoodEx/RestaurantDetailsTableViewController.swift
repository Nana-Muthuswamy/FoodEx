//
//  RestaurantDetailsViewController.swift
//  FoodEx
//
//  Created by Nana on 2/28/17.
//  Copyright © 2017 Apple. All rights reserved.
//

import UIKit

class RestaurantDetailsViewController: UITableViewController {

    var restaurantSynopsis = [String:String]()
    var menuList = [[String:String]]()

    // MARK: UITableViewDataSource

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        switch section {
        case 0:
            return 1
        case 1:
            return menuList.count
        default:
            return 0
        }
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        switch indexPath.section {

        case 0:

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

        case 1:
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
        case 1:
            return "Menu"
        default:
            return ""
        }
    }

    // MARK: UITableViewDelegate

    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        switch indexPath.section {
        case 0:
            return 100.0
        case 1:
            return 70.0
        default:
            return 0
        }
    }

}
