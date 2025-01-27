

import Foundation

class ChordChangeViewModel: ObservableObject{
    
    @Published var chordString: String = ""
    
    private let notes = ["C","C#","D","D#","E","F","F#","G","G#","A","A#","B"]
    
    
    
    func transposeUp(_ chord: String) -> String {
        guard !chord.isEmpty else {return ""}
        
        let rootNote = extractRootNote(from: chord)
        let tensions = chord.dropFirst(rootNote.count)
        
        if let currentIndex = notes.firstIndex(of: rootNote) {
            let nextIndex = (currentIndex + 1) % notes.count
            return notes[nextIndex] + tensions
        }
        
        return chord
    }
    
    
    
    func transposeDown(_ chord: String) -> String {
        guard !chord.isEmpty else {return ""}
        
        let rootNote = extractRootNote(from: chord)
        let tensions = chord.dropFirst(rootNote.count)
        
        if let currentIndex = notes.firstIndex(of: rootNote) {
            let previousIndex = (currentIndex - 1 + notes.count) % notes.count
            return notes[previousIndex] + tensions
        }
        
        return chord
    }
    
    
    
    
    
    
  
    
    private func extractRootNote(from chord: String) -> String {
        if chord.isEmpty {return ""}
        
        if chord.count >= 2 && (chord[chord.index(after: chord.startIndex)] == "#" || chord[chord.index(after: chord.startIndex)] == "b") {
            return String(chord.prefix(2))
        }
            
        return String(chord.prefix(1))
    }
    
    
    
}
