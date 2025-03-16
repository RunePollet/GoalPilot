//
//  SelectAppIconView.swift
//  GoalPilot
//
//  Created by Rune Pollet on 15/03/2025.
//

import SwiftUI

struct SelectAppIconView: View {
    @Environment(GlobalViewModel.self) private var globalModel
    
    var body: some View {
        List {
            Section("Display") {
                HStack {
                    Spacer()
                    appIconButton(.blue)
                    Spacer()
                    appIconButton(.purple)
                    Spacer()
                }
                .padding(.vertical)
            }
        }
        .navigationTitle("App Icon")
    }
    
    private func appIconButton(_ appIcon: AppIcon) -> some View {
        Button {
            if globalModel.selectedAppIcon != appIcon {
                globalModel.setAlternateAppIcon(to: appIcon)
            }
        } label: {
            VStack(spacing: 20) {
                Image(uiImage: appIcon.preview)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 70)
                    .clipShape(RoundedRectangle(cornerRadius: 10))
                    .shadow(color: .gray.opacity(0.3), radius: 10)
                Image(systemName: globalModel.selectedAppIcon == appIcon ? "checkmark.circle.fill" : "circle")
            }
        }
        .buttonStyle(.borderless)
    }
}

#Preview {
    NavigationStack {
        SelectAppIconView()
    }
    .environment(GlobalViewModel())
}
