//
//  TabNavigator.swift
//  BinanceEvaluation
//
//  Created by johnny on 2018/7/31.
//  Copyright © 2018 johnny. All rights reserved.
//

import Foundation
import UIKit

class TabNavigator: UIView {
    
    var tabs : [String] = [] {
        didSet { setTabs() }
    }
    var onTap : ((Int, UIButton) -> Void)?
    var current : Int = 0 {
        didSet { setCurrentSelected() }
    }
    
    private let tagIndex = 10000
    private lazy var scroll : UIScrollView = { [unowned self] in
        let view = UIScrollView(frame: self.bounds)
        view.contentSize = self.bounds.size
        view.showsVerticalScrollIndicator = false
        view.showsHorizontalScrollIndicator = false
        
        return view
    }()
    private lazy var underline: UIImageView = { [unowned self] in
        let view = UIImageView(frame: CGRect(x: 0, y: self.height - 1, width: 50, height: 1))
        view.backgroundColor = Palette.golden
        view.alpha = 0
        
        return view
    }()
    
    private var selectedBtn : UIButton?
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        scroll.addSubview(underline)
        self.addSubview(scroll)
    }
    
    @objc func tabTapped(_ sender: UIButton!) {
        sender.isSelected = true
        
        selectedBtn?.isSelected = false
        selectedBtn = sender
        current = sender.tag - tagIndex
        
        onTap?(current, sender)
    }
    
    func setTabs() {
        for subview in scroll.subviews { if subview is UIButton { subview.removeFromSuperview() } }
        
        var left : CGFloat = 0
        for (i, tab) in tabs.enumerated() {
            let btnWidth = tab.size(font: Font.tab).width + 55
            let btn = UIButton(frame: CGRect(x: left, y: 0, width: btnWidth, height: self.height))
            btn.setTitle(tab, for: .normal)
            btn.setTitleColor(Palette.white, for: .normal)
            btn.setTitleColor(Palette.golden, for: .selected)
            btn.titleLabel?.font = Font.tab
            btn.addTarget(self, action: #selector(tabTapped(_:)), for: .touchUpInside)
            btn.tag = tagIndex + i
            btn.titleEdgeInsets = UIEdgeInsets(top: -5, left: 0, bottom: 0, right: 0)
            
            scroll.addSubview(btn)
            scroll.contentSize = CGSize(width: btn.right, height: btn.height)
            left = btn.right
            
            if (i == current) {
                btn.isSelected = true
                
                selectedBtn = btn
                underline.centerX = btn.centerX
                underline.alpha = 1
            }
        }
    }
    
    func setCurrentSelected() {
        selectedBtn = scroll.viewWithTag(current + tagIndex) as? UIButton
        selectedBtn?.isSelected = true
        
        guard let btn = selectedBtn else { return }
        
        UIView.animate(withDuration: 0.3, delay: 0, usingSpringWithDamping: 20, initialSpringVelocity: 0, options: .curveEaseOut, animations: { [weak self] in
            self?.underline.centerX = btn.centerX
        }, completion: nil)
    }
}
