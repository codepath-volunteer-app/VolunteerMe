//
//  ProfileViewController.swift
//  VolunteerMe
//
//  Created by ruthie_berman on 10/20/17.
//  Copyright © 2017 volunteer_me. All rights reserved.
//

import UIKit

class ProfileViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var profileName: UILabel!
    @IBOutlet weak var profileUsername: UILabel!
    @IBOutlet weak var profileHours: UILabel!
    @IBOutlet weak var profileTags: UILabel!
    
    @IBOutlet weak var tableView: UITableView!
    
    var events: [[Event]] = []
    private let eventCategories = ["Upcoming", "History"]
    var currentUser: User? {
        didSet {
            profileName.text = currentUser!.name
            profileUsername.text = currentUser!.username
            profileHours.text = currentUser!.userDescription
            tags = currentUser!.interests!
            
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

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
