//
//  RiceLabelNode.swift
//  UIPlayground
//
//  Created by 盧聖宜 on 2018/10/8.
//  Copyright © 2018年 Edward. All rights reserved.
//

import AsyncDisplayKit

public class RiceLabelNode : ASControlNode {

    private let digitsRice: [String] = [
        "soocii_point_0",
        "soocii_point_1",
        "soocii_point_2",
        "soocii_point_3",
        "soocii_point_4",
        "soocii_point_5",
        "soocii_point_6",
        "soocii_point_7",
        "soocii_point_8",
        "soocii_point_9"
    ]

    lazy var ricePlusSign: UIImage? = { [unowned self] in
        return UIImage(named: "soocii_point_plus", in: SCUtils.shared.bundle, compatibleWith: nil)
    }()

    lazy var riceDotSign: UIImage? = { [unowned self] in
        return UIImage(named: "soocii_point_dot", in: SCUtils.shared.bundle, compatibleWith: nil)
    }()

    lazy var digitImage: [ASLayoutElement]! = { [unowned self] in
        let digitArray = String(self.rice).compactMap{Int(String($0))}
        var digitImageArray: [ASLayoutElement] = []
        let plusSign: ASImageNode = ASImageNode()
        plusSign.image = self.ricePlusSign
        digitImageArray.append(plusSign)
        for digit in digitArray {
            let digitNode: ASImageNode = ASImageNode()
            digitNode.image = UIImage(named: digitsRice[digit], in: SCUtils.shared.bundle, compatibleWith: nil)
            digitImageArray.append(digitNode)
        }
        return digitImageArray
    }()

    var rice: Int!

    public init(rice: Int) {
        super.init()
        self.rice = rice
        automaticallyManagesSubnodes = true
        initUI()
    }

    func initUI() {
        print("initUI")
    
    }

    public override func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {
        return ASStackLayoutSpec(direction: .horizontal, spacing: 0, justifyContent: .center, alignItems: .center,
                                 children: self.digitImage!)
    }
}
