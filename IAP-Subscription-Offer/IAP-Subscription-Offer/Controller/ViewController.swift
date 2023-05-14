//
//  ViewController.swift
//  IAP-Subscription-Offer
//
//  Created by Jenny Hung on 2023/5/12.
//

import UIKit

class ViewController: UIViewController {
    
    private var tableView = UITableView(frame: .zero, style: .insetGrouped)

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        configViews()
    }

    private func configViews() {
        setupViews()
        setupLayout()
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
    
    private func setupLayout() {
        view.addSubview(tableView)
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
}

extension ViewController: UITableViewDataSource, UITableViewDelegate {
    
//    func numberOfSections(in tableView: UITableView) -> Int {
//        return 1
//    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        let cell = tableView.dequeueReusableCell(
//            withIdentifier: "\(SubscriptionCell.identifier)-\(indexPath.section)",
//            for: indexPath
//        )
        let cell = tableView.dequeueReusableCell(withIdentifier: SubscriptionCell.identifier, for: indexPath)
        guard let cell = cell as? SubscriptionCell else { return cell }
        
        return cell
    }
}
