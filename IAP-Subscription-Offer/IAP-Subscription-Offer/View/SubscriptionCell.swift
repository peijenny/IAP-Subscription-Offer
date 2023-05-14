//
//  SubscriptionCell.swift
//  IAP-Subscription-Offer
//
//  Created by Jenny Hung on 2023/5/14.
//

import UIKit
import StoreKit

class SubscriptionCell: UITableViewCell {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var collectionView: UICollectionView!
    
    private var product: SKProduct?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        setupViews()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
    }
    
    private func setupViews() {
        titleLabel.textColor = .gray
        titleLabel.font = UIFont.boldSystemFont(ofSize: 18)
        
        if let layout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout {
            layout.scrollDirection = .horizontal
            let inset = 8.0
            layout.minimumLineSpacing = inset
            layout.sectionInset = UIEdgeInsets(top: 0, left: inset, bottom: 0, right: inset)
        }
        
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.registerCell(identifier: SubscriptionItemCell.identifier)
    }
    
    func setupCell(product: SKProduct) {
        self.product = product
        titleLabel.text = product.localizedTitle
    }
}

extension SubscriptionCell: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 1 + (product?.discounts.count ?? 0)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: SubscriptionItemCell.identifier, for: indexPath)
        guard let cell = cell as? SubscriptionItemCell else { return cell }
        
        guard let product = product else { return cell }
        let originPrice = Int(truncating: product.price)
        cell.setupOriginPrice(product: product)
        
        if indexPath.item == 0 {
            guard let discount = product.introductoryPrice else { return cell }
            cell.setupOfferPrice(discount: discount, originPrice: originPrice, type: .introductory)
        } else {
            guard let discount = product.discounts[exist: indexPath.item - 1] else { return cell }
            cell.setupOfferPrice(discount: discount, originPrice: originPrice, type: .promotional)
        }
        
        return cell
    }
}

extension SubscriptionCell: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 300, height: 200)
    }
}

