//
//  WeatherCell.swift
//  Le Baluchon
//
//  Created by Guillaume Ramey on 02/01/2019.
//  Copyright © 2019 Guillaume Ramey. All rights reserved.
//

import UIKit

class CityCell: UITableViewCell {

    @IBOutlet weak var background: UIImageView!
    @IBOutlet weak var conditionImage: UIImageView!
    @IBOutlet weak var temperature: UILabel!
    @IBOutlet weak var cityDescription: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
}
