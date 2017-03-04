//
//  DashboardViewController.swift
//  FoodEx
//
//  Created by Nana on 2/12/17.
//  Copyright © 2017 Apple. All rights reserved.
//

import UIKit

class DashboardViewController: UITableViewController, UISearchControllerDelegate {

    private var searchController: UISearchController!

    private var cuisines = [String]()
    private var restaurantsHistory = [[String:String]]()

    struct DashboardSections {
        static let QuickSearch = 0
        static let LastSeen = 1
    }

    // MARK: Overrides

    override func viewDidLoad() {
        super.viewDidLoad()

        // Setup Search Controller
        setupSearchController()

        // Setup Presentation Traits
        definesPresentationContext = true
        let cartButton = UIButton(frame: CGRect(x: 0, y: 0, width: 30, height: 30))
        cartButton.setBackgroundImage(UIImage(named: "Cart"), for: .normal)
        cartButton.addTarget(self, action: #selector(presentCartViewController), for: .touchDown)

        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: cartButton)

        // Setup Data
        setupData()
    }

    // MARK: UITableViewDataSource

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        switch section {

        case DashboardSections.QuickSearch:
            return cuisines.count
        case DashboardSections.LastSeen:
            return restaurantsHistory.count
        default:
            return 0
        }
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        switch indexPath.section {

        case DashboardSections.QuickSearch:

            let tableCell = tableView.dequeueReusableCell(withIdentifier: "CuisineName")!
            tableCell.textLabel?.text = cuisines[indexPath.row]

            return tableCell

        case DashboardSections.LastSeen:

            let tableCell = tableView.dequeueReusableCell(withIdentifier: "RestaurantSynopsis")! as! RestaurantSynopsisTableViewCell

            let restaurantSynopsis = restaurantsHistory[indexPath.row]

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

        default:
            return UITableViewCell()
        }
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }

    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {

        switch section {

        case DashboardSections.QuickSearch:
            return "Quick Search"
        case DashboardSections.LastSeen:
            return "Last Seen"
        default:
            return ""
        }
    }

    // MARK: UITableViewDelegate

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

        if indexPath.section == DashboardSections.QuickSearch {
            // Set the search bar's text
            searchController.searchBar.text = cuisines[indexPath.row]
            // Force activate UISearchController
            searchController.searchBar.becomeFirstResponder()
        }
    }

    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        switch indexPath.section {

        case DashboardSections.QuickSearch:
            return 44.0
        case DashboardSections.LastSeen:
            return 100.0
        default:
            return 0
        }
    }

    // MARK: Utils
    private func setupSearchController() -> Void {

        let searchResultsController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "RestaurantsSearchResultsController") as! RestaurantsSearchResultsController

        searchController = UISearchController(searchResultsController: searchResultsController)
        searchController.searchResultsUpdater = searchResultsController

        searchController.delegate = self
        searchController.searchBar.delegate = searchResultsController

        // Update Search Bar's properties
        searchController.searchBar.placeholder = "Restaurant or Cuisine"
        searchController.searchBar.scopeButtonTitles = ["All","< 5 Miles"]
        searchController.searchBar.sizeToFit()

        // Add Search Bar to the view
        tableView.tableHeaderView = searchController.searchBar
    }

    private func setupData() -> Void {

        if let availableCuisines = AppGlobals.shared.cuisines {
            cuisines = availableCuisines
        }

        if let history = AppGlobals.shared.restaurantsHistory {
            restaurantsHistory = history
        }
    }

    // MARK: Segue

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {

        if (segue.identifier == "ShowRestaurantDetails") {

            if let indexPath = tableView.indexPath(for: sender as! UITableViewCell) {

                let selectedRestaurant = restaurantsHistory[indexPath.row]

                let destination = segue.destination as! RestaurantDetailsViewController

                destination.restaurantSynopsis = selectedRestaurant

                if let restaurantName = selectedRestaurant["Name"], let menuList = AppGlobals.shared.menuList(for: restaurantName) {
                    destination.menuList = menuList
                }
            }
        }
    }

    func presentCartViewController() -> Void {
        print("Displaying Cart View")
    }
}
