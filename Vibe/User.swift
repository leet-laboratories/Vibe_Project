//
//  User.swift
//
//  Created by Abey Bazbaz on 8/7/18.
//

import Foundation

// Create User class with multiple properties
class User{
    var id: String
	var name: String
	var email: String
    var username: String
    var vibeStatus: Int
    var photoURL: String
    
    // Initialize instance of User with the following properties
    init(userEmail: String, userID: String, name: String, username: String, vibeStatus: Int, photoURL: String){
		self.id = userID
		self.email = userEmail
        self.name = name
        self.username = username
        self.vibeStatus = vibeStatus
        self.photoURL = photoURL
	}
    
//    // Load user data from firebase
//    func loadData(){
//        // Pull data from firebase once
//        self.ref?.child("users").child((Auth.auth().currentUser?.uid)!).observeSingleEvent(of: .value, with: { (snapshot) in
//            // Get user values
//            let value = snapshot.value as? NSDictionary
//            homeUser.nameDisplayed = value?["name"] as? String ?? ""
//            homeUser.usernameDisplayed = value?["username"] as? String ?? ""
//            homeUser.vibeStatus = value?["vibeStatus"] as? Int ?? 0
//            print("Username: " + homeUser.usernameDisplayed)
//            print("Vibe Status: ", homeUser.vibeStatus)
//            // ...
//        }) { (error) in
//            print(error.localizedDescription)
//        }
//    }
    
    
}
