//
//  UICollectionView+Extension.swift
//  IAP-Subscription-Offer
//
//  Created by Jenny Hung on 2023/5/14.
//

import UIKit

extension UICollectionView {
    func registerCell(identifier: String, bundle: Bundle? = nil) {
        let nib = UINib(nibName: identifier, bundle: bundle)
        register(nib, forCellWithReuseIdentifier: identifier)
    }
}

extension UICollectionViewCell {
    static var identifier: String { return String(describing: self) }
}
