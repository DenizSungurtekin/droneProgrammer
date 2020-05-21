//
//  SimulationView.swift
//  DroneProgrammer
//
//  Created by Mathias Tonini on 03.04.20.
//  Copyright © 2020 CUI. All rights reserved.
//


/*  Lien entre numéro et les commandes
 0: Decollage
 1: Aterrisage
 2: Droite
 3: Gauche
 4: Avancer
 5: Reculer
 6: Monter
 7: Descendre
 */

import Foundation
import SceneKit
import UIKit

class SimulationView: UIViewController ,UIAlertViewDelegate,BebopDroneDelegate, UITableViewDelegate, UITableViewDataSource,DroneDiscovererDelegate{
    
    
    var errorAlertView: UIAlertController?
    var connectionAlertView: UIAlertController?
    
    // Simulation declaration
    var commandes: [Int] = [];
    var obstacles: [Obstacle] = [];
    var objectifs: [Objectif] = [];
    var tmpCmd: [Int] = [];
    var tmpObs: [Obstacle] = [];
    var tmpObj: [Objectif] = [];
    var obstacleVectors: [SCNVector3] = [];
    var objectifVectors: [SCNVector3] = [];
    var sphereListe: [SCNTorus] = [];
    
    @IBOutlet var LaunchDroneBtn: UIButton!
    @IBOutlet var LaunchSimulation: UIButton!
    @IBOutlet var droneSelected: UILabel!
    
    //Drone declaration
    @IBOutlet var tableView: UITableView!
    let cellReuseIdentifier = "cell"
    var stateSem: DispatchSemaphore?
    let chercheur = DroneDiscoverer.init();
    var service: ARService?
    var droneListe:[ARService] = [];
    var bebopDrone: BebopDrone?
    var isDroneSelected = false;
    
    // SceneKit declaration
    @IBOutlet var sceneView: SCNView!
    let sphere = SCNSphere(radius: 0.5);
    var simulationEnded: Bool = false
    var sphereNode = SCNNode(geometry: SCNSphere(radius: 0.5))
    var cubeNode = SCNNode()
    var cameraNode = SCNNode()
    let cubeGeometry = SCNBox(width: 20, height: 20, length: 20, chamferRadius: 0.0)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        LaunchDroneBtn.isHidden = true
        droneSelected.text = "Please select a drone"
        prepare()
        tableView.dataSource = self;
        tableView.delegate = self;
        chercheur.startDiscovering()
        self.tableView.register(UITableViewCell.self, forCellReuseIdentifier: cellReuseIdentifier)
        print("connecting")
    }
    override func viewDidDisappear(_ animated: Bool) {
        //disconnect the device when we leave the view
        super.viewDidDisappear(animated)
        if (connectionAlertView != nil) {
            connectionAlertView?.dismiss(animated: false, completion: nil)
        }
        connectionAlertView = UIAlertController(
            title: service?.name,
            message: "Disconnecting ...",
            preferredStyle: .alert
        )
        connectionAlertView?.show(connectionAlertView!, sender: connectionAlertView!)
        // in background, disconnect from the drone
        DispatchQueue.global(qos: .default).async(execute: {() -> Void in
            self.bebopDrone?.disconnect()
            // wait for the disconnection to appear
            self.stateSem?.wait(timeout: DispatchTime.distantFuture)
            self.bebopDrone = nil
            // dismiss the alert view in main thread
            DispatchQueue.main.async(execute: {() -> Void in
                self.connectionAlertView?.dismiss(animated: true, completion: nil)
            })
        })
    }
    func prepare(){
        // Récupere les variables reçus
        self.commandes = tmpCmd;
        self.obstacles = tmpObs;
        self.objectifs = tmpObj;
        self.view.addSubview(sceneView)
        self.sceneView.autoenablesDefaultLighting = true
        self.sceneView.allowsCameraControl = true
        
        let scene = SCNScene()
        sceneView.scene = scene
        sceneView.backgroundColor = UIColor.white
        
        let camera = SCNCamera()
        
        // Paremetrage camera
        cameraNode.camera = camera
        cameraNode.position = SCNVector3(x: 15, y: 5, z: 30)
        
        if obstacles.count > 0 {        // Met en place les obstacles
            for element in obstacles {
                let sphereTmp = SCNSphere(radius: 0.5)
                sphereTmp.firstMaterial?.diffuse.contents = UIColor.red
                let sphereTmpNode = SCNNode(geometry: sphereTmp)
                sphereTmpNode.position = SCNVector3(x: Float(element.posX), y: Float(element.posY), z: Float(element.posZ))
                obstacleVectors += [sphereTmpNode.position]
                scene.rootNode.addChildNode(sphereTmpNode)
            }
        }
        
        if objectifs.count > 0 {        // Met en place les objectifs
            for element in objectifs {
                let anneauTmp = SCNTorus(ringRadius: 0.5, pipeRadius: 0.1)
                anneauTmp.firstMaterial?.diffuse.contents = UIColor.black
                self.sphereListe.append(anneauTmp);
                let anneauTmpNode = SCNNode(geometry: anneauTmp)
                anneauTmpNode.position = SCNVector3(x: Float(element.posX), y: Float(element.posY), z: Float(element.posZ))
                objectifVectors += [anneauTmpNode.position]
                scene.rootNode.addChildNode(anneauTmpNode)
            }
        }
        // Paramétrage du cube et du drone
        self.cubeNode = SCNNode(geometry: cubeGeometry)
        cubeGeometry.firstMaterial?.diffuse.contents = UIColor.brown
        cubeGeometry.firstMaterial?.transparency = 0.5
        self.sphere.firstMaterial?.diffuse.contents = UIColor.blue
        self.sphereNode = SCNNode(geometry: self.sphere)
        scene.rootNode.addChildNode(self.cameraNode)
        scene.rootNode.addChildNode(self.cubeNode)
        scene.rootNode.addChildNode(self.sphereNode)
        sphereNode.position = SCNVector3(x: 0, y: -10, z: 0)
        
        let constraint = SCNLookAtConstraint(target: cubeNode)
        constraint.isGimbalLockEnabled = true
        self.cameraNode.constraints = [constraint]
        
    }
    // Lancement de la simulation
    @IBAction func simulate(_sender: Any){
        
        
        sphereNode.position = SCNVector3(x: 0, y: -10, z: 0)
        var counter = self.objectifs.count;
        
        //Definition de nos mouvements possibles
        let decollage = SCNAction.moveBy(x: 0, y: 1, z: 0, duration: 1);
        let monter = SCNAction.moveBy(x: 0, y: 1, z: 0, duration: 1);
        let descendre = SCNAction.moveBy(x: 0, y: -1, z: 0, duration: 1);
        let droite = SCNAction.moveBy(x: 1, y: 0, z: 0, duration: 1);
        let gauche = SCNAction.moveBy(x: -1, y: 0, z: 0, duration: 1);
        let avancer = SCNAction.moveBy(x: 0, y: 0, z: -1, duration: 1);
        let reculer = SCNAction.moveBy(x: 0, y: 0, z: 1, duration: 1);
        
        // Position initial
        var position = sphereNode.position;
        var monterDescendre: Int = 0;    // Compte le deplacement verticale pour connaitre la position d'atterrisage à la fin de la sequence car impossible de récuperer la valeur sur "y" de la sphère après l'éxecution de la séquence de déplacement. (la méthode run action bouge la sphère mais ne met pas à jour la position)
        
        var gaucheDroit: Int = 0;   // Permet de connaître la position finale en x
        var avancerReculer: Int = 0;// Permet de connâitre la position finale en z
        
        
        var sequences: [SCNAction] = [];
        var flagToBreakObstacle: Bool = false
        var flagPosition: Bool = false
        print("Position before sequenceies loop: ",position)
        
        // Remplit notre séquence selon les commandes reçus et compte les déplacements sur x/y/z
        getSequencies: for element in commandes {
            switch element{
            case 0:
                sequences.append(decollage)
                monterDescendre += 1
                position.y = position.y + 1;
            case 1:
                let atterisage = SCNAction.moveBy(x: 0, y: -CGFloat(monterDescendre), z: 0, duration: 1)
                while position.y != -10 {
                    sequences.append(descendre)
                    position.y -= 1;
                    for obsVec in self.obstacleVectors{
                        if SCNVector3EqualToVector3(obsVec, position){
                            print("Touch an Obstacle")
                            flagToBreakObstacle = true
                        }
                    }
                    for (ind,obj) in self.objectifVectors.enumerated(){
                        if SCNVector3EqualToVector3(obj, position)
                        {
                            let currentObj = self.sphereListe[ind];
                            currentObj.firstMaterial?.diffuse.contents = UIColor.green;
                            counter -= 1;
                        }
                    }
                }
                
            case 2:
                sequences.append(droite)
                gaucheDroit += 1
                position.x = position.x + 1
            case 3:
                sequences.append(gauche)
                gaucheDroit -= 1
                position.x = position.x - 1
            case 4:
                sequences.append(avancer)
                avancerReculer -= 1
                position.z = position.z - 1
            case 5:
                sequences.append(reculer)
                avancerReculer += 1
                position.z = position.z + 1
                
            case 6:
                sequences.append(monter)
                monterDescendre += 1
                position.y = position.y + 1
            case 7:
                sequences.append(descendre)
                monterDescendre -= 1
                position.y = position.y - 1
                
            default:
                print("La liste de commande est vide")
            }
            for obsVec in self.obstacleVectors{
                if SCNVector3EqualToVector3(obsVec, position){
                    print("Touch an Obstacle")
                    flagToBreakObstacle = true
                }
            }
            for (ind,obj) in self.objectifVectors.enumerated(){
                if SCNVector3EqualToVector3(obj, position)
                {
                    let currentObj = self.sphereListe[ind];
                    currentObj.firstMaterial?.diffuse.contents = UIColor.green;
                    counter -= 1;
                }
            }
            if position.x < -10 || position.x > 10 || position.y < -10 || position.y > 10 || position.z < -10 || position.z > 10 {
                flagPosition = true
                
                
            }
            if flagToBreakObstacle || flagPosition{
                break getSequencies;
            }
        }
        // Collision avec un obstacle
        let moveSequence = SCNAction.sequence(sequences)
        self.sphereNode.runAction(moveSequence) {
            
            if flagToBreakObstacle{
                DispatchQueue.main.async {
                    self.errorAlertView = UIAlertController(
                        title: " !!!!!!!!! CRASH !!!!!!!!!",
                        message: "L'analyse du plan de vol nous indique le drone c'est crashé avec un obstacle",
                        preferredStyle: .alert)
                    self.errorAlertView?.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                    self.present(self.errorAlertView!, animated: true, completion: nil)
                }
                
                // Sortie de la zone
            }else if flagPosition {
                DispatchQueue.main.async {
                    self.errorAlertView = UIAlertController(
                        title: "Le drone est sorti de la zone de simulation",
                        message: "Veuillez entrer une liste de commande adéquate",
                        preferredStyle: .alert)
                    self.errorAlertView?.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                    self.present(self.errorAlertView!, animated: true, completion: nil)
                    
                }
                
            }
            else{
                
                // Toute les conditions sont satisfaites
                DispatchQueue.main.async {
                    if counter == 0{
                        self.errorAlertView = UIAlertController(
                            title: "La simulation s'est bien déroulé",
                            message: "Vous pouvez donc désormais lancer le trajet sur le drone",
                            preferredStyle: .alert)
                        self.errorAlertView?.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                        self.present(self.errorAlertView!, animated: true, completion: nil)
                        self.LaunchDroneBtn.isHidden = false
                    
                    // Objectifs non touchés
                    }else{
                        self.errorAlertView = UIAlertController(
                            title: "Tous les objectifs n'ont pas été touché",
                            message: "Essayer de toucher tous les objectifs la prochaine fois",
                            preferredStyle: .alert)
                        self.errorAlertView?.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                        self.present(self.errorAlertView!, animated: true, completion: nil)
                    }
                    
                    
                }
                
                
            }
            
        }
        
    }
    // Lancement du drone - A tester lorsque le drone sera réparé
    @IBAction func launchDrone(_sender: Any){
        if isDroneSelected{
            var tempsExec = 0.0
            var indexExec = 0
            for instruction in self.commandes{
                switch (instruction) {
                case 0:
                    // takeOff()
                    
                    DispatchQueue.main.asyncAfter(deadline: .now() + tempsExec + 3.0, execute: {
                        NSLog("takeOff")
                        self.bebopDrone?.takeOff()
                    })
                    // FIXME: time of the execution
                    tempsExec = tempsExec + 4.0 /*tabLengthCmd[indexExec]*/
                    
                    break
                    
                case 1:
                    // land()
                    
                    DispatchQueue.main.asyncAfter(deadline: .now() + 2.0 + tempsExec + 3.0, execute: {
                        // FIXME: time of the execution
                        NSLog("land")
                        self.bebopDrone?.land()
                    })
                    tempsExec = tempsExec + 5.0/*tabLengthCmd[indexExec]*/
                    break
                case 2:
                    // rollRightTouchDown()
                    
                    DispatchQueue.main.asyncAfter(deadline: .now() + 2.0 + tempsExec, execute: {
                        NSLog("begin right")
                        self.bebopDrone?.setFlag(1)
                        self.bebopDrone?.setRoll(50)
                    })
                    DispatchQueue.main.asyncAfter(deadline: .now()  + 2.0 + tempsExec + 3.0, execute: {
                        // rollRightTouchUp()
                        self.bebopDrone?.setFlag(0)
                        self.bebopDrone?.setRoll(0)
                        NSLog("end right")
                    })
                    tempsExec = tempsExec + 3 + 3
                    indexExec += 1
                    
                    break
                case 3:
                    // rollLeftTouchDown()
                    
                    DispatchQueue.main.asyncAfter(deadline: .now() + 2.0 + tempsExec, execute: {
                        NSLog("begin left")
                        self.bebopDrone?.setFlag(1)
                        self.bebopDrone?.setRoll(-50)
                    })
                    
                    DispatchQueue.main.asyncAfter(deadline: .now() + 2.0 + tempsExec + 3.0, execute: {
                        // rollLeftTouchUp()
                        self.bebopDrone?.setFlag(0)
                        self.bebopDrone?.setRoll(0)
                        NSLog("end left")
                    })
                    tempsExec = tempsExec + 3.0 + 3
                    indexExec += 1
                    
                    break
                case 4:
                    // pitchForwardTouchDown()
                    
                    DispatchQueue.main.asyncAfter(deadline: .now() + 2.0 + tempsExec, execute: {
                        NSLog("begin front")
                        self.bebopDrone?.setFlag(1)
                        self.bebopDrone?.setPitch(50)
                    })
                    DispatchQueue.main.asyncAfter(deadline: .now() + 2.0 + tempsExec + 3.0, execute: {
                        // pitchForwardTouchUp()
                        self.bebopDrone?.setFlag(0)
                        self.bebopDrone?.setPitch(0)
                        NSLog("end front")
                    })
                    tempsExec = tempsExec + 3.0 + 3
                    indexExec += 1
                    
                    break
                case 5:
                    // pitchBackTouchDown()
                    
                    DispatchQueue.main.asyncAfter(deadline: .now() + 2.0 + tempsExec, execute: {
                        NSLog("begin back")
                        self.bebopDrone?.setFlag(1)
                        self.bebopDrone?.setPitch(-50)
                    })
                    
                    DispatchQueue.main.asyncAfter(deadline: .now() + 2.0 + tempsExec + 3.0, execute: {
                        // pitchBackTouchUp()
                        self.bebopDrone?.setFlag(0)
                        self.bebopDrone?.setPitch(0)
                        NSLog("end back")
                    })
                    tempsExec = tempsExec + 3 + 4
                    indexExec += 1
                    
                    break
                case 6:
                    // gazUpTouchDown()
                    
                    DispatchQueue.main.asyncAfter(deadline: .now() + 2.0 + tempsExec, execute: {
                        NSLog("begin up")
                        self.bebopDrone?.setGaz(50)
                    })
                    DispatchQueue.main.asyncAfter(deadline: .now() + 2.0 + tempsExec + 3.0, execute: {
                        // gazUpTouchUp()
                        self.bebopDrone?.setGaz(0)
                        NSLog("end up")
                    })
                    tempsExec = tempsExec + 3 + 3
                    indexExec += 1
                    
                    break
                case 7:
                    // gazDownTouchDown()
                    
                    DispatchQueue.main.asyncAfter(deadline: .now() + 2.0 + tempsExec, execute: {
                        NSLog("begin down")
                        self.bebopDrone?.setGaz(-50)
                    })
                    
                    DispatchQueue.main.asyncAfter(deadline: .now() + 2.0 + tempsExec + 3.0, execute: {
                        // gazDownTouchUp()
                        self.bebopDrone?.setGaz(0)
                        NSLog("end down")
                    })
                    
                    indexExec += 1
                    
                    break
                default:
                    break
                }
            }
        }else{
            self.errorAlertView = UIAlertController(
                title: "Aucun drone selectionné",
                message: "Veuillez selectionner un drone s'il vous plaît",
                preferredStyle: .alert)
            self.errorAlertView?.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(self.errorAlertView!, animated: true, completion: nil)
            
        }
    }
    
    func droneDiscoverer(_ droneDiscoverer: DroneDiscoverer!, didUpdateDronesList dronesList: [Any]!) {
        self.droneListe = dronesList as! [ARService]
        self.tableView.beginUpdates()
        self.tableView.insertRows(at: [IndexPath(row: self.droneListe.count-1, section: 0)], with: .automatic)
        self.tableView.endUpdates()
    }
    
    //TableViews function ///
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath){
        //Selection of a drone
        if self.droneListe.count != 0{
            self.service = droneListe[indexPath.row];
            chercheur.stopDiscovering()
            self.bebopDrone = BebopDrone(service: self.service)
            self.bebopDrone?.delegate = self
            self.bebopDrone?.connect()
            self.droneSelected.text = self.service?.name
            self.isDroneSelected = true
        }
    }
    // TableView pour la connection au drone
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell:UITableViewCell = (self.tableView.dequeueReusableCell(withIdentifier: cellReuseIdentifier) as? UITableViewCell)!
        
        if droneListe.count != 0 {
            cell.textLabel?.text = self.droneListe[indexPath.row].name
        }else{
            cell.textLabel?.text = "Looking for drones..."
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? { return "Liste des drones" }
    
    
    
    //Drone bullshit functions
    func bebopDrone(_ bebopDrone: BebopDrone!, connectionDidChange state: eARCONTROLLER_DEVICE_STATE) {
        print("La connection a changé")
    }
    func bebopDrone(_ bebopDrone: BebopDrone!, batteryDidChange batteryPercentage: Int32) {
        
    }
    func bebopDrone(_ bebopDrone: BebopDrone!, flyingStateDidChange state: eARCOMMANDS_ARDRONE3_PILOTINGSTATE_FLYINGSTATECHANGED_STATE) {}
    func bebopDrone(_ bebopDrone: BebopDrone!, configureDecoder codec: ARCONTROLLER_Stream_Codec_t) -> Bool {
        return true
    }
    func bebopDrone(_ bebopDrone: BebopDrone!, didReceive frame: UnsafeMutablePointer<ARCONTROLLER_Frame_t>!) -> Bool {
        return true
    }
    func bebopDrone(_ bebopDrone: BebopDrone!, didFoundMatchingMedias nbMedias: UInt) {}
    func bebopDrone(_ bebopDrone: BebopDrone!, media mediaName: String!, downloadDidProgress progress: Int32){}
    func bebopDrone(_ bebopDrone: BebopDrone!, mediaDownloadDidFinish mediaName: String!) {}
    
    
    
}
