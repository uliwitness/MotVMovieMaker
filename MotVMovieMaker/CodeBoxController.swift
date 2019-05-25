import Cocoa

class CodeBoxController: NSObject {
	@IBOutlet var codeTextField: NSTextField!
	@IBOutlet var lineIndicatorView: LineIndicatorView!
	@IBOutlet var lineIndicatorTopConstraint: NSLayoutConstraint!
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
			self.lineIndicatorView.isHidden = false
			updateIndicatorPosition()
		}
	}
	
	override func awakeFromNib() {
		lineCount = codeLines.count
		let attrStr = NSAttributedString(string: "func main() -> Foo {}", attributes: [.font: codeTextField.font!])
		lineHeight = attrStr.size().height
		updateIndicatorPosition()
		
		lineTimer = Timer.scheduledTimer(withTimeInterval: 0.7, repeats: true) { _ in
			if self.selectedLine > (self.lineCount - 1) {
				self.lineIndicatorView.isHidden = true
			} else {
				self.updateIndicatorPosition()
				self.selectedLine += 1
			}
		}
	}
	
	func updateIndicatorPosition() {
		lineIndicatorTopConstraint.constant = lineHeight * CGFloat(selectedLine) - 3.0
	}
}
