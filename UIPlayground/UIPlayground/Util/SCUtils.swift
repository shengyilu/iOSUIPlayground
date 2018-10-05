//
//  SCUtils.swift
//  PopTipTest
//
//  Created by 盧聖宜 on 2018/9/26.
//  Copyright © 2018年 Edward. All rights reserved.
//

import UIKit

public class SCUtils: NSObject {
    
    public static let shared: SCUtils = SCUtils()
    
    public lazy var bundle: Bundle = {
        
        return Bundle(for: type(of: self))
        
    }()
}
