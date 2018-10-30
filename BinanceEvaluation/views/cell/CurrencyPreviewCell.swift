//
//  CurrencyPreviewCell.swift
//  BinanceEvaluation
//
//  Created by johnny on 2018/7/31.
//  Copyright © 2018 johnny. All rights reserved.
//

import UIKit

class CurrencyPreviewCell: UITableViewCell {
    
    static let identifier = String(describing: CurrencyPreviewCell.self)
    
    private var separator : UIImageView = {
        let view = UIImageView(frame: CGRect(x: 0, y: CurrencyPreviewCell.height() - 1, width: Screen.width, height: 1))
        view.backgroundColor = Palette.separator
        
        return view
    }()
    private lazy var name = UILabel(frame: CGRect(x: 25, y: 16, width: Screen.width - 130, height: 15))
    private lazy var high : UILabel = {
        let label = UILabel(frame: CGRect(x: Screen.width - 120, y: 16, width: 120, height: 15))
        label.textColor = Palette.white
        label.font = Font.title
        
        return label
    }()
    private lazy var volumn : UILabel = {
        let label = UILabel(frame: CGRect(x: 25, y: name.bottom + 12, width: Screen.width - 130, height: 13))
        label.textColor = Palette.silver
        label.font = Font.subtitle
        
        return label
    }()
    private lazy var price : UILabel = {
        let label = UILabel(frame: CGRect(x: Screen.width - 120, y: name.bottom + 12, width: 120, height: 13))
        label.textColor = Palette.silver
        label.font = Font.subtitle
        
        return label
    }()
    
    

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        self.backgroundColor = UIColor.clear
        self.selectionStyle  = .none
        
        self.contentView.addSubview(name)
        self.contentView.addSubview(high)
        self.contentView.addSubview(volumn)
        self.contentView.addSubview(price)
        self.contentView.addSubview(separator)
    }
    
    class func reusableCell(_ tableView: UITableView, indexPath: IndexPath, data: [Coin]?) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: identifier) as? CurrencyPreviewCell
        if (cell == nil) { cell = CurrencyPreviewCell.init(style: .default, reuseIdentifier: identifier) }
        cell?.set(item: data?[indexPath.row])
        
        return cell!
    }
    
    class func height() -> CGFloat { return 70 }
    
    func set(item: Coin?) {
        guard let coin = item else { return }
        
        let vm = CoinVM(coin: coin)
        
        name.attributedText = vm.attributedName()
        volumn.text = vm.volumn()
        high.text = coin.high
        price.text = vm.price()
    }
}
