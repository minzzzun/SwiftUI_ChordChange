

import Foundation

class ChordChangeViewModel: ObservableObject {
    @Published var chordString: String = ""
    @Published var semitones: Int = 0
    
    private let sharpNotes = ["C", "C#", "D", "D#", "E", "F", "F#", "G", "G#", "A", "A#", "B"]
    private let flatNotes = ["C", "Db", "D", "Eb", "E", "F", "Gb", "G", "Ab", "A", "Bb", "B"]
    
    private let enharmonicMap: [String: String] = [
        "C#": "Db", "Db": "C#",
        "D#": "Eb", "Eb": "D#",
        "F#": "Gb", "Gb": "F#",
        "G#": "Ab", "Ab": "G#",
        "A#": "Bb", "Bb": "A#"
    ]
    
    //MARK: -키 변환(도수 만큼 변환)
    func transpose(_ chord: String, semitones: Int) -> String {
        guard !chord.isEmpty else { return "" }
        
        if chord.contains("/"){
            return transposeSlashChord(chord, semitones: semitones)
        }
        
        let rootNote = extractRootNote(from: chord)
        let tensions = chord.dropFirst(rootNote.count)
        let noteArray = rootNote.contains("b") ? flatNotes : sharpNotes
        
        if let currentIndex = noteArray.firstIndex(of: rootNote) {
            let newIndex = (currentIndex + semitones + noteArray.count) % noteArray.count
            return noteArray[newIndex] + tensions
        }
        
        return chord
    }
    
    // 반 키 업
    func transposeUp(_ chord: String) -> String {
        return transpose(chord, semitones: 1)
    }
    
    // 반 키 다운
    func transposeDown(_ chord: String) -> String {
        return transpose(chord, semitones: -1)
    }
    
    // 5도씩 이동 함수
    func transposePerfectFifth(up: Bool) -> String {
        return transpose(chordString, semitones: up ? 7 : -7)
    }
    
    // #,b 변환 함수
    func sharpFlatChanger(_ chord: String) -> String {
        guard !chord.isEmpty else { return "" }
        
        if chord.contains("/") {
            let components = chord.split(separator: "/")
            if components.count == 2 {
                var rootNote = String(components[0])
                let bassNote = String(components[1])
                
                rootNote = extractRootNote(from: rootNote)
                
                let changedRoot = enharmonicMap[rootNote] ?? rootNote
                let changedBass = enharmonicMap[bassNote] ?? bassNote
                
                return "\(changedRoot)/\(changedBass)"
            }
        }
        
        let rootNote = extractRootNote(from: chord)
        let tensions = chord.dropFirst(rootNote.count)
        
        if let changedChord = enharmonicMap[rootNote] {
            return changedChord + tensions
        }
        return chord
    }
    
    // 루트 코드 추출 함수
    private func extractRootNote(from chord: String) -> String {
        guard !chord.isEmpty else { return "" }
        
        if chord.count >= 2 && (chord[chord.index(after: chord.startIndex)] == "#" ||
                                chord[chord.index(after: chord.startIndex)] == "b") {
            return String(chord.prefix(2))
        }
        
        return String(chord.prefix(1))
    }
    
    // 분수 코드 변환 함수
    func transposeSlashChord(_ chord: String, semitones: Int) -> String {
        guard !chord.isEmpty, let slashIndex = chord.firstIndex(of: "/") else {
            return transpose(chord, semitones: semitones)
        }
        
        let rootNote = String(chord[..<slashIndex])
        let bassNote = String(chord[chord.index(after: slashIndex)...])
        
        let transposedRoot = transpose(rootNote, semitones: semitones)
        let transposedBass = transpose(bassNote, semitones: semitones)
        
        return "\(transposedRoot)/\(transposedBass)"
    }
}
