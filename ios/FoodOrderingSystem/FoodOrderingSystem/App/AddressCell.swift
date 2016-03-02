//
//  AddressCell.swift
//  FoodOrderingSystem
//
//  Created by MoonSlides on 16/3/1.
//  Copyright © 2016年 李龑. All rights reserved.
//

import UIKit

class AddressCell: UITableViewCell {

    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var address: UILabel!
    @IBOutlet weak var phone: UILabel!
    @IBOutlet weak var defaultImage: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
