//
//  MuscleReport.swift
//  MuscleFLossingRoller
//
//  Created by Rodrigo Schreiner on 1/11/19.
//  Copyright © 2019 MFR. All rights reserved.
//

import UIKit
import FirebaseFirestore

class MuscleReport: ViewController, UITableViewDelegate, UITableViewDataSource {
    let cellMuscleId = "cellMuscleId"
    var username = ""
    var bodypartid = 0
    var bodypartname = ""
    var muscleList = [Sessions]()
    @IBOutlet weak var myNavigation: UINavigationBar!
    
    @IBOutlet weak var tableView: UITableView!
    
    lazy var refresher: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        refreshControl.tintColor = UIColor.red
        refreshControl.addTarget(self, action: #selector(refreshList), for: .valueChanged)
        return refreshControl
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()

       
        self.navigationController?.navigationBar.topItem!.title = bodypartname
     
        
        tableView.dataSource = self
        tableView.delegate = self
      
        tableView.refreshControl = refresher
        let db = Firestore.firestore()
        db.collection("sessions").whereField("username", isEqualTo: username).whereField("bodypartid", isEqualTo: bodypartid).order(by: "sessiondate", descending: true).getDocuments {(snapshot, error) in
            if error != nil {
                print(error as Any)
            } else {
                if (snapshot?.documents.count)! > 0 {
                    self.muscleList.removeAll()
                    for muscle in (snapshot?.documents)! {
                        let sessionObject = muscle.data() as? [String: AnyObject]
                        let bodypartname = muscle["bodypartname"]
                        let bodypartid = muscle["bodypartid"]
                        let cooloff = muscle["cooloff"]
                        let isfavorite = muscle["isfavorite"]
                        let minutes = muscle["minutes"]
                        let notes = muscle["notes"]
                        let painbefore = muscle["painbefore"]
                        let painafter = muscle["painafter"]
                        let reps = muscle["resps"]
                        let username = muscle["username"]
                        
                        
                        let muscle = Sessions(bodypartid: bodypartid as! Int?, bodypartname: bodypartname as! String?, cooloff: cooloff as! Int?, isfavorite: isfavorite as! Int?, miutes: minutes as! Int?,notes: notes as! String?, painafter: painafter as! Int?, painbefore: painbefore as! Int?, reps: reps as! Int?, username: username as! String?  )
                        self.muscleList.append(muscle)
                        
                        
                    }
                    DispatchQueue.main.async {
                        self.tableView.reloadData()
                      
                    }
                } else {
                    print("No data")
                }
            }
        }
        tableView.register(SessionCell.self, forCellReuseIdentifier: cellMuscleId)
    }
    

    func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return muscleList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SessionCustomCell", for: indexPath) as! SessionCustomCell
        
        let muscleInfo = muscleList[indexPath.row]
        let myImage = UIImage(named: "ios_more");
        //cell.imgCell.image = myImage
        cell.lblTitle.text = muscleInfo.username
        cell.lblSubTitle.text=muscleInfo.notes
        cell.lblDetails.text="details"
        //  cell.accessoryType = .disclosureIndicator
        //    cell.detailTextLabel!.numberOfLines = 0
       // cell.textLabel!.text = muscleInfo.username
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
    
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let muscle_info = muscleList[indexPath.row]
        let bodypartid = muscle_info.bodypartid!
        let username = muscle_info.username!


        let vc = storyboard?.instantiateViewController(withIdentifier: "musclereports") as? MuscleReport
//        vc?.coach_name = coachName
//        vc?.coach_email = coachEmail
//        vc?.coach_phone = coachPhone
//        vc?.coach_invited = coachInvited

        self.present(vc!,animated:true,completion: nil)
    }

}
