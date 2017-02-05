import UIKit

var toDoList = [String]()

class FirstViewController: UIViewController, UITableViewDelegate {
    
    @IBOutlet weak var editButton: UIButton!
    @IBOutlet var toDoListTable: UITableView!
    var pinchGesture = UIPinchGestureRecognizer()
    var fontSize:CGFloat = 22
    var fontName = "Avenir-Book"
    var ps_prevprev:CGFloat = -1
    var ps_prev:CGFloat = -1
    var scaleDown:Bool = false
    var scaleUp:Bool = false
    var nightMode:Bool = false
    var redVal:CGFloat = 255
    var greenVal:CGFloat = 255
    var blueVal:CGFloat = 255
    var redValBg:CGFloat = 240
    var greenValBg:CGFloat = 240
    var blueValBg:CGFloat = 240
    var fontColor:UIColor = UIColor.black
    var separatorColor:UIColor = UIColor.init(red: 200/255.0, green: 199/255.0, blue: 204/255.0, alpha: 1.0)
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        if UserDefaults.standard.object(forKey: "toDoList") != nil {
        
            toDoList = UserDefaults.standard.object(forKey: "toDoList") as! [String]
        
            if UserDefaults.standard.object(forKey: "fontSize") != nil {
                
                fontSize = UserDefaults.standard.object(forKey: "fontSize") as! CGFloat
            
            }
            
            if UserDefaults.standard.object(forKey: "nightMode") != nil {
                
                nightMode = UserDefaults.standard.object(forKey: "nightMode") as! Bool
                
            }
            
        }
        
        toDoListTable.isUserInteractionEnabled = true
        toDoListTable.isMultipleTouchEnabled = true
        
        self.pinchGesture = UIPinchGestureRecognizer(target: self, action: #selector(pinchRecognized(_:)))
        toDoListTable.addGestureRecognizer(self.pinchGesture)
    
        let tap = UITapGestureRecognizer(target: self, action: #selector(doubleTapped))
        tap.numberOfTapsRequired = 2
        toDoListTable.addGestureRecognizer(tap)
        
        if(nightMode) { turnOnNightMode() }
        
        let longPressRecognizer = UILongPressGestureRecognizer(target: self, action: #selector(longPressed(_:)))
        toDoListTable.addGestureRecognizer(longPressRecognizer)
        
    }
    
    func doubleTapped() {
        if(nightMode) {
            
            redVal = 255
            greenVal = 255
            blueVal = 255
            
            redValBg = 240
            greenValBg = 240
            blueValBg = 240
            
            fontColor = UIColor.black
            
            separatorColor = UIColor.init(red: 200/255.0, green: 199/255.0, blue: 204/255.0, alpha: 1.0)
            
            nightMode = false
            
        } else {
            
            turnOnNightMode()
            
        }
        
        UserDefaults.standard.set(nightMode, forKey: "nightMode")
        toDoListTable.reloadData()
    }
    
    func turnOnNightMode() {
        redVal = 15
        greenVal = 15
        blueVal = 15
        
        redValBg = 0
        greenValBg = 0
        blueValBg = 0
        
        fontColor = UIColor.white
        
        separatorColor = UIColor.init(red: 100/255.0, green: 99/255.0, blue: 104/255.0, alpha: 1.0)
        
        nightMode = true
    }
    
    func longPressed(_ long: UILongPressGestureRecognizer) {
        if(long.state == UIGestureRecognizerState.began) {
            let p = long.location(in: self.toDoListTable)
            let indexPath = self.toDoListTable.indexPathForRow(at: p)
            if indexPath != nil {
                
                let itemText = (toDoList[(indexPath?.row)!])
                
                let alert = UIAlertController(title: "", message: itemText, preferredStyle: UIAlertControllerStyle.alert)
                alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.default, handler: nil))
                alert.addAction(UIAlertAction(title: "Delete", style: UIAlertActionStyle.destructive, handler: { action in
                    
                    toDoList.remove(at: (indexPath?.row)!)
                        
                    UserDefaults.standard.set(toDoList, forKey: "toDoList")
                    
                    self.toDoListTable.reloadData()
                }))

                self.present(alert, animated: true, completion: nil)
                
            }
            
        }
    }
    
    @IBAction func pinchRecognized(_ pinch: UIPinchGestureRecognizer) {
        
        let newFontSize:CGFloat = fontSize + (pinch.scale-1)*0.618
        
        if newFontSize > 12 && newFontSize < 32{
            fontSize = newFontSize
            toDoListTable.reloadData()
        } else {
            pinch.scale = 1
        }
        
        if ps_prevprev != -1 && ps_prev != -1 {
            if ps_prevprev < ps_prev {
                scaleUp = true
                scaleDown = false
            } else if ps_prevprev > ps_prev {
                scaleUp = false
                scaleDown = true
            }
            if (scaleUp && pinch.scale < ps_prev) || (scaleDown && pinch.scale > ps_prev) {
                pinch.scale = 1
                scaleUp = false
                scaleDown = false
            }
        }
        
        if ps_prev != -1 {
            ps_prevprev = ps_prev
        }
        
        ps_prev = pinch.scale
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return toDoList.count
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAtIndexPath indexPath: IndexPath) -> UITableViewCell {
        
        let cell = UITableViewCell(style: UITableViewCellStyle.default, reuseIdentifier: "Cell")
        
        cell.textLabel?.text = toDoList[(indexPath as NSIndexPath).row]
        
        cell.selectionStyle = UITableViewCellSelectionStyle.none
        
        cell.backgroundColor = UIColor.init(red: redVal/255.0, green: greenVal/255.0, blue: blueVal/255.0, alpha: 1.0)

        toDoListTable.backgroundColor = UIColor.init(red: redValBg/255.0, green: greenValBg/255.0, blue: blueValBg/255.0, alpha: 1.0)

        toDoListTable.separatorColor = separatorColor;
        
        cell.textLabel?.font = UIFont(name: fontName, size: fontSize)
        
        cell.textLabel?.textColor = fontColor
        
        UserDefaults.standard.set(fontSize, forKey: "fontSize")
        
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        return 65.0;
    }
    
    func tableView(_ tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: IndexPath) {
        
        if editingStyle == UITableViewCellEditingStyle.delete {
            
            toDoList.remove(at: (indexPath as NSIndexPath).row)
            
            UserDefaults.standard.set(toDoList, forKey: "toDoList")
            
            toDoListTable.reloadData()
            
        }
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        toDoListTable.reloadData() 
        
    }
    
    
    
    @IBAction func editList(_ sender: Any) {
        if toDoListTable.isEditing{
            toDoListTable.isEditing = false;
            toDoListTable.setEditing(false, animated: false)
            editButton.setTitle("Edit", for: UIControlState.normal)
        }
        else{
            toDoListTable.isEditing = true;
            toDoListTable.setEditing(true, animated: true);
            editButton.setTitle("Done", for: UIControlState.normal)
        }
    }

}
