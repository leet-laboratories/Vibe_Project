//
//  MenuViewController.swift
//  Vibe
//
//  Created by Allan Frederick on 8/15/18.
//  Copyright © 2018 Allan Frederick. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth
import FirebaseDatabase
import FirebaseStorage
import Nuke

class MenuViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var username: UILabel!
    @IBOutlet weak var vibeSwitch: UISwitch!
    
    
    @IBAction func vibeSwitchToggle(_ sender: Any) {
        // Turn on vibe
        if self.vibeSwitch.isOn == true{
            FriendSystem.system.CURRENT_USER_REF.child("vibeStatus").setValue(1)
            print("vibe on")
        }
            // Turn off vibe
        else{
            FriendSystem.system.CURRENT_USER_REF.child("vibeStatus").setValue(0)
            print("vibe off")
        }
    }
    
    // Store array of menu items
    var menuItems:Array = [String]()
    
    // Index counter
    var indxCount = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        // Generate an array of menu items
        menuItems = ["Profile", "Friends", "Settings", "Logout"]
        // Load user data from firebase
        name.text = FriendsViewController.homeUser.nameDisplayed
        username.text = FriendsViewController.homeUser.usernameDisplayed
        let imageURL = URL(string: FriendsViewController.homeUser.photoURL)!
        // Resize via Nuke
        var request = ImageRequest(url: imageURL, targetSize: CGSize(width: 125, height: 125), contentMode: .aspectFill)
        // Load image via Nuke
        Nuke.loadImage(with: request, into: profileImage )
        let preheater = Nuke.ImagePreheater()
        preheater.stopPreheating(with: [imageURL])
        // Round profile image
        profileImage.layer.cornerRadius = profileImage.frame.size.width/2
        profileImage.clipsToBounds = true
        
    }
    
    // Set the number of rows, based on the number of menu items
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return menuItems.count
    }
    
    // Populate table cell rows with corresponding menu item
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! MenuTableViewCell
        cell.menuItemLabel.text = menuItems[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // Detect selected row
        indxCount = indexPath.row
        // Logout detection
        if (indxCount == 3){
            userLogout()
            let storyboard = UIStoryboard(name: "Start", bundle: nil)
            let signInVC = storyboard.instantiateViewController(withIdentifier: "SignInViewController")
            self.present(signInVC, animated: true, completion: nil)
        }
        else{
            // Go to corresponding view controller
            self.performSegue(withIdentifier: menuItems[indexPath.row], sender: self)
        }
    }
    // Logout user
    func userLogout(){
        FriendSystem.system.logoutAccount()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
