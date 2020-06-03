//
//  TODOTableViewCell.swift
//  mvc-mvvm
//
//  Created by Ricky on 25/5/20.
//  Copyright © 2020 Ricky. All rights reserved.
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
