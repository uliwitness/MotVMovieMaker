import Foundation

import Cocoa

class TerminalWindowBoxView: NSView {
	
	var headerHeight = CGFloat(26)
	
	func drawTitleBarBackground(box: CGRect, path: NSBezierPath) -> CGRect {
		var titleBarBox = box
		
		NSGraphicsContext.saveGraphicsState()
		defer { NSGraphicsContext.restoreGraphicsState() }
		let lightColor = NSColor(calibratedWhite: 0.95, alpha: 1.0)
		let midColor = NSColor(calibratedWhite: 0.85, alpha: 1.0)
		let darkColor = NSColor(calibratedWhite: 0.75, alpha: 1.0)
		let gradient = NSGradient(colors: [lightColor, midColor, darkColor])
		titleBarBox.origin.y += titleBarBox.size.height - headerHeight
		titleBarBox.size.height = headerHeight
		path.addClip()
		NSBezierPath.clip(titleBarBox)
		gradient?.draw(in: titleBarBox, angle: -90.0)
		
		return titleBarBox
	}
	
	override func draw(_ dirtyRect: NSRect) {
		let box = self.bounds.insetBy(dx: 0.5, dy: 0.5)
		let path = NSBezierPath(roundedRect: box, xRadius: 5, yRadius: 5)
		
		NSColor.darkGray.setFill()
		path.fill()
		
		NSColor.gray.setStroke()
		path.stroke()
		
		let titleBarBox = drawTitleBarBackground(box: box, path: path)
		var closeBoxBox = titleBarBox.insetBy(dx: 7, dy: 7)
		closeBoxBox.size.width = closeBoxBox.size.height
		
		closeBoxBox.origin.x += 3
		let closeBoxPath = NSBezierPath(ovalIn: closeBoxBox)
		NSColor(calibratedRed: 0.985, green: 0.281, blue: 0.279, alpha: 1.000).setFill()
		closeBoxPath.fill()
		NSColor(calibratedRed: 0.850, green: 0.166, blue: 0.177, alpha: 1.000).setStroke()
		closeBoxPath.stroke()

		var minimizeBoxBox = closeBoxBox
		minimizeBoxBox.origin.x = closeBoxBox.maxX + 9
		let minimizeBoxPath = NSBezierPath(ovalIn: minimizeBoxBox)
		NSColor(calibratedRed: 0.992, green: 0.693, blue: 0.141, alpha: 1.000).setFill()
		minimizeBoxPath.fill()
		NSColor(calibratedRed: 0.846, green: 0.571, blue: 0.121, alpha: 1.000).setStroke()
		minimizeBoxPath.stroke()
		
		var zoomBoxBox = minimizeBoxBox
		zoomBoxBox.origin.x = minimizeBoxBox.maxX + 9
		let zoomBoxPath = NSBezierPath(ovalIn: zoomBoxBox)
		NSColor(calibratedRed: 0.160, green: 0.766, blue: 0.199, alpha: 1.000).setFill()
		zoomBoxPath.fill()
		NSColor(calibratedRed: 0.104, green: 0.623, blue: 0.108, alpha: 1.000).setStroke()
		zoomBoxPath.stroke()
	}
}
