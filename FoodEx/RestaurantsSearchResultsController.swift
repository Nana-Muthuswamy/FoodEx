//
//  RestaurantsSearchResultsController.swift
//  FoodEx
//
//  Created by Nana on 2/12/17.
//  Copyright © 2017 Apple. All rights reserved.
//

class RestaurantsSearchResultsController: UITableViewController, UISearchResultsUpdating, UISearchBarDelegate {

    var restaurants: [[String:Any]] = [] {
        didSet {
            filteredRestaurants = restaurants
        }
    }
    var filteredRestaurants: [[String:Any]] = [] {
        didSet {
            tableView.reloadData()
        }
    }

    // MARK: Overrides

    override func viewDidLoad() {
        super.viewDidLoad()

        if let restaurantList = AppGlobals.shared.restaurants {

            restaurants = restaurantList.sorted() {

                let firstDistance = Float(($0["Distance"] as! String?) ?? "") ?? 0.0
                let secondDistance = Float(($1["Distance"] as! String?) ?? "") ?? 0.0

                return firstDistance < secondDistance
            }
        }
    }

    // MARK: Utils

    func filterRestaurants(nameOrCuisine searchText: String?, scope: Int = 0) {

        if let searchText = searchText {

            let filterOnlyTheNearest = (scope > 0)

            filteredRestaurants = restaurants.filter({ (aRestaurant) -> Bool in

                var didPass = false
                // If Name isn't available for the element, should not make to filtered list!
                guard let name = aRestaurant["Name"] as! String? else {
                    return didPass
                }

                // If Name matches, consider the element
                if name.lowercased().contains(searchText.lowercased()) {
                    didPass = true
                } else if let cuisine = aRestaurant["Cuisine"] as! String? { // Or Else if the Cuisine type exists and matches
                    if searchText.lowercased().contains(cuisine.lowercased()) {
                        didPass = true
                    }
                }

                // If the element is considered, check the scope and validate the distance preference too...
                if didPass && filterOnlyTheNearest {

                    if let distanceStr = aRestaurant["Distance"] as! String?, let distance = Float(distanceStr) {
                        didPass = (distance <= 5)
                    }
                }

                return didPass
            })
        } else {
            
            filteredRestaurants = restaurants
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

        tableCell.nameLabel.text = restaurantSynopsis["Name"] as! String?
        tableCell.subTitleLabel.text = (restaurantSynopsis["Description"] as! String?) ?? "No description available."
        tableCell.distanceLabel.text = "\(restaurantSynopsis["Distance"]!) mi."
        tableCell.addressLabel.text = restaurantSynopsis["Address"] as! String?

        if let imageFileNameTypeComponents = (restaurantSynopsis["Image"] as! String?)?.components(separatedBy: ".") {
            tableCell.symbolImageView.image = UIImage(named: imageFileNameTypeComponents.first!)
        }

        if let reviewCount = Int((restaurantSynopsis["Reviews"] as! String?) ?? "0") {
            tableCell.setReviewStars(count: reviewCount)
        }

        if let costCount = Int((restaurantSynopsis["Cost"] as! String?) ?? "0") {
            tableCell.setCostDollars(count: costCount)
        }

        return tableCell
    }

    // MARK: UISearchResultsUpdating

    func updateSearchResults(for searchController: UISearchController) {

        filterRestaurants(nameOrCuisine: searchController.searchBar.text, scope: searchController.searchBar.selectedScopeButtonIndex)
    }

    // MARK: UISearchBarDelegate

    func searchBar(_ searchBar: UISearchBar, selectedScopeButtonIndexDidChange selectedScope: Int) {

        filterRestaurants(nameOrCuisine: searchBar.text, scope: searchBar.selectedScopeButtonIndex)
    }
}
