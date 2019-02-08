//
//  NoSelections
//  NoSelections
//
//  Created by Rodrigo Schreiner on 1/11/19.
//  Copyright © 2019 MFR. All rights reserved.
//

import UIKit
import FirebaseFirestore

class NoSelections: ViewController, UITableViewDelegate, UITableViewDataSource {
    let cellMuscleId = "cellMuscleId"
    var username = ""
    var sessiondate = ""
    var bodypartid = 0
    var bodypartname = ""
    var muscleList = [Sessions]()
    var pageFrom = ""
    var bartitle = ""
    var datestring = ""
    
    @IBOutlet weak var navBackButton: UIBarButtonItem!
    @IBOutlet weak var tableView: UITableView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
        navigationItem.title = UserDefaults.standard.string(forKey: "bartitle")!
       
        self.pageFrom = UserDefaults.standard.string(forKey: "bartitle")!
        let backbutton = UIButton(type: .custom)
        backbutton.titleLabel?.font = backbutton.titleLabel?.font.withSize(30)
        backbutton.setTitle("<", for: .normal)
        
        backbutton.setTitleColor(backbutton.tintColor, for: .normal) // You can change the TitleColor
        backbutton.addTarget(self, action: #selector(goBack), for: .touchUpInside)
        
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(customView: backbutton)
        
        tableView.dataSource = self
        tableView.delegate = self
        self.username = UserDefaults.standard.string(forKey: "myuserid")!
        
        tableView.register(SessionCell.self, forCellReuseIdentifier: cellMuscleId)
        tableView.tableFooterView = UIView()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        let db = Firestore.firestore().collection("sessions")
        var query_string: Query

        
        if self.pageFrom == "Favorites" {
            query_string = db.whereField("username", field_value:self.username, field1:"isfavorite", file2_value:1).order(by: "sessiondate", descending: true)
        } else {
            query_string = db.whereField("username", field_value:self.username, field1:"lastthree", file2_value:3).order(by: "sessiondate", descending: true).limit(to: 3)
        }

        query_string.addSnapshotListener {(snapshot, error) in
            if error != nil {
                print(error as Any)
            } else {
                if (snapshot?.documents.count)! > 0 {
                    self.muscleList.removeAll()
                    for muscle in (snapshot?.documents)! {
                        _ = muscle.data()
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
                        let datestring = muscle["datestring"]
                        
                        let session_date = convertTimeStampToString(dt: sessiondate as! Date, formatdate: "E, d MMM yyyy HH:mm: a")
                        
                        let muscle = Sessions(bodypartid: bodypartid as! Int?, bodypartname: bodypartname as! String?, cooloff: cooloff as! Int?, isfavorite: isfavorite as! Int?, minutes: minutes as! Int?,notes: notes as! String?, painafter: painafter as! Int?, painbefore: painbefore as! Int?, reps: reps as! Int?, username: username as! String?, musclename: bodypartname as! String?, sessiondate: session_date as String?, datestring: datestring as! String?)
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
        cell.btnGo.layer.borderWidth = 2
        let muscleInfo = muscleList[indexPath.row]
        //        let myImage = UIImage(named: "ios_more");
        //        cell.imgCell.image = muscleInfo.musclename
        
        //        if self.pageFrom == "muscles" {
        //            cell.lblGeneric.text = "Date"
        //            cell.lblDate.isHidden = true
        //            cell.lblDateValue.isHidden = true
        //            cell.lblBodyPartName.text = muscleInfo.sessiondate
        //        } else if  self.pageFrom == "date" {
        //            cell.lblGeneric.text = "Body Part"
        //            cell.lblDate.isHidden = true
        //            cell.lblDateValue.isHidden = true
        //            cell.lblBodyPartName.text = muscleInfo.bodypartname
        //        } else {
        //            cell.lblGeneric.text = "Body Part"
        //            cell.lblBodyPartName.text = muscleInfo.bodypartname
        //            cell.lblDate.isHidden = false
        //            cell.lblDateValue.isHidden = false
        //            cell.lblDateValue.text = muscleInfo.sessiondate
        //        }
        
        cell.lblDateValue.text = muscleInfo.sessiondate
        cell.lblBodyPartName.text = muscleInfo.bodypartname
        cell.lblSessionDuration.text = "\(String(describing: muscleInfo.minutes!)) min"
        cell.lblSessionReps.text = "\(String(describing: muscleInfo.reps!))"
        cell.lblPainBefore.text = "\(String(describing: muscleInfo.painbefore!))"
        cell.lblPainAfter.text = "\(String(describing: muscleInfo.painafter!))"
        //cell.lblSessionDate.text = muscleInfo.sessiondate
        if muscleInfo.cooloff! == 0 {
            cell.lblCoolOffTime.text = "30 secs"
        } else {
            cell.lblCoolOffTime.text = "\(String(describing: muscleInfo.cooloff!)) min"
        }
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
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    @IBAction func goToRollerTracker(_ sender: Any) {
        if let btn = sender as? UIButton {
            let row = btn.tag
            let muscle_info = muscleList[row]
            let vc = storyboard?.instantiateViewController(withIdentifier: "rollertracker") as? RollerTracker
            
            vc!.bodypartname = muscle_info.bodypartname!
            vc!.myMinutes=muscle_info.minutes!
            vc!.myRepetitions=muscle_info.reps!
            vc!.myCoolOff=muscle_info.cooloff!
            vc!.bodypartid = muscle_info.bodypartid!
            vc!.pageFrom = pageFrom
            
            self.present(vc!,animated:true,completion: nil)
            // tableView.deselectRow(at: [IndexPath], animated: true)
            
        }
    }
    
    @objc func goBack(){
        self.dismiss(animated: true, completion: nil)
    }
}
