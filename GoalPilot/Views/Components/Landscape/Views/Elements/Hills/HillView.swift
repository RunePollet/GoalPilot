//
//  HillView.swift
//  GoalPilot
//
//  Created by Rune Pollet on 25/01/2024.
//

import SwiftUI

extension Landscape {
    /// The view representation of a 'Hill' model.
    struct HillView: View {
        var hill: Hill
        
        init(_ hill: Hill) {
            self.hill = hill
        }
        
        var body: some View {
            GeometryReader { geo in
                ZStack(alignment: .topLeading) {
                    DrawedShape { path, width, height in
                        hill.path(&path, width, height)
                    }
                    .foregroundStyle(hill.color)
                    
                    ForEach(hill.trees) { tree in
                        TreeView(tree)
                    }
                }
                .frame(width: geo.size.width*hill.size.width, height: geo.size.height*hill.size.height)
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: hill.alignment)
            }
        }
    }
}
