//
//  GlobalVaribles.swift
//  IAP-Subscription-Offer
//
//  Created by Jenny Hung on 2023/5/14.
//

import UIKit
import CommonCrypto

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
    
    func getUsernameHash() -> String {
        return hashedValueForAccountName(username) ?? ""
    }
    
    // Custom method to calculate the SHA-256 hash using Common Crypto
    private func hashedValueForAccountName(_ userAccountName: String) -> String? {
        let HASH_SIZE = Int(32)

        let hashedChars = UnsafeMutablePointer<CUnsignedChar>.allocate(capacity: HASH_SIZE)
        let accountName = UnsafePointer<CChar>(userAccountName.cString(using: .utf8))
        let accountNameLen = userAccountName.count

        // Confirm that the length of the user name is small enough
        // to be recast when calling the hash function.
        if accountNameLen > UInt32.max {
            print("Account name too long to hash: \(userAccountName)")
            return nil
        }
        CC_SHA256(accountName, CC_LONG(accountNameLen), hashedChars)

        // Convert the array of bytes into a string showing its hex representation.
        var userAccountHash = String()
        for i in 0..<HASH_SIZE {
            // Add a dash every four bytes, for readability.
            if (i != 0 && i % 4 == 0) {
                userAccountHash += ""
            }
            userAccountHash += String(format: "%02x", arguments: [hashedChars[i]])
        }

        return userAccountHash
    }
}

