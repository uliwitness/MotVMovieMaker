import Foundation

class CodeLine {
	var text: String
	var subroutineName: String?
	var subroutine = [CodeLine]()
	var changedVariableName: String?
	var changedVariableValue: String?
	var terminalOutput: String?
	
	init(text: String, changedVariableName: String? = nil, changedVariableValue: String? = nil, terminalOutput: String? = nil, subroutineName: String? = nil) {
		self.text = text
		self.subroutineName = subroutineName
		self.changedVariableName = changedVariableName
		self.changedVariableValue = changedVariableValue
		self.terminalOutput = terminalOutput
	}
}
