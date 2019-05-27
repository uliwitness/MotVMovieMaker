import Cocoa

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {

	@IBOutlet weak var window: NSWindow!
	@IBOutlet weak var codeBoxController: CodeBoxController!
	var lines = [CodeLine]()

	func addLine(_ line: CodeLine, parentLines: inout [CodeLine]) {
		if let lastLine = parentLines.last {
			lastLine.subroutine.append(line)
		} else {
			lines.append(line)
		}
	}
	
	func parse(_ str: String) -> [String] {
		let scanner = Scanner(string: str)
		var commandName: NSString?
		scanner.scanUpTo(" ", into: &commandName)
		scanner.scanString(" ", into: nil)
		var inString = false
		
		guard let name = commandName as String? else { return [] }
		
		var parts = [name]
		
		while true {
			var currPart = ""
			while true {
				var tmp: NSString?
				scanner.scanUpToCharacters(from: CharacterSet(charactersIn: "«»\\"), into: &tmp)
				if let tmp = tmp as String? {
					currPart.append(tmp)
				}
				if scanner.isAtEnd {
					parts.append(currPart)
					break
				}
				scanner.scanCharacters(from: CharacterSet(charactersIn: "«»\\"), into: &tmp)
				if tmp == "«" && !inString {
					inString = true
				} else if tmp == "»" && inString {
					inString = false
					parts.append(currPart)
					currPart = ""
				} else if tmp == "\\" && inString {
					if scanner.scanString("n", into: nil) {
						currPart.append("\n")
					} else if scanner.scanString(" ", into: nil) {
						currPart.append(" ")
					} else if scanner.scanString("t", into: nil) {
						currPart.append("\t")
					}
				} else if let tmp = tmp as String? {
					currPart.append(tmp)
				}
			}
			if scanner.isAtEnd { break }
		}
		
		return parts
	}
	
	func application(_ application: NSApplication, open urls: [URL]) {
		guard let url = urls.first else { return }
		
		NSDocumentController.shared.noteNewRecentDocumentURL(url)
		
		let lineDescs = try! String(contentsOf: url, encoding: .utf8).split(separator: "\n")
		var parentLines = [CodeLine]()
		
		lineDescs.forEach { line in
			let parts = parse(String(line))
			
			switch parts[0] {
			case "#":
				return
			case "-":
				lines.append(CodeLine(text: String(line.dropFirst().dropFirst())))
			case "SET":
				let codeLine = CodeLine(text: parts.last!, changedVariableName: parts[1], changedVariableValue: parts[3])
				addLine(codeLine, parentLines: &parentLines)
			case "FUNC":
				let codeLine = CodeLine(text: parts.last!, subroutineName: parts[1])
				addLine(codeLine, parentLines: &parentLines)
				parentLines.append(codeLine)
			case ">":
				let codeLine = CodeLine(text: parts.last!, terminalOutput: parts[1])
				addLine(codeLine, parentLines: &parentLines)
			case "END":
				_ = parentLines.popLast()
			default:
				print("unknown command \"\(parts[0])\", did you mean no command \"-\" ?")
			}
		}
		
		codeBoxController.codeLines = lines
		lines = []
	}
}

