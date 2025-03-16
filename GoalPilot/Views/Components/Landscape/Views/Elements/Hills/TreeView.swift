//
//  TreeView.swift
//  GoalPilot
//
//  Created by Rune Pollet on 21/02/2024.
//

import SwiftUI

extension Landscape {
    /// The view representation of a 'Tree' model.
    struct TreeView: View {
        @Environment(\.colorScheme) private var colorScheme
        
        var tree: Tree
        
        init(_ tree: Tree) {
            self.tree = tree
        }
        
        var body: some View {
            GeometryReader { geo in
                ZStack {
                    // Log
                    Rectangle()
                        .foregroundStyle(Color(red: 90/255, green: 51/255, blue: 51/255))
                        .frame(width: 3.47, height: 21.35)
                        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .bottom)
                        .offset(y: 5.32)
                    
                    Canopy()
                        .foregroundStyle(colorScheme == .dark ? Color(AssetsCatalog.secondaryCanopyColorID) : tree.canopyColor)
                    Leaf()
                        .foregroundStyle(colorScheme == .dark ? Color(AssetsCatalog.canopyColorID) : tree.leafColor)
                        .frame(width: 5.79, height: 9.39)
                        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .bottomLeading)
                        .offset(x: 2.73, y: -4.1)
                    
                    TreeFoot()
                        .foregroundStyle(tree.footColor)
                        .frame(width: 11.7, height: 3.2)
                        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .bottomLeading)
                        .offset(x: 4.02, y: 7.36)
                }
                .scaleEffect(tree.scale)
                .frame(width: 21.19, height: 28.52)
                .offset(x: geo.size.width * tree.offset.width, y: geo.size.height * tree.offset.height)
            }
        }
    }
    
    struct Canopy: Shape {
        func path(in rect: CGRect) -> Path {
            var path = Path()
            let width = rect.size.width
            let height = rect.size.height
            path.move(to: CGPoint(x: 0.56067*width, y: 0.03239*height))
            path.addCurve(to: CGPoint(x: 0.95815*width, y: 0.74093*height), control1: CGPoint(x: 0.82879*width, y: 0.052*height), control2: CGPoint(x: 0.98373*width, y: 0.53537*height))
            path.addCurve(to: CGPoint(x: 0.48693*width, y: 0.98319*height), control1: CGPoint(x: 0.91963*width, y: 0.90154*height), control2: CGPoint(x: 0.73828*width, y: 0.94453*height))
            path.addCurve(to: CGPoint(x: 0.0397*width, y: 0.6402*height), control1: CGPoint(x: 0.25881*width, y: 0.924*height), control2: CGPoint(x: 0.0397*width, y: 0.8317*height))
            path.addCurve(to: CGPoint(x: 0.56067*width, y: 0.03239*height), control1: CGPoint(x: 0.0397*width, y: 0.44869*height), control2: CGPoint(x: 0.36972*width, y: 0.03076*height))
            path.closeSubpath()
            return path
        }
    }
    
    struct Leaf: Shape {
        func path(in rect: CGRect) -> Path {
            var path = Path()
            let width = rect.size.width
            let height = rect.size.height
            path.move(to: CGPoint(x: 0.7484*width, y: 0.01478*height))
            path.addCurve(to: CGPoint(x: 0.7484*width, y: 0.52697*height), control1: CGPoint(x: 1.11452*width, y: 0.03923*height), control2: CGPoint(x: 0.78466*width, y: 0.26093*height))
            path.addCurve(to: CGPoint(x: 0.68903*width, y: 0.93958*height), control1: CGPoint(x: 0.69476*width, y: 0.73489*height), control2: CGPoint(x: 1.03261*width, y: 0.88869*height))
            path.addCurve(to: CGPoint(x: 0.09178*width, y: 0.4136*height), control1: CGPoint(x: 0.37782*width, y: 0.86379*height), control2: CGPoint(x: 0.10347*width, y: 0.6348*height))
            path.addCurve(to: CGPoint(x: 0.7484*width, y: 0.01478*height), control1: CGPoint(x: 0.08755*width, y: 0.10178*height), control2: CGPoint(x: 0.34753*width, y: -0.04897*height))
            path.closeSubpath()
            return path
        }
    }
    
    struct TreeFoot: Shape {
        func path(in rect: CGRect) -> Path {
            var path = Path()
            let width = rect.size.width
            let height = rect.size.height
            path.move(to: CGPoint(x: 0.92308*width, y: 0.5*height))
            path.addCurve(to: CGPoint(x: 0.9675*width, y: 0.89437*height), control1: CGPoint(x: 0.96794*width, y: 0.70407*height), control2: CGPoint(x: 0.97912*width, y: 0.82654*height))
            path.addCurve(to: CGPoint(x: 0.86127*width, y: 0.95598*height), control1: CGPoint(x: 0.95475*width, y: 0.9688*height), control2: CGPoint(x: 0.91455*width, y: 0.97747*height))
            path.addCurve(to: CGPoint(x: 0.50001*width, y: 0.7501*height), control1: CGPoint(x: 0.7549*width, y: 0.91308*height), control2: CGPoint(x: 0.59639*width, y: 0.75002*height))
            path.addCurve(to: CGPoint(x: 0.22677*width, y: 0.84096*height), control1: CGPoint(x: 0.37288*width, y: 0.7502*height), control2: CGPoint(x: 0.29956*width, y: 0.84298*height))
            path.addCurve(to: CGPoint(x: 0.1154*width, y: 0.75014*height), control1: CGPoint(x: 0.19153*width, y: 0.83998*height), control2: CGPoint(x: 0.15643*width, y: 0.8168*height))
            path.addCurve(to: CGPoint(x: 0.07168*width, y: 0.60356*height), control1: CGPoint(x: 0.08478*width, y: 0.70039*height), control2: CGPoint(x: 0.07155*width, y: 0.65114*height))
            path.addCurve(to: CGPoint(x: 0.0928*width, y: 0.5*height), control1: CGPoint(x: 0.07179*width, y: 0.56793*height), control2: CGPoint(x: 0.07939*width, y: 0.53324*height))
            path.addCurve(to: CGPoint(x: 0.62806*width, y: 0.17249*height), control1: CGPoint(x: 0.17993*width, y: 0.28404*height), control2: CGPoint(x: 0.51237*width, y: 0.12902*height))
            path.addCurve(to: CGPoint(x: 0.92308*width, y: 0.5*height), control1: CGPoint(x: 0.78535*width, y: 0.23159*height), control2: CGPoint(x: 0.89261*width, y: 0.36141*height))
            path.closeSubpath()
            return path
        }
    }
}
