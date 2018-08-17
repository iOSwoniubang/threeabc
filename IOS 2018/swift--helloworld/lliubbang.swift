//
//  lliubbang.swift
//  swift--helloworld
//
//  Created by baimi on 2018/8/7.
//  Copyright © 2018年 liubang. All rights reserved.
//

import Foundation
import UIKit



let SCREEN_WIDTH = UIScreen.main.bounds.size.width

var gof_RGBColor: (CGFloat, CGFloat, CGFloat) -> UIColor = {red, green, blue in
    return UIColor(red: red / 255, green: green / 255, blue: blue / 255, alpha: 1);
}
