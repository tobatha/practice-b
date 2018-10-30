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
    
    var left : CGFloat {
        set {
            var frame      = self.frame
            frame.origin.x = newValue
            self.frame     = frame
        }
        get {
            return self.frame.origin.x
        }
    }
    
    var top : CGFloat {
        set {
            var frame      = self.frame
            frame.origin.y = newValue
            self.frame     = frame
        }
        get {
            return self.frame.origin.y
        }
    }
    
    var right : CGFloat {
        set {
            var frame = self.frame
            frame.origin.x = newValue - frame.size.width
            self.frame = frame
        }
        get {
            return self.frame.origin.x + self.frame.size.width
        }
    }
    
    var bottom : CGFloat {
        set {
            var frame = self.frame
            frame.origin.y = bottom - frame.size.height
            self.frame = frame
        }
        get {
            return self.frame.origin.y + self.frame.size.height
        }
    }
    
    var width : CGFloat {
        set {
            var frame        = self.frame
            frame.size.width = newValue
            self.frame       = frame
        }
        get {
            return self.frame.size.width
        }
    }
    
    var height : CGFloat {
        set {
            var frame         = self.frame
            frame.size.height = newValue
            self.frame        = frame
        }
        get {
            return self.frame.size.height
        }
    }
    
    var centerX : CGFloat {
        set {
            self.center = CGPoint(x: newValue, y: self.center.y)
        }
        get {
            return self.center.x
        }
    }
    
    var centerY : CGFloat {
        set {
            self.center = CGPoint(x: self.center.x, y: newValue)
        }
        get {
            return self.center.y
        }
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


