//
//  ViewController.swift
//  swift--helloworld
//
//  Created by baimi on 2018/8/6.
//  Copyright © 2018年 liubang. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        let rect = CGRect(x: 0, y: 100, width: SCREEN_WIDTH, height: 55)
        
        let lbColor = gof_RGBColor(33,44,55)
        
        let label = UILabel(frame:rect)
        label.backgroundColor = lbColor
        label.textAlignment = .center
        label.text = "什么鬼"
        label.font = UIFont(name:"Arial", size: 36)
        label.textColor = UIColor.red
        
        self.view.addSubview(label)
        
        
        
        
        
        
        
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

