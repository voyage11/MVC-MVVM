//
//  TODOTableViewCell.swift
//  mvc1
//
//  Created by RandomMac on 25/5/20.
//  Copyright © 2020 RandomMac. All rights reserved.
//

import UIKit

class TodoTableViewCell: UITableViewCell {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!

    var todoCellViewModel: TodoCellViewModel? {
        didSet {
            bindViewModel()
        }
    }
    
    private func bindViewModel() {
        titleLabel.text = todoCellViewModel?.title
        dateLabel.text = todoCellViewModel?.dateString()
        descriptionLabel.text = todoCellViewModel?.description
    }
    
}
