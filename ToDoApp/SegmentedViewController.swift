//
//  ViewController.swift
//  UIKit037
//

import UIKit

class SegmentedViewController: UIViewController, UITableViewDelegate{

    var dataSource : ArrayDataSource!
    var myTableView: UITableView!

    override init() {
        super.init()
        //remove bar item with all init method
        self.tabBarItem = UITabBarItem(tabBarSystemItem: UITabBarSystemItem.Featured, tag: 1)
    }

    // required for protocol NSCoding
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    required override init(nibName nibNameOrNil: String!, bundle nibBundleOrNil: NSBundle!) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        self.view.backgroundColor = UIColor.greenColor()

        // Status Barの高さを取得する.
        let barHeight: CGFloat = UIApplication.sharedApplication().statusBarFrame.size.height

        // Viewの高さと幅を取得する.
        let displayWidth: CGFloat = self.view.frame.width
        let displayHeight: CGFloat = self.view.frame.height

        // 表示する配列を作成する.
        let myArray: NSArray = ["Unread","InBox","Done"]

        // SegmentedControlを作成する.
        let mySegcon: UISegmentedControl = UISegmentedControl(items: myArray)

        mySegcon.center = CGPoint(x: displayWidth/2, y: barHeight + mySegcon.frame.height/2)
        //mySegcon.frame = CGRect(x: 0, y: barHeight, width: displayWidth, height: 30)
        // イベントを追加する.
        mySegcon.addTarget(self, action: "segconChanged:", forControlEvents: UIControlEvents.ValueChanged)
        // Viewに追加する.
        self.view.addSubview(mySegcon)

        // TableViewの生成する(status barの高さ分ずらして表示).
        myTableView = UITableView(frame: CGRect(x: 0, y: barHeight + mySegcon.frame.height, width: displayWidth, height: displayHeight - barHeight))
        // Cell名の登録をおこなう.
        myTableView.registerClass(BookTableViewCell.self, forCellReuseIdentifier: "MyCell")
        //myTableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: "MyCell")
        // DataSourceの設定をする.
        dataSource = ArrayDataSource(items:["TEST1", "TEST2", "TEST3"],cellIdentifier:"MyCell"){
            cell, item in
            //item in
            if let book = item as? String {
                cell.textLabel!.text = book //item as String
            }
            if let bookCell = cell as? BookTableViewCell {
                println("book")
                //cell.textLabel!.text = book
                let checkAction = Action(view: bookCell.checkView,
                                         color:bookCell.greenColor){
                    cell, state, mode in
                    println("Did swipe \"Checkmark\" cell")
                    self.deleteCell(cell)
                }
                bookCell.addGesture(.Right,     action: checkAction)
            }
        }
        myTableView.delegate = dataSource
        myTableView.dataSource = dataSource

        // Delegateを設定する.
        // Viewに追加する.
        self.view.addSubview(myTableView)
    }

    func deleteCell(cell: MCSwipeTableViewCell)->Book?{
        let indexPath:NSIndexPath=self.myTableView.indexPathForCell(cell)!
        //let result=books.remove(indexPath.row)
        //self.tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: UITableViewRowAnimation.Fade)
        //return result
        return nil
    }

    func segconChanged(segcon: UISegmentedControl){

        switch(segcon.selectedSegmentIndex){
        case 0:
            self.myTableView.backgroundColor = UIColor.redColor()

        case 1:
            self.myTableView.backgroundColor = UIColor.blueColor()

        case 2:
            self.myTableView.backgroundColor = UIColor.greenColor()

        default:
            println("Error")

        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}
