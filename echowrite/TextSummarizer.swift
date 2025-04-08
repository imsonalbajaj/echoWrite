//
//  TextSummarizer.swift
//  echoWrite
//
//  Created by Sonal on 08/04/25.
//

import NaturalLanguage

class TextSummarizer {
    static func summarize(text: String) -> (summary: String, heading: String) {
        let tokenizer = NLTokenizer(unit: .sentence)
        tokenizer.string = text
        var sentences: [String] = []

        tokenizer.enumerateTokens(in: text.startIndex..<text.endIndex) { range, _ in
            let sentence = String(text[range]).trimmingCharacters(in: .whitespacesAndNewlines)
            if !sentence.isEmpty {
                sentences.append(sentence)
            }
            return true
        }

        let summary = sentences.prefix(3).joined(separator: " ")
        let heading = sentences.first ?? "Summary"
        return (summary, heading)
    }
}
