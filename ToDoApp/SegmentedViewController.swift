//
//  ViewController.swift
//  UIKit037
//

import UIKit

class SegmentedViewController:UIViewController{

  var unreadBooks : ArrayDataSource!
  var inBoxBooks : ArrayDataSource!
  var doneBooks : ArrayDataSource!
  var myTableView: UITableView!
  var mySegcon: UISegmentedControl!

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
    mySegcon = UISegmentedControl(items: myArray)

    mySegcon.center = CGPoint(x: displayWidth/2, y: barHeight + mySegcon.frame.height/2)
    //mySegcon.frame = CGRect(x: 0, y: barHeight, width:  displayWidth, height: 30)
    // イベントを追加する.
    mySegcon.addTarget(self, action: "segconChanged:", forControlEvents: UIControlEvents.ValueChanged)
    mySegcon.selectedSegmentIndex=1
    // Viewに追加する.
    self.view.addSubview(mySegcon)

    // TableViewの生成する(status barの高さ分ずらして表示).
    myTableView = UITableView(frame: CGRect(x: 0, y: barHeight + mySegcon.frame.height, width: displayWidth, height: displayHeight - barHeight))
    // Cell名の登録をおこなう.
    myTableView.registerClass(BookTableViewCell.self, forCellReuseIdentifier: "MyCell")
    //myTableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: "MyCell")

    let checkAction = Action(view: Action.checkView,
                             color:Action.greenColor){
      cell, state, mode in
      println("Did swipe \"Checkmark\" cell")
      self.doneBooks.create(self.deleteCell(cell))
    }

    unreadBooks = ArrayDataSource(
        // if (s:String)->String
        //fatal error: can't unsafeBitCast between types of different sizes
        items: ["UNREAD1", "UNREAD2", "UNREAD3"].map({(s:String)->Any in return Book(title:s)}),
        cellIdentifier:"MyCell"){
      cell, item in

      let book = item as Book
      cell.textLabel!.text = book.title

      let bookCell = cell as BookTableViewCell
      bookCell.addGesture(.Right,action: checkAction)
    }
    doneBooks = ArrayDataSource(items:["done1", "done2", "done3"].map({(s:String)->Any in return Book(title:s)}),
                                 cellIdentifier:"MyCell"){
      cell, item in

      let book = item as Book
      cell.textLabel!.text = book.title //item as String

      let bookCell = cell as BookTableViewCell
      bookCell.addGesture(.Right,action: checkAction)
    }

    inBoxBooks = ArrayDataSource(items:["inbox1", "inbox2", "inbox3"].map({(s:String)->Any in return Book(title:s)}),
                                 cellIdentifier:"MyCell"){
      cell, item in

      let book = item as Book
      cell.textLabel!.text = book.title //item as String

      let bookCell = cell as BookTableViewCell
      bookCell.addGesture(.Right,action: checkAction)
    }
    // DataSourceの設定をする.
    myTableView.delegate = inBoxBooks
    myTableView.dataSource = inBoxBooks

    // Delegateを設定する.
    // Viewに追加する.
    self.view.addSubview(myTableView)
  }

  func deleteCell(cell: MCSwipeTableViewCell)->Book{
    let indexPath:NSIndexPath=myTableView.indexPathForCell(cell)!
    let books = myTableView.dataSource as ArrayDataSource
    let result = books.remove(indexPath.row) as Book

    self.myTableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: UITableViewRowAnimation.Fade)
    return result
    //return nil
  }

  func segconChanged(segcon: UISegmentedControl){

    switch(segcon.selectedSegmentIndex){
    case 0:
      myTableView.delegate = unreadBooks
      myTableView.dataSource = unreadBooks
      //即時反映はreloadData、アニメーション絡む場合はbegenUpdates〜
      //http://qiita.com/mag4n/items/bcdf1e88794317cf8c9c
      myTableView.reloadData()

    case 1:
      myTableView.delegate = inBoxBooks
      myTableView.dataSource = inBoxBooks
      myTableView.reloadData()

    case 2:
      myTableView.delegate = doneBooks
      myTableView.dataSource = doneBooks
      myTableView.reloadData()
      //removeSegmentAtIndex:animated:
      //insertSegmentWithTitle:atIndex:animated:

    default:
      println("Error")

    }
  }

  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
  }
}
