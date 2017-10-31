//
//  FilterViewController.swift
//  VolunteerMe
//
//  Created by Rajat Bhargava on 9/22/17.
//  Copyright © 2017 RNR. All rights reserved.
//

import UIKit

@objc protocol FilterViewControllerDelegate {
    @objc optional func filterViewController(filterViewController: FilterViewController, didUpdateFilters filter: [String: Any])
}

struct SectionStruct {
    var headerTitle: String = ""
    var cellType: String?
    var data: [(String, Any)]?
    var results: [Int: Bool]=[Int: Bool]()
    var checked_index : Int = 0
}

class FilterViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, SwitchCellDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    
    /*let dealsSection: SectionStruct = SectionStruct(headerTitle: "Deals", cellType: "switchCell",
                                                    data:[("Offering Deals", "Offering Deals")],
                                                    results:[Int: Bool](), checked_index: 0)
    */
    let distanceSection: SectionStruct = SectionStruct(headerTitle: "Distance", cellType: "filterCell",
                                                       data:[("Auto", 10000.0), ("0.2 miles", 0.2),
                                                             ("1 mile", 1.0), ("5 miles", 5.0),
                                                             ("10 miles", 10.0), ("20 miles", 20.0)],
                                                       results:[Int: Bool](), checked_index: 0)
  /*  let sortBySection: SectionStruct = SectionStruct(headerTitle: "SortBy", cellType: "filterCell",
                                                     data:[("Best Match", "Best Match"), ("Distance", "distance"),
                                                           ("Highest Rates", "higest Rated")],
                                                     results:[Int: Bool](), checked_index: 0)
 */
    let tagsSection: SectionStruct = SectionStruct(headerTitle: "Tags", cellType: "switchCell",
                                                       data:[("Animals", "animals"), ("Arts", "arts"), ("Full Day", "full day"), ("Fun", "fun"), ("Reading", "reading"), ("Women", "women"), ("Men", "men"), ("Children", "children"), ("Board Development", "board development"),
                                                             ("Media", "media"),("Feed the Hungry","hunger"), ("Homelessness", "housing"), ("LGBT", "lgbt"), ("Education", "education"), ("Politics", "politics")],
                                                       results:[Int: Bool](), checked_index: 0)
    
    
    var sections: [Int:SectionStruct]?
    
    weak var delegate: FilterViewControllerDelegate?
    
    var collapsed:[Int: Bool] = [Int:Bool]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.dataSource = self
        tableView.delegate = self
        
        sections = [0:distanceSection,1: tagsSection]
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
    @IBAction func onSearch(_ sender: Any) {
        var filters = [String:Any]()
        
        //Get Deals
//        let isDeal = sections?[0]?.results[0]
//        filters["deals"] = isDeal
        
        //Get categories
        var tags = [String]()
        let results = sections?[1]?.results
        for (index, isSelected) in results! {
            if isSelected{
                tags.append(sections?[1]?.data?[index].1 as! String)
            }
        }
        if tags.count > 0 {
            filters["tags"] = tags
        }
        
        //Get distance
        let row_selected = sections?[0]?.checked_index
        let distance_filter = sections?[0]?.data?[row_selected!].1 as? Double
        filters["distance"] = distance_filter
        
        
        
        //Add the categories in filter if more that 0
        delegate?.filterViewController?(filterViewController: self, didUpdateFilters: filters)
        //print(sections?[3]?.results)
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func onCancel(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    
    // MARK: - TableView Setup
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        let cellType = sections?[section]?.cellType ?? "filterCell"
        if cellType == "filterCell" {
            return  (collapsed[section] ?? true) ? 1 : sections?[section]?.data!.count ?? 0
        } else {
            return sections?[section]?.data!.count ?? 0
        }
        
    }
    
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let section_index = indexPath.section
        let row = indexPath.row
        var cell: UITableViewCell?
        let cellType = sections?[section_index]?.cellType ?? "filterCell"
        
        
        switch cellType {
        case "filterCell":
            cell = tableView.dequeueReusableCell(withIdentifier: "filterCell")
            let filterCell = cell as! FilterCell
            // Change the index from data depending if its collapsed
            var rowValue : Int = row
            if (collapsed[section_index] ?? true) {
                rowValue = sections?[section_index]?.checked_index ?? 0
            }
            filterCell.displayLabel.text = sections?[section_index]?.data?[rowValue].0
            if sections?[section_index]?.checked_index == rowValue {
                //if its collapsed show a down arrow
                if (collapsed[section_index] ?? true) {
                    var imageView : UIImageView
                    let rect = CGRect(x: 0, y: 0, width: 20, height: 20)
                    imageView = UIImageView(frame: rect)
                    imageView.image = UIImage(named:"navigate-down")
                    cell?.accessoryView = imageView
                } else {
                    cell?.accessoryType = UITableViewCellAccessoryType.checkmark
                }
                
            } else {
                cell?.accessoryType = UITableViewCellAccessoryType.none
            }
            
            
        case "switchCell":
            cell = tableView.dequeueReusableCell(withIdentifier: "switchCell")
            let switchCell = cell as! SwitchCell
            switchCell.delegate = self
            
            switchCell.displayLabel.text = sections?[section_index]?.data?[row].0
            switchCell.onSwitch.isOn = sections?[section_index]?.results[row] ?? false
        default:
            cell = tableView.dequeueReusableCell(withIdentifier: "filterCell") as! FilterCell
        }
        
        cell?.layer.borderWidth = 0.5
     /*   cell?.layer.borderColor = UIColor.gray.cgColor
        cell?.layer.cornerRadius = 5
 */
        
        return cell!
    }
    
    
    public func numberOfSections(in tableView: UITableView) -> Int {
        return sections?.count ?? 0
        
    }
    
    
    public func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return sections?[section]?.headerTitle
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //take care of checkmarks for filter . Change the index and reload. Make sure it is un collapsed
        print("Row got selected")
        let section_index = indexPath.section
        let row = indexPath.row
        let cellType = sections?[section_index]?.cellType ?? "filterCell"
        
        if cellType == "filterCell" {
            // if collapsed and its clicked don't change the index
            if !(collapsed[section_index] ?? true){
                sections?[section_index]?.checked_index = row
            }
            //toggle collapsed
            collapsed[section_index] = !(collapsed[section_index] ?? true)
            
        }
        tableView.reloadSections(IndexSet(integer: section_index), with: .automatic)
    }
    
    
    // MARK: - SwitchCell Delegate
    func switchCell(switchCell: SwitchCell, didChangeValue value: Bool){
        let indexPath = tableView.indexPath(for: switchCell)
        let section_index = indexPath?.section
        let row = indexPath?.row
        //results[row!] = value
        sections?[section_index!]?.results[row!] = value
        
        //get the value fo the selected switch
        let value: String = sections?[section_index!]?.data![row!].1 as! String
        print("The value selected is:\(value)")
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

