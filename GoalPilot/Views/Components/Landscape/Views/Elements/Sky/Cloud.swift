//
//  Cloud.swift
//  GoalPilot
//
//  Created by Rune Pollet on 02/09/2024.
//

import SwiftUI

extension Landscape {
    struct Cloud: View {
        enum Variation {
            case one, two
        }
        
        var variation: Variation
        
        var body: some View {
            Group {
                if variation == .one {
                    Cloud1()
                } else {
                    Cloud2()
                }
            }
            .foregroundStyle(.white)
        }
    }
    
    private struct Cloud1: Shape {
        func path(in rect: CGRect) -> Path {
            var path = Path()
            let width = rect.size.width
            let height = rect.size.height
            path.move(to: CGPoint(x: 0.61638*width, y: 0.50744*height))
            path.addCurve(to: CGPoint(x: 0.51889*width, y: 0.9453*height), control1: CGPoint(x: 0.67902*width, y: 0.6647*height), control2: CGPoint(x: 0.63537*width, y: 0.86073*height))
            path.addCurve(to: CGPoint(x: 0.19455*width, y: 0.81368*height), control1: CGPoint(x: 0.4024*width, y: 1.02986*height), control2: CGPoint(x: 0.25719*width, y: 0.97093*height))
            path.addCurve(to: CGPoint(x: 0.29205*width, y: 0.37582*height), control1: CGPoint(x: 0.13191*width, y: 0.65642*height), control2: CGPoint(x: 0.17556*width, y: 0.46039*height))
            path.addCurve(to: CGPoint(x: 0.61638*width, y: 0.50744*height), control1: CGPoint(x: 0.40853*width, y: 0.29126*height), control2: CGPoint(x: 0.55374*width, y: 0.35019*height))
            path.closeSubpath()
            path.move(to: CGPoint(x: 0.95749*width, y: 0.42762*height))
            path.addCurve(to: CGPoint(x: 0.85999*width, y: 0.86547*height), control1: CGPoint(x: 1.02013*width, y: 0.58487*height), control2: CGPoint(x: 0.97648*width, y: 0.7809*height))
            path.addCurve(to: CGPoint(x: 0.53566*width, y: 0.73385*height), control1: CGPoint(x: 0.74351*width, y: 0.95003*height), control2: CGPoint(x: 0.5983*width, y: 0.8911*height))
            path.addCurve(to: CGPoint(x: 0.63315*width, y: 0.296*height), control1: CGPoint(x: 0.47301*width, y: 0.57659*height), control2: CGPoint(x: 0.51666*width, y: 0.38056*height))
            path.addCurve(to: CGPoint(x: 0.95749*width, y: 0.42762*height), control1: CGPoint(x: 0.74964*width, y: 0.21143*height), control2: CGPoint(x: 0.89485*width, y: 0.27036*height))
            path.closeSubpath()
            path.move(to: CGPoint(x: 0.46118*width, y: 0.41036*height))
            path.addCurve(to: CGPoint(x: 0.36368*width, y: 0.84821*height), control1: CGPoint(x: 0.52382*width, y: 0.56761*height), control2: CGPoint(x: 0.48017*width, y: 0.76365*height))
            path.addCurve(to: CGPoint(x: 0.03935*width, y: 0.71659*height), control1: CGPoint(x: 0.2472*width, y: 0.93277*height), control2: CGPoint(x: 0.10199*width, y: 0.87384*height))
            path.addCurve(to: CGPoint(x: 0.13684*width, y: 0.27874*height), control1: CGPoint(x: -0.02329*width, y: 0.55934*height), control2: CGPoint(x: 0.02036*width, y: 0.3633*height))
            path.addCurve(to: CGPoint(x: 0.46118*width, y: 0.41036*height), control1: CGPoint(x: 0.25333*width, y: 0.19417*height), control2: CGPoint(x: 0.39854*width, y: 0.2531*height))
            path.closeSubpath()
            path.move(to: CGPoint(x: 0.76249*width, y: 0.19163*height))
            path.addCurve(to: CGPoint(x: 0.66499*width, y: 0.62948*height), control1: CGPoint(x: 0.82513*width, y: 0.34888*height), control2: CGPoint(x: 0.78148*width, y: 0.54492*height))
            path.addCurve(to: CGPoint(x: 0.34066*width, y: 0.49786*height), control1: CGPoint(x: 0.54851*width, y: 0.71405*height), control2: CGPoint(x: 0.4033*width, y: 0.65512*height))
            path.addCurve(to: CGPoint(x: 0.43815*width, y: 0.06001*height), control1: CGPoint(x: 0.27801*width, y: 0.3406*height), control2: CGPoint(x: 0.32166*width, y: 0.14457*height))
            path.addCurve(to: CGPoint(x: 0.76249*width, y: 0.19163*height), control1: CGPoint(x: 0.55464*width, y: -0.02456*height), control2: CGPoint(x: 0.69985*width, y: 0.03437*height))
            path.closeSubpath()
            return path
        }
    }
    
    private struct Cloud2: Shape {
        func path(in rect: CGRect) -> Path {
            var path = Path()
            let width = rect.size.width
            let height = rect.size.height
            path.move(to: CGPoint(x: 0.29068*width, y: 0.38458*height))
            path.addCurve(to: CGPoint(x: 0.48271*width, y: 0.01998*height), control1: CGPoint(x: 0.25865*width, y: 0.22114*height), control2: CGPoint(x: 0.34462*width, y: 0.0579*height))
            path.addCurve(to: CGPoint(x: 0.79073*width, y: 0.24728*height), control1: CGPoint(x: 0.62079*width, y: -0.01793*height), control2: CGPoint(x: 0.75869*width, y: 0.08383*height))
            path.addCurve(to: CGPoint(x: 0.59871*width, y: 0.61187*height), control1: CGPoint(x: 0.82276*width, y: 0.41072*height), control2: CGPoint(x: 0.73679*width, y: 0.57396*height))
            path.addCurve(to: CGPoint(x: 0.29068*width, y: 0.38458*height), control1: CGPoint(x: 0.46062*width, y: 0.64979*height), control2: CGPoint(x: 0.32272*width, y: 0.54803*height))
            path.closeSubpath()
            path.move(to: CGPoint(x: 0.01747*width, y: 0.51981*height))
            path.addCurve(to: CGPoint(x: 0.20949*width, y: 0.15522*height), control1: CGPoint(x: -0.01456*width, y: 0.35637*height), control2: CGPoint(x: 0.07141*width, y: 0.19313*height))
            path.addCurve(to: CGPoint(x: 0.51752*width, y: 0.38251*height), control1: CGPoint(x: 0.34758*width, y: 0.1173*height), control2: CGPoint(x: 0.48548*width, y: 0.21906*height))
            path.addCurve(to: CGPoint(x: 0.32549*width, y: 0.7471*height), control1: CGPoint(x: 0.54955*width, y: 0.54595*height), control2: CGPoint(x: 0.46358*width, y: 0.70919*height))
            path.addCurve(to: CGPoint(x: 0.01747*width, y: 0.51981*height), control1: CGPoint(x: 0.18741*width, y: 0.78502*height), control2: CGPoint(x: 0.0495*width, y: 0.68326*height))
            path.closeSubpath()
            path.move(to: CGPoint(x: 0.48867*width, y: 0.74914*height))
            path.addCurve(to: CGPoint(x: 0.6807*width, y: 0.38454*height), control1: CGPoint(x: 0.45664*width, y: 0.58569*height), control2: CGPoint(x: 0.54261*width, y: 0.42246*height))
            path.addCurve(to: CGPoint(x: 0.98872*width, y: 0.61183*height), control1: CGPoint(x: 0.81878*width, y: 0.34663*height), control2: CGPoint(x: 0.95669*width, y: 0.44839*height))
            path.addCurve(to: CGPoint(x: 0.7967*width, y: 0.97643*height), control1: CGPoint(x: 1.02075*width, y: 0.77528*height), control2: CGPoint(x: 0.93478*width, y: 0.93851*height))
            path.addCurve(to: CGPoint(x: 0.48867*width, y: 0.74914*height), control1: CGPoint(x: 0.65861*width, y: 1.01435*height), control2: CGPoint(x: 0.52071*width, y: 0.91259*height))
            path.closeSubpath()
            path.move(to: CGPoint(x: 0.13668*width, y: 0.66234*height))
            path.addCurve(to: CGPoint(x: 0.32871*width, y: 0.29774*height), control1: CGPoint(x: 0.10465*width, y: 0.49889*height), control2: CGPoint(x: 0.19062*width, y: 0.33566*height))
            path.addCurve(to: CGPoint(x: 0.63673*width, y: 0.52503*height), control1: CGPoint(x: 0.46679*width, y: 0.25982*height), control2: CGPoint(x: 0.60469*width, y: 0.36159*height))
            path.addCurve(to: CGPoint(x: 0.44471*width, y: 0.88963*height), control1: CGPoint(x: 0.66876*width, y: 0.68848*height), control2: CGPoint(x: 0.58279*width, y: 0.85171*height))
            path.addCurve(to: CGPoint(x: 0.13668*width, y: 0.66234*height), control1: CGPoint(x: 0.30662*width, y: 0.92754*height), control2: CGPoint(x: 0.16872*width, y: 0.82578*height))
            path.closeSubpath()
            return path
        }
    }
}
