//
//  PrimaryButton.swift
//  SignFlow
//

import SwiftUI

struct PrimaryButton: View {
    let title: String
    var style: Style = .filled
    var action: () -> Void

    enum Style {
        case filled
        case outline
    }

    var body: some View {
        Button(action: action) {
            Text(title)
                .font(.system(.headline, design: .rounded).weight(.semibold))
                .frame(maxWidth: .infinity)
                .padding(.vertical, 16)
                .background {
                    if style == .filled {
                        RoundedRectangle(cornerRadius: 16, style: .continuous)
                            .fill(Color.white.opacity(0.95))
                    } else {
                        RoundedRectangle(cornerRadius: 16, style: .continuous)
                            .stroke(Color.white.opacity(0.55), lineWidth: 1.5)
                    }
                }
                .foregroundStyle(style == .filled ? Color.black.opacity(0.88) : Color.white)
        }
        .buttonStyle(.plain)
    }
}
