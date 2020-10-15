//
//  Extensions.swift
//  ACV
//
//  Created by Sanjay Khan on 10/8/20.
//

import ARKit
import Foundation
import SceneKit

extension SCNVector3: Equatable {
    static func positionFromTransform(_ transform: matrix_float4x4) -> SCNVector3 {
        return SCNVector3Make(transform.columns.3.x, transform.columns.3.y, transform.columns.3.z)
    }
    
    func distance(from vector: SCNVector3) -> CGFloat {
        let dx = x - vector.x
        let dy = y - vector.y
        let dz = z - vector.z
        
        return CGFloat(sqrt(dx * dx + dy * dy + dz * dz))
    }
    
    public static func == (lhs: SCNVector3, rhs: SCNVector3) -> Bool {
        return (lhs.x == rhs.x) && (lhs.y == rhs.y) && (lhs.z == rhs.z)
    }
}

extension ARSCNView {
    func realWorldVector(screenPos: CGPoint) -> SCNVector3? {
        let planeTestResults = hitTest(screenPos, types: [.featurePoint])
        if let result = planeTestResults.first {
            return SCNVector3.positionFromTransform(result.worldTransform)
        }
        
        return nil
    }
}
