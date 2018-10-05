//
//  ViewController.swift
//  PopTipTest
//
//  Created by 盧聖宜 on 2018/9/21.
//  Copyright © 2018年 Edward. All rights reserved.
//
import AsyncDisplayKit
import AMPopTip

class ViewController: ASViewController<ASDisplayNode> {
    
    var customNode:GiftIconNode?
    let howToPinPostPopTip = PopTip()
    
    init() {
        super.init(node: ASDisplayNode())
        self.title = "Layout Example"
        
        self.customNode = GiftIconNode(dayth: 2, isHighlight: false, isCollect: true)
        
        self.node.addSubnode(customNode!)
        
        self.node.backgroundColor = UIColor.lightGray
        self.node.layoutSpecBlock = { [weak self] node, constrainedSize in
            guard let customNode = self?.customNode else { return ASLayoutSpec() }
            return ASCenterLayoutSpec(centeringOptions: .XY,
                                      sizingOptions: .minimumXY,
                                      child: customNode)
        }
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        showHowToPinPost()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
    }
    
    func showHowToPinPost() {
        let consecutiveLoginDialogNode = ConsecutiveLoginDialogNode(alreadyLogInDays: 2)
        consecutiveLoginDialogNode.showDialog(hostView: self.view, anchor: self.view.frame)
    }
}

