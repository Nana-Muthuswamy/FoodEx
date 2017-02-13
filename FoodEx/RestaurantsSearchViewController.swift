//
//  RestaurantsSearchViewController.swift
//  FoodEx
//
//  Created by Nana on 2/12/17.
//  Copyright © 2017 Apple. All rights reserved.
//

class RestaurantsSearchViewController: UIViewController {

    @IBOutlet weak var searchBar: UISearchBar!

    // MARK: Overrides
    override func viewDidLoad() {
        super.viewDidLoad()

        // Set the title
        self.navigationItem.title = "FoodEx Restaurants"
    }


    // MARK: IBActions
    @IBAction func quickSearch(_ sender: UIButton) {

        // Get the title of the quick search button
        if var quickSearchType = sender.title(for: .normal) {

            // Just a silly cosmetic correction done in the cheapest way possible!
            if (quickSearchType == "Favorites") {quickSearchType = "Favorite"}

            // Set the search bar's text
            searchBar.text = "\(quickSearchType) Restaurants"
        }

    }
    
}
