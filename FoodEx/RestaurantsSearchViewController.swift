//
//  RestaurantsSearchViewController.swift
//  FoodEx
//
//  Created by Nana on 2/12/17.
//  Copyright © 2017 Apple. All rights reserved.
//

class RestaurantsSearchViewController: UIViewController, UISearchBarDelegate {

    @IBOutlet weak var searchBar: UISearchBar!

    // MARK: Overrides
    override func viewDidLoad() {
        super.viewDidLoad()

        // TODO: Setup Data for Search Results
    }

    // MARK: Segue
    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {

        return false
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {

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
            searchBar.text = "\(quickSearchType) Restaurants"
        }

    }
    
}
