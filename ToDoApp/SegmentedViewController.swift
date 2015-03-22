//
//  ViewController.swift
//  UIKit037
//

import UIKit

//http://techlife.cookpad.com/entry/2015/03/18/180000
func doBounceAnimation(view: UIView){
  UIView.animateWithDuration(
    0.05,
    animations: { () -> Void in
      view.transform = CGAffineTransformMakeScale(1.4, 1.4)
    },
    completion: { (Bool) -> Void in
      UIView.animateWithDuration(
        0.6,
        delay: 0.0,
        usingSpringWithDamping: 0.3,
        initialSpringVelocity: 0.0,
        options: .CurveLinear,
        animations: { () -> Void in
          view.transform = CGAffineTransformMakeScale(1.0, 1.0)
        },
        completion: { (Bool) -> Void in
          view.transform = CGAffineTransformIdentity
        }
      )
    }
  )
}

class SegmentedViewController:UIViewController{

  var unreadBooks : ArrayDataSource!
  var inBoxBooks : ArrayDataSource!
  var doneBooks : ArrayDataSource!
  var myTableView: UITableView!
  var mySegcon: UISegmentedControl!

  override func viewDidLoad() {
    super.viewDidLoad()

    self.view.backgroundColor = UIColor.greenColor()

    // Status Barの高さを取得する.
    let barHeight: CGFloat = UIApplication.sharedApplication().statusBarFrame.size.height

    // Viewの高さと幅を取得する.
    let displayWidth: CGFloat = self.view.frame.width
    let displayHeight: CGFloat = self.view.frame.height

    //http://tnakamura.hatenablog.com/entry/2013/12/10/113954
    let unreadIcon :FAKFontAwesome = FAKFontAwesome.clockOIconWithSize(20)
    //circleOIconWithSize(20)
    let inboxIcon :FAKFontAwesome = FAKFontAwesome.inboxIconWithSize(20)
    let doneIcon :FAKFontAwesome = FAKFontAwesome.checkIconWithSize(20)
                                   //checkCircleIconWithSize(20)

    // 表示する配列を作成する.
    let myArray: NSArray = [
        unreadIcon.imageWithSize(CGSizeMake(20, 20)),
        inboxIcon.imageWithSize(CGSizeMake(20, 20)),
        doneIcon.imageWithSize(CGSizeMake(20, 20)),
        ]

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

    let doneAction = Action(view: Action.checkView,
                             color:Action.greenColor){
      cell, state, mode in
      println("Did swipe \"done\" cell")
      self.doneBooks.create(self.deleteCell(cell))
      let doneView :UIView = self.mySegcon.subviews[0].subviews[0] as UIView
      doBounceAnimation(doneView)
    }

    unreadBooks = ArrayDataSource(
        // if (s:String)->String
        //fatal error: can't unsafeBitCast between types of different sizes
        items: ["UNREAD1", "UNREAD2", "UNREAD3"].map({(s:String)->Any in return Book(title:s)}),
        cellIdentifier:"MyCell"){
      cell, item in

      let book = item as Book
      cell.textLabel!.text = book.title
      // let icon :FAKFontAwesome = FAKFontAwesome.startIconWithSize(20)
      // cell.textLabel!.font = icon.iconFont
      // cell.textLabel!.text = icon.characterCode

      let bookCell = cell as BookTableViewCell
      bookCell.addGesture(.Right,action: doneAction)
    }
    doneBooks = ArrayDataSource(items:["done1", "done2", "done3"].map({(s:String)->Any in return Book(title:s)}),
                                 cellIdentifier:"MyCell"){
      cell, item in

      let book = item as Book
      cell.textLabel!.text = book.title //item as String

      let bookCell = cell as BookTableViewCell
      bookCell.addGesture(.Right,action: doneAction)
    }

    inBoxBooks = ArrayDataSource(items:["inbox1", "inbox2", "inbox3"].map({(s:String)->Any in return Book(title:s)}),
                                 cellIdentifier:"MyCell"){
      cell, item in

      let book = item as Book
      cell.textLabel!.text = book.title //item as String

      let bookCell = cell as BookTableViewCell
      bookCell.addGesture(.Right,action: doneAction)
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
