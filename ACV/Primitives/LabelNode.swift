//
//  LabelNode.swift
//  ACV
//
//  Created by Sanjay Khan on 10/8/20.
//

import ARKit
import Foundation
import SceneKit
import UIKit

final class LabelNode: SCNNode {
    static let sceneSize = CGSize(width: 240, height: 100)
    // Plane size used real world unit = Meters
    static let planeSize: (width: CGFloat, height: CGFloat) = (width: 0.048, height: 0.020)

    override init() {
        super.init()
    }

    init(_ text: String, position: SCNVector3, backgroundColor: UIColor, textColor _: UIColor) {
        super.init()

        let skScene = SKScene(size: LabelNode.sceneSize)
        skScene.backgroundColor = UIColor.clear

        let rectangle = SKShapeNode(rect: CGRect(origin: CGPoint.zero, size: LabelNode.sceneSize), cornerRadius: LabelNode.sceneSize.height / 2)
        rectangle.fillColor = backgroundColor
        rectangle.lineWidth = 0
        skScene.addChild(rectangle)

        let labelNode = SKLabelNode(text: text)
        labelNode.fontSize = 32
        labelNode.fontName = "AvenirNext-Bold"
        labelNode.fontColor = .black
        labelNode.position = CGPoint(x: LabelNode.sceneSize.width / 2, y: LabelNode.sceneSize.height / 2 - 8)
        skScene.addChild(labelNode)

        let plane = SCNPlane(width: LabelNode.planeSize.width, height: LabelNode.planeSize.height)
        let material = SCNMaterial()
        material.isDoubleSided = true
        material.diffuse.contents = skScene
        material.diffuse.contentsTransform = SCNMatrix4Translate(SCNMatrix4MakeScale(1, -1, 1), 0, 1, 0)
        plane.materials = [material]

        let node = SCNNode(geometry: plane)
        node.position = position

        let billboardConstraint = SCNBillboardConstraint()
        billboardConstraint.freeAxes = [.X, .Y, .Z]
        node.constraints = [billboardConstraint]

        addChildNode(node)
    }

    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
