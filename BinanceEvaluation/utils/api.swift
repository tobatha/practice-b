//
//  api.swift
//  BinanceEvaluation
//
//  Created by johnny on 2018/7/31.
//  Copyright © 2018 johnny. All rights reserved.
//

import Foundation

struct RESTful {
    
    static func get(link: String, then callback:( (AnyObject?) -> Void )?) {
        
        guard let url = URL(string: link) else {
            print("***************************************************************")
            print("illegal link: ", link)
            print("***************************************************************")
            
            return
        }
        
        let req = URLRequest(url: url)
        let session = URLSession(configuration: .default)
        
        let task = session.dataTask(with: req) { (data, res, error) in
            
            DispatchQueue.main.async {
                if (error != nil) {
                    print("url request error: ", error!)
                    callback?(nil)
                    return
                    
                }
                
                guard let _data = data else {
                    print("no data available")
                    callback?(nil)
                    return
                }
                
                callback?(_data as AnyObject)
            }
        }
        
        task.resume()
    }
}

struct API {
    
    static func fetchProducts(then callback:( ([Coin]?) -> Void)?) {
        
        RESTful.get(link: BinanceAPI.products) { (data) in
            
            guard
                let result = JsonToObject(data: data as AnyObject, type: [String: [Coin]].self),
                let collection = result["data"] else {
                    print("no data available")
                    callback?(nil)
                    return
            }
            
            callback?(collection)
        }
    }
}


// ===============================================================================
// MARK: - helpers
// ===============================================================================
func JsonToObject<T>(data: AnyObject?, type: T.Type) -> T? where T: Decodable
{
    guard let _data = data, _data is Data else { return nil }
    
    var result : T?
    
    do {
        result = try JSONDecoder().decode(type, from: (_data as? Data)!) as T
    } catch {
        print("***************************************************************")
        print("json decoding error: ", error)
        print("***************************************************************")
        
        return nil
    }
    
    return result
}
