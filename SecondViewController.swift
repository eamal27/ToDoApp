import UIKit

class SecondViewController: UIViewController {

    @IBOutlet var item: UITextField!
    @IBOutlet weak var addItemButton: UIButton!
    
    @IBAction func addItem(_ sender: AnyObject) {
        if(item.text != "") {
            toDoList.append(item.text!)
        }
        item.text = ""
        UserDefaults.standard.set(toDoList, forKey: "toDoList")
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        addItemButton.layer.cornerRadius = 5
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    func textFieldShouldReturn(_ textField: UITextField!) -> Bool {
        item.resignFirstResponder()
        return true
    }
    
    func matches(for regex: String, in text: String) -> [String] {
        
        do {
            let regex = try NSRegularExpression(pattern: regex)
            let nsString = text as NSString
            let results = regex.matches(in: text, range: NSRange(location: 0, length: nsString.length))
            return results.map { nsString.substring(with: $0.range)}
        } catch let error as NSError {
            print("invalid regex: \(error.localizedDescription)")
            return []
        }
    }
    
}

