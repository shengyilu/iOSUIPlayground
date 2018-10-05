//
//  ConsecutiveLoginDialogNode.swift
//  PopTipTest
//
//  Created by 盧聖宜 on 2018/10/1.
//  Copyright © 2018年 Edward. All rights reserved.
//

import AsyncDisplayKit
import AMPopTip

public class ConsecutiveLoginDialogNode : ASDisplayNode {
    
    let popDialog = PopTip()
    
    // Dialog size
    let dialogRect = CGRect(x: 0, y: 0, width: 300, height: 340)
    
    // UI Component
    let dialogTitleNode: ASTextNode = ASTextNode()
    let dialogDescriptionNode: ASTextNode = ASTextNode()
    var giftIconNodes = [GiftIconNode]()
    let signUpBtnNode: ASButtonNode = ASButtonNode()
    lazy var customView: UIView? = { [unowned self] in
        var customView = UIView(frame: self.dialogRect)
        customView.addSubnode(self)
        customView.layer.cornerRadius = 2
        customView.clipsToBounds = true
        return customView
        }()
    
    // Localized string resource
    lazy var dialogTitle: String? = {
        return "Rewards for Login"
    }()
    
    lazy var dialogDescription: String? = {
        return "Special rewards for 3-day and 7-day\n logins!"
    }()
    
    lazy var signUpBtnLabel: String? = {
        return "Sign Up"
    }()
    
    // Color
    private struct BackgroundColor {
        static let dialog = UIColor(hexString:"#343C42")
        static let button = UIColor(hexString:"#17B23A")
    }
    
    private struct TextColor {
        static let title = UIColor(hexString:"#0AED3D")
        static let description = UIColor(hexString:"#FFFFFF")
    }
    
    // Property
    var alreadyLogInDays: Int = 0
    
    public init(alreadyLogInDays: Int) {
        super.init()
        self.alreadyLogInDays = alreadyLogInDays
        automaticallyManagesSubnodes = true
        initTextUI()
        initLoginGiftIcons()
        initSignUpButton()
    }
    
    override required public init() {
        super.init()
    }
    
    func initTextUI() {
        self.view.frame = dialogRect
        self.backgroundColor = BackgroundColor.dialog
        // init title
        let paragraph = NSMutableParagraphStyle()
        paragraph.alignment = .center
        
        self.dialogTitleNode.attributedText = NSAttributedString(string: self.dialogTitle ?? "", attributes: [
            NSAttributedStringKey.font: UIFont.boldSystemFont(ofSize: 16),
            NSAttributedStringKey.foregroundColor: TextColor.title,
            ])
        
        self.dialogDescriptionNode.attributedText = NSAttributedString(string: self.dialogDescription ?? "", attributes: [
            NSAttributedStringKey.font: UIFont.boldSystemFont(ofSize: 14),
            NSAttributedStringKey.foregroundColor: TextColor.description,
            NSAttributedStringKey.paragraphStyle: paragraph,
            ])
    }
    
    private func initLoginGiftIcons() {
        for day in 1...7 {
            let isHighLight = (day == self.alreadyLogInDays + 1)
            let isCollect = (day <= self.alreadyLogInDays)
            let giftIconNode = GiftIconNode(dayth: day, isHighlight: isHighLight, isCollect: isCollect)
            if (isHighLight) {
                giftIconNode.addTarget(self, action: #selector(ConsecutiveLoginDialogNode.tap(_:)), forControlEvents: .touchUpInside)
            }
            giftIconNodes.append(giftIconNode)
        }
    }
    
    private func initSignUpButton() {
        self.signUpBtnNode.setAttributedTitle(NSAttributedString(string: signUpBtnLabel ?? "", attributes: [
            NSAttributedStringKey.font: UIFont.systemFont(ofSize: 14),
            NSAttributedStringKey.foregroundColor: TextColor.description,
            ]), for: .normal)
        
        self.signUpBtnNode.style.width = ASDimension(unit: .points, value: 260)
        self.signUpBtnNode.style.height = ASDimension(unit: .points, value: 36)
        self.signUpBtnNode.cornerRadius = 2
        self.signUpBtnNode.contentEdgeInsets = UIEdgeInsets(top: 4, left: 4, bottom: 4, right: 4)
        self.signUpBtnNode.backgroundColor = BackgroundColor.button
        self.signUpBtnNode.addTarget(self, action: #selector(ConsecutiveLoginDialogNode.tap(_:)), forControlEvents: .touchUpInside)
    }
    
    public override func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {
        
        let dialogtitleLayoutSpec = ASWrapperLayoutSpec(layoutElement: self.dialogTitleNode)
        dialogtitleLayoutSpec.style.spacingBefore = 26
        dialogtitleLayoutSpec.style.spacingAfter = 4
        
        let dialogDescriptionLayoutSpec = ASWrapperLayoutSpec(layoutElement: self.dialogDescriptionNode)
        dialogDescriptionLayoutSpec.style.spacingAfter = 24
        
        let firstRowLoginIconsLayoutSpec = ASStackLayoutSpec(direction: .horizontal,
                                                             spacing: 12,
                                                             justifyContent: .center,
                                                             alignItems: .center,
                                                             children: [giftIconNodes[0], giftIconNodes[1], giftIconNodes[2]])
        firstRowLoginIconsLayoutSpec.style.spacingAfter = 20
        
        let secondRowLoginIconsLayoutSpec = ASStackLayoutSpec(direction: .horizontal,
                                                              spacing: 12,
                                                              justifyContent: .center,
                                                              alignItems: .center,
                                                              children: [giftIconNodes[3], giftIconNodes[4], giftIconNodes[5], giftIconNodes[6]])
        secondRowLoginIconsLayoutSpec.style.spacingAfter = 20
        
        return ASStackLayoutSpec(direction: .vertical, spacing: 0, justifyContent: .start, alignItems: .center,
                                 children: [dialogtitleLayoutSpec, dialogDescriptionLayoutSpec, firstRowLoginIconsLayoutSpec, secondRowLoginIconsLayoutSpec, self.signUpBtnNode])
    }
    
    public func getCustomView() -> UIView {
        return customView!
    }
    
    public func showDialog(hostView: UIView, anchor: CGRect) {
        self.popDialog.shouldShowMask = true
        self.popDialog.shouldDismissOnTap = false
        self.popDialog.shouldDismissOnTapOutside = false
        self.popDialog.bubbleColor = UIColor.clear
        self.popDialog.edgeMargin = 0 //(containerView.bounds.size.width - customView.bounds.size.width) / 2
        if self.popDialog.isVisible { return }
        
        self.popDialog.show(customView: customView!, direction: .none, in: hostView, from: anchor)
    }
    
    @objc func tap(_ sender: Any?) {
        print("Button is clicked.")
    }
}
