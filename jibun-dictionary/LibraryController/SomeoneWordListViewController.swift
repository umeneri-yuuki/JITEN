//
//  SomeoneWordListViewController.swift
//  jibun-dictionary
//
//  Created by 村中　勇輝 on 2018/09/27.
//  Copyright © 2018年 村中　勇輝. All rights reserved.
//

import UIKit
import FirebaseDatabase
import FirebaseStorage

class SomeoneWordListViewController: UIViewController , UITableViewDataSource, UITableViewDelegate{
    

    @IBOutlet weak var TableView: UITableView!
    
    var selectDic = myDic(dictitle: "",dicid: "")
    //var selectDic = myDic()
    
    var selectdictitle = ""
    
    var dicid = ""
    
     var userid = ""
    
        var tableheight = CGFloat()
    
        var selectrow = -1
    
    var selectwordtitle = ""
    
    var selectwordmean = ""
    
    var selectwordid = ""
    
    var selectwordpos = 0
    
    var wordid = ""
    
    
    var ref: DatabaseReference!
        var storage = Storage.storage()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("\(dicid)")

        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: " ", style: .plain, target: nil, action: nil)
        
        TableView.delegate = self
        TableView.dataSource = self
        tabBarController?.tabBar.isHidden = true

        ref = Database.database().reference()
        
        self.ref.child("alldictionarylist/\(dicid)/words").observeSingleEvent(of: .value, with: { (snapshot) in
            
            let subdic = myDic(dictitle: "",dicid: "")
            
            for list in snapshot.children {
                
                let snap = list as! DataSnapshot
                let word = snap.value as! [String: Any]
                self.selectwordtitle = (word["wordtitle"])! as! String
                self.selectwordid = (word["wordid"])! as! String
                self.selectwordmean = (word["wordmean"])! as! String
                self.selectwordpos = (word["wordpos"])!  as! Int
                print("self.selectwordtitle:\(self.selectwordtitle)")
                print("self.wordid:\(self.selectwordid)")
                //let newdic = myDic(dictitle: (dic["dictitle"])!, dicid: (dic["dicid"])!)
                //print(newdic.dictitle)
                // self.mydiclist.addDicList(dic: newdic)
                //print(self.mydiclist.dics[0].dictitle)
                //let newdic = myDic(dictitle: self.selectwordtitle, dicid: self.dicid)
                let newword = Word()
                newword.wordtitle = self.selectwordtitle
                newword.wordmean = self.selectwordmean
                newword.wordid = self.selectwordid
                newword.wordpos = self.selectwordpos
                subdic.addWordList(word: newword)
                
            }
            self.selectDic.words = subdic.words.sorted(by: {$0.wordpos < $1.wordpos})
            self.TableView.reloadData()
            
        }
        )
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        self.navigationController!.navigationBar.tintColor = UIColor.black
        
        selectDic.dicid = self.dicid
        selectDic.dictitle = selectdictitle
        
       // self.WordListTitle.title = selectDic.dictitle
        
        
        navigationController?.hidesBarsOnTap = false
        
        tableheight = TableView.frame.size.height
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {

        if (segue.identifier == "toSomeDetail") {
            let SDVC = segue.destination as! SomeoneDicViewController
            SDVC.selectDic = self.selectDic
            SDVC.selectrow = self.selectrow
            SDVC.dicid = self.dicid
            SDVC.userid = self.userid
        
        }
    }

    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return selectDic.words.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)
        
        let word = self.selectDic.words[indexPath.row]
        
        cell.textLabel!.text = word.wordtitle
        cell.textLabel!.font = UIFont(name: "HirakakuProN-W3", size: 15)
        
        return cell
    }
    
  
    
    func tableView(_ table: UITableView,didSelectRowAt indexPath: IndexPath) {
        
        self.selectrow = indexPath.row
        DispatchQueue.main.async {
            self.performSegue(withIdentifier: "toSomeDetail",sender:nil)
        }
        
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
