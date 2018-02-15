//
//  ViewController.swift
//  A3
//
//  Created by toxin_4500 on 2018-02-15.
//  Copyright © 2018 toxin_4500. All rights reserved.
//

import UIKit
import SceneKit

class ViewController: UIViewController {
    
    func computeX(k: Double, l: Double, R: Double, t: Double) -> Float {
        
        return Float(R * ((1.0 - k) * cos(t) + l * k * cos(((1.0 - k) / k ) * t)))
        
    }
    
    func computeZ(k: Double, l: Double, R: Double, t: Double) -> Float {
        
        return Float(R * ((1.0 - k) * sin(t) + l * k * sin(((1.0 - k) / k) * t)))
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        var k: Double
        var l: Double
        var R: Double
        var t: Double
        
        let dimen: CGFloat = 0.05
        
        if let file = Bundle.main.path(forResource: "input", ofType: "txt") {
            
            do {
                let contents = try String(contentsOfFile: file)
                let terms = contents.components(separatedBy: ",")
                print(terms.count)
                if (terms.count >= 2) {
                    k = (terms[0] as NSString).doubleValue
                    l = (terms[1] as NSString).doubleValue
                    R = (terms[2] as NSString).doubleValue
                    t = 0
                    
                    let sceneView = SCNView(frame: self.view.frame)
                    self.view.addSubview(sceneView)
                    let scene = SCNScene()
                    sceneView.scene = scene
                    
                    let camera = SCNCamera()
                    let cameraNode = SCNNode()
                    cameraNode.camera = camera
                    cameraNode.position = SCNVector3(x: -3.0, y: 3.0, z: 3.0)
                    
                    let ambientLight = SCNLight()
                    ambientLight.type = SCNLight.LightType.ambient
                    ambientLight.color = UIColor(red: 0.2, green: 0.2, blue: 0.2, alpha: 1.0)
                    cameraNode.light = ambientLight
                    
                    let light = SCNLight()
                    light.type = SCNLight.LightType.spot
                    light.spotInnerAngle = 30.0
                    light.spotOuterAngle = 80.0
                    light.castsShadow = true
                    let lightNode = SCNNode()
                    lightNode.light = light
                    lightNode.position = SCNVector3(x: 1.5, y: 1.5, z: 1.5)
                    
                    let origin = SCNBox(width: 0.001, height: 0.001, length: 0.001, chamferRadius: 0.0)
                    let origNode = SCNNode(geometry: origin)
                    origNode.position = SCNVector3(x: 0.0, y: 0.0, z: 0.0)
                    
                    let back = SCNPlane(width: 70.0, height: 70.0)
                    let backNode = SCNNode(geometry: back)
                    backNode.eulerAngles = SCNVector3(x: GLKMathDegreesToRadians(-90), y: 0, z: 0)
                    backNode.position = SCNVector3(x: 0, y: -0.5, z: 0)
                    
                    let spiralColour = SCNMaterial()
                    spiralColour.diffuse.contents = UIColor.red
                    
                    let backColour = SCNMaterial()
                    backColour.diffuse.contents = UIColor.green
                    back.materials = [backColour]
                    
                    let constraint = SCNLookAtConstraint(target: origNode)
                    constraint.isGimbalLockEnabled = true
                    cameraNode.constraints = [constraint]
                    lightNode.constraints = [constraint]
                    
                    scene.rootNode.addChildNode(lightNode)
                    scene.rootNode.addChildNode(cameraNode)
                    scene.rootNode.addChildNode(origNode)
                    scene.rootNode.addChildNode(backNode)
                    
                    var spiralArray: [SCNNode] = []
                    
                    for i in 0..<10000 {
                        
                        t = Double(i) * 0.06282
                        let x = computeX(k: k, l: l, R: R, t: t)
                        let z = computeZ(k: k, l: l, R: R, t: t)
                        let cube = SCNBox(width: dimen, height: dimen, length: dimen, chamferRadius: 0.0)
                        let cubeNode = SCNNode(geometry: cube)
                        cubeNode.position = SCNVector3(x: x, y: 0.0, z: z)
                        cube.materials = [spiralColour]
                        spiralArray.append(cubeNode)
                        
                    }
                    
                    for i in 0..<10000 {
                        scene.rootNode.addChildNode(spiralArray[i])
                    }
                    
                } else {//not enough terms
                    print("Error in file")
                }
            } catch {
                print("Exception caught")
            }
            
        }
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

