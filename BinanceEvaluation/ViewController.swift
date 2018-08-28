//
//  ViewController.swift
//  BinanceEvaluation
//
//  Created by johnny on 2018/7/31.
//  Copyright © 2018 johnny. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    private lazy var list = CryptoCurrencyList(frame: CGRect(x: 0, y: 0, width: Screen.width, height: Screen.height))

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        self.view = list
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    
}

