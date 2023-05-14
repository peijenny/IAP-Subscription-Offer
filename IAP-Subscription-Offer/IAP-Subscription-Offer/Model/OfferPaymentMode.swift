//
//  OfferPaymentMode.swift
//  IAP-Subscription-Offer
//
//  Created by Jenny Hung on 2023/5/14.
//

import Foundation

enum OfferPaymentMode: Int, CaseIterable {
    case payAsYouGo = 0
    case payUpFront = 1
    case freeTrial = 2
    
    var title: String {
        switch self {
        case .payAsYouGo: return "Pay As You Go"
        case .payUpFront: return "Pay Up Front"
        case .freeTrial: return "Free Trial"
        }
    }
}

enum OfferType: String {
    case introductory = "Introductory Offers"
    case promotional = "Promotional Offers"
}
