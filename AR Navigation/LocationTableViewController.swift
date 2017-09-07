//
//  LocationTableViewController.swift
//  AR Navigation
//
//  Created by Chris Wang on 9/2/17.
//  Copyright © 2017 Chris Wang. All rights reserved.
//

import UIKit

class LocationTableViewController: UITableViewController {
    
    var delegate: SearchHandleDelegate? = nil
    private var filteredLocations = [location]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredLocations.count
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        
        cell.textLabel!.text = locations[indexPath.row].name
        
        return cell
    }
    
     // Pass the selected object to the detail view controller
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let searchResultsController = searchResultsController else {
            return
        }
        
        var location: location
        if isFiltering(searchController: searchResultsController) {
            location = filteredLocations[indexPath.row]
        } else {
            location = locations[indexPath.row]
        }
        delegate?.didSelectLocation(selectedLocation: location)
    }
    
    // Private instance methods
    func isFiltering(searchController: UISearchController) -> Bool {
        let searchBarFiltering: Bool = searchController.isActive
        let searchBarHasText: Bool = !(searchController.searchBar.text?.isEmpty ?? true)
        return (searchBarFiltering && searchBarHasText)
    }
    
}


extension LocationTableViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        guard let searchBarText = searchController.searchBar.text else { return }
        
        // Fill in filteredLocations array
        filteredLocations = locations.filter({ (locationObject) -> Bool in
            if !isFiltering(searchController: searchController) {
                // If not filtering, return all results
                return true
            } else {
                return locationObject.name.lowercased().contains(searchBarText.lowercased())
            }
        })
        tableView.reloadData()
    }
}
