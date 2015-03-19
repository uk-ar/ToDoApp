//
//  BookTableViewController.swift
//  UIKit013
//
//

import UIKit

//UITableViewDataSource is class only protocol
//TODO: Generics raise error, bug?
//class ArrayDataSource<T>: NSObject, UITableViewDataSource{
class ArrayDataSource: NSObject {
    var items: [Any]
    var cellIdentifier: String
    //typealias TableViewCellConfigureBlock = (item: Any) -> ()
    typealias TableViewCellConfigureBlock = (cell:UITableViewCell, item: Any) -> ()
    var configureCellBlock: TableViewCellConfigureBlock

    init(items: [Any],cellIdentifier: String, configureCellBlock: TableViewCellConfigureBlock) {
        self.items = items
        self.cellIdentifier = cellIdentifier
        self.configureCellBlock = configureCellBlock
        super.init()
    }

    subscript(index: Int) -> Any {
        return items[index]
    }

    var count : Int {
        return items.count
    }

    func remove(index: Int) -> Any {
        return self.items.removeAtIndex(index)
    }
    // TODO:extension
    func itemAtIndexPath(indexPath: NSIndexPath)->Any{
        return self.items[indexPath.row]
    }
}

extension ArrayDataSource : UITableViewDataSource {
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.items.count
    }

    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell: UITableViewCell = tableView.dequeueReusableCellWithIdentifier(self.cellIdentifier, forIndexPath:indexPath) as UITableViewCell
        let item: Any = self.itemAtIndexPath(indexPath)
        self.configureCellBlock(cell:cell, item:item)
        return cell
        //return self.configureCellBlock(item:item)
    }
}

extension ArrayDataSource : UITableViewDelegate {
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        println("from Array")
        println("Num: \(indexPath.row)")
        println("Value: \(self.items[indexPath.row])")
    }
}
