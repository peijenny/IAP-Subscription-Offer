//
//  IAPManager.swift
//  IAP-Subscription-Offer
//
//  Created by Jenny Hung on 2023/5/14.
//

import StoreKit

protocol IAPManagerDelegate: AnyObject {
    func getProductData(products: [SKProduct])
    func canUseIntroductory(isEligible: Bool)
}

class IAPManager: NSObject {
    
    static let shared = IAPManager()
    
    weak var delegate: IAPManagerDelegate?
    
    // stored Subscription Product
    private var skProducts: [SKProduct] = [] {
        didSet {
            delegate?.getProductData(products: skProducts)
        }
    }
    
    // initialization
    func initialize() {
        SKPaymentQueue.default().add(self)
    }
    
    // get product infomation
    func getProduct() {
        let ids = getProductIDs()
        let idsSet = Set(ids)
        if SKPaymentQueue.canMakePayments() {
            let productRequest = SKProductsRequest(productIdentifiers: idsSet)
            productRequest.delegate = self
            productRequest.start()
        }
    }
    
    // IAP product (no offer / introduct offer)
    func purchaseIntroductory(_ product: SKProduct) {
        print("IAPStep03 purchaseWithProduct")
        
        // purchase introductory product，need to put discount (payment.paymentDiscount)
        let payment = SKMutablePayment(product: product)
        SKPaymentQueue.default().add(payment)
    }
    
    // Example Product IDs
    private func getProductIDs() -> [String] {
        return [
            "com.jenny.IAP_Subscription_Offer.sub.month",
            "com.jenny.IAP_Subscription_Offer.sub.season",
            "com.jenny.IAP_Subscription_Offer.sub.year"
        ]
    }
    
    // fetch App Store - verify receipt
    func isEligibleForIntroductory() {
        guard let receiptUrl = Bundle.main.appStoreReceiptURL else {
            delegate?.canUseIntroductory(isEligible: true)
            return
        }

        let receiptData = try? Data(contentsOf: receiptUrl).base64EncodedString()

        let requestData = [
            "receipt-data": receiptData ?? "",
            "password": GlobalVaribles.shared.sharedSecret,
            "exclude-old-transactions": false
        ] as [String: Any]

        var request = URLRequest(url: URL(string: GlobalVaribles.shared.verifyReceiptURL)!)
        request.httpMethod = "POST"
        request.setValue("Application/json", forHTTPHeaderField: "Content-Type")
        let httpBody = try? JSONSerialization.data(withJSONObject: requestData, options: [])
        request.httpBody = httpBody
        URLSession.shared.dataTask(with: request) { data, response, error in
            // decode data
            guard let data = data,
                  let json = try? JSONSerialization.jsonObject(with: data, options: .allowFragments) as? [String: AnyHashable],
                  let receipts_array = json["latest_receipt_info"] as? [[String: AnyHashable]] else {
                self.delegate?.canUseIntroductory(isEligible: true)
                return
            }
            var latestExpiresDate = Date(timeIntervalSince1970: 0)
            let formatter = DateFormatter()
            formatter.dateFormat = "yyyy-MM-dd HH:mm:ss VV"
            
            // check all receipts
            for receipt in receipts_array {
                let used_trial: Bool = receipt["is_trial_period"] as? Bool ?? false || (receipt["is_trial_period"] as? NSString)?.boolValue ?? false
                let used_intro: Bool = receipt["is_in_intro_offer_period"] as? Bool ?? false || (receipt["is_in_intro_offer_period"] as? NSString)?.boolValue ?? false
                
                // check introductory offer already used
                if used_trial || used_intro {
                    self.delegate?.canUseIntroductory(isEligible: false)
                    return
                }
                
                // check current subscription status (use expires_date)
                if let expiresDateString = receipt["expires_date"] as? String,
                   let date = formatter.date(from: expiresDateString) {
                    if date > latestExpiresDate {
                        latestExpiresDate = date
                    }
                }
            }
            
            // If the subscription has expired, than you can use introductory offer
            if latestExpiresDate > Date() {
                self.delegate?.canUseIntroductory(isEligible: false)
            } else {
                self.delegate?.canUseIntroductory(isEligible: true)
            }
        }.resume()
    }
}

// MARK: - get products from AppStore
extension IAPManager: SKProductsRequestDelegate {
    
    // request product
    func productsRequest(_ request: SKProductsRequest, didReceive response: SKProductsResponse) {
        print("IAPManager productsRequest")
        if response.products.count == 0 {
            print("IAPManager productsRequest can't fetch any Product")
        } else {
            var products = [SKProduct]()
            _ = response.products.map {
                products.append($0)
            }
            self.skProducts = products
        }
    }
    
}

// MARK: - purchase
extension IAPManager: SKPaymentTransactionObserver {
    
    /* 觸發時機: 打開 App & 交易時
     打開 App 時
     transaction.transactionState.rawValue = 1 交易完成，進行下一步
     
     App 交易時會觸發二次
     第一次： transactionState == .purchasing (rawValue = 0) 交易進行。點完 Appstore 的完成鈕後，觸發第二次
     第二次： transactionState == .purchased  (rawValue = 1) 交易完成，進行下一步
     */
    
    // Trigger timing: open App & when purchase
    func paymentQueue(_ queue: SKPaymentQueue, updatedTransactions transactions: [SKPaymentTransaction]) {
        print("IAPStep04")
        _ = transactions.map { transaction in
            printTransactionInfo(transaction)
            
            switch transaction.transactionState {
            case .purchasing, .deferred: break
            case .purchased, .restored: finishPurchasedTransaction(transaction)
            case .failed: handleFailTransaction(transaction)
            default: break
            }
            
        }
    }
    
    // print purchase information
    func printTransactionInfo(_ transaction: SKPaymentTransaction) {
        print("IAPStep04 printTransactionInfo =============")
        print("transactionState: \(transaction.transactionState.rawValue)")
        
        print("payment.productIdentifier: \(transaction.payment.productIdentifier)")
        
        if #available(iOS 12.2, *) {
            if let paymentDiscount = transaction.payment.paymentDiscount {
                print("payment.paymentDiscount: \(paymentDiscount)")
            }
        }
    }
    
    // handle failure
    private func handleFailTransaction(_ transaction: SKPaymentTransaction) {
        print("IAPManager handleFailTransaction")
        
        let error = transactionError(for: transaction.error as NSError?)
        print("SKErrorCode: \(error.code.rawValue)")
        finishPurchasedTransaction(transaction)
    }
    
    // handle success, complete purchase
    private func finishPurchasedTransaction(_ transaction: SKPaymentTransaction) {
        SKPaymentQueue.default().finishTransaction(transaction)
    }
    
    // purchase error, error message displayed
    private func transactionError(for error: NSError?) -> SKError {
        let message = "Unknown error"
        let altError = NSError(
            domain: SKErrorDomain,
            code: SKError.unknown.rawValue,
            userInfo: [NSLocalizedDescriptionKey: message]
        )
        let nsError = error ?? altError
        return SKError(_nsError: nsError)
    }
}
