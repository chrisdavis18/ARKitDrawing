//
//  ViewController.swift
//  AugmentedReality
//
//  Created by Personal on 9/23/17.
//  Copyright © 2017 Chris Davis. All rights reserved.
//

import UIKit
import ARKit

class ViewController: UIViewController, ARSCNViewDelegate {
    
    // MARK: - Outlets
    @IBOutlet weak var sceneView: ARSCNView!
    @IBOutlet weak var drawButton: UIButton!
    
    // MARK: - Variables
    let configuration = ARWorldTrackingConfiguration()

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        // Start 
        self.sceneView.debugOptions = [ARSCNDebugOptions.showWorldOrigin, ARSCNDebugOptions.showFeaturePoints]
        self.sceneView.showsStatistics = true
        self.sceneView.session.run(configuration)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
  
    
    // MARK: - ARSCNViewDelegate
    func renderer(_ renderer: SCNSceneRenderer, willRenderScene scene: SCNScene, atTime time: TimeInterval) {
        
        guard let pov = sceneView.pointOfView else { return }
        let transform = pov.transform
        let orientation = SCNVector3(-transform.m31, -transform.m32, -transform.m33)
        let location = SCNVector3(transform.m41, transform.m42, transform.m43)
        let cameraPosition = addVectors(left: orientation, right: location)
        
        DispatchQueue.main.async {


            if self.drawButton.isHighlighted {

                let sphereNode = SCNNode(geometry: SCNSphere(radius: 0.02))
                sphereNode.position = cameraPosition
                sphereNode.geometry?.firstMaterial?.diffuse.contents = UIColor.red
                self.sceneView.scene.rootNode.addChildNode(sphereNode)


            } else {

                self.sceneView.scene.rootNode.enumerateChildNodes({ (node, _) in
                    // Remove Node if it's a pointer, keep other drawing nodes
                    if node.name == "pointer" {
                        node.removeFromParentNode()
                    }
                })

                let pointer = SCNNode(geometry: SCNSphere(radius: 0.01))
                pointer.name = "pointer"
                pointer.position = cameraPosition
                pointer.geometry?.firstMaterial?.diffuse.contents = UIColor.red
                self.sceneView.scene.rootNode.addChildNode(pointer)

            }
        }
        
    }
    // MARK: - Helper Function to Add Vectors
    func addVectors(left: SCNVector3, right: SCNVector3) -> SCNVector3 {
        return SCNVector3Make(left.x + right.x, left.y + right.y, left.z + right.z)
    }
    
    


}



