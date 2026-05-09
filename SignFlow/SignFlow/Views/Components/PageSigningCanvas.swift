//
//  PageSigningCanvas.swift
//  SignFlow
//

import SwiftUI
import UIKit

/// PDF page thumbnail with a draggable signature overlay. `normalizedRect` uses top-left origin, 0...1.
struct PageSigningCanvas: View {
    let thumbnail: UIImage
    @Binding var normalizedRect: CGRect
    let signature: UIImage?
    @Binding var rotationDegrees: Double
    var onCancel: (() -> Void)?

    @State private var dragOffset: CGSize = .zero
    @State private var liveScale: CGFloat = 1
    @State private var liveRotation: Angle = .zero

    var body: some View {
        GeometryReader { geo in
            let size = geo.size
            ZStack(alignment: .topLeading) {
                Image(uiImage: thumbnail)
                    .resizable()
                    .scaledToFit()
                    .frame(width: size.width, height: size.height)
                    .clipped()

                if let signature {
                    let w = max(36, normalizedRect.width * size.width)
                    let h = max(24, normalizedRect.height * size.height)
                    let x = normalizedRect.minX * size.width + dragOffset.width
                    let y = normalizedRect.minY * size.height + dragOffset.height

                    ZStack(alignment: .topTrailing) {
                        Image(uiImage: signature)
                            .resizable()
                            .scaledToFit()
                            .frame(width: w, height: h)
                            .shadow(color: .black.opacity(0.2), radius: 6, x: 0, y: 3)
                            .rotationEffect(.degrees(rotationDegrees) + liveRotation)
                            .scaleEffect(liveScale)
                            .gesture(dragGesture(size: size))
                            .simultaneousGesture(magnificationGesture())
                            .simultaneousGesture(rotationGesture())

                        Button {
                            onCancel?()
                        } label: {
                            Image(systemName: "xmark.circle.fill")
                                .foregroundStyle(.white, .red)
                                .font(.system(size: 22))
                                .background(Circle().fill(.ultraThinMaterial))
                        }
                        .offset(x: 10, y: -10)
                    }
                    .position(x: x + w / 2, y: y + h / 2)
                }
            }
        }
    }

    private func dragGesture(size: CGSize) -> some Gesture {
        DragGesture()
            .onChanged { value in
                dragOffset = value.translation
            }
            .onEnded { value in
                let dx = value.translation.width / max(size.width, 1)
                let dy = value.translation.height / max(size.height, 1)
                var next = normalizedRect
                next.origin.x = clamp(next.origin.x + dx, min: 0, max: 1 - next.width)
                next.origin.y = clamp(next.origin.y + dy, min: 0, max: 1 - next.height)
                normalizedRect = next
                dragOffset = .zero
            }
    }

    private func magnificationGesture() -> some Gesture {
        MagnificationGesture()
            .onChanged { value in
                liveScale = value
            }
            .onEnded { value in
                let clamped = clamp(value, min: 0.5, max: 2.0)
                var next = normalizedRect
                next.size.width = clamp(next.width * clamped, min: 0.08, max: 0.9)
                next.size.height = clamp(next.height * clamped, min: 0.04, max: 0.6)
                next.origin.x = clamp(next.origin.x, min: 0, max: 1 - next.width)
                next.origin.y = clamp(next.origin.y, min: 0, max: 1 - next.height)
                normalizedRect = next
                liveScale = 1
            }
    }

    private func rotationGesture() -> some Gesture {
        RotationGesture()
            .onChanged { value in
                liveRotation = value
            }
            .onEnded { value in
                rotationDegrees += value.degrees
                liveRotation = .zero
            }
    }

    private func clamp(_ v: CGFloat, min: CGFloat, max: CGFloat) -> CGFloat {
        Swift.min(Swift.max(v, min), max)
    }
}
