//
//  HighlightedLabel.swift
//  GoalPilot
//
//  Created by Rune Pollet on 13/04/2024.
//

import SwiftUI

/// Highlights a certain part of the text.
struct HighlightedLabel: View {
    @State private var prefix: String
    @State private var highlight: String
    @State private var suffix: String
    
    init(label: String, splitBy splitLabel: String) {
        let splicedLabel: [String] = label.split(separator: splitLabel, maxSplits: 2, omittingEmptySubsequences: false).map { String($0) }
        
        // Set the prefix, highlight and suffix
        if splicedLabel.count == 1 {
            self.prefix = splicedLabel[0]
            self.highlight = ""
            self.suffix = ""
        } else if splicedLabel.count == 2 {
            if label.replacingOccurrences(of: " ", with: "").starts(with: splitLabel) {
                self.prefix = ""
                self.highlight = splicedLabel[0]
                self.suffix = splicedLabel[1]
            } else {
                self.prefix = splicedLabel[0]
                self.highlight = splicedLabel[1]
                self.suffix = ""
            }
        } else {
            self.prefix = splicedLabel[0]
            self.highlight = splicedLabel[1]
            self.suffix = splicedLabel[2]
        }
    }
    
    var body: some View {
        Text(prefix)
        + Text(highlight)
            .font(.system(size: 17, weight: .medium, design: .default))
            .foregroundStyle(Color.accentColor)
        + Text(suffix)
    }
}
