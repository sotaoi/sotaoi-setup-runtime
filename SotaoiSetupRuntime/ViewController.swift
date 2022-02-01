import Cocoa

class ViewController: NSViewController {

    @IBOutlet var showNumberButton: NSButton!
    @IBOutlet var valueLabel: NSTextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override var representedObject: Any? {
        didSet {
            // Update the view, if already loaded.
        }
    }
    
    @IBAction func main(_ sender: Any) {
        alert("Starting runtime", "Continue?")
    }
    
    func alert(_ title: String, _ msg: String) -> Void {
        let a = NSAlert()
        a.messageText = title
        a.informativeText = msg
        a.addButton(withTitle:"Run")
        a.addButton(withTitle:"Cancel")
        // a.alertStyle = NSAlert.Style.WarningAlertStyle

        a.beginSheetModal(for: self.view.window!, completionHandler: { (modalResponse) -> Void in
            if modalResponse == NSApplication.ModalResponse.alertFirstButtonReturn {
                print("Will start setup...")
            }
        })
    }
    
//    func showRandomNumber(_ sender: Any) {
//        let randomValue = generateRandomNumber()
//        updateLabel(value: randomValue)
//    }
//
//    func generateRandomNumber() -> Int {
//        let minValue = 0
//        let maxValue = 99
//        return Int.random(in: minValue...maxValue)
//    }
//
//    func updateLabel(value: Int) {
//        valueLabel.stringValue = value.description
//    }
}

