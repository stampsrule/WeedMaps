//
//  Copyright © 2018 Weedmaps, LLC. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController {

    // MARK: Properties
    
    @IBOutlet private var collectionView: UICollectionView!
    
    private var searchController = UISearchController(searchResultsController: nil)
    private var searchBarController = SearchBar()
    private var searchResults = [Business]()
    private var searchDataTask: URLSessionDataTask?
    private var pendingRequestWorkItem: DispatchWorkItem?
    private var query: String? {
        didSet {
            navigationItem.title = query
        }
    }
    
    let businessCellId = "BusinessCell"
    // MARK: Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupCollectionView()
        setupSearchController()
        
        definesPresentationContext = true
        
    }
    
    private func setupCollectionView() {
        collectionView.register(UINib.init(nibName: "BusinessCell", bundle: nil), forCellWithReuseIdentifier: businessCellId)
        
        collectionView?.alwaysBounceVertical = true
        collectionView?.keyboardDismissMode = .onDrag
        collectionView?.dataSource = self
        collectionView?.delegate = self
        
        if let flowLayout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout {
            flowLayout.estimatedItemSize = UICollectionViewFlowLayout.automaticSize
            flowLayout.scrollDirection = .vertical
        }
    }
    
    private func setupSearchController() {
        searchController.searchResultsUpdater = searchBarController
        searchController.searchBar.delegate = searchBarController
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search Businesses"
        navigationItem.searchController = searchController
        searchBarController.onSearch = search(_:)
        searchBarController.onCancel = {
            self.searchResults = [Business]()
            DispatchQueue.main.async{
                self.collectionView.reloadData()
            }
        }
        searchBarController.throttlingInterval = 0.25
    }
    
    func search(_ query: String) {
        guard !query.isEmpty && query.count > 3 else { return }
        self.query = query
        BusinessesSearch().get(query: query, newSearch: true) { (result) in
            switch result {
            case .failure(_):
                print("failed")
            case .success(let businesses):
                self.searchResults.reserveCapacity(BusinessesSearch.totalListings ?? 1000)
                self.searchResults = businesses ?? [Business]()
                DispatchQueue.main.async{
                    self.collectionView.reloadData()
                }
            }
        }
    }
    
    func getNextSearchResults() {
        guard let text = self.query else { return }
        BusinessesSearch().get(query: text, nextPage: true) { (result) in
            switch result {
            case .failure(_):
                print("failed")
            case .success(let businesses):
                guard let data = businesses else { return }
                self.searchResults.append(contentsOf: data)
                DispatchQueue.main.async{
                    self.collectionView.reloadData()
                }
            }
        }
    }
}

// MARK: UICollectionViewDelegate

extension HomeViewController: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if indexPath.item > searchResults.count - 5 {
            getNextSearchResults()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let alert = UIAlertController(title: "Show Details", message: "Please select how you would like to view the details", preferredStyle: .actionSheet)
        
        
        // to either display the Business's Yelp page in a WKWebView
        let inApp = UIAlertAction(title: "In App", style: .default) {  [weak self] (_) in
//            self?.resignFirstResponder()
            let business = self?.searchResults[indexPath.item]
            
            guard let urlString = business?.url else { return }
            
            let webView = WebViewController(url: urlString)
            self?.navigationController?.pushViewController(webView, animated: true)
        }
        alert.addAction(inApp)
        
        // OR bump the user out to Safari.
        let safari = UIAlertAction(title: "Safari", style: .default) {  [weak self] (_) in
            self?.resignFirstResponder()
            let business = self?.searchResults[indexPath.item]
            
            guard let urlString = business?.url, let url = URL(string: urlString) else { return }
            
            UIApplication.shared.open(url)
        }
        alert.addAction(safari)
        
        //Chrome
        let chrome = UIAlertAction(title: "Chrome", style: .default) {  [weak self] (_) in
            self?.resignFirstResponder()
            let business = self?.searchResults[indexPath.item]
            
            guard let urlString = business?.url, let httpUrl = URL(string: urlString) else { return }
            
            var components = URLComponents(url: httpUrl, resolvingAgainstBaseURL: false)
            components?.scheme = "googlechromes"
            
            guard let adjustedComponents = components, let chromeUrl = adjustedComponents.url else { return }
            
            if UIApplication.shared.canOpenURL(chromeUrl) {
                UIApplication.shared.open(chromeUrl)
            } else {
                let alertController = UIAlertController(title: "Sorry", message: "Google Chrome app is not installed", preferredStyle: .alert)
                
                
                
                let chromeLink = "itms-apps://itunes.apple.com/us/app/chrome/id535886823"
                if let itunesLink = URL(string: chromeLink) {
                    let getAction = UIAlertAction(title: "Get Chrome", style: .default) { (_) in
                        UIApplication.shared.open(itunesLink)
                    }
                    alertController.addAction(getAction)
                }
                
                
                let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
                alertController.addAction(okAction)
                self?.present(alertController, animated: true, completion: nil)
            }
        }
        alert.addAction(chrome)
        
        //Cancel
        let okAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alert.addAction(okAction)
        
        present(alert, animated: true, completion: nil)

    }
}

// MARK: UICollectionViewDataSource

extension HomeViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return searchResults.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: businessCellId, for: indexPath) as? BusinessCell else {
            fatalError("Creating cells failed, please fix")
        }
        
        cell.business = searchResults[indexPath.item]
        
        return cell
    }
}
