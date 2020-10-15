//
//  LineNode.swift
//  ACV
//
//  Created by Sanjay Khan on 10/8/20.
//

import SceneKit

final class LineNode: SCNNode {

    override init() {
        super.init()
    }

    init(from vectorA: SCNVector3, to vectorB: SCNVector3, lineColor color: UIColor, lineFlat: CGFloat = 0.0015, distanceDifference: CGFloat = 0.0) {
        super.init()

        let height = vectorA.distance(from: vectorB) - distanceDifference

        position = vectorA
        let nodeVector2 = SCNNode()
        nodeVector2.position = vectorB

        let nodeZAlign = SCNNode()
        nodeZAlign.eulerAngles.x = Float.pi / 2

        let cylinder = SCNCylinder(radius: lineFlat, height: height)
        let material = SCNMaterial()
        material.diffuse.contents = color
        cylinder.materials = [material]

        let nodeLine = SCNNode(geometry: cylinder)
        nodeLine.position.y = Float(-height / 2) + 0.001
        nodeZAlign.addChildNode(nodeLine)

        addChildNode(nodeZAlign)

        constraints = [SCNLookAtConstraint(target: nodeVector2)]
    }

    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
