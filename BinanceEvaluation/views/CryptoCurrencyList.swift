//
//  CryptoCurrencyList.swift
//  BinanceEvaluation
//
//  Created by johnny on 2018/7/31.
//  Copyright © 2018 johnny. All rights reserved.
//

import UIKit

class CryptoCurrencyList: UIView {
    
    private lazy var loader : UIActivityIndicatorView = {
        let view = UIActivityIndicatorView(activityIndicatorStyle: .white)
        view.width = 30
        view.height = 30
        view.center = CGPoint(x: Screen.width / 2, y: Screen.height / 2)
        view.startAnimating()
        
        return view
    }()
    private lazy var nav : UIView = {
        let view = UIView(frame: CGRect(x: 0, y: 0, width: Screen.width, height: 88))
        view.backgroundColor = Palette.nav
        
        let title = UILabel.init(frame: CGRect(x: 0, y: 0, width: view.width, height: 50))
        title.font = UIFont.systemFont(ofSize: 14, weight: .bold)
        title.textAlignment = .center
        title.textColor = Palette.silver
        title.text = "Markets"
        
        let clear = UIButton(frame: CGRect(x: 0, y: 0, width: 70, height: 50))
        clear.setTitle("Clear", for: .normal)
        clear.setTitleColor(Palette.golden, for: .normal)
        clear.titleLabel?.font = UIFont.systemFont(ofSize: 13, weight: .bold)
        clear.addTarget(self, action: #selector(clearTapped), for: .touchUpInside)
        clear.alpha = 0
        
        let search = UIButton(frame: CGRect(x: Screen.width - 50, y: 0, width: 50, height: 50))
        search.setImage(#imageLiteral(resourceName: "search").tint(Palette.silver!), for: .normal)
        search.addTarget(self, action: #selector(searchTapped), for: .touchUpInside)
        
        view.addSubview(title)
        view.addSubview(clear)
        view.addSubview(search)
        
        self.clear = clear
        
        return view
    }()
    private lazy var searchInputContainer: UIView = {
        let view = UIView(frame: CGRect(x: 0, y: -50, width: Screen.width, height: 50))
        view.backgroundColor = Palette.bg
        
        let container = UIView(frame: CGRect(x: 10, y: 10, width: view.width - 20, height: view.height - 20))
        container.backgroundColor = UIColor.init(hexString: "#24262A")
        
        let input = UITextField(frame: CGRect(x: 10, y: 5, width: container.width - 20, height: container.height - 10))
        input.textColor = Palette.white
        input.font = Font.input
        input.returnKeyType = .search
        input.autocapitalizationType = .none
        input.autocorrectionType = .no
        input.delegate = self
        input.text = ""
        
        container.addSubview(input)
        view.addSubview(container)
        self.searchInput = input
        
        return view
    }()
    private lazy var tabNavigator: TabNavigator = TabNavigator(frame: CGRect(x: 0, y: 50, width: nav.width, height: 38))
    private lazy var table: UITableView = {
        let view = UITableView.defaultTable(frame: CGRect(x: 0, y: nav.bottom, width: self.width, height: self.height - nav.bottom), delegate: self)
        view.backgroundColor = Palette.bg
        view.alpha = 0
        
        return view
    }()
    private lazy var refreshControl : UIRefreshControl = {
        let view = UIRefreshControl()
        view.tintColor = Palette.white
        view.addTarget(self, action: #selector(fetchData), for: .valueChanged)
        
        return view
    }()
    private lazy var nodata : UILabel = {
        let view = UILabel(frame: CGRect(x: 0, y: 0, width: Screen.width, height: 50))
        view.centerY = Screen.height / 2
        view.font = Font.title
        view.textColor = Palette.silver
        view.text = "No Results"
        view.textAlignment = .center
        view.alpha = 0
        
        return view
    }()
    
    
    private var tabs : [String] = [] {
        didSet { self.tabNavigator.tabs = tabs }
    }
    private var selectedTabIndex = 0
    private var allcoins : [Coin] = []
    private var coins : [Coin] = [] {
        didSet { table.reloadData() }
    }
    private weak var searchInput : UITextField?
    private weak var clear : UIButton?
    

    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        self.addSubview(table)
        self.addSubview(nav)
        self.addSubview(tabNavigator)
        self.addSubview(searchInputContainer)
        self.addSubview(loader)
        self.addSubview(nodata)
        
        table.addSubview(refreshControl)
        
        tabNavigator.onTap = { [weak self] (index, sender) in
            self?.tabTapped(index)
        }
        
        fetchData()
    }
    
    @objc func fetchData() {
        API.fetchProducts { [weak self] (results) in
            guard let _results = results else { return }
            
            self?.allcoins = _results
            self?.tabs = quoteAssets(coins: _results)
            self?.reloadCoins()
            
            self?.table.alpha = 1
            self?.tabNavigator.current = self!.selectedTabIndex
            self?.loader.stopAnimating()
            self?.refreshControl.endRefreshing()
        }
    }
    
    @objc func clearTapped() {
        self.searchInput?.text = ""
        self.clear?.alpha = 0
        reloadCoins()
    }
    
    @objc func searchTapped() {
        
        UIView.animate(withDuration: 0.26, animations: { [weak self] in
            guard let input = self?.searchInputContainer else { return }
            
            input.top = input.top == 0 ? -50 : 0
        }) { [weak self] (finished) in
            self?.searchInput?.becomeFirstResponder()
        }
    }
    
    func tabTapped(_ index: Int) {
        selectedTabIndex = index
        reloadCoins()
    }
    
    func reloadCoins() {
        if tabs.isEmpty { return }
        
        let coins = filterQuoteAssets(tabs[self.selectedTabIndex], in: self.allcoins, keyword: self.searchInput?.text ?? "")
        
        self.nodata.alpha = coins.count == 0 ? 1 : 0
        self.coins = coins
    }
}

extension CryptoCurrencyList : UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.endEditing(true)
        
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        UIView.animate(withDuration: 0.36) { [weak self] in
            guard let inputContainer = self?.searchInputContainer, let inputContent = self?.searchInput?.text else { return }
            inputContainer.top = -50
            
            self?.clear?.alpha =  inputContent.isEmpty ? 0 : 1
        }
        
        self.endEditing(true)
        reloadCoins()
    }
    
}


extension CryptoCurrencyList : UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return coins.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return CurrencyPreviewCell.reusableCell(tableView, indexPath: indexPath, data: coins)
    }
    
    
}

extension CryptoCurrencyList : UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return CurrencyPreviewCell.height()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
    }
}
