//
//  SignedPDFPreviewView.swift
//  SignFlow
//

import PDFKit
import SwiftUI
import UIKit
import AdsManagerKit


struct SignedPDFPreviewView: View {
    @Environment(\.colorScheme) private var colorScheme
    let document: SignedDocumentModel
    let onDone: () -> Void

    @State private var pdf: PDFDocument?
    @State private var showShare = false

    var body: some View {
        NavigationStack {
            ZStack {
                Color(uiColor: .systemGroupedBackground)
                    .ignoresSafeArea()

                if let pdf {
                    PDFKitView(document: pdf)
                        .ignoresSafeArea(edges: .bottom)
                } else {
                    ProgressView("Opening PDF…")
                }
            }
            .navigationTitle(document.displayName)
            .navigationBarTitleDisplayMode(.inline)
            .toolbarBackground(.visible, for: .navigationBar)
            .toolbarBackground(colorScheme == .dark ? Color.black.opacity(0.92) : Color(uiColor: .systemBackground), for: .navigationBar)
            .toolbarColorScheme(colorScheme == .dark ? .dark : .light, for: .navigationBar)
            .tint(.primary)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Done") { onDone() }
                        .foregroundStyle(.primary)
                }
                ToolbarItemGroup(placement: .topBarTrailing) {
                    Button {
                        showShare = true
                    } label: {
                        Image(systemName: "square.and.arrow.up")
                    }
                    .disabled(pdf == nil)
                    .foregroundStyle(.primary.opacity(pdf == nil ? 0.45 : 1))

                    Menu {
                        Button("Copy path (debug)") {
                            UIPasteboard.general.string = document.fileURL.path
                        }
                    } label: {
                        Image(systemName: "ellipsis.circle")
                            .foregroundStyle(.primary)
                    }
                }
            }
        }
        .onAppear {
            pdf = PDFDocument(url: document.fileURL)
        }
        .sheet(isPresented: $showShare) {
            ActivityView(activityItems: [document.fileURL])
        }
    }
}

private struct ActivityView: UIViewControllerRepresentable {
    let activityItems: [Any]

    func makeUIViewController(context: Context) -> UIActivityViewController {
        UIActivityViewController(activityItems: activityItems, applicationActivities: nil)
    }

    func updateUIViewController(_ uiViewController: UIActivityViewController, context: Context) {}
}
