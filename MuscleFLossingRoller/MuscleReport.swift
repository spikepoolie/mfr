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
    var sessiondate = ""
    var bodypartid = 0
    var bodypartname = ""
    var muscleList = [Sessions]()
    var pageFrom = ""
    var bartitle = ""
    

    
    @IBOutlet weak var tableView: UITableView!
    
    lazy var refresher: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        refreshControl.tintColor = UIColor.red
        refreshControl.addTarget(self, action: #selector(refreshList), for: .valueChanged)
        return refreshControl
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationController?.navigationBar.topItem!.title = bartitle
     
        tableView.dataSource = self
        tableView.delegate = self
        tableView.refreshControl = refresher
        
        
        tableView.register(SessionCell.self, forCellReuseIdentifier: cellMuscleId)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        let db = Firestore.firestore()
        db.collection("sessions").whereField("username", isEqualTo: self.username).whereField("bodypartid", isEqualTo: self.bodypartid).order(by: "sessiondate", descending: true).getDocuments {(snapshot, error) in
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
                        let reps = muscle["reps"]
                        let username = muscle["username"]
                        let sessiondate = muscle["sessiondate"]
                        
                        let session_date = convertTimeStampToString(dt: sessiondate as! Date)
                        
                        let muscle = Sessions(bodypartid: bodypartid as! Int?, bodypartname: bodypartname as! String?, cooloff: cooloff as! Int?, isfavorite: isfavorite as! Int?, minutes: minutes as! Int?,notes: notes as! String?, painafter: painafter as! Int?, painbefore: painbefore as! Int?, reps: reps as! Int?, username: username as! String?, musclename: bodypartname as! String?, sessiondate: session_date as! String?)
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
        cell.btnGo.layer.cornerRadius = cell.btnGo.frame.width / 2
        cell.btnGo.layer.borderColor = UIColor.black.cgColor
        cell.btnGo.layer.borderWidth = 1
        let muscleInfo = muscleList[indexPath.row]
//        let myImage = UIImage(named: "ios_more");
//        cell.imgCell.image = muscleInfo.musclename
        
        if self.pageFrom == "muscles" {
            cell.lblGeneric.text = "Date"
            cell.lblBodyPartName.text = muscleInfo.sessiondate
        } else {
            cell.lblGeneric.text = "Body Part"
            cell.lblBodyPartName.text = muscleInfo.bodypartname
        }
        
        
        cell.lblSessionDuration.text = "\(String(describing: muscleInfo.minutes!))"
        cell.lblSessionReps.text = "\(String(describing: muscleInfo.reps!))"
        cell.lblPainBefore.text = "\(String(describing: muscleInfo.painbefore!))"
        cell.lblPainAfter.text = "\(String(describing: muscleInfo.painafter!))"
        //cell.lblSessionDate.text = muscleInfo.sessiondate
        cell.lblCoolOffTime.text = "\(String(describing: muscleInfo.cooloff!))"
        cell.btnGo.tag = indexPath.row
    
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
//        tableView.deselectRow(at: indexPath, animated: true)
//        let muscle_info = muscleList[indexPath.row]
//        let vc = storyboard?.instantiateViewController(withIdentifier: "rollertracker") as? RollerTracker
//        
//        vc!.bodypartname = muscle_info.bodypartname
//        vc!.myMinutes=muscle_info.minutes!
//        vc!.myRepetitions=muscle_info.reps!
//        vc!.myCoolOff=muscle_info.cooloff!
//        vc!.bodypartid = muscle_info.bodypartid!
//
//        self.present(vc!,animated:true,completion: nil)
//        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    @IBAction func goToRollerTracker(_ sender: Any) {
        if let btn = sender as? UIButton {
            let row = btn.tag
            let muscle_info = muscleList[row]
            let vc = storyboard?.instantiateViewController(withIdentifier: "rollertracker") as? RollerTracker
            
            vc!.bodypartname = muscle_info.bodypartname
            vc!.myMinutes=muscle_info.minutes!
            vc!.myRepetitions=muscle_info.reps!
            vc!.myCoolOff=muscle_info.cooloff!
            vc!.bodypartid = muscle_info.bodypartid!
          //  vc!.pageFrom =
            
            self.present(vc!,animated:true,completion: nil)
           // tableView.deselectRow(at: [IndexPath], animated: true)
            
        }
    }
    
}
