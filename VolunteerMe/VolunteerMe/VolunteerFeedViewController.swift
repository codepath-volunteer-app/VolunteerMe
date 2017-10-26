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
    var searchedEvents: [Event]?
    var searchText: String?

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
        if isFiltering() {
            return searchedEvents?.count ?? 0
        }
        return events?.count ?? 0
        
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "FeedCell") as! FeedCell
        var event: Event?
        if isFiltering() {
            event = (searchedEvents?[indexPath.row])!
        } else {
            event = (events?[indexPath.row])!
        }
        cell.event = event!
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
        let tags = filter["tags"] as? [String]
        //let isDeal = filter["deals"] as? Bool
       // let sortBy = filter["sortBy"] as! [String]
        let distance = filter["distance"] as! Double
        print(tags ?? [])
        print(distance)
        
        getEventsForFilter(searchText: searchText, tags: tags, distance: distance)

        
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
            self.searchText = searchText
            getEventsForSearch(searchText: searchText)
        }
        
    }
    
    // ToDo: Phase 2
    public func willPresentSearchController(_ searchController: UISearchController){
        // Save the previous data set into a temp Array
        print("About to go to controller")
    }

    public func didDismissSearchController(_ searchController: UISearchController) {
        // When cancelled show the previous data set
        searchedEvents = []
        searchText = nil
        tableView.reloadData()
    }
    
    // MARK: - Network call
    func getEvents(){
        Event.getNearbyEvents(radiusInMiles: 10000, searchString: nil, tags: nil, limit: 20) { (eventsReturned: [Event]) in
            print("I am in here")
            self.events = eventsReturned
            self.tableView.reloadData()
        }
    }
    
    func getEventsForSearch(searchText: String){
        Event.getNearbyEvents(radiusInMiles: 10000, searchString: searchText, tags: nil, limit: 20) { (eventsReturned: [Event]) in
            print("I am in here")
            self.searchedEvents = eventsReturned
            self.tableView.reloadData()
        }
    }
    
    //MARK: - Search
    private func isFiltering() -> Bool {
        return searchController.isActive && !searchBarIsEmpty()
    }
    
    private func searchBarIsEmpty() -> Bool {
        // Returns true if the text is empty or nil
        return searchController.searchBar.text?.isEmpty ?? true
    }
    
    private func getEventsForFilter(searchText: String?, tags: [String]?, distance:Double ){
        Event.getNearbyEvents(radiusInMiles: distance, searchString: searchText, tags: tags, limit: 20) { (eventsReturned: [Event]) in
            print("I am in here")
            if self.isFiltering(){
                self.searchedEvents = eventsReturned
            } else {
                self.events = eventsReturned
            }
            self.tableView.reloadData()
        }
       
    }

}
