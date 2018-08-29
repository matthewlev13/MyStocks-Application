//
//  ScrollViewController.swift
//  MyStocks
//
//  Created by Matthew  Levis on 7/15/18.
//  Copyright © 2018 Matthew  Levis. All rights reserved.
//
//  UIViewController for the detail view of a given stock, inherits from the UIScrollViewDelegate, UITableViewDelegate, and the UITableViewDataSource


import UIKit
import Foundation

class ScrollViewController: UIViewController, UIScrollViewDelegate, UITableViewDelegate, UITableViewDataSource {
    
    var stock: Stock!                         // reference to stock that appeared before in the navigation controller
    @IBOutlet var scrollView: UIScrollView!
    @IBOutlet var newsTableView: UITableView!
    @IBOutlet var companyNameLabel: UILabel!
    @IBOutlet var stockLabel: UILabel!
    @IBOutlet var openPriceLabel: UILabel!
    @IBOutlet var closePriceLabel: UILabel!
    @IBOutlet var highPriceLabel: UILabel!
    @IBOutlet var lowPriceLabel: UILabel!
    @IBOutlet var peRatioLabel: UILabel!
    @IBOutlet var week52HighLabel: UILabel!
    @IBOutlet var week52LowLabel: UILabel!
    @IBOutlet var ytdChangeLabel: UILabel!
    

    // Assign the delegates and labels
    override func viewDidLoad() {
        super.viewDidLoad()
        scrollView.delegate = self
        scrollView.bounces = false
        navigationItem.title = "\(stock.symbol!)  $\(stock.sharePrice!)"
        stockLabel.text = stock.symbol
        companyNameLabel.text = stock.companyName
        openPriceLabel.text = "\(stock.openPrice!)"
        closePriceLabel.text = "\(stock.closePrice!)"
        highPriceLabel.text = "\(stock.highPrice!)"
        lowPriceLabel.text = "\(stock.lowPrice!)"
        peRatioLabel.text = "\(stock.peRatio!)"
        week52HighLabel.text = "\(stock.week52High!)"
        week52LowLabel.text = "\(stock.week52Low!)"
        ytdChangeLabel.text = "\(stock.ytdChange!)"
        newsTableView.rowHeight = 130
    }
    
    
    // MARK: Table view
    // Tells the data source to return the number of rows in a given section of a table view
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return stock.articles?.count ?? 0
    }
    
    
    // MARK: table view
    // Delegate is called when asked for a cell to insert at a particular location of table view
    // returns a cell with the news headline and source
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //let cell = tableView.dequeueReusableCell(withIdentifier: "articleCell", for: indexPath) as! ArticleCell
        let cell: ArticleCell = tableView.dequeueReusableCell(withIdentifier: "articleCell", for: indexPath) as! ArticleCell
        cell.title.text = stock.articles![indexPath.row].headline
        cell.source.text = stock.articles![indexPath.row].source
        return cell
    }
    
    
    // MARK: Segue
    // Segue to the NewsWebViewController that passes along reference to the article that was tapped
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // If the triggered segue is the "showNews" segue
        switch segue.identifier {
        case "showNews"?:
            // Figure out what row was tapped
            if let row = newsTableView.indexPathForSelectedRow?.row {
                // Get the news associated with this row and pass it along
                let article = stock.articles![row]
                let newsWebViewController = segue.destination as! NewsWebViewController
                newsWebViewController.article = article
            }
        default:
            preconditionFailure("Unexpected segue identifier")
        }
    }
}
