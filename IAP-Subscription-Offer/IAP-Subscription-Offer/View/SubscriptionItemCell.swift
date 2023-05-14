//
//  SubscriptionItemCell.swift
//  IAP-Subscription-Offer
//
//  Created by Jenny Hung on 2023/5/14.
//

import UIKit

class SubscriptionItemCell: UICollectionViewCell {

    @IBOutlet weak var backView: UIView!
    @IBOutlet weak var offerModeLabel: UILabel!
    @IBOutlet weak var originPriceLabel: UILabel!
    @IBOutlet weak var discountPriceLabel: UILabel!
    @IBOutlet weak var confirmButton: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        setupViews()
    }

    private func setupViews() {
        backView.layer.borderWidth = 1
        backView.layer.borderColor = UIColor.lightGray.cgColor
        confirmButton.addTarget(self, action: #selector(clickedButton(_:)), for: .touchUpInside)
        originPriceLabel.font = UIFont.systemFont(ofSize: 14)
        discountPriceLabel.font = UIFont.systemFont(ofSize: 14)
        offerModeLabel.font = UIFont.systemFont(ofSize: 14)
        offerModeLabel.textColor = .orange
        confirmButton.setTitle("confirm Subscription", for: .normal)
        confirmButton.setTitleColor(.white, for: .normal)
        confirmButton.backgroundColor = .darkGray
    }
    
    @objc func clickedButton(_ sender: UIButton) {
        
    }
}
