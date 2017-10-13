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

    class func createNewTag(name: String, successCallback: @escaping (Tag, Error?) -> ()) -> () {
        let tag = Tag()
        tag.name = name

        tag.saveInBackground { (success, error) in
            if success {
                successCallback(tag, error)
            } else if error != nil {
                print(error?.localizedDescription)
            }
        }
    }

    class func findTagsByNameArray(_ arrayOfTagNames: [String]) -> [Tag] {
        let query = PFQuery(className: "Tag")
        query.whereKey("name", containedIn: arrayOfTagNames)
        do {
            let tags = try query.findObjects()
            print(tags)
            
            return tags as! [Tag]
        } catch {
            return []
        }
    }

    class func parseClassName() -> String {
        return "Tag"
    }
}
