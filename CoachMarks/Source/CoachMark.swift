
import Foundation
import UIKit

public struct CoachMark {
    enum Shape {
        case square
        case round
        case roundedRect(cornerRadius: CGFloat)
    }
    
    let rect: CGRect
    let caption: String
    let font: UIFont = UIFont.boldSystemFont(ofSize: 14.0)
    let shape: Shape
    let swipe: Bool = false
    let direction: FocusView.FocusSwipeDirection? = nil
    let poi: CGRect? = nil
}
