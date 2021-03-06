//
//  WeatherCell.swift
//  Le Baluchon
//
//  Copyright © 2019 Guillaume Ramey. All rights reserved.
//

import UIKit

class CityCell: UITableViewCell {

    @IBOutlet weak var cityImage: UIImageView!
    @IBOutlet weak var conditionImage: UIImageView!
    @IBOutlet weak var temperature: UILabel!
    @IBOutlet weak var caption: UILabel!

    func set(city: City) {
        cityImage.image = city.image
        temperature.text = city.temperature
        conditionImage.image = city.conditionImage
        caption.text = city.caption
    }
}
