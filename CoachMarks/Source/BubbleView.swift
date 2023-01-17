
import Foundation
import UIKit

/// The view in charge of displaying the text around the focus area
class BubbleView: UIView {

    enum ArrowPosition {
        case top
        case bottom
    }

    // MARK:- Properties

    let arrowHeight: CGFloat = 12

    /// Space between arrow and highlighted region
    let arrowSpace: CGFloat = 6

    /// Padding between text and border of bubble
    let textPadding: CGFloat = 8.0

    /// Corner radius of bubble
    let cornerRadius: CGFloat = 6.0

    /// X-offset from left
    var arrowOffset: CGFloat = 0

    var arrowPosition: ArrowPosition = .top

    var text: String?

    /// Color of the bubble
    var color: UIColor = UIColor.white
    var bouncing: Bool = true

    var attachedFrame: CGRect = CGRect.zero
    var font: UIFont = UIFont.systemFont(ofSize: 14)
    var label: UILabel?

    var animationShouldStop: Bool = false

    init(frame: CGRect, text: String) {
        self.text = text
        self.font = UIFont.systemFont(ofSize: UIFont.systemFontSize)
        super.init(frame: frame)
    }

    convenience init(frame: CGRect, text: String, color: UIColor?, font: UIFont? = nil) {
        self.init(frame: frame, text: text)

        if color != nil {
            self.color = color!
        }

        if font != nil {
            self.font = font!
        }

        self.text = text
//        self.arrowPosition = arrowPosition
        self.backgroundColor = UIColor.clear

        self.attachedFrame = frame
        self.frame = bubbleViewFrame
        fixFrameIfOutOfBounds()

        // Make it pass touch events through to the CoachMarksView
        isUserInteractionEnabled = false

        // Calculate and position text
        label = makeLabel(with: text)
        guard let label = label else {
            return
        }

        self.addSubview(label)
        self.setNeedsDisplay()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }


    override func draw(_ rect: CGRect) {

        guard let ctx = UIGraphicsGetCurrentContext() else {
            super.draw(rect)
            print("BubbleView#draw Couldn't get graphics context")
            return
        }

        ctx.saveGState()

        let size = bubbleSize
        let center = arrowHeight / 2

        //  points used to draw arrow
        //  Wide Arrow --> x = center + - ArrowSize
        //  Skinny Arrow --> x = center + - center
        //  Normal Arrow -->
        let start = CGPoint(x: center, y: bounds.height)
        let end = CGPoint(x: center, y: 0)

        let path = UIBezierPath()
        
        path.move(to: start)
        path.addLine(to: end)
                
        let pointerLineLength: CGFloat = 10
        let arrowAngle = CGFloat(Double.pi / 4)
        
        let startEndAngle = atan((end.y - start.y) / (end.x - start.x)) + ((end.x - start.x) < 0 ? CGFloat(Double.pi) : 0)
        let arrowLine1 = CGPoint(x: end.x + pointerLineLength * cos(CGFloat(Double.pi) - startEndAngle + arrowAngle), y: end.y - pointerLineLength * sin(CGFloat(Double.pi) - startEndAngle + arrowAngle))
        let arrowLine2 = CGPoint(x: end.x + pointerLineLength * cos(CGFloat(Double.pi) - startEndAngle - arrowAngle), y: end.y - pointerLineLength * sin(CGFloat(Double.pi) - startEndAngle - arrowAngle))

        path.addLine(to: arrowLine1)
        path.move(to: end)
        path.addLine(to: arrowLine2)

        let halfArrowSize = arrowHeight / CGFloat(2.0)

        var trans: CGAffineTransform!
        var rot: CGAffineTransform?

        if (arrowPosition == .top) {
            trans = CGAffineTransform(translationX: size.width/2 - halfArrowSize + arrowOffset, y: 0)
        } else if (arrowPosition == .bottom) {
            rot = CGAffineTransform(rotationAngle: CGFloat.pi)
            trans = CGAffineTransform(translationX: size.width/2 + halfArrowSize + arrowOffset, y: size.height + arrowHeight)
        }

        if let rotationTransform = rot {
            path.apply(rotationTransform)
        }
        
        UIColor.white.setStroke()
        path.lineWidth = 2

        path.apply(trans)
        path.stroke()
        ctx.restoreGState()
        
        
        if let oldLabel = self.label {
            let newLabel = modifyLabel(with: oldLabel)
            newLabel.text = oldLabel.text
            newLabel.font = oldLabel.font
            newLabel.textColor = oldLabel.textColor

            oldLabel.removeFromSuperview()
            self.addSubview(newLabel)
        }
    }

    func makeLabel(with text: String) -> UILabel {
        let label = UILabel()

        label.text = text
        label.numberOfLines = 0
        let labelFont: UIFont = .systemFont(ofSize: 15, weight: .medium)
        label.font = labelFont
        label.frame = CGRect(x: 0, y: 0, width: bubbleSize.width, height: bubbleSize.width)
        return label
    }

    var bubbleViewFrame: CGRect {
        // Calculate bubble position
        var x = attachedFrame.origin.x
        var y = attachedFrame.origin.y

        let size = bubbleSize

        var widthDelta: CGFloat = 0, heightDelta: CGFloat = 0
        x += attachedFrame.size.width / 2 - size.width / 2
        y += arrowPosition == .top ? arrowSpace + attachedFrame.size.height : -(arrowSpace * 2 + size.height)
            heightDelta = arrowHeight

        return CGRect(x: x, y: y, width: size.width + widthDelta, height: size.height + heightDelta)
    }


    var offsets: CGSize {
        return CGSize(width: 0, height: arrowPosition == .top ? arrowHeight : 0)
    }

    var bubbleSize: CGSize {
        let boundingSize = CGSize(width: 100  - textPadding * 3.0, height: CGFloat.greatestFiniteMagnitude)
        let result = NSString(string: text!).boundingRect(with: boundingSize, options: .usesLineFragmentOrigin, attributes: [NSAttributedString.Key.font : font], context: nil).size

        return CGSize(width: result.width + textPadding * 3.0, height: result.height + textPadding * 2.5)
    }

    func modifyLabel(with label: UILabel) -> UILabel {

        let xBounds = UIScreen.main.bounds.size.width
        let labelX = frame.maxX
        
        let textWidth = label.frame.width
        var x: CGFloat
        let newLabel = label
        if labelX + textWidth > xBounds {
            x = -frame.size.width/2 - 20
            newLabel.frame.size = bubbleSize
            newLabel.textAlignment = .right
        } else {
            newLabel.textAlignment = .left
            x = frame.size.width/2 - (arrowHeight / CGFloat(2.0)) + arrowOffset + 20
        }
        newLabel.frame.origin.x = x
        return newLabel
    }

    func fixFrameIfOutOfBounds() {
        let screenSize = UIScreen.main.bounds.size
        let xBounds = screenSize.width
        let yBounds = screenSize.height

        var x = frame.origin.x
        var y = frame.origin.y
        let width = frame.size.width
        var height = frame.size.height

        let padding = CGFloat(3.0)

        // Check for right-most bound
        if (x + width > xBounds) {
            arrowOffset = (x + width) - xBounds
            x = xBounds - width
        }

        // Check for left-most bound
        if (x < 0) {
            if (arrowOffset == 0) {
                arrowOffset = x - padding
            }
            x = 0
        }

        // If the content pushes us off the vertical bounds, we might have to be more
        // drastic and flip the arrow direction
        if (arrowPosition == .top && (y + height) > yBounds) {
            arrowPosition = .bottom

            // Restart the entire process
            let flippedFrame = bubbleViewFrame
            y = flippedFrame.origin.y
            height = flippedFrame.size.height
        } else if (arrowPosition == .bottom && y < 0) {
            arrowPosition = .top

            // Restart the entire process
            let flippedFrame = bubbleViewFrame
            y = flippedFrame.origin.y
            height = flippedFrame.size.height
        }

        frame = CGRect(x: x, y: y, width: width, height: height)
    }


    //    /// Start bounce animation
    func animate() {
        UIView.animate(withDuration: 2.0, delay: 0.3, options: [.repeat, .autoreverse], animations: {
            self.transform = CGAffineTransform(translationX: 0, y: -5)
        }, completion: nil)
    }
}
