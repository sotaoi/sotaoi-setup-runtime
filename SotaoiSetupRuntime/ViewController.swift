import Cocoa

@available(macOS 10.15, *)
class ViewController: NSViewController {
  @IBOutlet var showNumberButton: NSButton!
  @IBOutlet var valueLabel: NSTextField!
  
  var callback: () -> Void = { /* Do nothing */ }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    self.callback = { /* Do nothing */ }
  }

  override var representedObject: Any? {
    didSet {
      // Update the view, if already loaded.
    }
  }
  
  @IBAction func main(_ sender: Any) -> Void {
    PermissionsHandler().run(self)
  }
  
  func dialog(_ title: String, _ msg: String, _ callback: @escaping () -> Void) -> Void {
    if (title.count == 0 && msg.count == 0) {
      print("...")
    } else if (msg.count == 0) {
      print(title)
    } else if (title.count == 0) {
      print(msg)
    } else {
      print(title + " -- " + msg)
    }
    
    let nsAlert = NSAlert()
    self.callback = callback
    
    nsAlert.messageText = title
    nsAlert.informativeText = msg
    nsAlert.addButton(withTitle:"Run")
    nsAlert.addButton(withTitle:"Cancel")
    // nsAlert.alertStyle = NSAlert.Style.WarningAlertStyle

    nsAlert.beginSheetModal(for: self.view.window!, completionHandler: { (modalResponse) -> Void in
      let callback: () -> Void = self.callback
      self.callback = { /* Do nothing */ }
      if modalResponse != NSApplication.ModalResponse.alertFirstButtonReturn {
        return
      }
      callback()
    })
  }
  
  func alert(_ msg: String, _ callback: @escaping () -> Void) -> Void {
    print(msg)
    let nsAlert = NSAlert()
    self.callback = callback
    
    nsAlert.messageText = ""
    nsAlert.informativeText = msg
    nsAlert.addButton(withTitle:"OK")

    nsAlert.beginSheetModal(for: self.view.window!, completionHandler: { (modalResponse) -> Void in
      let callback: () -> Void = self.callback
      self.callback = { /* Do nothing */ }
      callback()
    })
  }
  
//  func showRandomNumber(_ sender: Any) {
//    let randomValue = generateRandomNumber()
//    updateLabel(value: randomValue)
//  }
//
//  func generateRandomNumber() -> Int {
//    let minValue = 0
//    let maxValue = 99
//    return Int.random(in: minValue...maxValue)
//  }
//
//  func updateLabel(value: Int) {
//    valueLabel.stringValue = value.description
//  }
}

