//
//  VolunteerFeedViewController.swift
//  VolunteerMe
//
//  Created by Rajat Bhargava on 10/11/17.
//  Copyright © 2017 volunteer_me. All rights reserved.
//

import UIKit

class VolunteerFeedViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, FilterViewControllerDelegate {
    @IBOutlet weak var tableView: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        
        // Configure tableView.
        tableView.estimatedRowHeight = 200
        self.tableView.rowHeight = UITableViewAutomaticDimension

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    // MARK: - Table View Delegate
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "FeedCell") as! FeedCell
        //cell.colorLabel.text = data[indexPath.row]
        cell.feedDescriptionLabel.text = "This is the best charity to work for. Don't waste your saturday on cleaning alone. Make it more productive, give a sandwich. "
        cell.tagsLabel.text = "Tags: Help, #forever, #Sandwich, #Carrots, #HELP, #Saturday"
        return cell
    }
    
    // MARK: - Table View Methods
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        let navigationController = segue.destination as! UINavigationController
        let filterVC = navigationController.topViewController as! FilterViewController
        filterVC.delegate = self
    }
    
    // MARK: - Delegate
    func filterViewController(filterViewController: FilterViewController, didUpdateFilters filter: [String: Any]){
        let categories = filter["categories"] as? [String]
        let isDeal = filter["deals"] as? Bool
        let sortBy = filter["sortBy"] as! [String]
        let distance = filter["distance"] as! Int
        print(categories ?? [])
        print(isDeal ?? true)
        print(sortBy)
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

}