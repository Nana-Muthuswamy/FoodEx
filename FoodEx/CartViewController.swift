//
//  CartViewController.swift
//  FoodEx
//
//  Created by Divya on 3/6/17.
//  Copyright © 2017 Apple. All rights reserved.
//

import UIKit
import PassKit
import Stripe

class CartViewController: UITableViewController {

    var cart: Cart {
        return AppDataManager.shared.user.cart
    }

    var newOrder: Order?

    struct CartDetailsSections {
        static let Summary = 0
        static let Items = 1
        static let Total = 2

        static func totalSections() -> Int {
            return 3
        }
    }

    // MARK: ---- Life Cycle ----

    override func viewDidLoad() {
        super.viewDidLoad()

        // Adding Tap Gesture Recognizer to end editing mode when tapping elsewhere in Table View
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTap))
        tableView.addGestureRecognizer(tapGesture)
    }

    // MARK: ---- Gesture Recognizer ----

    func handleTap(recognizer: UITapGestureRecognizer) -> Void {
        view.endEditing(true)
    }

    // MARK: ---- UITableViewDataSource ----

    override func numberOfSections(in tableView: UITableView) -> Int {

        if cart.items.count > 0 {
            return CartDetailsSections.totalSections()
        } else {
            return 1
        }
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        switch section {

        case CartDetailsSections.Summary:
            return 1

        case CartDetailsSections.Items:
            return cart.items.count

        case CartDetailsSections.Total:
            if cart.items.count > 0 {
                return 2
            } else {
                return 0
            }

        default:
            return 0
        }
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        switch indexPath.section {

        case CartDetailsSections.Summary:

            var tableCell: UITableViewCell

            if cart.items.count > 0 {
                tableCell = tableView.dequeueReusableCell(withIdentifier: "OrderTitle")!

                if let title = cart.title, let titleField = tableCell.viewWithTag(1) as? UITextField {
                    titleField.text = title
                }

            } else {
                tableCell = tableView.dequeueReusableCell(withIdentifier: "EmptyCart")!
            }

            return tableCell

        case CartDetailsSections.Items:

            let tableCell = tableView.dequeueReusableCell(withIdentifier: "CartItem") as! CartItemTableViewCell

            let menuItem = cart.items[indexPath.row]

            tableCell.nameLabel.text = menuItem.name
            tableCell.detailsLabel.text = "@" + menuItem.restaurantName
            tableCell.quantityField.text = String(menuItem.quantity)
            tableCell.priceLabel.text = menuItem.formattedTotalPrice
            tableCell.menuItemImageView.image = UIImage(named: menuItem.imageName)

            tableCell.delegate = self

            return tableCell

        case CartDetailsSections.Total:

            let tableCell: UITableViewCell

            if indexPath.row < 1 {
                tableCell = tableView.dequeueReusableCell(withIdentifier: "CartTotal")!
            } else {
                tableCell = tableView.dequeueReusableCell(withIdentifier: "SubmitCart")!
            }

            if indexPath.row == 0 {
                tableCell.textLabel?.text = "Sub Total"
                tableCell.detailTextLabel?.text = cart.formattedSubTotal
            } else if indexPath.row == 1 {

                let paymentButton = PKPaymentButton(type: .plain, style: .black)

                paymentButton.addTarget(self, action: #selector(initiateApplePay), for: .touchUpInside)

                paymentButton.sizeToFit()
                paymentButton.translatesAutoresizingMaskIntoConstraints = false

                tableCell.contentView.addSubview(paymentButton)

                let paymentButtonConstraints = [NSLayoutConstraint(item: paymentButton, attribute: .centerX, relatedBy: .equal, toItem: tableCell.contentView, attribute: .centerX, multiplier: 1.0, constant: 0.0),NSLayoutConstraint(item: paymentButton, attribute: .centerY, relatedBy: .equal, toItem: tableCell.contentView, attribute: .centerY, multiplier: 1.0, constant: 0.0)]

                tableCell.contentView.addConstraints(paymentButtonConstraints)
            }

            return tableCell

        default:
            return UITableViewCell()
        }
    }

    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {

        switch section {

        case CartDetailsSections.Summary:
            if cart.items.count > 0 {
                return "Summary"
            } else {
                return ""
            }
        case CartDetailsSections.Items:
            if cart.items.count > 0 {
                return "Items"
            } else {
                return ""
            }
        case CartDetailsSections.Total:
            if cart.items.count > 0 {
                return "Total"
            } else {
                return ""
            }
        default:
            return ""
        }
    }

    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {

        switch indexPath.section {
        case CartDetailsSections.Items:
            return true
        default:
            return false
        }
    }

    // MARK: ---- UITableViewDelegate ----
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        switch indexPath.section {

        case CartDetailsSections.Summary:
            if cart.items.count > 0 {
                return 44
            } else {
                return 300
            }

        case CartDetailsSections.Items:
            return 70

        default:
            return 44
        }
    }

    override func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {

        switch indexPath.section {
        case CartDetailsSections.Items:

            let rowAction = UITableViewRowAction(style: .default, title: "Remove", handler: { (rowAction, indexPath) in
                // Remove the cart item in the current index
                AppDataManager.shared.user.cart.removeItem(at: indexPath.row)

                // End editing
                tableView.setEditing(false, animated: true)

                if AppDataManager.shared.user.cart.items.count > 0 {
                    // Delete row with animation
                    tableView.deleteRows(at: [indexPath], with: .fade)
                    // Update Totals
                    let indexSet = IndexSet(arrayLiteral:CartDetailsSections.Total)
                    tableView.reloadSections(indexSet, with: .fade)

                } else {
                    tableView.reloadData()
                }

            })

            rowAction.backgroundColor = UIColor.red

            
            return [rowAction]
            
        default:
            return nil
        }
        
    }
}

extension CartViewController: UITextFieldDelegate, CartItemTableViewCellDelegate {

    // MARK: ---- UITextFieldDelegate ----

    func textFieldDidEndEditing(_ textField: UITextField) {
        // Update cart title
        AppDataManager.shared.user.cart.title = textField.text
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        view.endEditing(true)

        return true
    }

    // MARK: ---- CartItemTableViewCellDelegate ----

    func tableViewCell(_ tableCell: UITableViewCell, quantityDidChange newValue: Int) {

        if let indexPath = tableView.indexPath(for: tableCell), cart.items.count > indexPath.row {

            let existingValue = cart.items[indexPath.row].quantity

            if (existingValue != newValue) {

                if newValue > 0 {
                    cart.items[indexPath.row].quantity = newValue
                    tableView.reloadRows(at: [indexPath], with: .automatic)
                    // Update Totals
                    let indexSet = IndexSet(arrayLiteral:CartDetailsSections.Total)
                    tableView.reloadSections(indexSet, with: .automatic)

                } else {

                    // Remove the cart item in the current index
                    AppDataManager.shared.user.cart.removeItem(at: indexPath.row)

                    if AppDataManager.shared.user.cart.items.count > 0 {
                        // Delete row with animation
                        tableView.deleteRows(at: [indexPath], with: .fade)
                        // Update Totals
                        let indexSet = IndexSet(arrayLiteral:CartDetailsSections.Total)
                        tableView.reloadSections(indexSet, with: .fade)

                    } else {
                        tableView.reloadData()
                    }
                }
            }
        }
    }
}

extension CartViewController: PKPaymentAuthorizationViewControllerDelegate {

    // MARK: ---- Segue ----

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {

        if segue.identifier == "ShowOrderConfirmationView" {

            let destination = (segue.destination as! UINavigationController).topViewController as! OrderConfirmationViewController
            destination.order = newOrder
        }
    }

    // MARK: ---- Initiate Payment ----

    func initiateApplePay() -> Void {

        // 1. Create Payment Request

        let paymentRequest = PKPaymentRequest()

        // Basic
        paymentRequest.countryCode = "US"
        paymentRequest.currencyCode = "USD"
        paymentRequest.merchantIdentifier = "merchant.com.nana-muthuswamy.FoodEx"
        paymentRequest.supportedNetworks = [.amex, .discover, .masterCard, .visa]
        paymentRequest.merchantCapabilities = .capability3DS

        // Billing and Shipping
        paymentRequest.requiredBillingAddressFields = .postalAddress
        paymentRequest.requiredShippingAddressFields = .postalAddress

        let loggedInUser = AppDataManager.shared.user!

        var nameComponents = PersonNameComponents()
        nameComponents.givenName = loggedInUser.name.firstName
        nameComponents.familyName = loggedInUser.name.lastName

        let address = CNMutablePostalAddress()
        address.street = loggedInUser.address.street
        address.city = loggedInUser.address.city
        address.state = loggedInUser.address.state
        address.postalCode = loggedInUser.address.postalCode

        let contact = PKContact()
        contact.name = nameComponents
        contact.postalAddress = address

        paymentRequest.billingContact = contact
        paymentRequest.shippingContact = contact

        // Shipping Methods
        paymentRequest.shippingMethods = shippingMethods()

        // Summary Items
        paymentRequest.paymentSummaryItems = summaryItemsWith(standardShippingItem())

        // 2. Present PKPaymentAuthorizationViewController

        let applePayView = PKPaymentAuthorizationViewController(paymentRequest: paymentRequest)

        applePayView.delegate = self
        present(applePayView, animated: true, completion: nil)
    }

    // MARK: ---- PKPaymentAuthorizationViewControllerDelegate ----

    func paymentAuthorizationViewController(_ controller: PKPaymentAuthorizationViewController, didAuthorizePayment payment: PKPayment, completion: @escaping (PKPaymentAuthorizationStatus) -> Void) {

        STPAPIClient.shared().createToken(with: payment) { (token, error) in

            if error == nil, let sourceID = token?.tokenId {

                let grandTotalItem = self.summaryItemsWith(payment.shippingMethod!).last!

                var amountToCharge: Decimal
                amountToCharge = grandTotalItem.amount as Decimal
                amountToCharge = amountToCharge / Decimal(pow(10, Double(amountToCharge.exponent)))

                AppDataManager.shared.createBackendCharge(sourceID: sourceID, grandTotal: amountToCharge, completion: { (error) in
                    if error == nil {

                        // Create New Order
                        if let shippingMethodIdentifier = payment.shippingMethod?.identifier {
                            self.newOrder = Order(cart: self.cart, deliveryCharge: self.deliveryChargeFor(shippingMethodIdentifier))
                        } else {
                            self.newOrder = Order(cart: self.cart, deliveryCharge: self.deliveryChargeFor("Standard"))
                        }

                        completion(.success)
                    } else {
                        completion(.failure)
                    }

                })
            } else {
                completion(.failure)
            }
        }
    }

    func paymentAuthorizationViewControllerDidFinish(_ controller: PKPaymentAuthorizationViewController) {

        controller.dismiss(animated: true) {

            if self.newOrder != nil {
                self.performSegue(withIdentifier: "ShowOrderConfirmationView", sender: self)
            }
        }
    }

    func paymentAuthorizationViewController(_ controller: PKPaymentAuthorizationViewController, didSelect shippingMethod: PKShippingMethod, completion: @escaping (PKPaymentAuthorizationStatus, [PKPaymentSummaryItem]) -> Void) {

        let shippingItem = (shippingMethod.identifier == "Express") ? expressShippingItem() : standardShippingItem()

        completion(.success, summaryItemsWith(shippingItem))

    }

    func paymentAuthorizationViewController(_ controller: PKPaymentAuthorizationViewController, didSelectShippingContact contact: PKContact, completion: @escaping (PKPaymentAuthorizationStatus, [PKShippingMethod], [PKPaymentSummaryItem]) -> Void) {
        completion(.success, shippingMethods(), summaryItemsWith(standardShippingItem()))
    }

    // MARK: ---- Utils ----

    private func shippingMethods() -> [PKShippingMethod] {

        let standardShippingCharge = Decimal(deliveryChargeFor("Standard"))
        let standardShipping = PKShippingMethod(label: "Standard Shipping", amount: NSDecimalNumber(decimal: standardShippingCharge))
        standardShipping.detail = "Deliver within 2 hours."
        standardShipping.identifier = "Standard"

        let expressShippingCharge = Decimal(deliveryChargeFor("Express"))
        let expressShipping = PKShippingMethod(label: "Express Shipping", amount: NSDecimalNumber(decimal: expressShippingCharge))
        expressShipping.detail = "Deliver within 60 mins."
        expressShipping.identifier = "Express"

        return [standardShipping, expressShipping]
    }

    private func standardShippingItem() -> PKShippingMethod {
        return shippingMethods().first!
    }

    private func expressShippingItem() -> PKShippingMethod {
        return shippingMethods().last!
    }

    private func summaryItemsWith(_ shippingItem: PKShippingMethod) -> [PKPaymentSummaryItem] {

        let subTotal = Decimal(cart.subTotal)
        let subTotalItem = PKPaymentSummaryItem(label: "Subtotal", amount: NSDecimalNumber(decimal: subTotal))
        let tax = subTotal * Decimal(0.0875)
        let taxItem = PKPaymentSummaryItem(label: "Tax", amount: NSDecimalNumber(decimal: tax))
        let grandTotal = subTotal + tax + (shippingItem.amount as Decimal)
        let grandTotalItem = PKPaymentSummaryItem(label: "FoodEx", amount: NSDecimalNumber(decimal: grandTotal))

        return [subTotalItem, taxItem, shippingItem, grandTotalItem]
    }

    private func deliveryChargeFor(_ shippingMethodIdentifier: String) -> Double {

        var charge = cart.subTotal > 50 ? cart.subTotal * 0.10 : 5.0

        if shippingMethodIdentifier == "Express" {
            charge += 5.00
        }

        return charge
    }
}
