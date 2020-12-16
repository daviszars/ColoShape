//
//  SettingsViewController.swift
//  ColoShape
//
//  Created by Davis Zarins on 27/11/2020.
//

import UIKit
import StoreKit

class SettingsViewController: UITableViewController, SKPaymentTransactionObserver {
    
    @IBOutlet weak var soundSwitch: UISwitch!
    @IBOutlet weak var vibrationSwitch: UISwitch!
    
    let defaults = UserDefaults.standard
    let productID = "com.daviszarins.ColoShape.RemoveAds"
    
    func paymentQueue(_ queue: SKPaymentQueue, updatedTransactions transactions: [SKPaymentTransaction]) {
        for transaction in transactions {
            if transaction.transactionState == .purchased {
                //payment successful
                print("Payment successful")
                defaults.set(true, forKey: productID)
                SKPaymentQueue.default().finishTransaction(transaction)
                //TODO: Remove purchase button
            } else if transaction.transactionState == .failed {
                //payment failed
                if let error = transaction.error {
                    let errorDescription = error.localizedDescription
                    print("Failed due to error: \(errorDescription)")
                }
                SKPaymentQueue.default().finishTransaction(transaction)
            } else if transaction.transactionState == .restored {
                defaults.set(true, forKey: productID)
                print("Purchase restored")
                SKPaymentQueue.default().finishTransaction(transaction)
            }
        }
    }
    
    @IBAction func removeAdsButton(_ sender: UIButton) {
        if SKPaymentQueue.canMakePayments() {
            let paymentRequest = SKMutablePayment()
            paymentRequest.productIdentifier = productID
            SKPaymentQueue.default().add(paymentRequest)
        } else {
            print("user can't make payments")
        }
    }
    
    @IBAction func restorePurchasesButton(_ sender: UIButton) {
        SKPaymentQueue.default().restoreCompletedTransactions()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated);
        self.navigationController?.isNavigationBarHidden = false
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //removes unnecesary cells after last section
        tableView.tableFooterView = UIView(frame: CGRect(x: 0, y: 0, width: tableView.frame.size.width, height: 1))
        
        soundSwitch.isOn = defaults.bool(forKey: "Sound")
        vibrationSwitch.isOn = defaults.bool(forKey: "Vibration")
        
        SKPaymentQueue.default().add(self)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        defaults.set(soundSwitch.isOn, forKey: "Sound")
        defaults.set(vibrationSwitch.isOn, forKey: "Vibration")
    }
    
}
