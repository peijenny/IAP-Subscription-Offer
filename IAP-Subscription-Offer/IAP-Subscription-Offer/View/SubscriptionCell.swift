//
//  SubscriptionCell.swift
//  IAP-Subscription-Offer
//
//  Created by Jenny Hung on 2023/5/14.
//

import UIKit

class SubscriptionCell: UITableViewCell {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var collectionView: UICollectionView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        setupViews()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
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
}

extension SubscriptionCell: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: SubscriptionItemCell.identifier, for: indexPath)
        guard let cell = cell as? SubscriptionItemCell else { return cell }
        
        return cell
    }
}

extension SubscriptionCell: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 300, height: 200)
    }
}

