//
//  ViewController.swift
//  ACV
//
//  Created by Sanjay Khan on 10/8/20.
//

import UIKit
import ARKit
import SceneKit

enum RulerScreenState {
    case reset
    case measuring
    case measuringEnd
}

class ViewController: UIViewController {
    
    // MARK: - Properties
    
    @IBOutlet var sceneView: ARSCNView!
    @IBOutlet var crosshairLabel: UILabel!
    @IBOutlet var plusButton: UIButton!
    @IBOutlet var clearButton: UIButton!
    
    var сalibrationAlert: UIAlertController!
    
    let vectorZero = SCNVector3()
    let ruler = Ruler(shapeColor: .white, textColor: .black)
    
    var screeState: RulerScreenState = .reset
    var points: (start: SCNVector3, end: SCNVector3) = (start: SCNVector3(), end: SCNVector3())
    
    // MARK: - Life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupScene()
        setupButtons()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        UIApplication.shared.isIdleTimerDisabled = true
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        setupCalibrationAlert()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        sceneView?.session.pause()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
    }
    
    // MARK: - Setup
    
    func setupScene() {
        sceneView.delegate = self
        sceneView.session = ARSession()
        //sceneView.showsStatistics = true
        sceneView.session.run(ARWorldTrackingConfiguration(), options: [.resetTracking, .removeExistingAnchors])
    }
    
    func setupCalibrationAlert() {
        сalibrationAlert = UIAlertController(title: "ACV Calibration",
                                              message: "IN-PROGRESS",
                                              preferredStyle: .alert)
        present(сalibrationAlert, animated: true, completion: nil)
    }
    
    func setupButtons() {
        let cornerRadius: CGFloat = 30
        plusButton.layer.cornerRadius = cornerRadius
        clearButton.layer.cornerRadius = cornerRadius
        
        setState(.reset)
    }
    
    // MARK: - Scene actions
    
    func resetValues() {
        ruler.removeNode()
        points.start = SCNVector3()
        points.end = SCNVector3()
    }
    
    // MARK: - UI Actions
    
    @IBAction func plusButtonTapped(_ sender: Any) {
        if points.start == vectorZero {
            setState(.measuring)
        } else {
            setState(.measuringEnd)
        }
    }
    
    @IBAction func clearButtonTapped(_ sender: Any) {
        setState(.reset)
    }
    
    // MARK: - Common
    
    func setState(_ newState: RulerScreenState) {
        switch newState {
        case .reset:
            resetValues()
            plusButton.isHidden = false
            clearButton.isHidden = true
        case .measuring:
            break
        case .measuringEnd:
            plusButton.isHidden = true
            clearButton.isHidden = false
        }
        screeState = newState
    }
}

// MARK: - ARSCNViewDelegate & Render

extension ViewController: ARSCNViewDelegate {
    func renderer(_: SCNSceneRenderer, updateAtTime _: TimeInterval) {
        DispatchQueue.main.async { [weak self] in
            self?.detectObjects()
        }
    }
    
    func detectObjects() {
        if let worldPos = sceneView?.realWorldVector(screenPos: view.center) {
            сalibrationAlert.dismiss(animated: true, completion: nil)
            if let sceneView = sceneView, let currentCameraPosition = sceneView.pointOfView {
                if screeState == .measuring {
                    if points.start == vectorZero {
                        points.start = worldPos
                    }
                    
                    points.end = worldPos
                    ruler.draw(startPoint: points.start, endPoint: points.end, sceneView: sceneView, fromPointOfView: currentCameraPosition)
                } else if screeState == .measuringEnd {
                    ruler.draw(startPoint: points.start, endPoint: points.end, sceneView: sceneView, fromPointOfView: currentCameraPosition)
                }
            }
        }
    }
}
