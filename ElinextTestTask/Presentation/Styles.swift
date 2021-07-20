import UIKit

enum Styles {
    enum SpringBoard: Int {
        case rows = 10
        case cols = 7
    }
    
    enum Default: CGFloat {
        case imageSpacing = 2.0
        case imageCornerRadius = 7.0
        
        static func of(_ it: Self) -> CGFloat {
            return it.rawValue
        }
    }
}
