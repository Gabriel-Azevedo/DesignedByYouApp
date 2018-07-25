//
//  CarPartCollectionViewCell.swift
//  DesignedByMeApp
//
//  Created by Gabriel Borri de Azevedo on 7/24/18.
//  Copyright © 2018 Citroen. All rights reserved.
//

import Foundation
import UIKit

class CarPartCollectionViewCell: UICollectionViewCell {

  @IBOutlet weak var iconImageView: UIImageView!

  @IBOutlet weak var partNameLabel: UILabel!

  @IBOutlet weak var view: UIView!
  var wasSelected : Bool? {
    didSet {
      if wasSelected! {
        view.layer.borderColor = UIColor.black.cgColor
        view.layer.borderWidth = 2.0
      } else {
        view.layer.borderColor = UIColor.clear.cgColor
      }
    }
  }
}
