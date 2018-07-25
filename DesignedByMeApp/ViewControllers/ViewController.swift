//
//  ViewController.swift
//  DesignedByMeApp
//
//  Created by Gabriel Borri de Azevedo on 7/23/18.
//  Copyright © 2018 Citroen. All rights reserved.
//

import UIKit
import SceneKit
import SceneKit.ModelIO

class ViewController: UIViewController {

  @IBOutlet weak var colorView: UIView!
  @IBOutlet weak var sceneView: SCNView!
  var scene = SCNScene()
  var node = SCNNode()
  var car = MDLMesh()
  var carGeometry: SCNGeometry?
  var currentAngleY: Float = 0.0
  let colorsArray = ["blue", "green", "yellow", "red"]
  let carPartsArray = ["Portas", "Capo", "Teto", "Interior", "Rodas"]
  var currentCarPartCellSelected = IndexPath(item: 0, section: 0)

  @IBOutlet weak var colorCollectionView: UICollectionView!
  @IBOutlet weak var carPartsCollectionView: UICollectionView!
  @IBOutlet weak var carPartsView: UIView!

  override func viewDidLoad() {
    super.viewDidLoad()

    let colorNib = UINib(nibName: "ColorCollectionViewCell", bundle: nil)
    colorCollectionView.register(colorNib, forCellWithReuseIdentifier: "colorCell")

    let carPartNib = UINib(nibName: "CarPartCollectionViewCell", bundle: nil)
    carPartsCollectionView.register(carPartNib, forCellWithReuseIdentifier: "carPartCell")

    colorView.layer.shadowColor = UIColor.darkGray.cgColor
    colorView.layer.shadowOpacity = 0.5
    colorView.layer.shadowOffset = CGSize.zero
    colorView.layer.shadowRadius = 3

    carPartsCollectionView.backgroundColor = UIColor(red: 246.0/255.0, green: 247.0/255.0, blue: 248.0/255.0, alpha: 1.0)

    initializeSCNScene()
  }

  private func initializeSCNScene() {

    guard let url = Bundle.main.url(forResource: "BMW X5 4", withExtension: "obj") else {
      fatalError("Failed to find model file.")
    }

    let asset = MDLAsset(url: url)
    car = asset.object(at: 0) as! MDLMesh

    carGeometry = SCNGeometry(mdlMesh: car)
    let material = SCNMaterial()
    material.diffuse.contents = UIImage(named: "red.jpg")
    carGeometry!.materials = [material]

    node = SCNNode(geometry: carGeometry)
    scene.rootNode.addChildNode(node)

    sceneView.scene = scene
    sceneView.backgroundColor = UIColor.white
    sceneView.autoenablesDefaultLighting = true
  }

  @IBAction func didPan(gestureRecognize: UIPanGestureRecognizer) {

    let translation = gestureRecognize.translation(in: gestureRecognize.view!)
    var newAngleY = (Float)(translation.x)*(Float)(Double.pi)/180.0
    newAngleY += currentAngleY

    node.eulerAngles.y = newAngleY

    if(gestureRecognize.state == .ended) {
      currentAngleY = newAngleY
    }
  }
}

extension ViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout  {
  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    if collectionView.tag == 1 {
      return colorsArray.count
    } else {
      return carPartsArray.count
    }
  }

  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    if collectionView.tag == 1 {
      let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "colorCell", for: indexPath) as! ColorCollectionViewCell
      cell.colorNameLabel.text = colorsArray[indexPath.row]
      var backgroundColor: UIColor?
      switch colorsArray[indexPath.row] {
      case "yellow":
        backgroundColor = UIColor(red: 245.0/255.0, green: 167.0/255.0, blue: 35.0/255.0, alpha: 1.0)
      case "red":
        backgroundColor = UIColor(red: 254.0/255.0, green: 0.0/255.0, blue: 0.0/255.0, alpha: 1.0)
      case "blue":
        backgroundColor = UIColor(red: 73.0/255.0, green: 144.0/255.0, blue: 266.0/255.0, alpha: 1.0)
      case "green":
        backgroundColor = UIColor(red: 126.0/255.0, green: 211.0/255.0, blue: 32.0/255.0, alpha: 1.0)
      default:
        backgroundColor = UIColor.gray
      }
      cell.circleView.backgroundColor = backgroundColor
      cell.circleView.layer.cornerRadius = cell.frame.size.width / 2
      cell.circleView.clipsToBounds = true
      return cell
    } else {
      let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "carPartCell", for: indexPath) as! CarPartCollectionViewCell
      let carPartName = carPartsArray[indexPath.row]
      if let image = UIImage(named: carPartName) {
        cell.iconImageView.image = image
      }
      if indexPath == currentCarPartCellSelected {
        cell.wasSelected = true
      }
      cell.partNameLabel.text = carPartName
      return cell
    }
  }

  func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    if collectionView.tag == 1 {
      let selectedColor = colorsArray[indexPath.row]
      let material = SCNMaterial()
      material.diffuse.contents = UIImage(named: "\(selectedColor).jpg")
      if let car = carGeometry {
        car.materials = [material]
      }
    } else {
      let selectedCell = collectionView.cellForItem(at: indexPath) as! CarPartCollectionViewCell
      selectedCell.wasSelected = true
      let previousCell = collectionView.cellForItem(at: currentCarPartCellSelected) as! CarPartCollectionViewCell
      previousCell.wasSelected = false
      currentCarPartCellSelected = indexPath
    }
  }

  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
    if collectionView.tag == 0 {
      return CGSize(width: (CGFloat((Float(collectionView.frame.size.width) / Float(carPartsArray.count))) - 10), height: collectionView.frame.size.height)
    } else {
      return CGSize(width: 100.0, height: 130.0)
    }
  }
}

extension MDLMaterial {
  func setTextureProperties(textures: [MDLMaterialSemantic:String]) -> Void {
    for (key,value) in textures {
      guard let url = Bundle.main.url(forResource: value, withExtension: "jpg") else {
        fatalError("Failed to find URL for resource \(value).")
      }
      let property = MDLMaterialProperty(name:value, semantic: key, url: url)
      self.setProperty(property)
    }
  }
}



