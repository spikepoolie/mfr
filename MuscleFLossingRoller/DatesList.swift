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
    var sessionsList = [Sessions]()
    var pageFrom = ""
    
    @IBOutlet weak var myNavigation: UINavigationItem!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var barButtonItem: UIBarButtonItem!
    
    lazy var refresher: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        refreshControl.tintColor = UIColor.red
        refreshControl.addTarget(self, action: #selector(refreshList), for: .valueChanged)
        return refreshControl
    }()
    
    override func viewDidAppear(_ animated: Bool) {
        let db = Firestore.firestore()
        db.collection("sessions").order(by: "sessiondate", descending: true).getDocuments {(snapshot, error) in
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
        print("ha")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let page_from = UserDefaults.standard.string(forKey: "pagefrom")
        navigationItem.largeTitleDisplayMode = .always
        navigationItem.title = "Session Dates"
        let backbutton = UIButton(type: .custom)
        backbutton.titleLabel?.font = backbutton.titleLabel?.font.withSize(30)
        backbutton.setTitle("<", for: .normal)
        
        backbutton.setTitleColor(backbutton.tintColor, for: .normal) // You can change the TitleColor
        backbutton.addTarget(self, action: #selector(goBack), for: .touchUpInside)
        
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(customView: backbutton)
        tableView.dataSource = self
        tableView.delegate = self
       

        
        tableView.register(SessionCell.self, forCellReuseIdentifier: dateCellId)
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
        return sessionsList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: dateCellId, for: indexPath)
        
        let sessionInfo = sessionsList[indexPath.row]
        let pagefrom = UserDefaults.standard.string(forKey: "pagefrom")
        
        cell.textLabel!.text = sessionInfo.sessiondate
        cell.accessoryType = .disclosureIndicator
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let muscle_info = sessionsList[indexPath.row]
        let bodypartid = muscle_info.bodypartid!
        let username = muscle_info.username!
        let bodypartname = muscle_info.bodypartname!
        let sessiondate =  muscle_info.sessiondate!
        
        let formatter1 = DateFormatter()
        formatter1.dateFormat = "E, mm/dd/yyyy h:mm a"
        let date1 = formatter1.date(from: sessiondate)
        
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let myString = formatter.string(from: date1!)
        let yourDate = formatter.date(from: myString)
        formatter.dateFormat = "E, d MMM yyyy"
        let session_date_label = formatter.string(from: yourDate!)
        let vc = storyboard?.instantiateViewController(withIdentifier: "musclereport") as? MuscleReport
        vc?.bodypartid = bodypartid
        vc?.username = username
        vc?.bodypartname = bodypartname
        vc?.pageFrom = self.pageFrom
        vc?.bartitle = session_date_label
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
