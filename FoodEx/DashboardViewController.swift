//
//  DashboardViewController.swift
//  FoodEx
//
//  Created by Nana on 2/12/17.
//  Copyright © 2017 Apple. All rights reserved.
//

import UIKit

class DashboardViewController: AppBaseViewController, UISearchControllerDelegate {

    private var searchController: UISearchController!

    private var cuisines = Array<String>()
    private var restaurantsLastViewed = Array<Restaurant>()
    private var orderHistory = Array<Order>()

    struct DashboardSections {
        static let QuickSearch = 0
        static let LastViewed = 1
        static let OrderHistory = 2
    }

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

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        restaurantsLastViewed = AppDataManager.shared.user.restaurantsLastViewed
        orderHistory = AppDataManager.shared.user.orderHistory

        tableView.reloadData()
    }

    // MARK: UITableViewDataSource

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        switch section {

        case DashboardSections.QuickSearch:
            return cuisines.count
        case DashboardSections.LastViewed:
            return restaurantsLastViewed.count
        case DashboardSections.OrderHistory:
            return orderHistory.count
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

        case DashboardSections.LastViewed:

            let tableCell = tableView.dequeueReusableCell(withIdentifier: "RestaurantSynopsis")! as! RestaurantSynopsisTableViewCell

            let restaurant = restaurantsLastViewed[indexPath.row]

            tableCell.nameLabel.text = restaurant.name
            tableCell.subTitleLabel.text = restaurant.description
            tableCell.distanceLabel.text = restaurant.formattedDistance
            tableCell.addressLabel.text = restaurant.address
            tableCell.symbolImageView.image = UIImage(named: restaurant.imageName)
            tableCell.setReviewStars(count: restaurant.reviewRating)
            tableCell.setCostDollars(count: restaurant.costRating)

            return tableCell

        case DashboardSections.OrderHistory:

            let tableCell = tableView.dequeueReusableCell(withIdentifier: "OrderSummary") as! OrderSummaryTableViewCell

            let order = orderHistory[indexPath.row]

            tableCell.summaryLabel.text = order.title + " - " + order.date
            tableCell.itemDetailsLabel.text = order.summary
            tableCell.totalLabel.text = order.formattedGrandTotal

            return tableCell

        default:
            return UITableViewCell()
        }
    }

    override func numberOfSections(in tableView: UITableView) -> Int {

        if restaurantsLastViewed.count > 0 && orderHistory.count > 0 {
            return 3
        } else if restaurantsLastViewed.count > 0 || orderHistory.count > 0 {
            return 2
        } else {
            return 1
        }
    }

    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {

        switch section {

        case DashboardSections.QuickSearch:
            return "Quick Search"
        case DashboardSections.LastViewed:
            return "Last Viewed"
        case DashboardSections.OrderHistory:
            return "Order History"
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
        case DashboardSections.LastViewed:
            return 100.0
        case DashboardSections.OrderHistory:
            return 70.0
        default:
            return 0
        }
    }

    // MARK: Utils
    private func setupSearchController() -> Void {

        let searchResultsController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "RestaurantSearchResultsController") as! RestaurantSearchResultsController

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

        cuisines = AppDataManager.shared.cuisines
        restaurantsLastViewed = AppDataManager.shared.user.restaurantsLastViewed
        orderHistory = AppDataManager.shared.user.orderHistory
    }

    // MARK: Segue

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {

        if (segue.identifier == "ShowRestaurantView") {

            if let indexPath = tableView.indexPath(for: sender as! UITableViewCell) {

                let selectedRestaurant = restaurantsLastViewed[indexPath.row]

                let destination = segue.destination as! RestaurantViewController

                destination.restaurant = selectedRestaurant
            }

        } else if (segue.identifier == "ShowOrderView") {

            if let indexPath = tableView.indexPath(for: sender as! UITableViewCell) {

                let selectedOrder = orderHistory[indexPath.row]
                let destination = segue.destination as! OrderViewController

                destination.orderDetails = selectedOrder
            }
        }
    }

    @IBAction func orderConfirmationUnwindAction(unwindSegue: UIStoryboardSegue) {

        if tableView.numberOfSections == 3 {
            tableView.scrollToRow(at: IndexPath(row:0, section:2), at: .top, animated: true)
        }
    }

}
