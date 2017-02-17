//
//  RestaurantSynopsisTableViewCell.swift
//  FoodEx
//
//  Created by Nana on 2/15/17.
//  Copyright © 2017 Apple. All rights reserved.
//

class RestaurantSynopsisTableViewCell: UITableViewCell {

    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var subTitleLabel: UILabel!
    @IBOutlet weak var distanceLabel: UILabel!
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var symbolImageView: UIImageView!

    @IBOutlet private weak var reviewsStack: UIStackView!
    @IBOutlet private weak var dollarsStack: UIStackView!

    func setReviewStars(count: Int) -> Void {

        var count = count
        let subviews = reviewsStack.arrangedSubviews

        if count > subviews.count {count = subviews.count}

        if count > 0 {
            reviewsStack.arrangedSubviews.prefix(upTo: count).forEach() {
                $0.isHidden = false
            }
        }
    }

    func setCostDollars(count: Int) -> Void {

        var count = count
        let subviews = reviewsStack.arrangedSubviews

        if count > subviews.count {count = subviews.count}

        dollarsStack.arrangedSubviews.suffix(count).forEach() {
            $0.isHidden = false
        }
    }
}
