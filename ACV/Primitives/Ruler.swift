//
//  Ruler.swift
//  ACV
//
//  Created by Sanjay Khan on 10/8/20.
//

import ARKit
import SceneKit
import UIKit

final class Ruler {
    var point1: SphereNode = SphereNode()
    var line1: LineNode = LineNode()
    var label: LabelNode = LabelNode()
    var line2: LineNode = LineNode()
    var point2: SphereNode = SphereNode()

    var shapeColor: UIColor
    var textColor: UIColor

    init(shapeColor: UIColor, textColor: UIColor) {
        self.shapeColor = shapeColor
        self.textColor = textColor
    }

    @available(iOS 11.0, *)
    func draw(startPoint: SCNVector3, endPoint: SCNVector3, sceneView: ARSCNView, fromPointOfView pointOfView: SCNNode) {
        removeNode()

        let dx = (startPoint.x + endPoint.x) / 2.0
        let dy = (startPoint.y + endPoint.y) / 2.0
        let dz = (startPoint.z + endPoint.z) / 2.0

        let centerPoint = SCNVector3(dx, dy, dz)
        
        let distanceBetweenNodeAndCamera = centerPoint.distance(from: pointOfView.worldPosition)
        let delta = Float(distanceBetweenNodeAndCamera * 3.5)
        
        let distanceText = updateResultLabel(startPoint.distance(from: endPoint))
        label = LabelNode(distanceText, position: centerPoint, backgroundColor: shapeColor, textColor: textColor)
        
        sceneView.scene.rootNode.addChildNode(label)
        label.childNodes.forEach { (node) in
            node.simdScale = simd_float3(delta, delta, delta)
        }
        
        let distanceDifference = label.boundingBox.min.distance(from: label.boundingBox.max) / 2
        let lineFlat = CGFloat(0.0015 * delta)
        let radius = CGFloat(0.003 * delta)

        point1 = SphereNode(position: startPoint, color: shapeColor, radius: radius)
        sceneView.scene.rootNode.addChildNode(point1)
        
        point2 = SphereNode(position: endPoint, color: shapeColor, radius: radius)
        sceneView.scene.rootNode.addChildNode(point2)

        line1 = LineNode(from: startPoint, to: centerPoint, lineColor: shapeColor, lineFlat: lineFlat, distanceDifference: distanceDifference)
        sceneView.scene.rootNode.addChildNode(line1)

        line2 = LineNode(from: endPoint, to: centerPoint, lineColor: shapeColor, lineFlat: lineFlat, distanceDifference: distanceDifference)
        sceneView.scene.rootNode.addChildNode(line2)
        
    }

    func removeNode() {
        point1.removeFromParentNode()
        line1.removeFromParentNode()
        label.removeFromParentNode()
        line2.removeFromParentNode()
        point2.removeFromParentNode()
    }

    func updateResultLabel(_ value: CGFloat) -> String {
        let meters = value
        return String(format: "%.01f ", meters*100*0.393701) + " in"
    }
    
    deinit {
        removeNode()
    }
}
