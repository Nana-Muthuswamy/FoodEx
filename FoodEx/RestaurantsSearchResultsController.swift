//
//  RestaurantsSearchResultsController.swift
//  FoodEx
//
//  Created by Nana on 2/12/17.
//  Copyright © 2017 Apple. All rights reserved.
//

class RestaurantsSearchResultsController: UITableViewController, UISearchResultsUpdating {

    var restaurants: [[String:String]] = [] {
        didSet {
            filteredRestaurants = restaurants
        }
    }
    var filteredRestaurants: [[String:String]] = [] {
        didSet {
            tableView.reloadData()
        }
    }

    // MARK: Overrides

    override func viewDidLoad() {
        super.viewDidLoad()

        if let restaurantList = AppDelegate().globals.restaurants {
            restaurants = restaurantList
        }
    }

    // MARK: UITableViewDataSource
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1;
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        return filteredRestaurants.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let reuseIdentifier = "Restaurant Synopsis"

        guard let tableCell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier) else {

            return UITableViewCell(style: .subtitle, reuseIdentifier: reuseIdentifier)
        }

        let restaurantSynopsis = filteredRestaurants[indexPath.row]

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


    // MARK: UISearchResultsUpdating

    func updateSearchResults(for searchController: UISearchController) {

        if var searchText = searchController.searchBar.text {

            var searchKey: String

            if searchText.contains("Restaurants") {
                searchKey = "Cuisine"
                searchText = searchText.components(separatedBy: .whitespaces).first!
            } else {
                searchKey = "Name"
            }

            filteredRestaurants = restaurants.filter{$0[searchKey]!.lowercased().contains(searchText.lowercased())}

        } else {

            filteredRestaurants = restaurants
        }
    }

}
