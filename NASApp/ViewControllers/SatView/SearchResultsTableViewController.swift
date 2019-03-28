//
//  SearchResultsTableViewController.swift
//  NASApp
//
//  Created by Akshay Verma on 2019-03-26.
//  Copyright © 2019 Akshay Verma. All rights reserved.
//

import UIKit
import MapKit
import Kingfisher

class SearchResultsTableViewController: UITableViewController {
    
    let reuseID = "reuse"
    
    let searchCompleter = MKLocalSearchCompleter()
    var results: [MKLocalSearchCompletion] = []
    
    weak var previousVC: SatViewViewController!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.register(SuggestedCompletionTableViewCell.self, forCellReuseIdentifier: SuggestedCompletionTableViewCell.reuseID)
        
        searchCompleter.delegate = self
        searchCompleter.filterType = .locationsOnly
        
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return results.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: SuggestedCompletionTableViewCell.reuseID, for: indexPath)

        // Configure the cell...
        cell.textLabel?.text = results[indexPath.row].title
        cell.detailTextLabel?.text = results[indexPath.row].subtitle

        return cell
    }
 
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let request = MKLocalSearch.Request(completion: results[indexPath.row])
        MKLocalSearch(request: request).start { response,_ in
            if let response = response{
                self.previousVC.location = response.mapItems.first
                self.dismiss(animated: true, completion: nil)
            }
        }
        
    }

}

extension SearchResultsTableViewController: MKLocalSearchCompleterDelegate{

    func completerDidUpdateResults(_ completer: MKLocalSearchCompleter) {
        results = completer.results
        tableView.reloadData()
    }
    
}

extension SearchResultsTableViewController: UISearchResultsUpdating{
    
    func updateSearchResults(for searchController: UISearchController) {
        searchCompleter.queryFragment = searchController.searchBar.text ?? ""
    }
    
}

private class SuggestedCompletionTableViewCell: UITableViewCell {
    
    static let reuseID = "SuggestedCompletionTableViewCellReuseID"
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: .subtitle, reuseIdentifier: reuseIdentifier)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
