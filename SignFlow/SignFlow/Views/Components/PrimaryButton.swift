//
//  PrimaryButton.swift
//  SignFlow
//

import SwiftUI

struct PrimaryButton: View {
    @Environment(\.colorScheme) private var colorScheme

    let title: String
    var systemImage: String? = nil
    var style: Style = .filled
    var action: () -> Void

    enum Style {
        case filled
        case outline
    }

    var body: some View {
        Button(action: action) {
            HStack(spacing: 10) {
                if let systemImage {
                    Image(systemName: systemImage)
                        .font(.system(size: 17, weight: .semibold))
                }
                Text(title)
                    .font(.system(.headline, design: .rounded).weight(.semibold))
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical, 16)
                .background {
                    if style == .filled {
                        Group {
                            if colorScheme == .light {
                                RoundedRectangle(cornerRadius: 16, style: .continuous)
                                    .fill(filledFill)
                                    .shadow(color: filledShadowColor, radius: 8, x: 0, y: 4)
                                    .overlay {
                                        RoundedRectangle(cornerRadius: 16, style: .continuous)
                                            .stroke(filledStroke, lineWidth: 1)
                                    }
                            } else {
                                RoundedRectangle(cornerRadius: 16, style: .continuous)
                                    .fill(filledFill)
                                    .shadow(color: filledShadowColor, radius: 4, x: 0, y: 2)
                                    .overlay {
                                        RoundedRectangle(cornerRadius: 16, style: .continuous)
                                            .stroke(filledStroke, lineWidth: 1)
                                    }
                            }
                        }
                    } else {
                        RoundedRectangle(cornerRadius: 16, style: .continuous)
                            .stroke(outlineStroke, lineWidth: 1.5)
                    }
                }
                .foregroundStyle(foregroundTint)
        }
        .buttonStyle(.plain)
    }

    private var filledFill: Color {
        colorScheme == .light
            ? Color(uiColor: .systemGray6)
            : Color(uiColor: .tertiarySystemFill)
    }

    private var filledStroke: Color {
        colorScheme == .light
            ? Color.black.opacity(0.12)
            : Color.white.opacity(0.14)
    }

    private var filledShadowColor: Color {
        colorScheme == .light
            ? Color.black.opacity(0.14)
            : Color.black.opacity(0.2)
    }

    private var outlineStroke: Color {
        colorScheme == .light
            ? Color.primary.opacity(0.35)
            : Color.white.opacity(0.55)
    }

    private var foregroundTint: Color {
        switch style {
        case .filled:
            return Color.primary.opacity(0.92)
        case .outline:
            return colorScheme == .light ? Color.primary.opacity(0.92) : Color.white
        }
    }
}
