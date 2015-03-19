//
//  BookTableViewController.swift
//  UIKit013
//
//

import UIKit

class BookTableViewController: UIViewController {
    var books :BookDataManager!
    var tableView :UITableView!

    //initializer for UIViewController
    override init() {
        super.init()

        // Viewの背景色をGreenに設定する.
        self.view.backgroundColor = UIColor.greenColor()

        // tabBarItemのアイコンをFeaturedに、タグを2と定義する.
        self.tabBarItem = UITabBarItem(tabBarSystemItem: UITabBarSystemItem.Featured, tag: 2)

        // Status Barの高さを取得する.
        let barHeight: CGFloat = UIApplication.sharedApplication().statusBarFrame.size.height

        // Viewの高さと幅を取得する.
        let displayWidth: CGFloat = self.view.frame.width
        let displayHeight: CGFloat = self.view.frame.height
        //println(displayHeight)//667

        // TableViewの生成する(status barの高さ分ずらして表示).
        let myTableView: UITableView = UITableView(frame: CGRect(x: 0, y: barHeight, width: displayWidth, height: displayHeight - barHeight))

        // Cell名の登録をおこなう.
        myTableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: "MyCell")

        // DataSourceの設定をする.
        myTableView.dataSource = self

        // Delegateを設定する.
        myTableView.delegate = self

        // Viewに追加する.
        self.view.addSubview(myTableView)

        self.tableView=myTableView
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
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }


}
extension BookTableViewController : UITableViewDelegate {
    /*
    Cellが選択された際に呼び出される.
    */
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        println("Num: \(indexPath.row)")
        println("Value: \(self.books[indexPath.row])")
    }
}

extension BookTableViewController : UITableViewDataSource {

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.books.size
    }
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {

//        let cell = TodoTableViewCell(style: .Default, reuseIdentifier: nil)
//        cell.delegate = self
//
//        cell.textLabel?.text = self.books[indexPath.row].title
//        cell.tag = indexPath.row

        var cell: BookTableViewCell! = tableView.dequeueReusableCellWithIdentifier("cell") as BookTableViewCell!;
        if cell == nil {
             cell = BookTableViewCell(style: UITableViewCellStyle.Subtitle, reuseIdentifier: "cell");

             // Remove inset of iOS 7 separators.
             if cell.respondsToSelector(Selector("separatorInset")){
                 cell.separatorInset=UIEdgeInsetsZero;
             }
             cell!.selectionStyle = UITableViewCellSelectionStyle.Gray;
             cell!.contentView.backgroundColor = UIColor.whiteColor();
        }
        cell.textLabel?.text = "\(books[indexPath.row])"
        //cell.textLabel?.text = "Switch Mode Cell"
        cell.detailTextLabel?.text = "Swipe to swich";

        let checkAction = Action(view: Action.checkView, color:Action.greenColor){
            cell, state, mode in
            println("Did swipe \"Checkmark\" cell")
            self.deleteCell(cell)
        }

        let crossAction = Action(view: Action.crossView, color:Action.redColor){
            cell, state, mode in
            println("Did swipe \"Cross\" cell")
        }

        let clockAction = Action(view: Action.clockView, color:Action.yellowColor){
            cell, state, mode in
            println("Did swipe \"Clock\" cell")
        }

        let listAction = Action(view: Action.listView, color:Action.brownColor){
            cell, state, mode in
            println("Did swipe \"List\" cell")
        }

        cell.addGesture(.Right,     action: checkAction)
        cell.addGesture(.LongRight, action: crossAction)
        cell.addGesture(.Left,      action: clockAction)
        cell.addGesture(.LongLeft,  action: listAction)
        return cell
    }

    func deleteCell(cell: MCSwipeTableViewCell)->Book{
        let indexPath:NSIndexPath=self.tableView.indexPathForCell(cell)!
        let result=books.remove(indexPath.row)
        self.tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: UITableViewRowAnimation.Fade)
        return result
    }
}

extension BookTableViewController : BookTableViewCellDelegate {

    func updateBook(index: Int) {
        //
    }

    func moveBook(index: Int) {
        //
    }
}
