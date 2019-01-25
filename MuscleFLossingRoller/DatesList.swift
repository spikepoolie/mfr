//
//  DatesList.swift
//  
//
//  Created by Rodrigo Schreiner on 1/16/19.
//

import UIKit
import FirebaseFirestore

class DatesList: UIViewController, UITableViewDelegate, UITableViewDataSource  {
   
    let dateCellId = "dateCellId"
    var datesList = [Dates]()
    var pageFrom = ""
    var myUserId = ""
    
    @IBOutlet weak var myNavigation: UINavigationItem!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var barButtonItem: UIBarButtonItem!
    
    lazy var refresher: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        refreshControl.tintColor = UIColor.red
        refreshControl.addTarget(self, action: #selector(refreshList), for: .valueChanged)
        return refreshControl
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.myUserId = UserDefaults.standard.string(forKey: "myuserid")!
        navigationItem.largeTitleDisplayMode = .always
        navigationItem.title = "Session Dates"
        let backbutton = UIButton(type: .custom)
        backbutton.titleLabel?.font = backbutton.titleLabel?.font.withSize(30)
        backbutton.setTitle("<", for: .normal)
        
        backbutton.setTitleColor(backbutton.tintColor, for: .normal)
        backbutton.addTarget(self, action: #selector(goBack), for: .touchUpInside)
        
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(customView: backbutton)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(SessionCell.self, forCellReuseIdentifier: dateCellId)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        let db = Firestore.firestore()
        db.collection("datesessions").whereField("userid", isEqualTo: self.myUserId).order(by: "datestring", descending: true).getDocuments {(snapshot, error) in
            if error != nil {
                print(error as Any)
            } else {
                if (snapshot?.documents.count)! > 0 {
                    self.datesList.removeAll()
                    for sessions in (snapshot?.documents)! {
                        let dateObject = sessions.data()
                        let datestring = dateObject["datestring"]
                        let datesession = Dates(datestring: datestring as! String?, userid: self.myUserId as String?)
                        if datestring as! String != "" {
                            self.datesList.append(datesession)
                        }
                    }
                    DispatchQueue.main.async {
                        self.tableView.reloadData()
                    }
                } 
            }
        }
    }
    
    class SessionCell: UITableViewCell {
        override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?){
            super.init(style: .subtitle, reuseIdentifier: reuseIdentifier)
        }
        
        required init?(coder aDecoder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
    }
    

    func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return datesList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: dateCellId, for: indexPath)
        
        let dateInfo = datesList[indexPath.row]
        let pagefrom = UserDefaults.standard.string(forKey: "pagefrom")
        
        cell.textLabel!.text = dateInfo.datestring
        cell.accessoryType = .disclosureIndicator
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let date_info = datesList[indexPath.row]
        let datestring = date_info.datestring!
        
//        let formatter1 = DateFormatter()
//        formatter1.dateFormat = "E, mm/dd/yyyy h:mm a"
//        let date1 = formatter1.date(from: sessiondate)
//
//        let formatter = DateFormatter()
//        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
//        let myString = formatter.string(from: date1!)
//        let yourDate = formatter.date(from: myString)
//        formatter.dateFormat = "E, d MMM yyyy"
//        let session_date_label = formatter.string(from: yourDate!)
        let vc = storyboard?.instantiateViewController(withIdentifier: "musclereport") as? MuscleReport
        //vc?.bodypartid = bodypartid
        vc?.username = self.myUserId
        vc?.pageFrom = self.pageFrom
        vc?.bartitle = date_info.datestring!
        vc?.datestring = date_info.datestring!
        self.navigationController?.pushViewController(vc!, animated: true)
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    @objc func refreshList(){
        self.tableView.reloadData()
        refresher.endRefreshing()
        
    }
  
    @IBAction func test(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @objc func goBack(){
        self.dismiss(animated: true, completion: nil)
    }

}
