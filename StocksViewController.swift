//
//  StocksViewController.swift
//  MyStocks
//
//  Created by Matthew  Levis on 6/24/18.
//  Copyright © 2018 Matthew  Levis. All rights reserved.
//
//  UITableViewController for the watchlist of stocks inputed by the user


import UIKit


class StocksViewController: UITableViewController {

    var stocks: [Stock]? = []                              // var for the users stocks in the watchlist
    var refresher: UIRefreshControl = UIRefreshControl()   // refresher for updating stock data
    var lastContentOffSet: CGFloat = 0                     // content offset for updating navigation controller header
    
    
    // Modify the navigation controller header and add the refresh controller
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "Watchlist"
        navigationController?.navigationBar.tintColor = UIColor.blue
        navigationController?.navigationBar.prefersLargeTitles = true
        tableView.refreshControl = refresher
        refresher.addTarget(self, action: #selector(StocksViewController.update), for: UIControlEvents.valueChanged)
        self.tableView.rowHeight = 90
    }
    
    
    // MARK: Scroll view
    // Delegate is called when the scrollView will start scrolling
    override func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        self.lastContentOffSet = scrollView.contentOffset.y
    }
    
    
    // MARK: Scroll view
    // Delegate is called when scrollView scrolled, updates navigation controller title
    override func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if (self.lastContentOffSet < scrollView.contentOffset.y) {
            navigationItem.title = "portfolio gains"
        } else {
            navigationItem.title = "Watchlist"
        }
    }
    
    
    // MARK: Table view
    // Delegate is called when asked for a cell to insert at a particular location of table view
    // returns a cell with the stock symbol, company name, price, and percent change
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "StockCell", for: indexPath) as! StockCell
        if let stock = stocks?[indexPath.row] {
            cell.symbolLabel.text = stock.symbol?.uppercased()
            if let sharePrice = stock.sharePrice {
                cell.priceLabel.text = "$\(sharePrice)"
                cell.percentChangeLabel.text = "\(stock.change!)"
                cell.companyNameLabel.text = "\(stock.companyName!)"
                if stock.change! < 0 {
                    cell.percentChangeLabel.textColor = .red
                } else {
                    cell.percentChangeLabel.text = "+\(stock.change!)"
                    cell.percentChangeLabel.textColor = .green
                }
            }
            return cell
        } else {
            cell.update(with: nil)
            return cell
        }
    }
    
    
    // MARK: Table view
    // Tells the delegate the table view is about to draw a cell for a particular row
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        let stock = stocks![indexPath.row]
        if let cell = self.tableView.cellForRow(at: indexPath) as? StockCell {
            cell.update(with: stock)
        }
    }
    
    
    // MARK: Table view
    // Tells the data source to return the number of rows in a given section of a table view
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.stocks?.count ?? 0
    }
    
    
    // MARK: Table view
    // Tells the data source the table view is editable
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    
    // MARK: Table view
    // Asks the data source to commit the insertion or deletion of a specified row in the receiver
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == UITableViewCellEditingStyle.delete {
            let stock = stocks![indexPath.row]
            if let index = stocks!.index(of: stock) {
                stocks!.remove(at: index)
                tableView.beginUpdates()                                 // update a particular cell, allow deletion
                tableView.deleteRows(at: [indexPath], with: .automatic)
                tableView.endUpdates()                                   // end updates on a particular cell, after deleted
            }
        }
    }
    
    
    // MARK: Table view
    // Tells the data source to move a row at a specific location in the table view to another location
    override func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        moveStock(from: sourceIndexPath.row, to: destinationIndexPath.row)
    }
    
    
    // MARK: Stock action
    // Action button that allows a user to type in the ticker symbol of a stock to put on the table view watchlist
    // takes in the sender of a UIBarButtonItem as a parameter
    @IBAction func addStockToMyList(_ sender: UIBarButtonItem) {
        // Create a new stock, have user search for stocks and add it
        let alertController = UIAlertController(title: "Add Stock", message: nil, preferredStyle: .alert)
        alertController.addTextField {
            (textField) -> Void in
            textField.placeholder = "ticker symbol"
            textField.autocapitalizationType = .words
        }
        let okAction = UIAlertAction(title: "OK", style: .default) {
            (action) -> Void in
            
            if let tickerSymbol = alertController.textFields?.first?.text {
                let stock = Stock()
                stock.symbol = tickerSymbol
                let stockAlreadyInListAlertController = UIAlertController(title: "Error", message: "This stock is already in your list", preferredStyle: .alert)                                                        // error alert controller is stock is already in list
                let okAction = UIAlertAction(title: "OK", style: .default, handler: { (action) in
                    stockAlreadyInListAlertController.dismiss(animated: true, completion: nil)
                    self.present(alertController, animated: true)
                    self.update()
                })
                stockAlreadyInListAlertController.addAction(okAction)
                self.parseJSON(stock: stock, type: "quote")     // parse the json of the quote url request
                self.parseJSON(stock: stock, type: "news")      // parse the json of the news url request
                self.stocks?.append(stock)
                for stockInList in self.stocks! {
                    if stockInList.symbol == stock.symbol?.uppercased() {
                        self.present(stockAlreadyInListAlertController, animated: true)
                        self.stocks?.removeLast()
                    }
                }
                if let index = self.stocks?.index(of: stock) {
                    let indexPath = IndexPath(row: index, section: 0)
                    
                    // Insert this new row into the table
                    self.tableView.insertRows(at: [indexPath], with: .automatic)
                }
            }
        }
        alertController.addAction(okAction)
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alertController.addAction(cancelAction)
        present(alertController, animated: true, completion: nil)
    }

    
    // MARK: Segue
    // Segue to the ScrollViewController that passes along reference to stock inside the array of stocks that was tapped
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch segue.identifier {
        case "showStock"?:
            // Figure out which row was just tapped
            if let row = tableView.indexPathForSelectedRow?.row {
                // Get the stock associated with this row and pass it along
                let stock = stocks![row]
                let scrollViewController = segue.destination as! ScrollViewController
                scrollViewController.stock = stock
            }
        default:
            preconditionFailure("Unexpected segue identifier.")
        }
    }
    
    
    // MARK: Stock action
    // Parse the JSON of web request and set properties of the stock, takes in the stock object and its type of request (optional string) as parameters
    func parseJSON(stock: Stock, type: String?) {
        let urlRequest = IexAPI.iexURL(symbol: stock.symbol, type: type)
        let task = URLSession.shared.dataTask(with: urlRequest) { (data, response, error) in
            
            guard error == nil else {
                print(error as Any)
                return
                
            }
            
            guard let content = data else {
                print("not returning data")
                return
            }
    
            switch type {
            case "quote":
                
                guard let json = (try? JSONSerialization.jsonObject(with: content, options: JSONSerialization.ReadingOptions.mutableContainers)) as? [String: Any] else {
                    print("Not containing JSON")
                    
                    let errorAlertController = UIAlertController(title: "Error", message: "Please enter a valid ticker symbol", preferredStyle: .alert)
                    
                    let okAction = UIAlertAction(title: "OK", style: .default, handler: { (action) in
                        errorAlertController.dismiss(animated: true, completion: nil)
                        self.update()
                    })
                    errorAlertController.addAction(okAction)
                    self.present(errorAlertController, animated: true, completion: nil)
                    self.stocks?.removeLast()
                    return
                }
                if let change = json["change"] as? Double,
                    let ytdChange = json["ytdChange"] as? Double,
                    let companyName = json["companyName"] as? String,
                    let price = json["delayedPrice"] as? Double,
                    let highPrice = json["high"] as? Double,
                    let closePrice = json["close"] as? Double,
                    let lowPrice = json["low"] as? Double,
                    let openPrice = json["open"] as? Double,
                    let peRatio = json["peRatio"] as? Double,
                    let primaryExchange = json["primaryExchange"] as? String,
                    let sector = json["sector"] as? String,
                    let week52High = json["week52High"] as? Double,
                    let week52Low = json["week52Low"] as? Double
                {
                    stock.change = change
                    stock.companyName = companyName
                    stock.sharePrice = price
                    stock.highPrice = highPrice
                    stock.closePrice = closePrice
                    stock.lowPrice = lowPrice
                    stock.peRatio = peRatio
                    stock.sector = sector
                    stock.week52Low = week52Low
                    stock.week52High = week52High
                    stock.primaryExchange = primaryExchange
                    stock.symbol = stock.symbol?.uppercased()
                    stock.openPrice = openPrice
                    stock.ytdChange = ytdChange.rounded(toPlaces: 2)
                }
                
            case "news":
                
                guard let json = (try? JSONSerialization.jsonObject(with: content, options: JSONSerialization.ReadingOptions.mutableContainers)) as? [[String: String]] else {
                    print("Not containing JSON")
                    return
                }
                for articleInJson in json {
                    if let headline = articleInJson["headline"] {
                        print(articleInJson["headline"]!)
                        let article = Article()
                        article.headline = headline
                        //article.image = json["image"] as! UIImage?
                        article.source = articleInJson["source"]!
                        article.desc = articleInJson["summary"]!
                        article.url = articleInJson["url"]!
                        
                        stock.articles?.append(article)
                    }
                }
            default:
                preconditionFailure("Unrecognized type.")
                
            }
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
        task.resume()
    }
    

    // MARK: Stock action
    // For the refresh control, updates the stocks in the array
    @objc func update() {
        
        for stock in stocks! {
            parseJSON(stock: stock, type: "quote")
        }
        tableView.reloadData()
        refresher.endRefreshing()
    }
    

    // MARK: Stock action
    // Toggles editing mode inside the table view
    @IBAction func toggleEditingMode(_ sender: UIBarButtonItem) {
        if isEditing {
            sender.title = "Edit"
            setEditing(false, animated: true)
        } else {
            sender.title = "Done"
            setEditing(true, animated: true)
        }
    }
        
    
    // MARK: Stock action
    // Moves a stock from a particular index in the array to another, visible in the table view, takes in the starting index and requested index as parameters
    func moveStock(from fromIndex: Int, to toIndex: Int) {
        if fromIndex == toIndex {
            return
        }
        // Get reference to object being moved so you can reinsert it
        let movedStock = stocks![fromIndex]
        // Remove stock from array
        stocks?.remove(at: fromIndex)
        // Insert stock in an array at new location
        stocks?.insert(movedStock, at: toIndex)
    }
}


// Extension to the type Double that allows one to round a Double to a given amount of decimal places
extension Double {
    func rounded(toPlaces places: Int) -> Double {
        let divisor = pow(10.0, Double(places))
        return (self * divisor).rounded() / divisor
    }
}
