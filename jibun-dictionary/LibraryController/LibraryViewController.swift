//
//  LibraryViewController.swift
//  jibun-dictionary
//
//  Created by 村中　勇輝 on 2018/09/27.
//  Copyright © 2018年 村中　勇輝. All rights reserved.
//

import UIKit
import XLPagerTabStrip

class LibraryViewController: ButtonBarPagerTabStripViewController {

    override func viewDidLoad() {
        // タブの背景色
        settings.style.buttonBarBackgroundColor = UIColor.lightGray
        // タブの色
        settings.style.buttonBarItemBackgroundColor = UIColor.lightGray
        // タブの文字サイズ
        settings.style.buttonBarItemFont = UIFont.systemFont(ofSize: 15)
        // カーソルの色
        buttonBarView.selectedBar.backgroundColor = UIColor.darkGray
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    override func viewControllers(for pagerTabStripController: PagerTabStripViewController) -> [UIViewController] {
        //管理されるViewControllerを返す処理
        let firstVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "First")
        let secondVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "Second")
        let childViewControllers:[UIViewController] = [firstVC, secondVC ]
        return childViewControllers
    }
}
