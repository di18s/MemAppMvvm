import UIKit

final class DrawView: UIView {
    
    private var lastPoint = CGPoint(x: 0.0, y: 0.0)
    private var bezierPath: UIBezierPath!
    var layers = [CAShapeLayer]()
    
    var color = UIColor(red: 1.0, green: 0.0, blue: 0.0, alpha: 1.0)
    var lineWidth: CGFloat = 5.0
    
    var uiImage: UIImage? {
        UIGraphicsBeginImageContext(self.frame.size)
        self.layer.render(in: UIGraphicsGetCurrentContext()!)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image
    }
    
    //MARK: - preparing
    
    func prepareForDrawing() {
        self.layers = self.layers.filter { $0.superlayer != nil }
        
        self.bezierPath = UIBezierPath()
        self.bezierPath.move(to: self.lastPoint)
        
        let layer = CAShapeLayer()
        layer.strokeColor = self.color.cgColor
        layer.lineWidth = self.lineWidth
        layer.lineCap = CAShapeLayerLineCap.round
        layer.allowsEdgeAntialiasing = true
        
        self.layer.addSublayer(layer)
        self.layers.append(layer)
    }
    
    //MARK: - drawing
    
    func drawCurve(with touch: UITouch) {
        let currentPoint = touch.location(in: self)
        
        self.add(point: currentPoint, to: self.bezierPath)
        self.layers.last?.path = self.bezierPath.cgPath
    }
    
    func add(point:CGPoint, to bezierPath:UIBezierPath) {
        var currentPoint = point
        
        currentPoint.x = self.lastPoint.x * 0.8 + currentPoint.x * 0.2
        currentPoint.y = self.lastPoint.y * 0.8 + (currentPoint.y - 10.0) * 0.2
        
        let midPoint = midPointForPoints(self.lastPoint, currentPoint)
        bezierPath.addQuadCurve(to: currentPoint, controlPoint: midPoint)
        self.lastPoint = currentPoint
        bezierPath.move(to: self.lastPoint)
    }
    
    func midPointForPoints(_ p1: CGPoint, _ p2: CGPoint) -> CGPoint {
        return CGPoint(x: (p1.x + p2.x) / 2.0, y: (p1.y + p2.y) / 2.0)
    }
    
    //MARK: - touchs processing
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        
        self.lastPoint = touches.first!.location(in: self)
        self.lastPoint.y -= 10
        
        self.prepareForDrawing()
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesMoved(touches, with: event)
        self.drawCurve(with: touches.first!)
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesEnded(touches, with: event)
        self.drawCurve(with: touches.first!)
        self.bezierPath.close()
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesCancelled(touches, with: event)
        self.drawCurve(with: touches.first!)
        self.bezierPath.close()
    }
    
    //MARK: - image editing
    
    func clear() {
        self.layers.forEach() { $0.removeFromSuperlayer() }
        self.layers = [CAShapeLayer]()
    }
    
    func redo() {
        if let layer = self.layers.first(where: { $0.superlayer == nil }) {
            self.layer.addSublayer(layer)
        }
    }
    
    func undo() {
        if let i = self.layers.firstIndex(where: { $0.superlayer == nil }), i > 0 {
            self.layers[i - 1].removeFromSuperlayer()
        } else {
            self.layers.last?.removeFromSuperlayer()
        }
    }
}
