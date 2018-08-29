//
//  StockCell.swift
//  MyStocks
//
//  Created by Matthew  Levis on 6/28/18.
//  Copyright © 2018 Matthew  Levis. All rights reserved.
//
//  Class for StockCell, custom UITableViewCell


import UIKit

class StockCell: UITableViewCell {
    
    @IBOutlet var symbolLabel: UILabel!
    @IBOutlet var priceLabel: UILabel!
    @IBOutlet var companyNameLabel: UILabel!
    @IBOutlet var percentChangeLabel: UILabel!
    @IBOutlet var spinner: UIActivityIndicatorView!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        update(with: nil)
    }
    
    
    // Update function for StockCell that animates a spinner until the stock is queried
    func update(with stock: Stock?) {
        if let stockToDisplay = stock {
            spinner.stopAnimating()
            symbolLabel.text = stockToDisplay.symbol
            priceLabel.text = "\(stockToDisplay.sharePrice!)"
        } else {
            spinner.startAnimating()
            symbolLabel.text = nil
            priceLabel.text = nil
            companyNameLabel.text = nil
            percentChangeLabel.text = nil
        }
    }
}
