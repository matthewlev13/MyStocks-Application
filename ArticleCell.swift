//
//  ArticleCell.swift
//  MyStocks
//
//  Created by Matthew  Levis on 7/15/18.
//  Copyright © 2018 Matthew  Levis. All rights reserved.
//
//  Class for ArticleCell or type UITableViewCell

import UIKit

class ArticleCell: UITableViewCell {
    
    @IBOutlet var title: UILabel!
    @IBOutlet var source: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
}
