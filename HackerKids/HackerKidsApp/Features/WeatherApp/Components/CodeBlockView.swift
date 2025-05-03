//
//  CodeBlockView.swift
//  HackerKids
//
//  Created by Roberto Ramirez on 4/27/25.
//

import SwiftUI

struct CodeBlockView: View {
    var code: String = ""
    var size: CGFloat = 14
    var body: some View {
        VStack {
            ZStack {
                HStack {Spacer()}
                Spacer()
                Text(attributedString(for: code)) // Display the formatted code
                    .font(.system(size: size, design: .monospaced)) // Use monospaced font
                    .padding()
                    .background(Color.black) // Dark background for the code block
                    .cornerRadius(8) // Rounded corners
                    .overlay(
                        RoundedRectangle(cornerRadius: 8)
                            .stroke(Color.gray, lineWidth: 1) // Add a gray border
                    )
                    .shadow(radius: 2) // Slight shadow for depth
                    .multilineTextAlignment(.leading) // Left-align the code
                    .foregroundColor(.white) // Default text color
                    .fixedSize(horizontal: false, vertical: true)
            }
        }
    }
    func attributedString(for code: String) -> AttributedString {
        var attributedString = AttributedString(code)// Define Swift keywords and regex pattern for strings
        let keywords = ["let", "var", "if", "else", "struct", "func", "return"]
        let stringPattern =
        """
        "\\\\".*?\\\\"" // Regex pattern to match strings
        """
        // Highlight keywords
        for keyword in keywords {
            let ranges = code.ranges(of: keyword)
            for range in ranges {
                if let attributedRange = Range(NSRange(range, in: code), in: attributedString) {
                    attributedString[attributedRange].foregroundColor = .blue // Highlight keywords in blue
                }
            }
        }
        // Highlight strings (text within quotation marks)
        if let regex = try? NSRegularExpression(pattern: stringPattern) {
            let matches = regex.matches(in: code, range: NSRange(code.startIndex..., in: code))
            for match in matches {
                if let stringRange = Range(match.range, in: code),
                   let attributedRange = Range(NSRange(stringRange, in: code), in: attributedString) {
                    attributedString[attributedRange].foregroundColor = .green // Highlight strings in green
                }
            }
        }
        return attributedString
    }
}

#Preview {
    CodeBlockView()
}
