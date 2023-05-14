//
//  SignatureManager.swift
//  IAP-Subscription-Offer
//
//  Created by Jenny Hung on 2023/5/14.
//

import Foundation

class SignatureManager {
    
    static let shared = SignatureManager()
    
    typealias ResponseCompletion = (SignatureResponse) -> Void
    
    private let apiPath = "http://172.20.10.4:3000/offer"
    
    func fetchOfferDetails(productID: String, offerID: String, completion: @escaping ResponseCompletion) {
        guard let url = URL(string: apiPath) else { return }
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let json: [String: Any] = [
            "appBundleID": GlobalVaribles.shared.bundleID,
            "keyIdentifier": GlobalVaribles.shared.keyID,
            "productIdentifier": productID,
            "subscriptionOfferID": offerID,
            "applicationUsername": GlobalVaribles.shared.getUsernameHash()
        ]
        let jsonData = try? JSONSerialization.data(withJSONObject: json)
        request.httpBody = jsonData
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            guard error == nil else {
                print("Error: \(error?.localizedDescription ?? "")")
                return
            }
            
            guard let data = data,
                  let response = response as? HTTPURLResponse,
                  response.statusCode == 200 else { return }
            
            do {
                guard let jsonObject = try JSONSerialization.jsonObject(with: data) as? [String: Any],
                      let nonce = UUID(uuidString: jsonObject["nonce"] as? String ?? ""),
                      let timeString = jsonObject["timestamp"] as? Int,
                      let signature = jsonObject["signature"] as? String else { return }
                let timestamp = NSNumber(value: timeString)
                
                let signatureObject = SignatureResponse(
                    nonce: nonce,
                    timestamp: timestamp,
                    signature: signature
                )
                completion(signatureObject)
            } catch {
                print("Error: \(error.localizedDescription)")
            }
        }.resume()

    }
}
