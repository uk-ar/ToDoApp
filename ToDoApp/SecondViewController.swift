//
//  SecondViewController.swift
//  UIKit013
//
//

import UIKit

class SecondViewController: UIViewController {
    var books = BookDataManager.unreadBooks
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
    }

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
extension SecondViewController : UITableViewDelegate {
    /*
    Cellが選択された際に呼び出される.
    */
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        println("Num: \(indexPath.row)")
        println("Value: \(self.books[indexPath.row])")
    }
}
enum GestureDirection {
    case Right
    case LongRight
    case Left
    case LongLeft
    func toCellState() -> MCSwipeTableViewCellState{
        switch self {
        case let .Right:
            return MCSwipeTableViewCellState.State1
        case let .LongRight:
            return MCSwipeTableViewCellState.State2
        case let .Left:
            return MCSwipeTableViewCellState.State3
        case let .LongLeft:
            return MCSwipeTableViewCellState.State4
        }
    }
}
struct Action {
    let view: UIView!
    let color: UIColor!
    let block: (cell: MCSwipeTableViewCell!, state: MCSwipeTableViewCellState, mode:MCSwipeTableViewCellMode)->()
}
extension SecondViewController : UITableViewDataSource {

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.books.size
    }
    func viewWithImageName(name: String) -> UIView {
        let image: UIImage? = UIImage(named: name);
        let imageView: UIImageView = UIImageView(image: image);
        imageView.contentMode = UIViewContentMode.Center;
        return imageView;
    }
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {

//        let cell = TodoTableViewCell(style: .Default, reuseIdentifier: nil)
//        cell.delegate = self
//
//        cell.textLabel?.text = self.books[indexPath.row].title
//        cell.tag = indexPath.row

        var cell: MCSwipeTableViewCell! = tableView.dequeueReusableCellWithIdentifier("cell") as MCSwipeTableViewCell!;
        if cell == nil {
             cell = MCSwipeTableViewCell(style: UITableViewCellStyle.Subtitle, reuseIdentifier: "cell");

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
        let greenColor = UIColor(red: 85.0 / 255.0, green: 213.0 / 255.0, blue: 80.0 / 255.0, alpha: 1.0);
        let redColor   = UIColor(red: 232.0 / 255.0, green: 61.0 / 255.0, blue: 14 / 255.0, alpha: 1.0);
        let yellowColor = UIColor(red: 254.0 / 255.0, green: 217.0 / 255.0, blue: 56.0 / 255.0, alpha: 1.0);
        let brownColor = UIColor(red: 206.0 / 255.0, green: 149.0 / 255.0, blue: 98.0 / 255.0, alpha: 1.0);

        let checkView = self.viewWithImageName("check");
        let crossView = self.viewWithImageName("cross");
        let clockView = self.viewWithImageName("clock");
        let listView  = self.viewWithImageName("list");

        let checkAction =
            Action(view: checkView, color: greenColor){
            (cell: MCSwipeTableViewCell!, state: MCSwipeTableViewCellState, mode:MCSwipeTableViewCellMode) in
            println("Did swipe \"Checkmark\" cell")
        }

        let crossAction = Action(view: crossView, color: redColor){
            (cell: MCSwipeTableViewCell!, state: MCSwipeTableViewCellState, mode:MCSwipeTableViewCellMode) in
            println("Did swipe \"Cross\" cell")
        }

        let clockAction = Action(view: clockView, color: yellowColor){
            (cell: MCSwipeTableViewCell!, state: MCSwipeTableViewCellState, mode:MCSwipeTableViewCellMode) in
            println("Did swipe \"Clock\" cell")
        }

        let listAction = Action(view: listView, color: brownColor){
            (cell: MCSwipeTableViewCell!, state: MCSwipeTableViewCellState, mode:MCSwipeTableViewCellMode) in
            println("Did swipe \"List\" cell")
        }

        addGesture(cell, direction: .Right, action: checkAction)
        addGesture(cell, direction: .LongRight, action: crossAction)
        addGesture(cell, direction: .Left, action: clockAction)
        addGesture(cell, direction: .LongLeft, action: listAction)
        return cell
    }
    func addGesture(cell: MCSwipeTableViewCell! ,
                    direction: GestureDirection ,action: Action){
        cell.setSwipeGestureWithView(
            action.view, color: action.color, mode: .Exit,
            state: direction.toCellState(),
            completionBlock: action.block
        );
    }
}

extension SecondViewController : TodoTableViewCellDelegate {

    func updateTodo(index: Int) {
        //
    }

    func removeTodo(index: Int) {
        //
    }
}
