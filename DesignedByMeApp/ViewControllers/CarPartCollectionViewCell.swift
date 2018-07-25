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

  override func awakeFromNib() {
    view.layer.shadowColor = UIColor.darkGray.cgColor
    view.layer.shadowOpacity = 0.5
    view.layer.shadowOffset = CGSize.zero
    view.layer.shadowRadius = 3
    view.layer.cornerRadius = view.frame.size.width / 2
  }
  
  var wasSelected : Bool? {
    didSet {
      if wasSelected! {
        view.backgroundColor = UIColor(red: 223.0/255.0, green: 99.0, blue: 46.0/255.0, alpha: 1.0)
        partNameLabel.font = UIFont.boldSystemFont(ofSize: 18.0)
      } else {
        view.backgroundColor = UIColor.white
        partNameLabel.font = UIFont.systemFont(ofSize: 17.0)
      }
    }
  }
  
}
