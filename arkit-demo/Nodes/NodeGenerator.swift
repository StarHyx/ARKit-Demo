//
//  ShapeGenerator.swift
//  arkit-demo
//
//  Created by Han Yixing on 2018/1/14.
//  Copyright © 2018年 Han Yixing. All rights reserved.
//


import Foundation
import SceneKit
import ARKit

struct NodeGenerator {
    
    //生成具有不同颜色的球体
    static func generateSphereInFrontOf(node: SCNNode) -> SCNNode {
        let radius = (0.02...0.06).random()
        let sphere = SCNSphere(radius: CGFloat(radius))

        let color = SCNMaterial()
        color.diffuse.contents = self.randomColor()
        sphere.materials = [color]

        let sphereNode = SCNNode(geometry: sphere)
        
        let position = SCNVector3(x: 0, y: 0, z: -1)
        sphereNode.position = node.convertPosition(position, to: nil)
        sphereNode.rotation = node.rotation//在屏幕正中间，面向用户生成
        
        return sphereNode
    }
    
    //生成具有不同颜色的立方体
    static func generateCubeInFrontOf(node: SCNNode, physics: Bool) -> SCNNode {
        let size = CGFloat((0.06...0.1).random())
        let box = SCNBox(width: size, height: size, length: size, chamferRadius: 0)
        
        let color = SCNMaterial()
        color.diffuse.contents = self.randomColor()
        box.materials = [color]
        
        let boxNode = SCNNode(geometry: box)
        
        let position = SCNVector3(x: 0, y: 0, z: -1)
        boxNode.position = node.convertPosition(position, to: nil)
        boxNode.rotation = node.rotation
        
        if physics {
            let physicsBody = SCNPhysicsBody(type: .dynamic, shape: SCNPhysicsShape(geometry: box, options: nil))
            physicsBody.mass = 1.25
            physicsBody.restitution = 0.25
            physicsBody.friction = 0.75
            physicsBody.categoryBitMask = CollisionTypes.shape.rawValue
            boxNode.physicsBody = physicsBody
        }
        
        return boxNode
    }
    
    // 生成平面
    static func generatePlaneFrom(planeAnchor: ARPlaneAnchor, physics: Bool, hidden: Bool) -> SCNNode {
        let plane = self.plane(from: planeAnchor, hidden: hidden)
        
        let planeNode = SCNNode(geometry: plane)
        planeNode.position = self.position(from: planeAnchor)
        
        if physics {
            let body = SCNPhysicsBody(type: .kinematic, shape: SCNPhysicsShape(geometry: plane, options: nil))
            body.restitution = 0.0
            body.friction = 1.0
            planeNode.physicsBody = body
        }
        
        return planeNode
    }
    
    // 扩大识别平面
    static func update(planeNode: SCNNode, from planeAnchor: ARPlaneAnchor, hidden: Bool) {
        
        let updatedGeometry = self.plane(from: planeAnchor, hidden: hidden)
        
        planeNode.geometry = updatedGeometry
        planeNode.physicsBody?.physicsShape = SCNPhysicsShape(geometry: updatedGeometry, options: nil)
        planeNode.position = self.position(from: planeAnchor)
    }
    
    static func update(planeNode: SCNNode, hidden: Bool) {
        planeNode.geometry?.materials.first?.diffuse.contents = hidden ? UIColor(white: 1, alpha: 0) : UIColor(red: 0, green: 0, blue: 1, alpha: 0.5)// 识别显示蓝色平面
    }
    
    private static func plane(from planeAnchor: ARPlaneAnchor, hidden: Bool) -> SCNGeometry {
        let plane = SCNBox(width: CGFloat(planeAnchor.extent.x), height: 0.005, length: CGFloat(planeAnchor.extent.z), chamferRadius: 0)
        
        let color = SCNMaterial()
        color.diffuse.contents = hidden ? UIColor(white: 1, alpha: 0) : UIColor(red: 0, green: 0, blue: 1, alpha: 0.5)
        plane.materials = [color]
        
        return plane
    }
    
    private static func position(from planeAnchor: ARPlaneAnchor) -> SCNVector3 {
        return SCNVector3Make(planeAnchor.center.x, -0.005, planeAnchor.center.z)
    }
    
    private static func randomColor() -> UIColor {
        return UIColor(hue: CGFloat(drand48()), saturation: 1, brightness: 1, alpha: 1)
    }
}

extension ClosedRange where Bound : FloatingPoint {
    public func random() -> Bound {
        let range = self.upperBound - self.lowerBound
        let randomValue = (Bound(arc4random_uniform(UINT32_MAX)) / Bound(UINT32_MAX)) * range + self.lowerBound
        return randomValue
    }
}
