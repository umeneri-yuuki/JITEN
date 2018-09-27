//
//  RankingViewController.swift
//  jibun-dictionary
//
//  Created by 村中　勇輝 on 2018/09/21.
//  Copyright © 2018年 村中　勇輝. All rights reserved.
//

import UIKit
import FirebaseDatabase

class RankingViewController: UIViewController , UITableViewDataSource, UITableViewDelegate{

    

    
    @IBOutlet weak var TableView: UITableView!
    
    var rankingdiclist = DicList()
    
    var ref: DatabaseReference!
    
    var selectrow = -1
    var selectdictitle = ""
    var selectdicpublish = true
    var selectuserid = ""
  //  var selectdicid = ""
    
    var refreshControl:UIRefreshControl!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        TableView.delegate = self
        TableView.dataSource = self
        
        ref = Database.database().reference()
        
        
        self.refreshControl = UIRefreshControl()
        self.refreshControl.addTarget(self, action: #selector(self.refresh(_:)), for: UIControlEvents.valueChanged)
        self.TableView.addSubview(refreshControl)
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        
        self.ref.child("alldictionarylist").observeSingleEvent(of: .value, with: { (snapshot) in
            
            let diclist = DicList()
            
            for list in snapshot.children {
                
                let snap = list as! DataSnapshot
                let dic = snap.value as! [String: Any]
                let dictitle = (dic["dictitle"])! as! String
                let dicpublish = (dic["publish"])! as! Bool
                let dicid = (dic["dicid"])! as! String
                if dicpublish == true {
                let newdic = myDic(dictitle: dictitle, dicid: dicid)
   
                self.selectuserid = (dic["userid"])! as! String
                diclist.addDicList(dic: newdic)
                }
                
            }
            self.rankingdiclist.dics  = diclist.dics
            //self.rankingdiclist.dics  = diclist.dics.sorted(by: {$0.dicpos < $1.dicpos})
            
            self.TableView.reloadData()
            
        }
        )
        
        self.TableView.reloadData()
        
        
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        tabBarController?.tabBar.isHidden = false
        
        
    }
    
    @objc func refresh(_ sender: UIRefreshControl) {
        self.ref.child("alldictionarylist").observeSingleEvent(of: .value, with: { (snapshot) in
            
            let diclist = DicList()
            
            for list in snapshot.children {
                
                let snap = list as! DataSnapshot
                let dic = snap.value as! [String: Any]
                let dictitle = (dic["dictitle"])! as! String
                let dicpublish = (dic["publish"])! as! Bool
                if dicpublish == true {
                    let newdic = myDic(dictitle: dictitle, dicid: "")
                    self.selectuserid = (dic["userid"])! as! String
                    diclist.addDicList(dic: newdic)
                }
                
            }
            self.rankingdiclist.dics  = diclist.dics
            //self.rankingdiclist.dics  = diclist.dics.sorted(by: {$0.dicpos < $1.dicpos})
            
            self.TableView.reloadData()
            
        }
        )
        
        self.TableView.reloadData()
        
        sender.endRefreshing()
    }
    
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "toSomeList") {
            let SWLVC = segue.destination as! SomeoneWordListViewController
            SWLVC.dicid = self.rankingdiclist.dics[selectrow].dicid
            SWLVC.selectdictitle = self.rankingdiclist.dics[selectrow].dictitle
            SWLVC.userid = selectuserid
            //WLVC.selectDic = mydiclist.dics[selectdicnum]
        }
    }
        
        
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.rankingdiclist.dics.count

    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)
        
        let dic = self.rankingdiclist.dics[indexPath.row]
        cell.textLabel!.text = dic.dictitle
        cell.textLabel!.font = UIFont(name: "HirakakuProN-W3", size: 15)
        
        return cell
    }
    
    func tableView(_ table: UITableView,didSelectRowAt indexPath: IndexPath) {
        
        self.selectrow = indexPath.row
        DispatchQueue.main.async {
            self.performSegue(withIdentifier: "toSomeList",sender:nil)
        }
        TableView.deselectRow(at: indexPath, animated: true)
        
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
