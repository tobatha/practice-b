//
//  extensions.swift
//  BinanceEvaluation
//
//  Created by johnny on 2018/7/31.
//  Copyright © 2018 johnny. All rights reserved.
//

import Foundation
import UIKit


extension String {
    
    func size(font: UIFont) -> CGSize {
        let fontAttributes = [NSAttributedString.Key.font: font]
        return self.size(withAttributes: fontAttributes)
    }
    
    func attributed (color: UIColor, font: UIFont, textAlignment: NSTextAlignment = .left, lineSpacing: CGFloat = 0) -> NSMutableAttributedString
    {
        let style = NSMutableParagraphStyle()
        style.lineSpacing = lineSpacing
        style.alignment = textAlignment
        style.lineBreakMode = .byTruncatingTail
        
        let attributedString = NSMutableAttributedString(string: self, attributes: [
            NSAttributedString.Key.font : font,
            NSAttributedString.Key.foregroundColor : color
        ])
        
        attributedString .addAttribute(NSAttributedString.Key.paragraphStyle, value: style, range: NSMakeRange(0, self.count))
        
        return attributedString
    }
}

extension UITableView {
    
    class func defaultTable(frame: CGRect, delegate: Any?) -> UITableView {
        let table = UITableView.init(frame: frame, style: .plain)
        table.backgroundView  = nil
        table.backgroundColor = UIColor.clear
        table.separatorStyle  = .none
        table.dataSource      = delegate as? UITableViewDataSource
        table.delegate        = delegate as? UITableViewDelegate
        
        return table
    }
    
    public func register<T: UITableViewCell>(cellClass name: T.Type) {
        self.register(T.self, forCellReuseIdentifier: String(describing: name))
    }
}

extension UITableViewCell {
    
    func setupTableCell(bg: UIColor = UIColor.clear, pressed: UIColor)
    {
        self.backgroundView              = nil
        self.backgroundColor             = UIColor.clear
        self.contentView.backgroundColor = bg
        
        let bgView                       = UIView()
        bgView.backgroundColor           = pressed
        self.selectedBackgroundView      = bgView
    }
}

extension UIView {
    
    public var width: CGFloat {
        get { return self.frame.size.width }
        set { self.frame.size.width = newValue }
    }
    
    public var height: CGFloat {
        get { return self.frame.size.height }
        set { self.frame.size.height = newValue }
    }
    
    public var top: CGFloat {
        get { return self.frame.origin.y }
        set { self.frame.origin.y = newValue }
    }
    
    public var right: CGFloat {
        get { return self.frame.origin.x + self.width }
        set { self.frame.origin.x = newValue - self.width }
    }
    
    public var bottom: CGFloat {
        get { return self.frame.origin.y + self.height }
        set { self.frame.origin.y = newValue - self.height }
    }
    
    public var left: CGFloat {
        get { return self.frame.origin.x }
        set { self.frame.origin.x = newValue }
    }
    
    public var centerX: CGFloat{
        get { return self.center.x }
        set { self.center = CGPoint(x: newValue,y: self.centerY) }
    }
    
    public var centerY: CGFloat {
        get { return self.center.y }
        set { self.center = CGPoint(x: self.centerX,y: newValue) }
    }
    
    public var origin: CGPoint {
        set { self.frame.origin = newValue }
        get { return self.frame.origin }
    }
    
    public var size: CGSize {
        set { self.frame.size = newValue }
        get { return self.frame.size }
    }
}

extension UIImage {
    
    func tint(_ color : UIColor)-> UIImage? {
        var image = self.withRenderingMode(.alwaysTemplate)
        UIGraphicsBeginImageContextWithOptions(self.size, false, image.scale);
        color.set()
        image.draw(in: CGRect(x: 0, y: 0, width: self.size.width, height: image.size.height))
        image = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        return  image
    }
    
}

extension UIColor {
    
    convenience init?(hexString: String) {
        var cString:String = hexString.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()
        
        if (cString.hasPrefix("#")) {
            cString.remove(at: cString.startIndex)
        }
        
        if ((cString.count) != 6) {
            return nil
        }
        
        var rgbValue:UInt32 = 0
        Scanner(string: cString).scanHexInt32(&rgbValue)
        
        self.init(
            red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
            alpha: CGFloat(1.0)
        )
    }
}


