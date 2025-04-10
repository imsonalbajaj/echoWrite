//
//  TextSummarizer.swift
//  echoWrite
//
//  Created by Sonal on 08/04/25.
//

import NaturalLanguage

class TextSummarizer {
    static func summarize(text: String, maxSentences: Int = 3) -> (summary: String, heading: String) {
        guard !text.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else {
            return ("", "Summary")
        }

        // 1. Tokenize sentences
        let sentenceTokenizer = NLTokenizer(unit: .sentence)
        sentenceTokenizer.string = text
        var sentences: [String] = []
        sentenceTokenizer.enumerateTokens(in: text.startIndex..<text.endIndex) { range, _ in
            let sentence = String(text[range]).trimmingCharacters(in: .whitespacesAndNewlines)
            if !sentence.isEmpty {
                sentences.append(sentence)
            }
            return true
        }

        guard !sentences.isEmpty else {
            return ("", "Summary")
        }

        // 2. Try Named Entity Scoring
        let tagger = NLTagger(tagSchemes: [.nameType])
        tagger.string = text
        tagger.setLanguage(.english, range: text.startIndex..<text.endIndex)

        var namedEntities: Set<String> = []
        tagger.enumerateTags(in: text.startIndex..<text.endIndex,
                             unit: .word,
                             scheme: .nameType,
                             options: [.omitWhitespace, .omitPunctuation]) { tag, tokenRange in
            if let tag = tag, [.personalName, .placeName, .organizationName].contains(tag) {
                namedEntities.insert(String(text[tokenRange]))
            }
            return true
        }

        var sentenceScores: [(sentence: String, score: Int)] = []

        if !namedEntities.isEmpty {
            // Score by named entity presence
            sentenceScores = sentences.map { sentence in
                let score = namedEntities.reduce(0) {
                    $0 + (sentence.localizedCaseInsensitiveContains($1) ? 1 : 0)
                }
                return (sentence, score)
            }
        } else {
            // Fallback: Score by frequent word usage
            var wordFreq: [String: Int] = [:]
            let wordTokenizer = NLTokenizer(unit: .word)
            wordTokenizer.string = text
            wordTokenizer.enumerateTokens(in: text.startIndex..<text.endIndex) { range, _ in
                let word = String(text[range]).lowercased()
                if word.range(of: "[a-z]", options: .regularExpression) != nil {
                    wordFreq[word, default: 0] += 1
                }
                return true
            }

            sentenceScores = sentences.map { sentence in
                let words = sentence.lowercased().components(separatedBy: .whitespacesAndNewlines)
                let score = words.reduce(0) { $0 + (wordFreq[$1] ?? 0) }
                return (sentence, score)
            }
        }

        let sorted = sentenceScores.sorted { $0.score > $1.score }.prefix(maxSentences)
        let summary = sorted.map { $0.sentence }.joined(separator: " ")
        let heading = sorted.first?.sentence ?? sentences.first ?? "Summary"

        return (summary, heading)
    }
}
