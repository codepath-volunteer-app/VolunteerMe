//
//  Tag.swift
//  VolunteerMe
//
//  Created by Auster Chen on 10/12/17.
//  Copyright © 2017 volunteer_me. All rights reserved.
//

import Foundation
import Parse

class Tag: PFObject, PFSubclassing {
    // name of tag
    @NSManaged var name: String?

    class func parseClassName() -> String {
        return "Tag"
    }

    class func createNewTag(name: String, successCallback: @escaping (Tag) -> ()) -> () {
        // Check if tag exists, create if not exists
        Tag.getTagsByNameArray([name]) { (tags: [Tag]) in
            if tags.count == 0 {
                let tag = Tag()
                tag.name = name.lowercased()
                
                tag.saveInBackground { (success, error) in
                    if success {
                        successCallback(tag)
                    } else if error != nil {
                        print(error?.localizedDescription)
                    }
                }
            } else {
                print("tag with name \(name) already exists")
            }
        }
    }

    class func getTagsByNameArray(_ arrayOfTagNames: [String], successCallback: @escaping ([Tag]) -> ()) -> () {
        let lowercaseArrayOfTagNames: [String] = arrayOfTagNames.map { (tagName) -> String in
            return tagName.lowercased()
        }
        let query = PFQuery(className: "Tag")
        query.whereKey("name", containedIn: lowercaseArrayOfTagNames)
            
        query.findObjectsInBackground { (results: [PFObject]?, error: Error?) in
            if let results = results {
                let tags = results as! [Tag]
                successCallback(tags)
            } else if error != nil {
                print(error?.localizedDescription)
            }
        }
    }

    // Synchronous version of findTagsByNameArray
    class func getTagsByNameArraySync(_ arrayOfTagNames: [String]) -> [Tag] {
        let lowercaseArrayOfTagNames: [String] = arrayOfTagNames.map { (tagName) -> String in
            return tagName.lowercased()
        }
        let query = PFQuery(className: "Tag")
        query.whereKey("name", containedIn: lowercaseArrayOfTagNames)
        var tags: [Tag] = []
            
        do {
            tags = try query.findObjects() as! [Tag]
        } catch {
            // Do nothing
        }
        
        return tags;
    }


    func printHumanReadableTestString() -> () {
        print("This is a tag with name: '\(name!)'")
    }
}
