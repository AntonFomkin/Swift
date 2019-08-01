//
//  ResultViewController.swift
//  MyFBApp
//
//  Created by Anton Fomkin on 24/07/2019.
//  Copyright © 2019 Anton Fomkin. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseFirestore


class ResultViewController: UIViewController {

    @IBOutlet weak var userLabel: UILabel!
    @IBOutlet weak var group1Label: UILabel!
    @IBOutlet weak var group2Label: UILabel!
    @IBOutlet weak var group3Label: UILabel!
   
    override func viewDidLoad() {
        super.viewDidLoad()

        
        let db = Firestore.firestore()
        

      
        let userId = (Auth.auth().currentUser?.uid)!
        let email = (Auth.auth().currentUser?.email)!
        
        var ref: DocumentReference? = nil
        ref = db.collection("users").document(userId)
        ref?.setData( [
            "firstName": email,
            "group1": "Животные",
            "group2": "Книги",
            "group3": "Музыка",
        ]) { err in
            if let err = err {
                print("Error adding document: \(err)")
            } else {
                print("Document added with ID: \(ref!.documentID)")
            }
        }
  
 
        db.collection("users").getDocuments() { (querySnapshot, err) in
            if let err = err {
                print("Error getting documents: \(err)")
            } else {
                        for document in querySnapshot!.documents {
                            if document.documentID == userId {
                                // print("\(document.documentID) => \(document.data())")
                                let data = document.data()
                                self.userLabel.text? = data["firstName"] as! String
                                self.group1Label.text? = data["group1"] as! String
                                self.group2Label.text? = data["group2"] as! String
                                self.group3Label.text? = data["group3"] as! String
                                
                            }
                        }
                  }
        }
}
    
    @IBAction func logoutTap(_ sender: Any) {
        try? Auth.auth().signOut()
        performSegue(withIdentifier: "gotoLogin", sender: nil)
    }
    
}
