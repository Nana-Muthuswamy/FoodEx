//
//  RestaurantsSearchViewController.swift
//  FoodEx
//
//  Created by Nana on 2/12/17.
//  Copyright © 2017 Apple. All rights reserved.
//

class RestaurantsSearchViewController: UIViewController, UISearchBarDelegate, UISearchControllerDelegate {

    var searchController: UISearchController!

    // MARK: Overrides

    override func viewDidLoad() {
        super.viewDidLoad()

        // Setup Search Controller
        let searchResultsController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "RestaurantsSearchResultsController")

        searchController = UISearchController(searchResultsController: searchResultsController)
        searchController.searchResultsUpdater = searchResultsController as! RestaurantsSearchResultsController

        searchController.delegate = self
        searchController.searchBar.delegate = self

        // Add Search Bar to the view
        navigationItem.titleView = searchController.searchBar

        // Setup Presentation Traits
        definesPresentationContext = true
        searchController.dimsBackgroundDuringPresentation = true
        searchController.hidesNavigationBarDuringPresentation = false
        searchController.obscuresBackgroundDuringPresentation = false
        
    }

    // MARK: UISearchBarDelegate

    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        print("Search Text: \(searchBar.text.debugDescription)")
    }

    // MARK: IBActions
    @IBAction func quickSearch(_ sender: UIButton) {

        // Get the title of the quick search button
        if var quickSearchType = sender.title(for: .normal) {

            // Just a silly cosmetic correction done in the cheapest way possible!
            if (quickSearchType == "Favorites") {quickSearchType = "Favorite"}

            // Set the search bar's text
            searchController.searchBar.text = "\(quickSearchType) Restaurants"
        }

    }
    
}
