//
//  ContentView.swift
//  TestChordChange
//
//  Created by 김민준 on 1/27/25.
//

import SwiftUI

struct ContentView: View {
    @StateObject private var viewModel = ChordChangeViewModel()
    
    //    @State var chord: String = ""
    
    var body: some View {
        VStack {
            TextField("코드를 입력하세요", text: $viewModel.chordString)
                .padding()
                .background(Color.init(#colorLiteral(red: 0.4666666687, green: 0.7647058964, blue: 0.2666666806, alpha: 1)))
            
            HStack{
                Button(action: {
                    print("반키 다운")
                    viewModel.chordString = viewModel.transposeDown(viewModel.chordString)
                }){
                    Text("반 키다운")
                }
                
                Button(action: {
                    print("반키업")
                    viewModel.chordString = viewModel.transposeUp(viewModel.chordString)
                }){
                    Text("반 키업")
                }
                
            }
            .padding()
            
            HStack {
                Button(action: {
                    viewModel.chordString = viewModel.transposePerfectFifth(up: false)
                }){
                    Text("5도 다운")
                }
                
                Button(action: {
                    viewModel.chordString = viewModel.transposePerfectFifth(up: true)
                }){
                    Text("5도 업")
                }
            }
            .padding()
            
            HStack {
                Stepper(value: $viewModel.semitones, in: -11...11) {
                    Text("이동할 반음 수: \(viewModel.semitones)")
                }
                
                Button(action: {
                    viewModel.chordString = viewModel.transposeByInterval(viewModel.chordString, semitones: viewModel.semitones)
                }) {
                    Text("이동")
                }
            }
            .padding()
            
            
            Button(action:{
                viewModel.chordString = viewModel.sharpFlatChanger(viewModel.chordString)
            }){
                Text("#,b 변경")
            }
            
            Text("결과 : \(viewModel.chordString)")
                .padding()
                .font(.system(size: 20))
            
        }
    }
}


#Preview {
    ContentView()
}
