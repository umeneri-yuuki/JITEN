//
//  SomeoneDicViewController.swift
//  jibun-dictionary
//
//  Created by 村中　勇輝 on 2018/09/27.
//  Copyright © 2018年 村中　勇輝. All rights reserved.
//

import UIKit
import FirebaseStorage

class SomeoneDicViewController: UIViewController ,UIScrollViewDelegate ,UIGestureRecognizerDelegate{
    
    @IBOutlet weak var scrollView: UIScrollView!
    var pageNum:Int!
    
    var screenSize:CGRect!
    
    var selectDic = myDic(dictitle: "",dicid: "")
    
    var userid = ""
    
    var dicid = ""
    
    var selectrow = -1
    
    let documentDir = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first
    
    var storage = Storage.storage()
    
    static let LABEL_TAG = 100
    // 現在表示されているページ
    var page: Int = 0
    // ScrollViewをスクロールする前の位置
    private var startPoint: CGPoint!
    // 表示するページビューの配列
    private var pageViewArray: [UIView] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()

        scrollView.delegate = self
        
       // navigationController?.setNavigationBarHidden(true, animated: true)
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    
    //selectDic.fetchWordList(row: Int(selectDic.dicid)!)
    
  //  let tapGesture:UITapGestureRecognizer = UITapGestureRecognizer(target: self,action: #selector(WordDetailViewController.tapped(_:)))
    
    //tapGesture.delegate = self
    
   // self.view.addGestureRecognizer(tapGesture)
    
    //navigationController?.navigationBar.backgroundColor = UIColor.clear
    //navigationController?.navigationBar.alpha = 0.7
    
    
    
    //navigationController?.hidesBarsOnTap = true
    
    //self.navigationController?.view.addSubview(self.scrollView)
    //self.scrollView.addSubview((navigationController?.navigationBar)!)
    //navigationController?.navigationBar.frame.origin.y = 100
    
    // scrollView.frame.origin.x = 0
    // scrollView.frame.origin.y = 0
    
    //　scrollViewの表示サイズ
    let size = CGSize(width: scrollView.frame.size.width, height: scrollView.frame.size.height)
    // 5ページ分のcontentSize
    let contentRect = CGRect(x: 0, y: 0, width: size.width * CGFloat(selectDic.words.count), height: size.height)
    let contentView = UIView(frame: contentRect)
    
    
    pageNum = selectDic.words.count
    
    for i in 0 ..< pageNum {
    //let page = makePage(x: CGFloat(i * Int(view.frame.width)), i: i)
    let pageview = UIView(frame: CGRect(x: size.width * CGFloat(i), y: 0, width: size.width, height: size.height))
    //self.navigationController?.view.addSubview(pageview)
    //pageview.addSubview((navigationController?.view)!)
    let WordName = UITextView()
    WordName.text = selectDic.words[i].wordtitle
    WordName.font = UIFont(name: "Hiragino Sans", size: 30)
    WordName.backgroundColor = .white
    WordName.frame.size.width = size.width - 10
    WordName.sizeToFit()
    WordName.frame.origin.x = 10
    WordName.frame.origin.y = 20
    WordName.tag = WordDetailViewController.LABEL_TAG
    WordName.isEditable = false
    
    let storageRef = storage.reference()
    let reference = storageRef.child("alldictionarylist/\(dicid)/words/\(selectDic.words[i].wordid!)")
    print("wordid:\(selectDic.words[i].wordid!)")
    reference.getData(maxSize: 1 * 1024 * 1024) { data, error in
    if error != nil {
    // Uh-oh, an error occurred!
    let WordMean = UITextView()
    WordMean.text = self.selectDic.words[i].wordmean
    WordMean.font = UIFont(name: "Hiragino Sans", size: 15)
    WordMean.backgroundColor = .white
    WordMean.frame.size.width = size.width - 20
    WordMean.sizeToFit()
    WordMean.center = pageview.center
    WordMean.frame.origin.x = 10
    WordMean.frame.origin.y = WordName.frame.height + 20
    WordMean.tag = WordDetailViewController.LABEL_TAG
    WordMean.isEditable = false
    WordMean.isScrollEnabled = false
    WordMean.isSelectable = false
    
    let pageviewscroll = UIScrollView()
    pageviewscroll.addSubview(WordName)
    pageviewscroll.addSubview(WordMean)
    pageviewscroll.contentSize = CGSize(width: size.width, height: WordName.frame.size.height + WordMean.frame.size.height + 100)
    pageviewscroll.contentOffset = CGPoint(x: 0, y: 0)
    pageviewscroll.frame = CGRect(x: size.width * CGFloat(i), y: 0, width: size.width, height: size.height + 100)
    
    
    contentView.addSubview(pageviewscroll)
    self.pageViewArray.append(pageviewscroll)
    
    } else {
    // Data for "images/island.jpg" is returned
    let image = UIImage(data: data!)
    
    let WordPicture = UIImageView()
    WordPicture.frame = CGRect(x: 20, y: WordName.frame.height + 20, width: size.width - 40, height: (size.width - 40)*3/4)
    WordPicture.contentMode = UIViewContentMode.scaleAspectFit
    WordPicture.image = image
    WordPicture.tag = WordDetailViewController.LABEL_TAG
    
    let WordMean = UITextView()
    WordMean.text = self.selectDic.words[i].wordmean
    WordMean.font = UIFont(name: "Hiragino Sans", size: 15)
    WordMean.backgroundColor = .white
    WordMean.frame.size.width = size.width - 20
    WordMean.sizeToFit()
    WordMean.center = pageview.center
    WordMean.frame.origin.x = 10
    WordMean.frame.origin.y = WordName.frame.height + WordPicture.frame.height + 40
    WordMean.tag = WordDetailViewController.LABEL_TAG
    WordMean.isEditable = false
    WordMean.isScrollEnabled = false
    WordMean.isSelectable = false
    
    let pageviewscroll = UIScrollView()
    pageviewscroll.addSubview(WordName)
    pageviewscroll.addSubview(WordPicture)
    pageviewscroll.addSubview(WordMean)
    pageviewscroll.contentSize = CGSize(width: size.width, height: WordName.frame.size.height + WordMean.frame.size.height + WordPicture.frame.height + 100)
    pageviewscroll.contentOffset = CGPoint(x: 0, y: 0)
    pageviewscroll.frame = CGRect(x: size.width * CGFloat(i), y: 0, width: size.width, height: size.height + 100)
    
    contentView.addSubview(pageviewscroll)
    self.pageViewArray.append(pageviewscroll)
    }
    }
    
   
    
    }
    
    scrollView.addSubview(contentView)
    scrollView.contentSize = contentView.frame.size
    
    scrollView.contentOffset = CGPoint(x: ((size.width * CGFloat(selectrow))), y: 0)
    page =  Int((scrollView.contentOffset.x + (0.5 * scrollView.bounds.width)) / scrollView.bounds.width)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.

        
    }
    /*
    @objc func tapped(_ sender: UITapGestureRecognizer){
        // print(navigationController?.navigationBar.barTintColor)
        if self.navigationController?.navigationBar.isHidden == true {
            //scrollView.frame.origin.y = scrollView.frame.origin.y - (navigationController?.navigationBar.frame.height)!
            navigationController?.setNavigationBarHidden(false, animated: true)
            
            //navigationController?.navigationBar.isTranslucent = false
        } else {
            //scrollView.frame.origin.y = scrollView.frame.origin.y + (navigationController?.navigationBar.frame.height)!
            
            navigationController?.setNavigationBarHidden(true, animated: true)
            
            //navigationController?.navigationBar.isTranslucent = true
        }
    }
 */
    open func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        
        page =  Int((scrollView.contentOffset.x + (0.5 * scrollView.bounds.width)) / scrollView.bounds.width)
        print(page)
        
    }
    
    
}



