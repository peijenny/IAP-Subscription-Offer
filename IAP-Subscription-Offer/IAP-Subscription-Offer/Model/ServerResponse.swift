//
//  ServerResponse.swift
//  IAP-Subscription-Offer
//
//  Created by Jenny Hung on 2023/5/14.
//

import UIKit

struct SignatureResponse {
    var nonce: UUID
    var timestamp: NSNumber
    var signature: String
}
