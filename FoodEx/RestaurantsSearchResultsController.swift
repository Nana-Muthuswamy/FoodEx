//
//  RestaurantsSearchResultsController.swift
//  FoodEx
//
//  Created by Nana on 2/12/17.
//  Copyright © 2017 Apple. All rights reserved.
//

class RestaurantsSearchResultsController: UITableViewController {

    var restaurants: [[String:String]] = []

    // MARK: UITableViewDataSource
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1;
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        return restaurants.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let reuseIdentifier = "Restaurant Synopsis"

        guard let tableCell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier) else {

            return UITableViewCell(style: .subtitle, reuseIdentifier: reuseIdentifier)
        }

        let restaurantSynopsis = restaurants[indexPath.row]

        tableCell.textLabel?.text = restaurantSynopsis["Name"]

        var description = restaurantSynopsis["Description"] ?? "No description available."

        if let distance = restaurantSynopsis["Distance"] {
            description.append(" | \(distance) Miles")
        }

        tableCell.detailTextLabel?.text = description


        if let imageFileNameTypeComponents = restaurantSynopsis["Image"]?.components(separatedBy: ".") {

            tableCell.imageView?.image = UIImage(named: imageFileNameTypeComponents.first!)
        }

        return tableCell
    }

    

    // MARK: UITableViewDelegate

}
