//
//  BookTableViewController.swift
//  UIKit013
//
//

import UIKit



class ArrayDataSource<T>: NSObject, UITableViewDataSource {
    var items: [T]
    var cellIdentifier: String
    typealias TableViewCellConfigureBlock = (cell: UITableViewCell, item: T) -> ()
    var configureCellBlock: TableViewCellConfigureBlock

    init(items: [T],cellIdentifier: String, configureCellBlock: TableViewCellConfigureBlock) {
        self.items = items
        self.cellIdentifier = cellIdentifier
        self.configureCellBlock = configureCellBlock
        super.init()
    }
    // TODO:extension
    func itemAtIndexPath(indexPath: NSIndexPath)->T{
        return self.items[indexPath.row]
    }

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.items.count
    }

    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell: UITableViewCell = tableView.dequeueReusableCellWithIdentifier(self.cellIdentifier, forIndexPath:indexPath) as UITableViewCell
        let item: T = self.itemAtIndexPath(indexPath)
        self.configureCellBlock(cell:cell, item:item)
        return cell
    }
}
