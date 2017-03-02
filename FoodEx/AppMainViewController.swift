//
//  AppMainViewController.swift
//  FoodEx
//
//  Created by Nana on 2/12/17.
//  Copyright © 2017 Apple. All rights reserved.
//

import UIKit

class AppMainViewController: UITableViewController, UISearchControllerDelegate {

    private var searchController: UISearchController!

    private var cuisines = [String]()

    // MARK: Overrides

    override func viewDidLoad() {
        super.viewDidLoad()

        // Setup Search Controller
        setupSearchController()

        // Setup Presentation Traits
        definesPresentationContext = true

        // Setup Data
        setupData()
    }

    // MARK: UITableViewDataSource

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        switch section {
        case 0:
            return cuisines.count
        default:
            return 0
        }
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let cell = tableView.dequeueReusableCell(withIdentifier: "CuisineName")!

        cell.textLabel?.text = cuisines[indexPath.row]

        return cell
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {

        switch section {
        case 0:
            return "Quick Search"
        default:
            return ""
        }
    }

    // MARK: UITableViewDelegate

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

        // Set the search bar's text
        searchController.searchBar.text = cuisines[indexPath.row]
        // Force activate UISearchController
        searchController.searchBar.becomeFirstResponder()
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
    }

}
