//
//  SubscriptionItemCell.swift
//  IAP-Subscription-Offer
//
//  Created by Jenny Hung on 2023/5/14.
//

import UIKit
import StoreKit

class SubscriptionItemCell: UICollectionViewCell {

    @IBOutlet weak var backView: UIView!
    @IBOutlet weak var offerModeLabel: UILabel!
    @IBOutlet weak var originPriceLabel: UILabel!
    @IBOutlet weak var discountPriceLabel: UILabel!
    @IBOutlet weak var confirmButton: UIButton!
    
    private var product: SKProduct?
    private var type: OfferType = .introductory
    
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
        guard let product = product else { return }
        
        if type == .introductory {
            purchaseIntroductory(product: product)
        } else {
            purchasePromotional(product: product)
        }
    }
    
    // setup cell - no offer (origin Price)
    func setupOriginPrice(product: SKProduct) {
        self.product = product
        
        let originPriceString = "Origin Price: $\(product.price)"
        originPriceLabel.text = originPriceString
        
        offerModeLabel.text = "No Introductory Offer"
        discountPriceLabel.text = " "
    }
    
    // setup cell - introductory offer (offer price)
    func setupOfferPrice(discount: SKProductDiscount, originPrice: Int, type: OfferType) {
        self.type = type
        
        let index = Int(discount.paymentMode.rawValue)
        let originPriceString = "Origin Price: $\(originPrice)"
        
        offerModeLabel.text = "\(type.rawValue) - \(OfferPaymentMode.allCases[index].title)"
        
        let attributedString = NSMutableAttributedString(string: originPriceString)
        srikethroughStyle(attributedString: attributedString)
        
        let discountPrice = Int(truncating: discount.price)
        discountPriceLabel.text = "Special Offer: $\(discountPrice)"
        discountPriceLabel.textColor = .red
    }
    
    private func srikethroughStyle(attributedString: NSMutableAttributedString) {
        attributedString.addAttribute(
            .strikethroughStyle,
            value: NSNumber(value: NSUnderlineStyle.thick.rawValue),
            range: NSMakeRange(0, attributedString.length)
        )
        attributedString.addAttribute(
            .strikethroughColor,
            value: UIColor.red,
            range: NSMakeRange(0, attributedString.length)
        )
        
        originPriceLabel.textColor = .lightGray
        originPriceLabel.attributedText = attributedString
    }
    
    private func purchaseIntroductory(product: SKProduct) {
        IAPManager.shared.purchaseIntroductory(product)
    }

    private func purchasePromotional(product: SKProduct) {
        // Generating a Promotional Offer Signature
        let productIdentifier = product.productIdentifier
        let offerIdentifier = product.discounts[exist: 0]?.identifier ?? ""
        
        SignatureManager.shared.fetchOfferDetails(
            productID: productIdentifier,
            offerID: offerIdentifier
        ) { serverResonse in
            
            IAPManager.shared.purchasePromotional(
                product, serverResponse: serverResonse
            )
        }
    }
}
