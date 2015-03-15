//
//  ViewController.swift
//  UIKit037
//

import UIKit

class SegmentedViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    let myItems: NSArray = ["TEST1", "TEST2", "TEST3"]
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
        let myTableView: UITableView = UITableView(frame: CGRect(x: 0, y: barHeight + mySegcon.frame.height, width: displayWidth, height: displayHeight - barHeight))
        // Cell名の登録をおこなう.
        myTableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: "MyCell")

        // DataSourceの設定をする.
        myTableView.dataSource = self

        // Delegateを設定する.
        myTableView.delegate = self

        self.myTableView=myTableView
        // Viewに追加する.
        self.view.addSubview(myTableView)
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

    /*
    Cellが選択された際に呼び出される.
    */
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        println("Num: \(indexPath.row)")
        println("Value: \(myItems[indexPath.row])")
    }

    /*
    Cellの総数を返す.
    */
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return myItems.count
    }

    /*
    Cellに値を設定する.
    */
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {

        // Cellの.を取得する.
        let cell = tableView.dequeueReusableCellWithIdentifier("MyCell", forIndexPath: indexPath) as UITableViewCell

        // Cellに値を設定する.
        cell.textLabel!.text = "\(myItems[indexPath.row])"

        return cell
    }

}
