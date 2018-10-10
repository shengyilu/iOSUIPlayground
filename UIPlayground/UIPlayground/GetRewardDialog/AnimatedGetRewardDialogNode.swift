//
//  GetRewardDialogNode.swift
//  UIPlayground
//
//  Created by 盧聖宜 on 2018/10/5.
//  Copyright © 2018年 Edward. All rights reserved.
//

import AsyncDisplayKit
import AMPopTip

public class AnimatedGetRewardDialogNode : ASDisplayNode {
    
    let popDialog = PopTip()
    
    // Component size
    let dialogRect = CGRect(x: 0, y: 0, width: 300, height: 340)
    let iconSize = CGSize(width: 107, height: 104)
    
    // UI Component
    private let dialogTitleNode: ASTextNode = ASTextNode()
    private let dialogDescriptionNode: ASTextNode = ASTextNode()
    private let iconNode: ASImageNode = ASImageNode()
    private var iconBackground: ASImageNode?
    private var riceLabelNode: RiceLabelNode?
    private var jptLabelNode: JptLabelNode?
    private let confirmBtnNode: ASButtonNode = ASButtonNode()
    
    lazy var customView: UIView? = { [unowned self] in
        var customView = UIView(frame: self.dialogRect)
        customView.addSubnode(self)
        customView.layer.cornerRadius = 2
        customView.clipsToBounds = true
        return customView
        }()
    
    // Localized string resource
    lazy var dialogTitle: NSAttributedString? = {
        return NSAttributedString(string: "Collect!", attributes: [
            NSAttributedStringKey.font: UIFont.boldSystemFont(ofSize: 20),
            NSAttributedStringKey.foregroundColor: TextColor.title,
            ])
    }()
    
    lazy var dialogDescription: NSAttributedString? = { [unowned self] in
        let description = NSMutableAttributedString()
        
        let font = UIFont.boldSystemFont(ofSize: 16)
        let textAttributes = [
            NSAttributedStringKey.font: font,
            NSAttributedStringKey.foregroundColor: TextColor.description
        ]
        
        let getString = NSAttributedString(string: "Get ", attributes: textAttributes)
        let andString = NSAttributedString(string: " and ", attributes: textAttributes)
        
        let riceValue = NSAttributedString(string: String(self.rice), attributes: textAttributes)
        let jptValue = NSAttributedString(string: String(self.jpt), attributes: textAttributes)
        
        let riceIconUIImage = UIImage(named: "soocii_rice", in: SCUtils.shared.bundle, compatibleWith: nil)
        let jptIconUIIMage = UIImage(named: "soocii_jplay", in: SCUtils.shared.bundle, compatibleWith: nil)
        let lineHeight = font.ascender * 0.95
        let ratio = (riceIconUIImage?.size.width)! / (riceIconUIImage?.size.height)!
        let iconBounds = CGRect(x: 0, y: (lineHeight - font.lineHeight) / 2, width: ratio * lineHeight, height: lineHeight)
        
        let riceIconAttachment = NSTextAttachment()
        riceIconAttachment.image = riceIconUIImage
        riceIconAttachment.bounds = iconBounds
        let riceIconString = NSAttributedString(attachment: riceIconAttachment)
        
        let jptIconAttachment = NSTextAttachment()
        jptIconAttachment.image = jptIconUIIMage
        jptIconAttachment.bounds = iconBounds
        let jptIconString = NSAttributedString(attachment: jptIconAttachment)
        
        description.append(getString)
        description.append(riceIconString)
        description.append(riceValue)
        
        if (self.jpt != 0) {
            description.append(andString)
            description.append(jptIconString)
            description.append(jptValue)
        }
        
        return description
        }()
    
    lazy var confirmBtnLabel: String? = {
        return "OK"
    }()
    
    // Image resource
    lazy var icon: UIImage? = { [unowned self] in
        if (self.dayth == 3 || self.dayth == 7) {
            if (self.jpt == 0) {
                return UIImage(named: "sign_up_gift_treasure_rice" , in: SCUtils.shared.bundle, compatibleWith: nil)
            } else {
                return UIImage(named: "sign_up_gift_treasure" , in: SCUtils.shared.bundle, compatibleWith: nil)
            }
        } else {
            return UIImage(named: "sign_up_gift_rice" , in: SCUtils.shared.bundle, compatibleWith: nil)
        }
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

    // Properties
    private var dayth: Int = 0
    private var rice: Int = 0
    private var jpt: Float = 0

    // Animator
    private var riceAmountAnimator: UIViewPropertyAnimator?
    private var jptAmountAnimator: UIViewPropertyAnimator?

    public init(dayth: Int, rice: Int, jpt: Float) {
        super.init()
        self.dayth = dayth
        self.rice = rice
        self.jpt = jpt
        automaticallyManagesSubnodes = true
        initTextUI()
        initIcon()
        initConfirmButton()
        initDigitsLabelWithAnimator()
    }
    
    override required public init() {
        super.init()
    }

    override public func didLoad() {
        print("[Edward] didLoad")
        //self.riceLabelNode?.view.transform = CGAffineTransform(scaleX: 0.0, y: 0.0)
        //self.riceLabelNode?.view.alpha = 0
    }
    
    func initTextUI() {
        self.view.frame = dialogRect
        self.backgroundColor = BackgroundColor.dialog
        // init title
        let paragraph = NSMutableParagraphStyle()
        paragraph.alignment = .center
        
        self.dialogTitleNode.attributedText = self.dialogTitle
        self.dialogDescriptionNode.attributedText = self.dialogDescription
    }
    
    private func initIcon() {
        self.iconNode.image = icon
        self.iconNode.style.preferredSize = iconSize
        
        let iconBackgroundImage = drawBackground(size: CGSize(width: 107, height: 140), fillColor: UIColor.clear) { () -> UIBezierPath in
            return UIBezierPath(rect: CGRect(origin: CGPoint.zero, size: CGSize(width: 107, height: 140)))
        }
        
        self.iconBackground = ASImageNode()
        self.iconBackground?.image = iconBackgroundImage
    }

    private func initDigitsLabelWithAnimator() {
        if (self.rice != 0) {
            self.riceLabelNode = RiceLabelNode(rice: self.rice)
            self.riceLabelNode?.style.height = ASDimension(unit: .points, value: 36)
            self.riceLabelNode?.view.transform = CGAffineTransform(scaleX: 0.0, y: 0.0)
            self.riceLabelNode?.view.alpha = 0
            self.riceAmountAnimator = self.scaleUp(view: (self.riceLabelNode?.view)!)
        }

        if (self.jpt != 0) {
            self.jptLabelNode = JptLabelNode(jpt: self.jpt)
            self.jptLabelNode?.style.height = ASDimension(unit: .points, value: 36)
            self.jptLabelNode?.view.transform = CGAffineTransform(scaleX: 0.0, y: 0.0)
            self.jptLabelNode?.view.alpha = 0
            self.jptAmountAnimator = self.scaleUp(view: (self.jptLabelNode?.view)!)

            if let _ = self.riceAmountAnimator {
                self.riceAmountAnimator?.addCompletion{_ in
                    print("[Edward] rice label completion")
                    self.riceLabelNode?.view.alpha = 0
                    self.jptAmountAnimator?.startAnimation()
                }
            }
        }
    }

    private func scaleUp(view: UIView) -> UIViewPropertyAnimator {
        print("[Edward] scaleUp")
        let spring = UISpringTimingParameters(dampingRatio:0.5,
                                              initialVelocity: CGVector(dx: 0.2, dy: 0.2))
        let scale = UIViewPropertyAnimator(duration: 1.0,
                                           timingParameters: spring)
        scale.addAnimations {
            view.alpha = 1.0
        }
        scale.addAnimations({
            view.transform = CGAffineTransform.identity
        }, delayFactor: 0.33)
        //        scale.addCompletion {_ in
        //            print("[Edward]ready")
        //        }
        return scale
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
    
    private func initConfirmButton() {
        self.confirmBtnNode.setAttributedTitle(NSAttributedString(string: confirmBtnLabel ?? "", attributes: [
            NSAttributedStringKey.font: UIFont.systemFont(ofSize: 14),
            NSAttributedStringKey.foregroundColor: TextColor.description,
            ]), for: .normal)
        
        self.confirmBtnNode.style.width = ASDimension(unit: .points, value: 260)
        self.confirmBtnNode.style.height = ASDimension(unit: .points, value: 36)
        self.confirmBtnNode.cornerRadius = 2
        self.confirmBtnNode.contentEdgeInsets = UIEdgeInsets(top: 4, left: 4, bottom: 4, right: 4)
        self.confirmBtnNode.backgroundColor = BackgroundColor.button
        self.confirmBtnNode.addTarget(self, action: #selector(GetRewardDialogNode.tap(_:)), forControlEvents: .touchUpInside)
    }
    
    public override func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {
        print("[Edward] layoutSpecThatFits")
        let dialogtitleLayoutSpec = ASWrapperLayoutSpec(layoutElement: self.dialogTitleNode)
        dialogtitleLayoutSpec.style.spacingBefore = 26
        dialogtitleLayoutSpec.style.spacingAfter = 4
        
        let dialogDescriptionLayoutSpec = ASWrapperLayoutSpec(layoutElement: self.dialogDescriptionNode)
        dialogDescriptionLayoutSpec.style.spacingAfter = 24

        let iconInsetLayoutSpec = ASInsetLayoutSpec(insets: UIEdgeInsets(top: 0, left: 2, bottom: 40, right: 2), child: self.iconNode)
        let iconContainerLayoutSpec = ASOverlayLayoutSpec(child: self.iconBackground!, overlay: iconInsetLayoutSpec)

        let riceLabelInsetLayoutSpec = ASInsetLayoutSpec(insets: UIEdgeInsets(top: CGFloat.infinity, left: 2, bottom: 4, right: 2), child: self.riceLabelNode!)
        let riceComboContainerLayoutSpec = ASOverlayLayoutSpec(child: iconContainerLayoutSpec, overlay: riceLabelInsetLayoutSpec)
        let jptLabelInsetLayoutSpec = ASInsetLayoutSpec(insets: UIEdgeInsets(top: CGFloat.infinity, left: 2, bottom: 4, right: 2), child: self.jptLabelNode!)
        let jptComboContainerLayoutSpec = ASOverlayLayoutSpec(child: riceComboContainerLayoutSpec, overlay: jptLabelInsetLayoutSpec)

        riceComboContainerLayoutSpec.style.spacingAfter = 26

        return ASStackLayoutSpec(direction: .vertical, spacing: 0, justifyContent: .start, alignItems: .center,
                                 children: [dialogtitleLayoutSpec,
                                            dialogDescriptionLayoutSpec,
                                            jptComboContainerLayoutSpec,
                                            self.confirmBtnNode])
    }

    override public func animateLayoutTransition(_ context: ASContextTransitioning) {
        print("[Edward] animateLayoutTransition")
        self.startAnimation()
    }

    private func startAnimation() {
        if let _ = self.riceAmountAnimator {
            self.riceAmountAnimator?.startAnimation()
        }
    }

    private func stopAnimation() {
        if let _ = self.riceAmountAnimator {
            if (self.riceAmountAnimator?.isRunning)! {
                self.riceAmountAnimator?.stopAnimation(true)
            }
        }

        if let _ = self.jptAmountAnimator {
            if (self.jptAmountAnimator?.isRunning)! {
                self.jptAmountAnimator?.stopAnimation(true)
            }
        }
    }
    
    public func getCustomView() -> UIView {
        return customView!
    }
    
    public func showDialog(hostView: UIView, anchor: CGRect) {
        print("[Edward]showDialog")
        self.popDialog.shouldShowMask = true
        self.popDialog.shouldDismissOnTap = false
        self.popDialog.shouldDismissOnTapOutside = false
        self.popDialog.bubbleColor = UIColor.clear
        self.popDialog.edgeMargin = 0 //(containerView.bounds.size.width - customView.bounds.size.width) / 2
        if self.popDialog.isVisible { return }
        
        self.popDialog.show(customView: customView!, direction: .none, in: hostView, from: anchor)
        transitionLayout(withAnimation: true, shouldMeasureAsync: false, measurementCompletion: nil)
    }
    
    @objc func tap(_ sender: Any?) {
        print("[Edward] Button is clicked.")
        hide()
    }

    private func hide() {
        stopAnimation()
        if self.popDialog.isVisible {
            self.popDialog.hide()
        }
    }
    
}
