//
//  WorkedMuscles.swift
//  MuscleFLossingRoller
//
//  Created by Rodrigo Schreiner on 1/10/19.
//  Copyright © 2019 MFR. All rights reserved.
//

import UIKit
import FirebaseFirestore

class WorkedMuscles: UITableViewController {
    let cellId = "cellId"
    var sessionsList = [Sessions]()

    @IBOutlet weak var myNavigation: UINavigationItem!
    lazy var refresher: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        refreshControl.tintColor = UIColor.red
        refreshControl.addTarget(self, action: #selector(refreshList), for: .valueChanged)
        return refreshControl
    }()
    
    @IBAction func backToSessionsOptions(_ sender: Any) {
        let vc:UIViewController = storyboard!.instantiateViewController(withIdentifier: "mysessionsoptions") as UIViewController
        self.present(vc,animated:true,completion: nil)
    }
    override func viewDidLoad() {
      
        super.viewDidLoad()
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Add", style: .plain, target: self, action: #selector(addTapped))
        tableView.refreshControl = refresher
        let db = Firestore.firestore()
        db.collection("sessions").order(by: "bodypartname").getDocuments {(snapshot, error) in
            if error != nil {
                print(error as Any)
            } else {
                if (snapshot?.documents.count)! > 0 {
                    self.sessionsList.removeAll()
                    for sessions in (snapshot?.documents)! {
                        let sessionObject = sessions.data() as? [String: AnyObject]
                        let bodypartname = sessionObject?["bodypartname"]
                        let bodypartid = sessionObject?["bodypartid"]
                        let cooloff = sessionObject?["cooloff"]
                        let isfavorite = sessionObject?["isfavorite"]
                        let minutes = sessionObject?["minutes"]
                        let notes = sessionObject?["notes"]
                        let painbefore = sessionObject?["painbefore"]
                        let painafter = sessionObject?["painafter"]
                        let reps = sessionObject?["reps"]
                        let sessiondate = sessionObject?["sessiondate"]
                        let username = sessionObject?["username"]
                        let pagecamefrom = sessionObject!["pagefrom"]
                        
                        let session_date = convertTimeStampToString(dt: sessiondate as! Date)
                        
                        let session = Sessions(bodypartid: bodypartid as! Int?, bodypartname: bodypartname as! String?, cooloff: cooloff as! Int?, isfavorite: isfavorite as! Int?, minutes: minutes as! Int?,notes: notes as! String?, painafter: painafter as! Int?, painbefore: painbefore as! Int?, reps: reps as! Int?, username: username as! String?, musclename: bodypartname as! String?, sessiondate: session_date as String?)
                        self.sessionsList.append(session)
                        
                       
                    }
                    DispatchQueue.main.async {
                        self.tableView.reloadData()
                    }
                } else {
                    print("No data")
                }
            }
        }
        tableView.register(SessionCell.self, forCellReuseIdentifier: cellId)
    }
    
    @objc func addTapped(){
        print("button works")
    }


    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return sessionsList.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath)
        
        let sessionInfo = sessionsList[indexPath.row]
        //  cell.accessoryType = .disclosureIndicator
        //    cell.detailTextLabel!.numberOfLines = 0
        cell.textLabel!.text = sessionInfo.bodypartname
        //cell.detailTextLabel?.text = ("\(String(describing: coachInfo.coach_phone!))\n\(String(describing: coachInfo.coach_email!))")
        return cell
    }
    
    class SessionCell: UITableViewCell {
        override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?){
            super.init(style: .subtitle, reuseIdentifier: reuseIdentifier)
        }
        
        required init?(coder aDecoder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
    }
    
   
    
    @objc func refreshList(){
        tableView.reloadData()
        refresher.endRefreshing()
      
    }

}
