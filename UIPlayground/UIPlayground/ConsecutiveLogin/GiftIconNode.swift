//
//  GiftIconNode.swift
//  PopTipTest
//
//  Created by 盧聖宜 on 2018/10/1.
//  Copyright © 2018年 Edward. All rights reserved.
//

import AsyncDisplayKit

public class GiftIconNode : ASControlNode {
    
    private let titleList: [String] = ["Day 1", "Day 2", "Day 3", "Day 4", "Day 5", "Day 6", "Day 7"]
    
    private let titleNode: ASTextNode = ASTextNode()
    private let titleBackground: ASImageNode = ASImageNode()
    private let iconNode: ASImageNode = ASImageNode()
    private var iconBackground: ASImageNode?
    
    private struct BackgroundSize {
        static let title = CGSize(width: 56, height: 14)
        static let icon = CGSize(width: 56, height: 54)
    }
    
    private struct BackgroundColor {
        static let normal = UIColor(hexString:"#4A4A4A")
        static let highlight = UIColor(hexString:"#17B23A")
    }
    
    private struct TextColor {
        static let normal = UIColor(hexString:"#A4A7A9")
        static let highlight = UIColor(hexString:"#FFFFFF")
    }
    
    private var dayth: Int = 0
    private var title: String?
    private var isHighlight: Bool = false
    private var isCollect: Bool = false
    
    lazy var icon: UIImage? = { [unowned self] in
        if (self.isCollect) {
            return UIImage(named: "gift_checked", in: SCUtils.shared.bundle, compatibleWith: nil)
        } else {
            if (self.dayth == 3 || self.dayth == 7) {
                return UIImage(named: "sign_up_treasure" , in: SCUtils.shared.bundle, compatibleWith: nil)
            } else {
                return UIImage(named: "gift", in: SCUtils.shared.bundle, compatibleWith: nil)
            }
        }
        }()
    
    public init(dayth: Int, isHighlight: Bool, isCollect: Bool) {
        super.init()
        self.dayth = dayth
        self.title = titleList[(dayth > 0) ? dayth-1 : 0]
        self.isHighlight = isHighlight
        self.isCollect = isCollect
        
        automaticallyManagesSubnodes = true
        initUI()
    }
    
    func initUI() {
        print("initUI")
        initTitle()
        initIcon()
    }
    
    private func initTitle() {
        let titleBackgroundImage = drawBackground(size: BackgroundSize.title, fillColor: isHighlight ? BackgroundColor.highlight : BackgroundColor.normal) { () -> UIBezierPath in
            return UIBezierPath(roundedRect: CGRect(origin: CGPoint.zero, size: BackgroundSize.title),
                                byRoundingCorners: [.topLeft, .topRight],
                                cornerRadii: CGSize(width: 4.0, height: 0.0))
        }
        self.titleBackground.image = titleBackgroundImage
        
        let paragraph = NSMutableParagraphStyle()
        paragraph.alignment = .center
        self.titleNode.attributedText = NSAttributedString(string: self.title ?? "", attributes: [
            NSAttributedStringKey.font: UIFont.boldSystemFont(ofSize: 10),
            NSAttributedStringKey.foregroundColor: isHighlight ? TextColor.highlight : TextColor.normal,
            NSAttributedStringKey.paragraphStyle: paragraph
            ])
    }
    
    func drawBackground(size: CGSize, fillColor: UIColor, shapeClosure: () -> UIBezierPath) -> UIImage {
        UIGraphicsBeginImageContext(size)
        
        let path = shapeClosure()
        path.addClip()
        
        fillColor.setFill()
        path.fill()
        
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return image!
    }
    
    private func initIcon() {
        self.iconNode.image = icon
        self.iconNode.style.preferredSize = BackgroundSize.icon
        if (self.isHighlight) {
            let iconBackgroundImage = drawBackground(size: BackgroundSize.icon, fillColor: BackgroundColor.highlight) { () -> UIBezierPath in
                return UIBezierPath(roundedRect: CGRect(origin: CGPoint.zero, size: BackgroundSize.icon),
                                    byRoundingCorners: [.bottomLeft, .bottomRight],
                                    cornerRadii: CGSize(width: 4.0, height: 0.0))
            }
            self.iconBackground = ASImageNode()
            self.iconBackground?.image = iconBackgroundImage
        } else {
            self.iconNode.willDisplayNodeContentWithRenderingContext = { context, drawParameters in
                let bounds = context.boundingBoxOfClipPath
                UIBezierPath(roundedRect: bounds,
                             byRoundingCorners: [.bottomLeft, .bottomRight],
                             cornerRadii: CGSize(width: 4.0, height: 0.0)).addClip()
            }
        }
    }
    
    public override func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {
        
        let titleLayoutSpec = ASOverlayLayoutSpec(child: self.titleBackground, overlay: self.titleNode)
        
        var iconContainerLayoutSpec: ASLayoutSpec?
        if let _ = iconBackground {
            let iconInsetLayoutSpec = ASInsetLayoutSpec(insets: UIEdgeInsets(top: 0, left: 2, bottom: 2, right: 2), child: self.iconNode)
            iconContainerLayoutSpec = ASOverlayLayoutSpec(child: self.iconBackground!, overlay: iconInsetLayoutSpec)
        } else {
            iconContainerLayoutSpec = ASWrapperLayoutSpec(layoutElement: self.iconNode)
        }
        
        return ASStackLayoutSpec(direction: .vertical, spacing: 0, justifyContent: .center, alignItems: .center,
                                 children: [titleLayoutSpec, iconContainerLayoutSpec!])
    }
}
