//
//  VolunteerFeedViewController.swift
//  VolunteerMe
//
//  Created by Rajat Bhargava on 10/11/17.
//  Copyright © 2017 volunteer_me. All rights reserved.
//

import UIKit

class VolunteerFeedViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, FilterViewControllerDelegate, UISearchBarDelegate, UISearchResultsUpdating {
    @IBOutlet weak var tableView: UITableView!
    
    let searchController = UISearchController(searchResultsController: nil)
    var events: [Event]?

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        
        // Configure tableView.
        tableView.estimatedRowHeight = 200
        self.tableView.rowHeight = UITableViewAutomaticDimension
        
        //Configure Search Bar
        configSearchBarAboveTable()

        // Do any additional setup after loading the view.
        getEvents()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    // MARK: - Table View Delegate
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return events?.count ?? 0
        
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "FeedCell") as! FeedCell
        cell.event = (events?[indexPath.row])!
        return cell
    }
    
    // MARK: - Table View Methods
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showEventDetails" {
             let cell = sender as! FeedCell
             let eventDetailsController = segue.destination as! EventDetailsViewController
             eventDetailsController.event = cell.event

        } else if segue.identifier == "filterSeque" {
            // Get the new view controller using segue.destinationViewController.
            // Pass the selected object to the new view controller.
            let navigationController = segue.destination as! UINavigationController
            let filterVC = navigationController.topViewController as! FilterViewController
            filterVC.delegate = self
        }
    }
    
    // MARK: - Delegate
    func filterViewController(filterViewController: FilterViewController, didUpdateFilters filter: [String: Any]){
        let categories = filter["categories"] as? [String]
        let isDeal = filter["deals"] as? Bool
       // let sortBy = filter["sortBy"] as! [String]
        let distance = filter["distance"] as! Int
        print(categories ?? [])
        print(isDeal ?? true)
       // print(sortBy)
        print(distance)
        
        // Call the search data method here and update the tableView. 
        
//        // If any previous calls are still going
//        MBProgressHUD.hide(for: self.view, animated: true)
//        MBProgressHUD.showAdded(to: self.view, animated: true)
//        Business.searchWithTerm(term: "Resturants", offset: 0, sort: sortBy, categories: categories, deals: isDeal, radius: distance) { (businesses, error) in
//            self.businesses = businesses
//            self.tableView.reloadData()
//            MBProgressHUD.hide(for: self.view, animated: true)
//        }
    }
    
    //MARK: - SEARCH BAR
    func configSearchBarAboveTable(){
        searchController.searchResultsUpdater = self
        searchController.dimsBackgroundDuringPresentation = false
        definesPresentationContext = true
        tableView.tableHeaderView = searchController.searchBar
    }
    
    public func updateSearchResults(for searchController: UISearchController) {
        if let searchText = searchController.searchBar.text {
            print("Search Text: \(searchText)")
            // todo: get data here
        }
        
    }
    
    // ToDo: Phase 2
    public func willPresentSearchController(_ searchController: UISearchController){
        // Save the previous data set into a temp Array
        print("About to go to controller")
    }

    public func didDismissSearchController(_ searchController: UISearchController) {
        // When cancelled show the previous data set
        print("done from the controller")
    }
    
    // MARK: - Network call
    func getEvents(){
        Event.getNearbyEvents(radiusInMiles: 10000, searchString: nil, tags: nil, limit: 20) { (eventsReturned: [Event]) in
            print("I am in here")
            self.events = eventsReturned
            for event in self.events! {
                event.printHumanReadableTestString()
            }
            self.tableView.reloadData()
        }
    }
}
