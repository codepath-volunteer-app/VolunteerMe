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
    fileprivate static var tagsCache: [String:Tag] = [:]

    // name of tag
    @NSManaged var name: String?

    class func parseClassName() -> String {
        return "Tag"
    }

    class func createNewTag(name: String, successCallback: @escaping (Tag) -> ()) -> () {
        let tag = Tag()
        tag.name = name

        tag.saveInBackground { (success, error) in
            if success {
                Tag.tagsCache[tag.name!] = tag
                successCallback(tag)
            } else if error != nil {
                print(error?.localizedDescription)
            }
        }
    }

    class func findTagsByNameArray(_ arrayOfTagNames: [String], successCallback: @escaping ([Tag]) -> ()) -> () {
        var foundTags: [Tag] = []
        var tagNamesToFetch: [String] = []
        
        for tagName in arrayOfTagNames {
            if let existingTag = Tag.tagsCache[tagName] {
                foundTags.append(existingTag)
            } else {
                tagNamesToFetch.append(tagName)
            }
        }

        if tagNamesToFetch.count > 0 {
            let query = PFQuery(className: "Tag")
            query.whereKey("name", containedIn: tagNamesToFetch)
            
            query.findObjectsInBackground { (results: [PFObject]?, error: Error?) in
                if let results = results {
                    let tags = results as! [Tag]

                    for tag in tags {
                        Tag.tagsCache[tag.name!] = tag
                        foundTags.append(tag)
                    }

                    successCallback(foundTags)
                } else if error != nil {
                    print(error?.localizedDescription)
                }
            }
        } else {
            print("in memory tags cache hit")
            successCallback(foundTags)
        }
    }

    // Synchronous version of findTagsByNameArray
    class func findTagsByNameArraySync(_ arrayOfTagNames: [String]) -> [Tag] {
        var foundTags: [Tag] = []
        var tagNamesToFetch: [String] = []

        for tagName in arrayOfTagNames {
            if let existingTag = Tag.tagsCache[tagName] {
                foundTags.append(existingTag)
            } else {
                tagNamesToFetch.append(tagName)
            }
        }

        if tagNamesToFetch.count > 0 {
            let query = PFQuery(className: "Tag")
            query.whereKey("name", containedIn: tagNamesToFetch)
            var tags: [Tag] = []
            
            do {
                tags = try query.findObjects() as! [Tag]
            } catch {
                // Do nothing
            }
            
            for tag in tags {
                Tag.tagsCache[tag.name!] = tag
                foundTags.append(tag)
            }
        }

        return foundTags
    }

    // Prefix search, depends on cache being loaded
    class func queryTagsFromCache(_ searchTerm: String) -> [Tag] {
        var foundTags: [Tag] = []

        for (name, tag) in Tag.tagsCache {
            if name.lowercased().range(of: searchTerm.lowercased()) != nil {
                foundTags.append(tag)
            }
        }

        return foundTags
    }

    func printHumanReadableTestString() -> () {
        print("This is a tag with name: '\(name!)'")
    }
}
