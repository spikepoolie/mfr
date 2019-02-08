//
//  MuscleList.swift
//  MuscleFLossingRoller
//
//  Created by Rodrigo Schreiner on 1/11/19.
//  Copyright © 2019 MFR. All rights reserved.
//

import UIKit
import Firebase
import FirebaseFirestore

class MuscleList: ViewController, UITableViewDelegate, UITableViewDataSource {
    
    let cellId = "cellId"
    var muscleList = [Muscles]()
    var pageFrom = ""
    var reportType = ""
    var ascdesc = false
    var myUserId = ""
    var bodypartid = 9999999999
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.pageFrom = UserDefaults.standard.string(forKey: "pagefrom")!
        self.myUserId = UserDefaults.standard.string(forKey: "myuserid")!
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
        tableView.register(SessionCell.self, forCellReuseIdentifier: cellId)
        tableView.tableFooterView = UIView()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        let db = Firestore.firestore()
        db.collection("muscles").whereField("userid", isEqualTo: self.myUserId).order(by: "musclename").addSnapshotListener({ (snapshot, error) in
            if error != nil {
                print(error as Any)
            } else {
                if (snapshot?.documents.count)! > 0 {
                    self.muscleList.removeAll()
                    for sessions in (snapshot?.documents)! {
                        let muscleObject = sessions.data() as? [String: AnyObject]
                        let bodypartname = muscleObject?["musclename"]
                        let bodypartid = muscleObject?["muscleid"]
                        let musclesession = Muscles(musclename: bodypartname as! String?, muscleid: bodypartid as! Int?)
                        if bodypartname as! String != "" {
                            self.muscleList.append(musclesession)
                        }
                    }
                    DispatchQueue.main.async {
                        self.tableView.reloadData()
                    }
                } else {
                    print("No data")
                }
            }
        })
    }
    
    func viewData() {
        
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
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath)
        
        let muscleInfo = muscleList[indexPath.row]
        cell.textLabel!.text = muscleInfo.musclename
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
    }
   
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let muscle_info = muscleList[indexPath.row]
        let vc = storyboard?.instantiateViewController(withIdentifier: "musclereport") as? MuscleReport
        vc?.bodypartid = muscle_info.muscleid!
        vc?.bodypartname = muscle_info.musclename!
        vc?.bartitle = muscle_info.musclename!
        vc?.pageFrom = self.pageFrom
        vc?.username = self.myUserId
        self.navigationController?.pushViewController(vc!, animated: true)
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    @objc func goBack(){
        self.dismiss(animated: true, completion: nil)
    }
}
