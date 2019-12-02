//
//  EricViewController.swift
//  StockApp
//
//  Created by Eric Cha on 11/27/19.
//  Copyright © 2019 Eric Cha. All rights reserved.
//

import UIKit
import EmptyStateKit
import RxSwift
import RxCocoa

class SearchViewController: UIViewController, EmptyStateDelegate{

    let queryService = QueryService()
    
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var tableView: UITableView!
    
    var searchResults: [BestMatch] = []
    var selected = TableState.noInternet
    lazy var tapRecognizer: UITapGestureRecognizer = {
        var recognizer = UITapGestureRecognizer(target:self, action: #selector(dismissKeyboard))
        return recognizer
    }()
    let selectedStockSubject = PublishSubject<String>()
    
    @objc func dismissKeyboard() {
        searchBar.resignFirstResponder()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.emptyState.format = selected.format
        tableView.emptyState.delegate = self
    }
    
    func emptyState(emptyState: EmptyState, didPressButton button: UIButton) {
    }
}


//
// MARK: - Search Bar Delegate
//
extension SearchViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        dismissKeyboard()
        guard let searchText = searchBar.text, !searchText.isEmpty else {
            return
        }
            
        queryService.getSearchResults(searchTerm: searchText) { [weak self] results, errorMessage in
            
            if let results = results {
                self?.searchResults = results
                self?.tableView.reloadData()
                self?.tableView.setContentOffset(CGPoint.zero, animated: false)
            }
            
            if !errorMessage.isEmpty {
                print("Search error: " + errorMessage)
            }
        }
    }
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        view.addGestureRecognizer(tapRecognizer)
    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        view.removeGestureRecognizer(tapRecognizer)
    }
}

//
// MARK: - Table View Data Source, Delegate
//
extension SearchViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if searchResults.count == 0 {
            tableView.emptyState.show(selected)
        } else {
            tableView.emptyState.hide()
        }
        return searchResults.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "stockCell", for: indexPath) as! StocksCell
        
        let stock = searchResults[indexPath.row]
        cell.configure(stock: stock)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedStockSubject.onNext(searchResults[indexPath.row].symbol)
        navigationController?.popViewController(animated: true)
    }
}
