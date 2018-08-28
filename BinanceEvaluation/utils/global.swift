//
//  global.swift
//  BinanceEvaluation
//
//  Created by johnny on 2018/7/31.
//  Copyright © 2018 johnny. All rights reserved.
//

import Foundation
import UIKit

struct Screen {
    
    static let width     = UIScreen.main.bounds.size.width
    static let height    = UIScreen.main.bounds.size.height

}

struct Palette {
    static let bg        = UIColor.init(hexString: "#13161B")
    static let nav       = UIColor.init(hexString: "#1F2833")
    static let silver    = UIColor.init(hexString: "#aaaaaa")
    static let golden    = UIColor.init(hexString: "#EABB39")
    static let white     = UIColor.white
    static let separator = UIColor.init(hexString: "#22272F")
}

struct BinanceAPI {
    static let products = "https://www.binance.com/exchange/public/product"
}

struct Font {
    static let tab      = UIFont.systemFont(ofSize     : 13)
    static let title    = UIFont.systemFont(ofSize: 15, weight: .bold)
    static let subtitle = UIFont.systemFont(ofSize: 13)
    static let input    = UIFont.systemFont(ofSize   : 14)
}
