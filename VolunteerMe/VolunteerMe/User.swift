//
//  User.swift
//  VolunteerMe
//
//  Created by Auster Chen on 10/11/17.
//  Copyright © 2017 volunteer_me. All rights reserved.
//

import Foundation
import Parse

enum UserType {
    case Organization
    case Volunteer
}

class User: PFUser {
    @NSManaged var name: String?
    @NSManaged var userDescription: String?
    @NSManaged var profilePictureUrl: String?
    var userType: UserType = .Volunteer
    var interests: [Tag] {
        get {
            do {
                let tags = try self.relation(forKey: "interests").query().findObjects()
                
                return tags as! [Tag]
            } catch {
                return []
            }
        }
    }

    class func createNewUser(username:String, password: String, name: String?, userDescription: String?, userType: UserType?, profilePictureUrl: String?, tags: [String]?, successCallback: @escaping (User, Error?) -> ()) -> () {
        let user = User()
        user.username = username
        user.password = password

        if let name = name {
            user.name = name
        }
        
        if let userDescription = userDescription {
            user.userDescription = userDescription
        }
        
        if let userType = userType {
            user.userType = userType
        }
        
        if let profilePictureUrl = profilePictureUrl {
            user.profilePictureUrl = profilePictureUrl
        }

        if let tags = tags {
            let foundTags = Tag.findTagsByNameArray(tags)
            let relation = user.relation(forKey: "interests")
            for tag in foundTags {
                relation.add(tag)
            }
        }
        
        user.signUpInBackground() {
            (success: Bool, error: Error?) in
            if success {
                successCallback(user, error)
            } else if error != nil {
                print(error?.localizedDescription)
            }
        }
    }
    
    class func login(username: String, password: String, successCallback: @escaping (User, Error?) -> ()) -> () {
        logInWithUsername(inBackground: username, password: password) { (user: PFUser?, error: Error?) in
            if let error = error {
                print("User log in failed: \(error.localizedDescription)")
            } else {
                successCallback(user as! User, error)
            }
            }
    }

    func update(name: String?, userDescription: String?, userType: UserType?, profilePictureUrl: String?, tags: [String]?, successCallback: @escaping (User, Error?) -> ()) -> () {
        if let name = name {
            self.name = name
        }

        if let userDescription = userDescription {
            self.userDescription = userDescription
        }

        if let userType = userType {
            self.userType = userType
        }

        if let profilePictureUrl = profilePictureUrl {
            self.profilePictureUrl = profilePictureUrl
        }
        
        if let tags = tags {
            let foundTags = Tag.findTagsByNameArray(tags)
            let relation = self.relation(forKey: "interests")
            for tag in foundTags {
                relation.add(tag)
            }
        }

        saveInBackground() {
            (success: Bool, error: Error?) in
            if success {
                successCallback(self, error)
            } else if error != nil {
                print(error?.localizedDescription)
            }
        }
    }
}
