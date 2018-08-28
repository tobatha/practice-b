//
//  Coin.swift
//  BinanceEvaluation
//
//  Created by johnny on 2018/7/31.
//  Copyright © 2018 johnny. All rights reserved.
//

import Foundation

struct Coin: Codable {
    
    let symbol : String
    let quoteAssetName : String
    let tradedMoney : Float
    let baseAssetUnit : String
    let baseAssetName : String
    let baseAsset : String
    let tickSize : String
    let prevClose : Float
    let activeBuy : Float
    let high : String
    let lastAggTradeId : Float
    let low : String
    let matchingUnitType : String
    let close : String
    let quoteAsset : String
    let productType : String?
    let active : Bool
    let minTrade : Float
    let activeSell : Float
    let withdrawFee : String
    let volume : String
    let decimalPlaces : Float
    let quoteAssetUnit : String
    let open : String
    let status : String
    let minQty : Float
}

struct CoinVM {
    
    let coin : Coin
    
    func attributedName() -> NSMutableAttributedString {
        let attributedString = coin.baseAsset.attributed(color: Palette.white, font: Font.title)
        attributedString.append(" / \(coin.quoteAsset)".attributed(color: Palette.silver!, font: Font.subtitle))
        
        return attributedString
    }
    
    func volumn() -> String {
        let numberFormatter = NumberFormatter()
        numberFormatter.usesGroupingSeparator = true
        numberFormatter.groupingSeparator = ","
        numberFormatter.groupingSize = 3
        numberFormatter.usesGroupingSeparator = true
        numberFormatter.decimalSeparator = "."
        
        let volumn = Float(coin.volume) ?? 0
        return "Vol. " + (numberFormatter.string(from: NSNumber(value: volumn)) ?? "-")
    }
    
    func price() -> String {
        let currencyFormatter = NumberFormatter()
        currencyFormatter.usesGroupingSeparator = true
        currencyFormatter.numberStyle = .currency
        currencyFormatter.locale = Locale.current
        
        let volumn = Float(coin.volume) ?? 0
        return currencyFormatter.string(from: NSNumber(value: volumn)) ?? "-"
    }
}


func quoteAssets(coins: [Coin]?) -> [String] {
    
    var data : Set<String> = []
    guard let _coins = coins else { return data.sorted() }
    
    for coin in _coins {
        data.insert(coin.quoteAsset)
    }
    
    return data.sorted()
}

func filterQuoteAssets(_ asset: String?, in coins: [Coin], keyword: String = "") -> [Coin] {
    
    guard let _asset = asset else { return [] }
    
    if (keyword.count == 0) { return coins.filter { $0.quoteAsset == _asset } }
    
    return coins.filter { $0.quoteAsset == _asset && $0.baseAsset.lowercased().contains(keyword.lowercased()) }
}
