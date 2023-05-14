//
//  ViewController.swift
//  IAP-Subscription-Offer
//
//  Created by Jenny Hung on 2023/5/12.
//

import UIKit
import StoreKit

class ViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!

    private var products: [SKProduct] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupViews()
        fetchSKProductData()
    }
    
    private func setupViews() {
        title = "App Subscription Offer Example"
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = .none
        tableView.backgroundColor = .lightGray
        tableView.showsVerticalScrollIndicator = false
        tableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 24, right: 0)
        tableView.allowsSelection = false
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.registerCell(identifier: SubscriptionCell.identifier)
    }
    
    private func registerCell() {
        for index in 0..<products.count {
            tableView.registerCell(identifier: SubscriptionCell.identifier, index: index)
        }
    }

    func fetchSKProductData() {
        IAPManager.shared.getProduct()
        IAPManager.shared.delegate = self
        IAPManager.shared.isEligibleForIntroductory()
    }
    
}

extension ViewController: UITableViewDataSource, UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return products.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(
            withIdentifier: "\(SubscriptionCell.identifier)-\(indexPath.section)",
            for: indexPath
        )
        guard let cell = cell as? SubscriptionCell else { return cell }
        
        let product = products[indexPath.section]
        cell.setupCell(product: product)
        
        return cell
    }
}

extension ViewController: IAPManagerDelegate {
    
    func getProductData(products: [SKProduct]) {
        self.products = products
        self.registerCell()
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
    
    func canUseIntroductory(isEligible: Bool) {
        print("This user can eligible: \(isEligible)")
    }
}
