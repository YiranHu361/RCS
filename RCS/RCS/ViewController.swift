import UIKit
import SceneKit

class Cube {
    var node: SCNNode
    var position: (x: Int?, y: Int?, z: Int?)
    var colors: [UIColor?]
    
    init(position: (x: Int?, y: Int?, z: Int?), colors: [UIColor?]) {
        self.position = position
        self.colors = colors

        let cubeSide = CGFloat(1)
        let box = SCNBox(width: cubeSide, height: cubeSide, length: cubeSide, chamferRadius: 0.0)
        
        // Materials for each face of the cube
        var materials = [SCNMaterial]()
        
        for color in colors {
            let material = SCNMaterial()
            material.diffuse.contents = color
            materials.append(material)
        }

        box.materials = materials

        self.node = SCNNode(geometry: box)
    }
    
    func changeColors(newColors: [UIColor?]) {
        self.colors = newColors
        guard let box = self.node.geometry as? SCNBox else {
            return
        }
      
        for i in 0..<6 {
            box.materials[i].diffuse.contents = newColors[i]
        }
        
    }
}

class ViewController: UIViewController {
    var scnView: SCNView!
    var cubes: [[[Cube?]]] = Array(repeating: Array(repeating: [nil, nil, nil], count: 3), count: 3)
    var initialTouchPoint: CGPoint = .zero

    
    override func viewDidLoad() {
        super.viewDidLoad()

        scnView = SCNView(frame: self.view.frame)
        self.view.addSubview(scnView)
        scnView.scene = SCNScene()
        scnView.allowsCameraControl = true

        setupCamera()
        createRubiksCube()
        
        let rotateButtonFC = UIButton(frame: CGRect(x: 20, y: 50, width: 20, height: 10))
            rotateButtonFC.backgroundColor = .blue
            rotateButtonFC.setTitle("Rotate Front ClockWise", for: .normal)
            rotateButtonFC.addTarget(self, action: #selector(rotateFrontFC), for: .touchUpInside)
            self.view.addSubview(rotateButtonFC)
        
        let rotateButtonFCC = UIButton(frame: CGRect(x: 40, y: 50, width: 20, height: 10))
            rotateButtonFCC.backgroundColor = .green
            rotateButtonFCC.setTitle("Rotate Front CClockWise", for: .normal)
            rotateButtonFCC.addTarget(self, action: #selector(rotateFrontFCC), for: .touchUpInside)
            self.view.addSubview(rotateButtonFCC)
        
        let rotateButtonLC = UIButton(frame: CGRect(x: 60, y: 50, width: 20, height: 10))
            rotateButtonLC.backgroundColor = .yellow
            rotateButtonLC.setTitle("Rotate Front CClockWise", for: .normal)
            rotateButtonLC.addTarget(self, action: #selector(rotateLeftFC), for: .touchUpInside)
            self.view.addSubview(rotateButtonLC)
    }
    
    @objc func rotateFrontFC() {
        rotateFrontClockwise()
    }
    
    @objc func rotateFrontFCC() {
        rotateFrontCounterClockwise()
    }
    
    @objc func rotateLeftFC() {
        rotateLeftClockwise()
    }


    func rotateFrontCounterClockwise() {
        SCNTransaction.begin()
        SCNTransaction.animationDuration = 0.5  // Adjust as needed
        
        var col = cubes[0][0][2]?.colors
        
        cubes[0][0][2]?.changeColors(newColors:cubes[0][2][2]!.colors)
        
        cubes[0][2][2]?.changeColors(newColors:cubes[2][2][2]!.colors)
        
        cubes[2][2][2]?.changeColors(newColors:cubes[2][0][2]!.colors)
        
        cubes[2][0][2]?.changeColors(newColors:col!)
        
        col = cubes[0][1][2]?.colors
        
        cubes[0][1][2]?.changeColors(newColors: cubes[1][2][2]!.colors)
        
        cubes[1][2][2]?.changeColors(newColors: cubes[2][1][2]!.colors)
        
        cubes[2][1][2]?.changeColors(newColors: cubes[1][0][2]!.colors)

        cubes[1][0][2]?.changeColors(newColors: col!)
        
        for i in 0..<3 {
            for j in 0..<3 {
                guard let cube = cubes[i][j][2] else { continue }
                cube.node.runAction(SCNAction.rotateBy(x: 0, y: 0, z: CGFloat.pi/2, duration: 0.5))
            }
        }
        SCNTransaction.commit()
    }
    
    func rotateFrontClockwise() {
        SCNTransaction.begin()
        SCNTransaction.animationDuration = 0.5  // Adjust as needed
        let cubee = cubes[1][1][2]
        let cube1 = cubes[0][0][2]
        let cube2 = cubes[2][2][2]
        cubes[1][1][2] = Cube(position: (cubee?.position.x, cubee?.position.y, cubee?.position.z), colors: [cube1?.colors[0], cube2?.colors[1], cube2?.colors[2], cube1?.colors[3], cube2?.colors[4], cube1?.colors[5]])
        let c = cubes[1][1][2]
        // Rotate each cube in the front face
        for i in 0..<3 {
            for j in 0..<3 {
                guard let cube = cubes[i][j][2] else { continue }
                // Rotate 90 degrees around the z-axis
                cube.node.runAction(SCNAction.rotateBy(x: 0, y: 0, z: -CGFloat.pi/2, duration: 0.5))
                cube.changeColors(newColors: [c?.colors[0],c?.colors[1],c?.colors[2],c?.colors[3],c?.colors[4],c?.colors[5]])
            }
        }
        
        SCNTransaction.commit()
        
    }
    
    
    func rotateLeftClockwise() {
        SCNTransaction.begin()
        SCNTransaction.animationDuration = 0.5  // Adjust as needed
        
        var col = cubes[0][0][2]?.colors
        
        cubes[0][0][2]?.changeColors(newColors:cubes[0][2][2]!.colors)
        
        cubes[0][2][2]?.changeColors(newColors:cubes[0][2][0]!.colors)
        
        cubes[0][2][0]?.changeColors(newColors:cubes[0][0][0]!.colors)
        
        cubes[0][0][0]?.changeColors(newColors:col!)
        
        col = cubes[0][1][2]?.colors
        
        cubes[0][1][2]?.changeColors(newColors: cubes[0][2][1]!.colors)
        
        cubes[0][2][1]?.changeColors(newColors: cubes[0][1][0]!.colors)
        
        cubes[0][1][0]?.changeColors(newColors: cubes[0][0][1]!.colors)

        cubes[0][0][1]?.changeColors(newColors: col!)
        
        for i in 0..<3 {
            for j in 0..<3 {
                guard let cube = cubes[0][i][j] else { continue }
                cube.node.runAction(SCNAction.rotateBy(x: CGFloat.pi/2, y: 0, z: 0, duration: 0.5))
            }
        }
        
        SCNTransaction.commit()
    }

    func rotateLeftCounterClockwise() {
        // ...
    }

    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    

    func setupCamera() {
        let cameraNode = SCNNode()
        cameraNode.camera = SCNCamera()
        cameraNode.position = SCNVector3(x: 1.5, y: 1, z: 12)

        let lightNode = SCNNode()
        lightNode.light = SCNLight()
        lightNode.light?.type = .omni
        lightNode.position = SCNVector3(x: 10, y: 10, z: 10)
        
        let lightNode2 = SCNNode()
        lightNode2.light = SCNLight()
        lightNode2.light?.type = .omni
        lightNode2.position = SCNVector3(x: -10, y: -10, z: -10)

        scnView.scene?.rootNode.addChildNode(cameraNode)
        scnView.scene?.rootNode.addChildNode(lightNode)
        scnView.scene?.rootNode.addChildNode(lightNode2)
    }

    func createRubiksCube() {
        let cubeSpace = CGFloat(1.04) // 2% space between cubes
        let offset = cubeSpace - 1.5  // Centers the Rubik's cube in the scene

        let gray = UIColor.gray  // Color for the hidden faces
        let colors: [UIColor] = [.orange, .green, .red, .blue, .white, .yellow]

        for i in 0..<3 {
            for j in 0..<3 {
                for k in 0..<3 {
                    // Skip the center cube
                    if i == 1 && j == 1 && k == 1 {
                        continue
                    }
                    
                    // Colors for each face of the cube: front, right, back, left, top, bottom
                    let cubeColors: [UIColor] = [
                        k == 2 ? colors[0] : gray,
                        i == 2 ? colors[1] : gray,
                        k == 0 ? colors[2] : gray,
                        i == 0 ? colors[3] : gray,
                        j == 2 ? colors[4] : gray,
                        j == 0 ? colors[5] : gray
                    ]

                    let cube = Cube(position: (x: i, y: j, z: k), colors: cubeColors)
                    cube.node.position = SCNVector3(CGFloat(i) * cubeSpace - offset, CGFloat(j) * cubeSpace - offset, CGFloat(k) * cubeSpace - offset)
                    scnView.scene?.rootNode.addChildNode(cube.node)
                    cubes[i][j][k] = cube
                }
            }
        }
    }
    


}
