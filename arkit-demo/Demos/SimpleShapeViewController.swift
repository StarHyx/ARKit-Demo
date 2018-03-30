//
//  SimpleShapeViewController.swift
//  arkit-demo
//
//  Created by Han Yixing on 2018/1/14.
//  Copyright © 2018年 Han Yixing. All rights reserved.
//

import UIKit
import ARKit
import SceneKit

class SimpleShapeViewController: UIViewController {
    
    //初始化设置
    @IBOutlet var sceneView: ARSCNView!

    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = "生成图形"
        
        self.sceneView.autoenablesDefaultLighting = true // 光照效果
        self.sceneView.antialiasingMode = .multisampling4X
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if ARWorldTrackingConfiguration.isSupported {
            let configuration = ARWorldTrackingConfiguration()
            self.sceneView.session.run(configuration)
        } else if ARConfiguration.isSupported {
            let configuration = AROrientationTrackingConfiguration()
            self.sceneView.session.run(configuration)
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.showHelperAlertIfNeeded()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.sceneView.session.pause()
    }
    
    // UI Events
    
    @IBAction func tapScreen() {
        if let camera = self.sceneView.pointOfView {
            let sphere = NodeGenerator.generateSphereInFrontOf(node: camera)
            self.sceneView.scene.rootNode.addChildNode(sphere)
            print("Added sphere to scene")
        }
    }
    
    @IBAction func twoFingerTapScreen() {
        if let camera = self.sceneView.pointOfView {
            let sphere = NodeGenerator.generateCubeInFrontOf(node: camera, physics: false)
            self.sceneView.scene.rootNode.addChildNode(sphere)
            print("Added cube to scene")
        }
    }
    
    // Private Methods
    
    private func showHelperAlertIfNeeded() {
        let key = "SimpleShapeViewController.helperAlert.didShow"
        if !UserDefaults.standard.bool(forKey: key) {
            let alert = UIAlertController(title: "Simple Shape", message: "Tap to anchor a sphere to the world. 2-finger tap to anchor a cube into the world.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
            self.present(alert, animated: true, completion: nil)
            
            UserDefaults.standard.set(true, forKey: key)
        }
    }
}
