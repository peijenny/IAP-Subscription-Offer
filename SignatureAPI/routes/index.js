/*
See LICENSE folder for this sample’s licensing information.

Abstract:
Main handler for HTTP requests to the server for generating subscription offer signatures.
*/

const express = require('express');
const router = express.Router();

const crypto = require('crypto');
const ECKey = require('ec-key');
const secp256k1 = require('secp256k1');
const uuidv4 = require('uuid/v4');

const KeyEncoder = require('key-encoder');
const keyEncoder = new KeyEncoder('secp256k1');

function getKeyID() {
    return process.env.SUBSCRIPTION_OFFERS_KEY_ID;
}

function getKeyStringForID(keyID) {
    if (keyID === process.env.SUBSCRIPTION_OFFERS_KEY_ID) {
        return
        ```
        -----BEGIN EC PRIVATE KEY-----
        MHcCAQEEIB2RjHHpWY5/qMhVzJr3ndDbgtd5paBt8v+rp6HwoVgfoAoGCCqGSM49
        AwEHoUQDQgAEz56u9L7wMDhXzzdRukRsrEAbt8H/i7M+EvUgld1OdYtVohe5Img7
        C9/e8/ASjv6d99U0teJ/0zsoNxFX9RhWfg==
        -----END EC PRIVATE KEY-----
        ```;
    }
    else {
        throw "Key ID not recognized";
    }
}

router.post('/offer', function(req, res) {

    const appBundleID = req.body.appBundleID;
    const keyIdentifier = req.body.keyIdentifier;
    const productIdentifier = req.body.productIdentifier;
    const subscriptionOfferID = req.body.subscriptionOfferID;
    const applicationUsername = req.body.applicationUsername;

    const nonce = uuidv4();

    const timestamp = Math.floor(new Date());

	  const payload = appBundleID + '\u2063' +
                  keyIdentifier + '\u2063' +
                  productIdentifier + '\u2063' +
                  subscriptionOfferID + '\u2063' +
                  applicationUsername  + '\u2063'+
                  nonce + '\u2063' +
                  timestamp;

    const fs = require('fs');
    const keyPem = fs.readFileSync("../key/SubscriptionKey_24L682G839.pem", 'ascii');
    const key = new ECKey(keyPem, 'pem');

    const signature = crypto.createSign('RSA-SHA256')
                   .update(payload)
                   .sign(keyPem, 'base64');

    let response1 = {
      "signature": signature,
      "nonce": nonce,
      "timestamp": timestamp,
      "keyIdentifier": keyIdentifier
    }
    res.type('json').send(response1);
});

module.exports = router;
