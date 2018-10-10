//
//  JptLabelNode.swift
//  UIPlayground
//
//  Created by 盧聖宜 on 2018/10/8.
//  Copyright © 2018年 Edward. All rights reserved.
//

import AsyncDisplayKit

public class JptLabelNode : ASControlNode {

    private let digitsJpt: [String: String]! = [
        "0":"soocii_jpt_0",
        "1":"soocii_jpt_1",
        "2":"soocii_jpt_2",
        "3":"soocii_jpt_3",
        "4":"soocii_jpt_4",
        "5":"soocii_jpt_5",
        "6":"soocii_jpt_6",
        "7":"soocii_jpt_7",
        "8":"soocii_jpt_8",
        "9":"soocii_jpt_9",
        ".":"soocii_jpt_dot"]

    lazy var jptPlusSign: UIImage? = { [unowned self] in
        return UIImage(named: "soocii_jpt_plus", in: SCUtils.shared.bundle, compatibleWith: nil)
        }()

    lazy var jptDotSign: UIImage? = { [unowned self] in
        return UIImage(named: "soocii_jpt_dot", in: SCUtils.shared.bundle, compatibleWith: nil)
        }()

    lazy var digitImage: [ASLayoutElement]! = { [unowned self] in
        let digitArray = String(self.jpt).compactMap{String($0)}
        var digitImageArray: [ASLayoutElement] = []
        let plusSign: ASImageNode = ASImageNode()
        plusSign.image = self.jptPlusSign
        digitImageArray.append(plusSign)
        for digit in digitArray {
            let digitNode: ASImageNode = ASImageNode()
            digitNode.image = UIImage(named: digitsJpt[digit]!, in: SCUtils.shared.bundle, compatibleWith: nil)
            digitImageArray.append(digitNode)
        }
        return digitImageArray
        }()

    var jpt: Float!

    public init(jpt: Float) {
        super.init()
        self.jpt = jpt
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

