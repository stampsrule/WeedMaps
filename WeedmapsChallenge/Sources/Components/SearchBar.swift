//
//  SearchBar.swift
//  WeedmapsChallenge
//
//  Created by Daniel Bell on 4/28/19.
//  Copyright © 2019 Weedmaps, LLC. All rights reserved.
//

import UIKit

public class SearchBar: UISearchBar {
    
    var dataList : [String] = []
    var tableView: UITableView?
    var searchBar: UISearchBar?
    
    private var throttler: Throttler? = nil
    
    public var throttlingInterval: Double? = 0 {
        didSet {
            guard let interval = throttlingInterval else {
                self.throttler = nil
                return
            }
            self.throttler = Throttler(seconds: interval)
        }
    }
    
    public var onCancel: (() -> (Void))? = nil
    
    public var onSearch: ((String) -> (Void))? = nil
    
    public override func awakeFromNib() {
        super.awakeFromNib()
        self.delegate = self
        buildSearchTableView()
    }
    
    init() {
        super.init(frame: CGRect.zero)
        self.delegate = self
        buildSearchTableView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func buildSearchTableView() {
        
        if let tableView = tableView {
            tableView.register(UITableViewCell.self, forCellReuseIdentifier: "CustomSearchTextFieldCell")
            tableView.delegate = self
            tableView.dataSource = self
            self.window?.addSubview(tableView)
            
        } else {
            print("tableView created")
            tableView = UITableView(frame: CGRect.zero)
        }
        
        updateSearchTableView()
    }
    
    func updateSearchTableView() {
        
        if let tableView = tableView {
            self.window?.bringSubviewToFront(tableView)
            let tableHeight = UIScreen.main.bounds.height/2
            
            // Set tableView frame
            var tableViewFrame = CGRect(x: 0, y: 0, width: frame.size.width - 4, height: tableHeight)
            tableViewFrame.origin = self.convert(tableViewFrame.origin, to: nil)
            tableViewFrame.origin.x += 2
            tableViewFrame.origin.y += frame.size.height + 2
            UIView.animate(withDuration: 0.2, animations: { [weak self] in
                self?.tableView?.frame = tableViewFrame
            })
            
            //Setting tableView style
            tableView.layer.masksToBounds = true
            tableView.separatorInset = UIEdgeInsets.zero
            tableView.layer.cornerRadius = 5.0
            tableView.separatorColor = UIColor.lightGray
            tableView.backgroundColor = UIColor.white.withAlphaComponent(0.4)
            
            if self.searchBar?.isFirstResponder ?? false {
                tableView.superview?.bringSubviewToFront(self)
            }
            
            tableView.reloadData()
        }
    }
}

extension SearchBar: UISearchBarDelegate{
    // Events for UISearchBarDelegate
    
    public func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        self.tableView?.removeFromSuperview()
        if self.searchBar != searchBar {
            self.searchBar = searchBar
        }
        onCancel?()
    }
    
    public func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        if self.searchBar != searchBar {
            self.searchBar = searchBar
        }
        if let searchTerm = searchBar.text {
            self.tableView?.removeFromSuperview()
            dataList.append(searchTerm)
            onSearch?(searchTerm)
        }
    }
}

// MARK: UISearchResultsUpdating

extension SearchBar: UISearchResultsUpdating {
    
    public func updateSearchResults(for searchController: UISearchController) {
        
        if self.searchBar != searchController.searchBar {
            self.searchBar = searchController.searchBar
        }
        
        self.updateSearchTableView()
        
        if let searchTerm = searchController.searchBar.text, !searchTerm.isEmpty {
            guard let throttler = self.throttler else {
                dataList.append(searchTerm)
                onSearch?(searchTerm)
                return
            }
            throttler.throttle {
                self.tableView?.removeFromSuperview()
                self.dataList.append(searchTerm)
                self.onSearch?(searchTerm)
            }
        }
    }
}

// MARK: UITableViewDataSource

extension SearchBar: UITableViewDataSource {
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataList.count
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CustomSearchTextFieldCell", for: indexPath) as UITableViewCell
        cell.backgroundColor = UIColor.clear
        cell.textLabel?.text = dataList[indexPath.row]
        return cell
    }
    
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.searchBar?.text = dataList[indexPath.row]
        tableView.isHidden = true
    }
    
}

// MARK: UITableViewDelegate

extension SearchBar: UITableViewDelegate {
    
}
