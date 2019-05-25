import Cocoa

class BoxView: NSView {

	var headerHeight = CGFloat(26)
	
    override func draw(_ dirtyRect: NSRect) {
		var box = self.bounds.insetBy(dx: 0.5, dy: 0.5)
		let path = NSBezierPath(roundedRect: box, xRadius: 10, yRadius: 10)
		
		NSColor(red: 0.98, green: 0.98, blue: 0.98, alpha: 1.0).setFill()
		path.fill()
		
		NSColor.gray.setStroke()
		path.stroke()
		
		box.origin.y += box.size.height - headerHeight
		box.size.height = headerHeight
		NSBezierPath.clip(box)
		NSColor.gray.setFill()
		path.fill()
    }
}
