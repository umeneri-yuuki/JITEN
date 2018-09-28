//
//  AnotherDictionaryListViewController.swift
//  jibun-dictionary
//
//  Created by 村中　勇輝 on 2018/09/27.
//  Copyright © 2018年 村中　勇輝. All rights reserved.
//

import UIKit
import XLPagerTabStrip

class AnotherDictionaryListViewController: UIViewController, IndicatorInfoProvider{

    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //必須
    func indicatorInfo(for pagerTabStripController: PagerTabStripViewController) -> IndicatorInfo {
        return "Second"
    }
    

}

