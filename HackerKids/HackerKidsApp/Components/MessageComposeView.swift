//
//  MessageComposeView.swift
//  HackerKids
//
//  Created by Roberto Ramirez on 1/26/25.
//
import MessageUI
import SwiftUI

struct MessageComposeView: UIViewControllerRepresentable {
    @Binding var result: Result<MessageComposeResult, Error>?
    var configure: (MFMessageComposeViewController) -> Void = { _ in }

    func makeUIViewController(context: Context) -> MFMessageComposeViewController {
        let controller = MFMessageComposeViewController()
        controller.messageComposeDelegate = context.coordinator
        configure(controller)
        return controller
    }

    func updateUIViewController(_ uiViewController: MFMessageComposeViewController, context: Context) {}

    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }

    class Coordinator: NSObject, MFMessageComposeViewControllerDelegate {
        var parent: MessageComposeView

        init(_ parent: MessageComposeView) {
            self.parent = parent
        }

        func messageComposeViewController(_ controller: MFMessageComposeViewController, didFinishWith result: MessageComposeResult) {
            controller.dismiss(animated: true) {
                self.parent.result = .success(result)
            }
        }
    }
}
