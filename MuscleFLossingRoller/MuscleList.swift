//
//  MuscleList.swift
//  MuscleFLossingRoller
//
//  Created by Rodrigo Schreiner on 1/11/19.
//  Copyright © 2019 MFR. All rights reserved.
//

import UIKit
import FirebaseFirestore

class MuscleList: ViewController, UITableViewDelegate, UITableViewDataSource {
    
    let cellId = "cellId"
    var sessionsList = [Sessions]()
    var pageFrom = ""
    var reportType = ""
    var ascdesc = false
    
   
    
    @IBOutlet weak var tableView: UITableView!
    
    lazy var refresher: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        refreshControl.tintColor = UIColor.red
        refreshControl.addTarget(self, action: #selector(refreshList), for: .valueChanged)
        return refreshControl
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let page_from = UserDefaults.standard.string(forKey: "pagefrom")
        navigationItem.largeTitleDisplayMode = .always
        navigationItem.title = "Muscles"
        let backbutton = UIButton(type: .custom)
        backbutton.titleLabel?.font = backbutton.titleLabel?.font.withSize(30)
        backbutton.setTitle("<", for: .normal)

        backbutton.setTitleColor(backbutton.tintColor, for: .normal) // You can change the TitleColor
        backbutton.addTarget(self, action: #selector(goBack), for: .touchUpInside)
        
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(customView: backbutton)
        
        tableView.dataSource = self
        tableView.delegate = self
        tableView.refreshControl = refresher
        
        if page_from == "muscles" {
            self.reportType = "bodypartname"
        } else if page_from == "favorites" {
            self.reportType = "isfavorite"
        } else {
            self.reportType = "sessiondate"
            self.ascdesc = true
        }
        
        let db = Firestore.firestore()
        db.collection("sessions").order(by: self.reportType, descending: ascdesc).getDocuments {(snapshot, error) in
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
                        
                        
                        let session_date = convertTimeStampToString(dt: sessiondate as! Date)
                        
                        let session = Sessions(bodypartid: bodypartid as! Int?, bodypartname: bodypartname as! String?, cooloff: cooloff as! Int?, isfavorite: isfavorite as! Int?, minutes: minutes as! Int?,notes: notes as! String?, painafter: painafter as! Int?, painbefore: painbefore as! Int?, reps: reps as! Int?, username: username as! String?, musclename: bodypartname as! String?, sessiondate: session_date as String?)
                        self.sessionsList.append(session)
                        
                        
                    }
                    DispatchQueue.main.async {
                        self.tableView.reloadData()
                        //self.dismiss(animated: true, completion: nil)
                    }
                } else {
                    print("No data")
                }
            }
        }
        tableView.register(SessionCell.self, forCellReuseIdentifier: cellId)
    }
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return sessionsList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath)
        
        let sessionInfo = sessionsList[indexPath.row]
        let pagefrom = UserDefaults.standard.string(forKey: "pagefrom")
        
        print("defaul = \(pagefrom)")
        
        if pagefrom == "muscles" {
            cell.textLabel!.text = sessionInfo.bodypartname
            
        } else if pagefrom == "favorites" {
            cell.textLabel!.text = sessionInfo.bodypartname
        } else {
            cell.textLabel!.text = sessionInfo.sessiondate
        }
       
        cell.accessoryType = .disclosureIndicator
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
        
        let muscle_info = sessionsList[indexPath.row]
        let bodypartid = muscle_info.bodypartid!
        let username = muscle_info.username!
        let bodypartname = muscle_info.bodypartname!
        let vc = storyboard?.instantiateViewController(withIdentifier: "musclereport") as? MuscleReport
        vc?.bodypartid = bodypartid
        vc?.username = username
        vc?.bodypartname = bodypartname
        vc?.pageFrom = self.pageFrom
        self.navigationController?.pushViewController(vc!, animated: true)
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    @objc func goBack(){
        self.dismiss(animated: true, completion: nil)
    }
   
}
