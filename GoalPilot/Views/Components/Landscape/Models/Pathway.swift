//
//  Pathway.swift
//  GoalPilot
//
//  Created by Rune Pollet on 07/03/2024.
//

import SwiftUI

extension Landscape {
    /// Holds values describing a Pathway.
    struct Pathway: Identifiable {
        var id = UUID()
        
        var frame: CGRect
        var stroke: @Sendable (_ magnitude: CGFloat, _ reached: Bool) -> StrokeStyle
        var path: @Sendable (_ width: CGFloat, _ height: CGFloat) -> Path
    }
}

extension Landscape.Pathway {
    static let firstHillFirstLeg: Self = .init(
        frame: CGRect(x: 230.5/393.0, y: 260.0/292.0, width: 70.78/393.0, height: 19.6/292.0),
        stroke: { magnitude, reached in
            StrokeStyle(lineWidth: magnitude * 3.0/489.6,
                               lineCap: .round,
                               dash: reached ? [] : [magnitude * 12.0/489.6, magnitude * 15.0/489.6],
                               dashPhase: 0)
        },
        path: { width, height in
            var path = Path()
            path.move(to: CGPoint(x: 0.9768*width, y: 0.89909*height))
            path.addCurve(to: CGPoint(x: 0.02027*width, y: 0.16667*height), control1: CGPoint(x: 0.91892*width, y: -0.04168*height), control2: CGPoint(x: 0.37838*width, y: 0.02082*height))
            return path
        }
    )
    
    static let firstHillSecondLeg: Self = .init(
        frame: CGRect(x: 148.5/393.0, y: 236.0/292.0, width: 56.5/393.0, height: 31.82/292.0),
        stroke: { magnitude, reached in
            StrokeStyle(lineWidth: magnitude * 3.0/489.6,
                               lineCap: .round,
                               dash: reached ? [] : [magnitude * 12.0/489.6, magnitude * 15.0/489.6],
                               dashPhase: 0)
        },
        path: { width, height in
            var path = Path()
            path.move(to: CGPoint(x: 0.96667*width, y: 0.94833*height))
            path.addCurve(to: CGPoint(x: 0.025*width, y: 0.05556*height), control1: CGPoint(x: 0.375*width, y: 1.05556*height), control2: CGPoint(x: 0.05833*width, y: 0.81944*height))
            return path
        }
    )
    
    static let secondHillFirstLeg: Self = .init(
        frame: CGRect(x: 170.0/393.0, y: 189.0/292.0, width: 30.5/393.0, height: 45.5/292.0),
        stroke: { magnitude, reached in
            StrokeStyle(lineWidth: magnitude * 3.0/489.6,
                               lineCap: .round,
                               dash: reached ? [] : [magnitude * 12.0/489.6, magnitude * 15.0/489.6],
                               dashPhase: 0)
        },
        path: { width, height in
            var path = Path()
            path.move(to: CGPoint(x: 0.98438*width, y: 0.98936*height))
            path.addCurve(to: CGPoint(x: 0.03125*width, y: 0.02128*height), control1: CGPoint(x: 0.98438*width, y: 0.98936*height), control2: CGPoint(x: 0.875*width, y: 0.14894*height))
            return path
        }
    )
    
    static let secondHillSecondLeg: Self = .init(
        frame: CGRect(x: 65.0/393.0, y: 193.0/292.0, width: 77.5/393.0, height: 34.21/292.0),
        stroke: { magnitude, reached in
            StrokeStyle(lineWidth: magnitude * 3.0/489.6,
                               lineCap: .round,
                               dash: reached ? [] : [magnitude * 12.0/489.6, magnitude * 15.0/489.6],
                               dashPhase: 0)
        },
        path: { width, height in
            var path = Path()
            path.move(to: CGPoint(x: 0.99367*width, y: 0.02778*height))
            path.addCurve(to: CGPoint(x: 0.01266*width, y: 0.95833*height), control1: CGPoint(x: 0.63291*width, y: 0.47222*height), control2: CGPoint(x: 0.23418*width, y: 1.09722*height))
            return path
        }
    )
    
    static let secondHillThirdLeg: Self = .init(
        frame: CGRect(x: 46.77/393.0, y: 123.0/292.0, width: 8.23/393.0, height: 84.0/292.0),
        stroke: { magnitude, reached in
            StrokeStyle(lineWidth: magnitude * 3.0/489.6,
                               lineCap: .round,
                               dash: reached ? [] : [magnitude * 12.0/489.6, magnitude * 15.0/489.6],
                               dashPhase: 0)
        },
        path: { width, height in
            var path = Path()
            path.move(to: CGPoint(x: 0.45001*width, y: 0.98837*height))
            path.addCurve(to: CGPoint(x: 0.90001*width, y: 0.01163*height), control1: CGPoint(x: -0.3*width, y: 0.69186*height), control2: CGPoint(x: 0.20002*width, y: 0.29651*height))
            return path
        }
    )
    
    static let thirdHillFirstLeg: Self = .init(
        frame: CGRect(x: 88.0/393.0, y: 89.0/292.0, width: 29.0/393.0, height: 35.0/292.0),
        stroke: { magnitude, reached in
            StrokeStyle(lineWidth: magnitude * 3.0/489.6,
                               lineCap: .round,
                               dash: reached ? [] : Array(repeating: magnitude * 10.0/489.6, count: 2),
                               dashPhase: reached ? 0 : magnitude * 5.0/489.6)
        },
        path: { width, height in
            var path = Path()
            path.move(to: CGPoint(x: 0.93939*width, y: 0.94872*height))
            path.addCurve(to: CGPoint(x: 0.06061*width, y: 0.05128*height), control1: CGPoint(x: 0.93939*width, y: 0.41026*height), control2: CGPoint(x: 0.19697*width, y: 0.08679*height))
            return path
        }
    )
    
    static let thirdHillSecondLeg: Self = .init(
        frame: CGRect(x: 54.5/393.0, y: 59.5/292.0, width: 8.5/393.0, height: 21.5/292.0),
        stroke: { magnitude, reached in
            StrokeStyle(lineWidth: magnitude * 3.0/489.6,
                               lineCap: .round,
                               dash: reached ? [] : Array(repeating: magnitude * 10.0/489.6, count: 2),
                               dashPhase: reached ? 0 : magnitude * 5.0/489.6)
        },
        path: { width, height in
            var path = Path()
            path.move(to: CGPoint(x: 0.83333*width, y: 0.92*height))
            path.addCurve(to: CGPoint(x: 0.125*width, y: 0.06*height), control1: CGPoint(x: 0.20835*width, y: 0.8*height), control2: CGPoint(x: 0.12502*width, y: 0.46*height))
            return path
        }
    )
    
    static let onboarding: Self = .init(
        frame: CGRect(x: 2459.31/393.0, y: 210/852.0, width: 630.69/393.0, height: 345.0/852.0),
        stroke: { magnitude, reached in
            StrokeStyle(lineWidth: magnitude * 4/938.3,
                        lineCap: .round,
                        dash: [magnitude * 15.0/938.3, magnitude * 13.0/938.3])
        },
        path: { width, height in
            var path = Path()
            path.move(to: CGPoint(x: 0.00442*width, y: 0.99427*height))
            path.addCurve(to: CGPoint(x: 0.18605*width, y: 0.69771*height), control1: CGPoint(x: 0.00442*width, y: 0.99427*height), control2: CGPoint(x: 0.09106*width, y: 0.71022*height))
            path.addCurve(to: CGPoint(x: 0.3551*width, y: 0.83095*height), control1: CGPoint(x: 0.25779*width, y: 0.68826*height), control2: CGPoint(x: 0.2837*width, y: 0.84685*height))
            path.addCurve(to: CGPoint(x: 0.51156*width, y: 0.43553*height), control1: CGPoint(x: 0.4588*width, y: 0.80785*height), control2: CGPoint(x: 0.40787*width, y: 0.45887*height))
            path.addCurve(to: CGPoint(x: 0.71363*width, y: 0.65043*height), control1: CGPoint(x: 0.59733*width, y: 0.41623*height), control2: CGPoint(x: 0.62723*width, y: 0.65326*height))
            path.addCurve(to: CGPoint(x: 0.90173*width, y: 0.41547*height), control1: CGPoint(x: 0.81721*width, y: 0.64704*height), control2: CGPoint(x: 0.79953*width, y: 0.40346*height))
            path.addCurve(to: CGPoint(x: 0.99607*width, y: 0.00573*height), control1: CGPoint(x: 0.99292*width, y: 0.42619*height), control2: CGPoint(x: 0.99607*width, y: 0.16476*height))
            return path
        }
    )
}
