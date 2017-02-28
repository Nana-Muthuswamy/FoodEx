//
//  RestaurantsSearchViewController.swift
//  FoodEx
//
//  Created by Nana on 2/12/17.
//  Copyright © 2017 Apple. All rights reserved.
//

import UIKit

class RestaurantsSearchViewController: UIViewController, UISearchControllerDelegate {

    var searchController: UISearchController!
    @IBOutlet weak var searchBarContainer: UIView!

    // MARK: Overrides

    override func viewDidLoad() {
        super.viewDidLoad()

        // Setup Search Controller
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
        searchBarContainer.addSubview(searchController.searchBar)
        searchBarContainer.sizeToFit()

        // Setup Presentation Traits
        definesPresentationContext = true
        searchController.hidesNavigationBarDuringPresentation = true
    }

    // MARK: IBActions
    @IBAction func quickSearch(_ sender: UIButton) {

        // Get the title of the quick search button
        if var quickSearchType = sender.title(for: .normal) {

            // Just a silly cosmetic correction done in the cheapest way possible!
            if (quickSearchType == "Favorites") {quickSearchType = "Favorite"}

            // Set the search bar's text
            searchController.searchBar.text = "\(quickSearchType) Restaurants"
            // Force activate UISearchController
            searchController.searchBar.becomeFirstResponder()
        }

    }
    
}
