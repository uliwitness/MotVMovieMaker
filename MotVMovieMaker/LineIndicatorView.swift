import Cocoa

class LineIndicatorView: NSView {

    override func draw(_ dirtyRect: NSRect) {
        NSColor(red: 0.851, green: 0.918, blue: 0.792, alpha: 0.5).setFill()
		var box = self.bounds
		var bgBox = box
		bgBox.origin.x += 8
		bgBox.size.width -= 8
		NSBezierPath.fill(bgBox)
		
		var indicatorBox = box
		indicatorBox.size.width = indicatorBox.size.height
		indicatorBox = indicatorBox.insetBy(dx: 2, dy: 2)
		
		let indicatorPath = NSBezierPath()
		indicatorPath.move(to: NSPoint(x: indicatorBox.maxX, y: ceil(indicatorBox.midY)))
		indicatorPath.line(to: NSPoint(x: indicatorBox.minX, y: indicatorBox.maxY))
		indicatorPath.line(to: NSPoint(x: indicatorBox.minX, y: indicatorBox.minY))
		indicatorPath.line(to: NSPoint(x: indicatorBox.maxX, y: ceil(indicatorBox.midY)))
		
		NSGraphicsContext.saveGraphicsState()
		defer { NSGraphicsContext.restoreGraphicsState() }
		let shadow = NSShadow()
		shadow.shadowBlurRadius = 2.0
		shadow.shadowOffset = CGSize(width: 1.0, height: -1.0)
		shadow.shadowColor = NSColor(red: 0.2, green: 0.2, blue: 0.2, alpha: 0.5)
		shadow.set()
		
		NSColor.white.setFill()
		indicatorPath.fill()
    }
    
}
