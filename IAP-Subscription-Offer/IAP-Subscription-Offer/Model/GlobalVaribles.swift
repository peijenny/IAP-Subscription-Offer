//
//  GlobalVaribles.swift
//  IAP-Subscription-Offer
//
//  Created by Jenny Hung on 2023/5/14.
//

import UIKit

class GlobalVaribles {
    
    static let shared = GlobalVaribles()
    
    let bundleID = Bundle.main.bundleIdentifier ?? ""
    
    let keyID = "24L682G839"
    
    let sharedSecret = "f7a2b8a9d4704c9b93d1955cf7ee3043"
    
    let username = "jenny.self.test@gmail.com"
    
    var verifyReceiptURL: String {
        #if DEBUG
        return "https://sandbox.itunes.apple.com/verifyReceipt"
        #else
        return "https://buy.itunes.apple.com/verifyReceipt"
        #endif
    }
}

