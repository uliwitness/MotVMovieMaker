import Cocoa

class CodeBoxController: NSObject {
	@IBOutlet var codeTextField: NSTextField!
	@IBOutlet var codeBoxView: BoxView!
	@IBOutlet var lineIndicatorView: LineIndicatorView!
	@IBOutlet var lineIndicatorTopConstraint: NSLayoutConstraint!
	@IBOutlet var terminal: TerminalWindowBoxController!
	var lineHeight: CGFloat = 0
	var selectedLine: Int = 0
	var lineCount: Int = 0
	var lineTimer: Timer?
	var codeLines = [CodeLine]() {
		didSet {
			let result = codeLines.map({ $0.text }).joined(separator: "\n")
			if let codeTextField = codeTextField {
				codeTextField.stringValue = result
			}
			selectedLine = 0
			lineCount = codeLines.count
			self.lineIndicatorView?.isHidden = false
			updateIndicatorPosition()
			self.codeBoxView?.isHidden = false
			
			start()
		}
	}
	
	override func awakeFromNib() {
		lineCount = codeLines.count
		let attrStr = NSAttributedString(string: "func main() -> Foo {}", attributes: [.font: codeTextField.font!])
		lineHeight = attrStr.size().height
		updateIndicatorPosition()
		
		start()
	}
	
	func start() {
		lineTimer?.invalidate()
		lineTimer = Timer.scheduledTimer(withTimeInterval: 1.2, repeats: true) { [weak self] timer in
			guard let self = self else { timer.invalidate(); return }
			guard self.lineIndicatorView != nil else { return }
			
			if self.selectedLine > (self.lineCount - 1) {
				self.lineIndicatorView.isHidden = true
				self.stop()
				DispatchQueue.main.asyncAfter(deadline: .now() + 1.2) {
					self.codeBoxView.isHidden = true
				}
			} else {
				self.updateIndicatorPosition()
				if !self.codeLines[self.selectedLine].subroutine.isEmpty {
					self.stop()
					self.lineIndicatorView.isHidden = true
				} else if let terminalOutput = self.codeLines[self.selectedLine].terminalOutput {
					self.stop()
					self.terminal.show(text: terminalOutput) {
						self.start()
					}
				}
				self.selectedLine += 1
			}
		}
	}
	
	func stop() {
		lineTimer?.invalidate()
		lineTimer = nil
	}
	
	func updateIndicatorPosition() {
		lineIndicatorTopConstraint.constant = lineHeight * CGFloat(selectedLine) - 3.0
	}
}
