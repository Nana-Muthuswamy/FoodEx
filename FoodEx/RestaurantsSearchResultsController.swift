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

        let tableCell = tableView.dequeueReusableCell(withIdentifier: "Restaurant Synopsis")! as! RestaurantSynopsisTableViewCell

        let restaurantSynopsis = filteredRestaurants[indexPath.row]

        tableCell.nameLabel.text = restaurantSynopsis["Name"]
        tableCell.subTitleLabel.text = restaurantSynopsis["Description"] ?? "No description available."
        tableCell.distanceLabel.text = "\(restaurantSynopsis["Distance"]!) Miles"
        tableCell.addressLabel.text = restaurantSynopsis["Address"]

        if let imageFileNameTypeComponents = restaurantSynopsis["Image"]?.components(separatedBy: ".") {
            tableCell.symbolImageView.image = UIImage(named: imageFileNameTypeComponents.first!)
        }

        return tableCell
    }


    // MARK: UISearchResultsUpdating

    func updateSearchResults(for searchController: UISearchController) {

        if let searchText = searchController.searchBar.text {

            filteredRestaurants = restaurants.filter{
                $0["Name"]!.lowercased().contains(searchText.lowercased()) ||
                searchText.lowercased().contains($0["Cuisine"]!.lowercased())
            }

        } else {

            filteredRestaurants = restaurants
        }
    }

}
