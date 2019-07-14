//
//  FriendRequestViewController.swift
//  Vibe
//
//  Created by Abey Bazbaz on 9/2/18.
//  Copyright © 2018 Allan Frederick. All rights reserved.
//

import UIKit
import FirebaseDatabase
import FirebaseAuth

class FriendRequestViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate, RequestsTableViewCellDelegate {
    
    @IBOutlet weak var requestsTable: UITableView!
    @IBOutlet weak var newFriendTextField: UITextField!
    @IBOutlet weak var addFriendButton: UIButton!
    @IBAction func addFriendRequest(_ sender: Any) {
        sendFriendRequest()
    }
    
    // Requested friend username -> UID -> send friend request -> add to request node
    func sendFriendRequest(){
        // Get requested friend email
        if let friendUsername = newFriendTextField.text {
            // Search through the database to find any user that matches the email input
            FriendSystem.system.USER_REF.queryOrdered(byChild: "username").queryEqual(toValue: friendUsername).observeSingleEvent(of: .value, with: { (snapshot) in
                // If the user exists
                if (snapshot.exists()) {
                    // Get ID of requested user
                    var requestUID : String?
                    for child in snapshot.children{
                        let snap = child as! DataSnapshot
                        requestUID = snap.key
                        print("UID obtained: " + requestUID!)
                    }
                    // User cannot add self
                    if friendUsername == FriendsViewController.homeUser.usernameDisplayed {
                        let notification = UIAlertController(title: "", message: "Wow, you're lonely!", preferredStyle: .alert)
                        self.present(notification, animated: true, completion: nil)
                        // Delay time of notification (1 = sec)
                        let delay = DispatchTime.now() + 1
                        DispatchQueue.main.asyncAfter(deadline: delay){
                            // Notification completed
                            notification.dismiss(animated: true, completion: nil)
                        }
                    }
                    else{
                        // Send friend request
                        FriendSystem.system.sendRequestToUser(requestUID!)
                        print("Request sent!")
                        // Display notification
                        let notification = UIAlertController(title: "", message: "Sent!", preferredStyle: .alert)
                        self.present(notification, animated: true, completion: nil)
                        // Delay time of notification (1 = sec)
                        let delay = DispatchTime.now() + 1
                        DispatchQueue.main.asyncAfter(deadline: delay){
                            // Notification completed
                            notification.dismiss(animated: true, completion: nil)
                        }
                    }
                    self.newFriendTextField.text = "";
                }
                // If user does not exist, cancel request
                else{
                    print("User does not exist!")
                    // Display notification if user has not entered a username
                    if friendUsername == ""{
                        let notification = UIAlertController(title: "", message: "Enter in a username!", preferredStyle: .alert)
                        self.present(notification, animated: true, completion: nil)
                        // Delay time of notification (1 = sec)
                        let delay = DispatchTime.now() + 1
                        DispatchQueue.main.asyncAfter(deadline: delay){
                            // Notification completed
                            notification.dismiss(animated: true, completion: nil)
                        }
                    }
                    // Display notification if user has not entered a valid username
                    else{
                        let notification = UIAlertController(title: "", message: "Invalid username!", preferredStyle: .alert)
                        self.present(notification, animated: true, completion: nil)
                        // Delay time of notification (1 = sec)
                        let delay = DispatchTime.now() + 1
                        DispatchQueue.main.asyncAfter(deadline: delay){
                            // Notification completed
                            notification.dismiss(animated: true, completion: nil)
                        }
                        self.newFriendTextField.text = "";
                    }
                }
            }, withCancel: { (error) in
                //Print out error
                print(error)
            })
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        // Round sign-in button
        addFriendButton.layer.cornerRadius = newFriendTextField.frame.size.width/20
        addFriendButton.clipsToBounds = true
        // Read request list
        FriendSystem.system.addRequestObserver {
            print (FriendSystem.system.requestList.count)
            self.requestsTable.reloadData()
        }
        // Setting delegate for text field
        newFriendTextField.delegate = self
    }
    
    // Takes keyboard down
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    func textFieldShouldReturn(_ textField : UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    // Set the number of rows, based on the number of menu items
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return  FriendSystem.system.requestList.count
    }
    
    // Populate table cell rows with corresponding requests
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "requestsCell", for: indexPath) as! RequestsTableViewCell
        cell.requestedNameLabel.text! = FriendSystem.system.requestList[indexPath.row].username
        // Round accept button
        cell.acceptRequestButton.layer.cornerRadius = cell.acceptRequestButton.frame.size.width/4
        cell.acceptRequestButton.clipsToBounds = true
        // Round ignore button
        cell.ignoreRequestButton.layer.cornerRadius = cell.ignoreRequestButton.frame.size.width/4
        cell.ignoreRequestButton.clipsToBounds = true
        // Set cell's delegate to the controller itself
        cell.delegate = self
        return cell
    }
    
    // Accept button tapped
    func requestTableViewCellDidAccept(_ sender: RequestsTableViewCell) {
        guard let indexPath = requestsTable.indexPath(for: sender) else {return}
        print("Accepted", sender, indexPath)
        let uid = FriendSystem.system.requestList[indexPath.row].id
        FriendSystem.system.acceptFriendRequest(uid)
    }
    
    // Ignore button tapped
    func requestTableViewCellDidIgnore(_ sender: RequestsTableViewCell) {
        guard let indexPath = requestsTable.indexPath(for: sender) else {return}
        print("Ignored", sender, indexPath)
        let uid = FriendSystem.system.requestList[indexPath.row].id
        FriendSystem.system.ignoreFriendRequest(uid)
    }
    
    // Removes observer when leaving view controller 
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        FriendSystem.system.removeRequestObserver()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
