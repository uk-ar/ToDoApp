//
//  BookTableViewController.swift
//  UIKit013
//
//

import UIKit

typealias TableViewCellConfigureBlock = (cell: UITableViewCell, item: AnyObject) -> ()

class ArrayDataSource: NSObject, UITableViewDataSource {
    var items: [AnyObject]
    var cellIdentifier: String
    var configureCellBlock: TableViewCellConfigureBlock

    init(items: [AnyObject],cellIdentifier: String, configureCellBlock: TableViewCellConfigureBlock) {
        self.items = items
        self.cellIdentifier = cellIdentifier
        self.configureCellBlock = configureCellBlock
        super.init()
    }

    func itemAtIndexPath(indexPath: NSIndexPath)->AnyObject{
        return self.items[indexPath.row]
    }

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.items.count
    }

    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell: UITableViewCell = tableView.dequeueReusableCellWithIdentifier(self.cellIdentifier, forIndexPath:indexPath) as UITableViewCell
        let item: AnyObject = self.itemAtIndexPath(indexPath)
        self.configureCellBlock(cell:cell, item:item)
        return cell
    }
}
