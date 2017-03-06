//
//  RestaurantsSearchResultsController.swift
//  FoodEx
//
//  Created by Nana on 2/12/17.
//  Copyright © 2017 Apple. All rights reserved.
//

import UIKit

class RestaurantsSearchResultsController: UITableViewController, UISearchResultsUpdating, UISearchBarDelegate {

    var restaurants: Array<Restaurant> = [] {
        didSet {
            filteredRestaurants = restaurants
        }
    }
    var filteredRestaurants: Array<Restaurant> = [] {
        didSet {
            tableView.reloadData()
        }
    }

    // MARK: Overrides

    override func viewDidLoad() {
        super.viewDidLoad()

        restaurants = AppDataMart.shared.restaurants.sorted{$0.distance < $1.distance}
    }

    // MARK: Utils

    func filterRestaurants(nameOrCuisine searchText: String?, scope: Int = 0) {

        if let searchText = searchText {

            let filterOnlyTheNearest = (scope > 0)

            filteredRestaurants = restaurants.filter({ (element) -> Bool in

                var didPass = false

                // If Name matches, consider the element
                if element.name.lowercased().contains(searchText.lowercased()) {
                    didPass = true
                } else { // Or Else if the Cuisine type exists and matches
                    if searchText.lowercased().contains(element.cuisine.lowercased()) {
                        didPass = true
                    }
                }

                // If the element is considered, check the scope and validate the distance preference too...
                if didPass && filterOnlyTheNearest {
                    didPass = (element.distance <= 5)
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

        let tableCell = tableView.dequeueReusableCell(withIdentifier: "RestaurantSynopsis")! as! RestaurantSynopsisTableViewCell

        let restaurant = filteredRestaurants[indexPath.row]

        tableCell.nameLabel.text = restaurant.name
        tableCell.subTitleLabel.text = restaurant.description
        tableCell.distanceLabel.text = restaurant.formattedDistance
        tableCell.addressLabel.text = restaurant.address
        tableCell.symbolImageView.image = UIImage(named: restaurant.imageName)
        tableCell.setReviewStars(count: restaurant.reviewRating)
        tableCell.setCostDollars(count: restaurant.costRating)

        return tableCell
    }

    // MARK: UITableViewDelegate

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

        let selectedRestaurant = filteredRestaurants[indexPath.row]

        let destination = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "RestaurantDetailsViewController") as! RestaurantDetailsViewController

        destination.restaurant = selectedRestaurant

        // Present Restaurant Details View Controller using Dashboard's Nav controller
        self.presentingViewController?.navigationController?.pushViewController(destination, animated: true)
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
