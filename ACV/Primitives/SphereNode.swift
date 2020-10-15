//
//  SphereNode.swift
//  ACV
//
//  Created by Sanjay Khan on 10/8/20.
//
import SceneKit
import UIKit

final class SphereNode: SCNNode {
    override init() {
        super.init()
    }

    init(position: SCNVector3, color: UIColor, radius: CGFloat = 0.003) {
        super.init()

        let sphere = SCNSphere(radius: radius)
        let material = SCNMaterial()
        material.diffuse.contents = color
        sphere.materials = [material]

        let sphereNode = SCNNode(geometry: sphere)
        sphereNode.position = position

        addChildNode(sphereNode)
    }

    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
