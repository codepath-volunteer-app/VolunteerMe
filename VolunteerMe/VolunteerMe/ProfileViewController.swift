//
//  ProfileViewController.swift
//  VolunteerMe
//
//  Created by ruthie_berman on 10/20/17.
//  Copyright © 2017 volunteer_me. All rights reserved.
//

import UIKit

class ProfileViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, EventDetailsViewControllerDelegate {
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var profileName: UILabel!
    @IBOutlet weak var profileHours: UILabel!
    @IBOutlet weak var profileTags: UILabel!
    
    @IBOutlet weak var tableView: UITableView!
    
    var events: [[Event]] = []
    private let eventCategories = ["Upcoming", "History"]
    var currentUser: User? {
        didSet {
            profileName.text = currentUser!.name
            profileHours.text = "4 hours"
            tags = currentUser!.interests!
            
            var tagText = ""
            for tag in tags! {
                tagText.append(tag.name!)
                tagText.append("  ")
            }
            profileTags.text = tagText
            
            currentUser!.getParticipatingEvents(userEventType: .Upcoming) { (upcomingEvents) in
                self.events.append(upcomingEvents)
                self.tableView.reloadData()
            }

            currentUser!.getParticipatingEvents(userEventType: .Past) { (pastEvents) in
                self.events.append(pastEvents)
                self.tableView.reloadData()
            }
        }
    }
    
    private var tags: [Tag]? {
        didSet {
            if tags?.count == 0 || tags == nil {
                profileTags.isHidden = true
            } else {
                var tagText = "Tags:"
                for tag in tags! {
                    if let name = tag.name {
                        tagText += " " + name
                    }
                }
                profileTags.text = tagText
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 150
        
        currentUser = User.current()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return events.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print("rows for section \(section)")
        print(events[section].count)
        return events[section].count
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerCell = tableView.dequeueReusableCell(withIdentifier: "HeaderCell") as! HeaderCell
        headerCell.categoryTitle.text = eventCategories[section]
        return headerCell
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "EventCell", for: indexPath) as! EventCell
        cell.event = events[indexPath.section][indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }

    func onUnregister() {
        self.events = []

        currentUser!.getParticipatingEvents(userEventType: .Upcoming) { (upcomingEvents) in
            print(upcomingEvents)
            self.events.append(upcomingEvents)
            self.tableView.reloadData()
        }
        
        currentUser!.getParticipatingEvents(userEventType: .Past) { (pastEvents) in
            print(pastEvents)
            self.events.append(pastEvents)
            self.tableView.reloadData()
        }
    }

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "displayEventDetails" {
            let cell = sender as! EventCell
            let eventDetailsController = segue.destination as! EventDetailsViewController
            eventDetailsController.event = cell.event
            eventDetailsController.delegate = self
        }
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }


}
