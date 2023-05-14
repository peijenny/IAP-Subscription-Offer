//
//  UITableView+Extension.swift
//  IAP-Subscription-Offer
//
//  Created by Jenny Hung on 2023/5/14.
//

import UIKit

extension UITableView {
    func registerCell(identifier: String, index: Int, bundle: Bundle? = nil) {
        let nib = UINib(nibName: identifier, bundle: bundle)
        register(nib, forCellReuseIdentifier: "\(identifier)-\(index)")
    }
    
    func registerCell(identifier: String, bundle: Bundle? = nil) {
        let nib = UINib(nibName: identifier, bundle: bundle)
        register(nib, forCellReuseIdentifier: "\(identifier)")
    }
}

extension UITableViewCell {
    static var identifier: String { return String(describing: self) }
}

