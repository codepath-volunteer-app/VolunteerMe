//
//  User.swift
//  VolunteerMe
//
//  Created by Auster Chen on 10/11/17.
//  Copyright © 2017 volunteer_me. All rights reserved.
//

import Foundation
import Parse

enum UserType: String {
    case Organization = "0"
    case Volunteer = "1"
}

class User: PFUser {
    static let userTypeToStringMap: [UserType:String] = [
        UserType.Organization: "0",
        UserType.Volunteer: "1",
    ]
    @NSManaged var name: String?
    @NSManaged var userDescription: String?
    @NSManaged var profilePictureUrl: String?
    @NSManaged var userType: String?
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

    class func createNewUser(username:String, password: String, name: String?, userDescription: String?, userType: UserType?, profilePictureUrl: String?, tags: [String]?, successCallback: @escaping (User) -> ()) -> () {
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
            user.userType = userType.rawValue
        } else {
            user.userType = UserType.Volunteer.rawValue
        }
        
        if let profilePictureUrl = profilePictureUrl {
            user.profilePictureUrl = profilePictureUrl
        }

        if let tags = tags {
            let foundTags = Tag.getTagsByNameArraySync(tags)
            let relation = user.relation(forKey: "interests")
            for tag in foundTags {
                relation.add(tag)
            }
        }
        
        user.signUpInBackground() {
            (success: Bool, error: Error?) in
            if success {
                successCallback(user)
            } else if error != nil {
                print(error?.localizedDescription)
            }
        }
    }
    
    class func login(username: String, password: String, successCallback: @escaping (User) -> ()) -> () {
        logInWithUsername(inBackground: username, password: password) { (user: PFUser?, error: Error?) in
            if let error = error {
                print("User log in failed: \(error.localizedDescription)")
            } else {
                successCallback(user as! User)
            }
            }
    }

    func update(name: String?, userDescription: String?, userType: UserType?, profilePictureUrl: String?, tags: [String]?, successCallback: @escaping (User) -> ()) -> () {
        if let name = name {
            self.name = name
        }

        if let userDescription = userDescription {
            self.userDescription = userDescription
        }

        if let userType = userType {
            self.userType = userType.rawValue
        }

        if let profilePictureUrl = profilePictureUrl {
            self.profilePictureUrl = profilePictureUrl
        }
        
        if let tags = tags {
            let foundTags = Tag.getTagsByNameArraySync(tags)
            let relation = self.relation(forKey: "interests")
            for tag in foundTags {
                relation.add(tag)
            }
        }

        saveInBackground() {
            (success: Bool, error: Error?) in
            if success {
                successCallback(self)
            } else if error != nil {
                print(error?.localizedDescription)
            }
        }
    }

    func isUserRegisteredForEvent(event: Event, successCallback: @escaping (Bool) -> ()) -> () {
        return EventAttendee.isUserRegisteredForEvent(user: self, event: event, successCallback: successCallback)
    }

    func isOrganization() -> Bool {
        return userType == UserType.Organization.rawValue
    }

    func isVolunteer() -> Bool {
        return userType == UserType.Volunteer.rawValue
    }

    func printHumanReadableTestString() -> (){
        print("username: \(username)")
        print("userDescription: \(userDescription)")
    }
}
