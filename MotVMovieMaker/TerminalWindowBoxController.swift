import Cocoa

class TerminalWindowBoxController: NSObject {
	@IBOutlet var terminalBoxView: TerminalWindowBoxView!
	@IBOutlet var terminalTextField: NSTextField!
	
	func show(text: String, completion: @escaping (() -> Void)) {
		terminalTextField.stringValue = text
		terminalBoxView.isHidden = false
		
		DispatchQueue.main.asyncAfter(deadline: .now() + 1.2) {
			self.terminalBoxView.isHidden = true
			completion()
		}
	}
}
