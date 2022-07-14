//
//  ViewController.swift
//  DiceAR
//
//  Created by Kittisak Panluea on 14/7/2565 BE.
//

import UIKit
import SceneKit
import ARKit

class ViewController: UIViewController, ARSCNViewDelegate {
    
    @IBOutlet var sceneView: ARSCNView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        

//        ให้มันแสดงจุดบน ar
        self.sceneView.debugOptions = [ARSCNDebugOptions.showFeaturePoints]
        
        // Set the view's delegate
        sceneView.delegate = self
        
        // Show statistics such as fps and timing information
        //        sceneView.showsStatistics = true
        
        // Create a new scene
        let diceScene = SCNScene(named: "art.scnassets/diceCollada.scn")!
        
        //        Create a new node
        //        ถ้าในซีนมันมี Node เยอะ ๆ ก็ให้มันเข้าไปหาซีนชื่อ Dice ในทุก ๆ โมเดล
//        if let diceNode = diceScene.rootNode.childNode(withName: "Dice", recursively: true) {
//            diceNode.position = SCNVector3(0, 0, -0.1)
//            //        Add Scene into rootNode
//            sceneView.scene.rootNode.addChildNode(diceNode)
//        }
//        //        Enable Lighting
//        sceneView.autoenablesDefaultLighting = true
        
        
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Create a session configuration
        
        let configuration = ARWorldTrackingConfiguration()
        
        // MARK: - 1. ตรวจจับพื้นเรียบเพื่อให้ลูกเต๋าไปวางอยู่ในที่ที่มันควรจะอยู่
        configuration.planeDetection = .horizontal
        
        
        // Run the view's session
        sceneView.session.run(configuration)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        // Pause the view's session
        sceneView.session.pause()
    }
    
    // MARK: - 1.1 เรียกใช้งาน didAdd จาก ARSCNViewDelegate
//    โดยพื้นฐานแล้วน้องจะทำหน้าที่ตรวจสอบว่าถ้ามีพื้นผิวที่เรียบแล้วจะให้เพิ่มหรือวางสิ่งของอะไรลงไปใน Scene ไหม
//    anchor จะใช้สำหรับวางวัตถุเข้าไปใน ARScene คิดซะว่าเรามีตาที่ตรวจพบพื้นที่เรียบ แล้วเราก็มีมือที่จะเอาของไปวางไว้บนพื้นที่เรียบนั้น แน่นอนว่ามันมีทั้งตำแหน่ง ทั้งการหมุนวัตถุที่มือเราสามารถทำได้
    func renderer(_ renderer: SCNSceneRenderer, didAdd node: SCNNode, for anchor: ARAnchor) {
//        ก็คือถ้า anchor มันเป็นชนิดพื้นที่เรียบ ให้ทำอะไร
        if anchor is ARPlaneAnchor {
            
            let planeAnchor = anchor as! ARPlaneAnchor
            let plane = SCNPlane(width: CGFloat(planeAnchor.extent.x), height: CGFloat(planeAnchor.extent.z))
            
            let planeNode = SCNNode()
            planeNode.position = SCNVector3(x: planeAnchor.center.x, y: 0, z: planeAnchor.center.z)
            
//            คือตัว SCNPlane อะถ้าในเอกสารจริงๆมันจะเป็นวัตถุที่เป็นแนวตั้งซึ่งมันเอามาใช้วาดลงบนพื้นในระบบนาบแนวนอนไม่ได้ ดังนั้นเราจะต้องทำการหมุนน้องจากแนวตั้งให้น้องเป็นแนวนอนก่อนแล้วค่อยเอาน้องไปใช้งานอะเนาะ
//            คือว่าเราต้องการหมุนมัน 90 องศาใช่ป่ะ แต่ว่าทีนี้ตัวองศาอะมันคำนวณจากค่่าพาย ซึ่งตามหลักของคณิตศาสตร์คือ 1 พายมีค่าเป็น 180 องศาดังนั้นถ้าเราต้องการ 90 องศาเราก็ต้องเอาค่าพายมาหารด้วย 2 แค่นั้นแหละ
            planeNode.transform = SCNMatrix4MakeRotation(-Float.pi / 2 , 1, 0, 0)
            
            let gridMaterial = SCNMaterial()
            gridMaterial.diffuse.contents = UIImage(named: "art.scnassets/grid.png")
            
            plane.materials = [gridMaterial]
            planeNode.geometry = plane
            
            node.addChildNode(planeNode)
            
        }
//        ถ้าไม่ใช่ให้ทำอะไรำ
        else {
            return
        }
    }
    
}
