//
//
//import Foundation
//
//class ChordChangeViewModel: ObservableObject{
//    
//    @Published var chordString: String = ""
//    @Published var semitones: Int = 0
//    
//    
//    private let sharpNotes = ["C", "C#", "D", "D#", "E", "F", "F#", "G", "G#", "A", "A#", "B"]
//    private let flatNotes = ["C", "Db", "D", "Eb", "E", "F", "Gb", "G", "Ab", "A", "Bb", "B"]
//    
//    private let enharmonicMap: [String: String] = [
//        "C#": "Db", "Db": "C#",
//        "D#": "Eb", "Eb": "D#",
//        "F#": "Gb", "Gb": "F#",
//        "G#": "Ab", "Ab": "G#",
//        "A#": "Bb", "Bb": "A#"
//    ]
//    
//    
//    // 키업
//    func transposeUp(_ chord: String) -> String {
//        guard !chord.isEmpty else {return ""}
//        
//        let rootNote = extractRootNote(from: chord)
//        let tensions = chord.dropFirst(rootNote.count)
//        
//        let noteArray = rootNote.contains("b") ? flatNotes : sharpNotes
//        
//        if let currentIndex = noteArray.firstIndex(of: rootNote) {
//            let nextIndex = (currentIndex + 1) % noteArray.count
//            return noteArray[nextIndex] + tensions
//        }
//        
//        
//        if let enharmonicNote = enharmonicMap[rootNote],
//           let currentIndex = (rootNote.contains("b") ? sharpNotes : flatNotes).firstIndex(of: enharmonicNote) {
//            let nextIndex = (currentIndex + 1) % sharpNotes.count
//            return sharpNotes[nextIndex] + tensions
//        }
//        
//        return chord
//    }
//    
//    
//    // 키 다운
//    func transposeDown(_ chord: String) -> String {
//        guard !chord.isEmpty else {return ""}
//        
//        let rootNote = extractRootNote(from: chord)
//        let tensions = chord.dropFirst(rootNote.count)
//        let noteArray = rootNote.contains("b") ? flatNotes : sharpNotes
//        
//        if let currentIndex = noteArray.firstIndex(of: rootNote) {
//            let previousIndex = (currentIndex - 1 + noteArray.count) % noteArray.count
//            return noteArray[previousIndex] + tensions
//        }
//        
//        if let enharmonicNote = enharmonicMap[rootNote],
//           let currentIndex = (rootNote.contains("b") ? sharpNotes : flatNotes).firstIndex(of: enharmonicNote) {
//            let nextIndex = (currentIndex + 1) % sharpNotes.count
//            return sharpNotes[nextIndex] + tensions
//        }
//        
//        return chord
//    }
//    
//    
//    
//    // 도수 단위로 키 변환
//    func transposeByInterval(_ chord: String, semitones: Int) -> String {
//        guard !chord.isEmpty else { return "" }
//        
//        let rootNote = extractRootNote(from: chord)
//        let remainder = chord.dropFirst(rootNote.count)
//        
//        let noteArray = rootNote.contains("b") ? flatNotes : sharpNotes
//        
//        if let currentIndex = noteArray.firstIndex(of: rootNote) {
//            // 양수든 음수든 모든 경우 처리 가능
//            let newIndex = (currentIndex + semitones + noteArray.count) % noteArray.count
//            return noteArray[newIndex] + remainder
//        }
//        
//        if let enharmonicNote = enharmonicMap[rootNote],
//           let currentIndex = (rootNote.contains("b") ? sharpNotes : flatNotes).firstIndex(of: enharmonicNote) {
//            let newIndex = (currentIndex + semitones + sharpNotes.count) % sharpNotes.count
//            return sharpNotes[newIndex] + remainder
//        }
//        
//        return chord
//    }
//    
//    // 5도 상행/하행을 위한 메서드
//    func transposePerfectFifth(up: Bool) -> String {
//        // 완전5도는 7개의 반음
//        let interval = up ? 7 : -7
//        return transposeByInterval(chordString, semitones: interval)
//    }
//    
//    
//    
//    // 샾 플랫 변환
//    func sharpFlatChanger(_ chord: String) -> String {
//        guard !chord.isEmpty else { return "" }
//        
//        let rootNote = extractRootNote(from: chord)
//        let tensions = chord.dropFirst(rootNote.count)
//        
//        if let changedChord  = enharmonicMap[rootNote] {
//            return changedChord + tensions
//        }
//        return chord
//    }
//    
//    
//    
//    
//    // 루트 코드 추출 함수
//    private func extractRootNote(from chord: String) -> String {
//        if chord.isEmpty {return ""}
//        
//        if chord.count >= 2 && (   chord[chord.index(after: chord.startIndex)] == "#"
//                                || chord[chord.index(after: chord.startIndex)] == "b") {
//            return String(chord.prefix(2))
//        }
//        
//        return String(chord.prefix(1))
//    }
//    
//    
//    
//}


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
    
    // 키 변환 (증가 또는 감소)
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
    
    func transposeUp(_ chord: String) -> String {
        return transpose(chord, semitones: 1)
    }
    
    func transposeDown(_ chord: String) -> String {
        return transpose(chord, semitones: -1)
    }
    
    func transposePerfectFifth(up: Bool) -> String {
        return transpose(chordString, semitones: up ? 7 : -7)
    }
    
    func sharpFlatChanger(_ chord: String) -> String {
        guard !chord.isEmpty else { return "" }
        
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
        
        if let slashIndex = chord.firstIndex(of: "/") {
            let rootPart = String(chord[..<slashIndex])
            let bassPart = String(chord[slashIndex ..< chord.endIndex])
            
            return extractRootNote(from: rootPart)
        }
        
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
