//
//  ContentView.swift
//  mancala
//
//  Created by 李炘杰 on 2023/4/6.
//

import SwiftUI



struct ContentView: View {
    @State var pits: [[Int]] = [
        [4, 4, 4, 4, 4, 4],
        [4, 4, 4, 4, 4, 4],
    ]
    @State var currentPlayer = 0
    @State var point0 = 0
    @State var point1 = 0
    @State var final = false
    var body: some View {
        ZStack {
            Image("background")
                .resizable()
                .scaledToFill()
                .ignoresSafeArea()
            HStack{
                VStack {
                    MancalaPitView(point: $point1, playernow: $currentPlayer, player: 1)
                }
                Spacer()
                VStack {
                    PitRowView(oppositepit: $pits,pits: $pits[1], player: $currentPlayer, playerpoint: $point1, oppositepoint: $point0, final: $final, pitsnum: 1)
                        .padding()
                    PitRowView(oppositepit: $pits,pits: $pits[0], player: $currentPlayer, playerpoint: $point0, oppositepoint: $point1, final: $final, pitsnum: 0)
                        .padding()
                    if(final){
                        if(point0 > point1){
                            Text("Player 1 win!!!!")
                                .font(.largeTitle)
                        }
                        else if(point0 < point1){
                            Text("Player 2 win!!!!")
                                .font(.largeTitle)
                        }
                        else {
                            Text("Tie!!!")
                            .font(.largeTitle)
                        }
                    }
                    else{
                        Text("Player \(currentPlayer + 1) Turn")
                            .font(.largeTitle)
                    }
                    
                }
                Spacer()
                VStack {
                    MancalaPitView(point: $point0, playernow: $currentPlayer, player: 0)
                }
            }
            .padding()
        }
    }
}

struct PitRowView: View {
    @Binding var oppositepit:[[Int]]
    @Binding var pits: [Int]
    @Binding var player: Int
    @Binding var playerpoint: Int
    @Binding var oppositepoint: Int
    @Binding var final: Bool
    let pitsnum: Int
    var body: some View {
        var position = 0
        var stone = 0
        var remain = 0
        var rremain = 0
        HStack {
            Spacer()
            ForEach(pits.indices, id: \.self) { index in
                VStack {
                    Circle()
                        .background(
                            Image("pitbackground")
                                .resizable()
                                .scaledToFill()
                                .clipShape(Circle())
                        )
                        .foregroundColor(.gray.opacity(0))
                        .frame(width: 80, height: 80)
                        .overlay(
                            Circle()
                                .stroke(pitsnum == 0 ? Color.green : Color.blue, lineWidth: 7)
                        )
                        .onTapGesture {
                            if(pits.allSatisfy { $0 == 0 } || oppositepit[(player + 1) % 2].allSatisfy{$0 == 0}) {
                                playerpoint += pits.reduce(0, +)
                                for index in 0...5 {
                                    pits[index] = 0
                                }
                                oppositepoint += oppositepit[(player + 1) % 2].reduce(0, +)
                                for index in 0...5 {
                                    oppositepit[(player + 1) % 2][index] = 0
                                }
                                final = true
                            }
                            if(player == 0 && pits[index] > 0 && player == pitsnum){     //player 1
                                position = index
                                stone = pits[index]
                                pits[index] = 0
                                if(index + stone <= 5) {    //same side
                                    while stone > 0 {
                                        pits[position + 1] += 1
                                        position += 1
                                        stone -= 1
                                    }
                                    if(pits[position] == 1 && oppositepit[(player + 1) % 2][position] != 0) {
                                        playerpoint += oppositepit[(player + 1) % 2][position]
                                        oppositepit[(player + 1) % 2][position] = 0
                                        playerpoint += 1
                                        pits[position] = 0
                                        player = (player + 1) % 2
                                    }
                                    player = (player + 1) % 2
                                }
                                else if(index + stone == 6) { //to point
                                    playerpoint += 1
                                    stone -= 1
                                    while stone > 0 {
                                        pits[position + 1] += 1
                                        position += 1
                                        stone -= 1
                                    }
                                    player = (player + 1) % 2
                                }
                                else if(stone + index == 13){   //to different point
                                    remain = stone - (5 - index) - 2
                                    stone -= (remain + 2)
                                    playerpoint += 1
                                    while stone > 0 {
                                        pits[position + 1] += 1
                                        position += 1
                                        stone -= 1
                                    }
                                    player = (player + 1) % 2
                                    position = 5
                                    while remain > 0 {
                                        oppositepit[player][position] += 1
                                        position -= 1
                                        remain -= 1
                                    }
                                    oppositepoint += 1
                                }
                                else if(stone + index > 13){    //back to same side
                                    rremain = stone - (5 - index) - 2 - 6
                                    remain = 6
                                    stone -= (rremain + remain + 2)
                                    playerpoint += 1
                                    while stone > 0 {
                                        pits[position + 1] += 1
                                        position += 1
                                        stone -= 1
                                    }
                                    position = 0
                                    while rremain > 0 {
                                        pits[position] += 1
                                        position += 1
                                        rremain -= 1
                                    }
                                    position = 5
                                    while remain > 0 {
                                        oppositepit[(player + 1) % 2][position] += 1
                                        position -= 1
                                        remain -= 1
                                    }
                                    oppositepoint += 1
                                    if(pits[position] == 1 && oppositepit[(player + 1) % 2][position] != 0) {
                                        playerpoint += oppositepit[(player + 1) % 2][position]
                                        oppositepit[(player + 1) % 2][position] = 0
                                        playerpoint += 1
                                        pits[position] = 0
                                        player = (player + 1) % 2
                                    }
                                    player = (player + 1) % 2
                                }
                                else {
                                    remain = stone - (5 - index) - 1
                                    stone -= (remain + 1)
                                    playerpoint += 1
                                    while stone > 0 {
                                        pits[position + 1] += 1
                                        position += 1
                                        stone -= 1
                                    }
                                    player = (player + 1) % 2
                                    position = 5
                                    while remain > 0 {
                                        oppositepit[player][position] += 1
                                        position -= 1
                                        remain -= 1
                                    }
                                }
                            }
                            else if(player == 1 && pits[index] > 0 && player == pitsnum) {   //player 2
                                position = index
                                stone = pits[index]
                                pits[index] = 0
                                if(stone - index < 0) {
                                    while stone > 0 {
                                        pits[position - 1] += 1
                                        position -= 1
                                        stone -= 1
                                    }
                                    if(pits[position] == 1 && oppositepit[(player + 1) % 2][position] != 0) {
                                        playerpoint += oppositepit[(player + 1) % 2][position]
                                        oppositepit[(player + 1) % 2][position] = 0
                                        playerpoint += 1
                                        pits[position] = 0
                                        player = (player + 1) % 2
                                    }
                                    player = (player + 1) % 2
                                }
                                else if(stone - index == 1) {
                                    playerpoint += 1
                                    stone -= 1
                                    while stone > 0 {
                                        pits[position - 1] += 1
                                        position -= 1
                                        stone -= 1
                                    }
                                    player = (player + 1) % 2
                                }
                                else if(stone - index == 8){
                                    remain = stone - index - 2
                                    stone -= (remain + 2)
                                    playerpoint += 1
                                    while stone > 0 {
                                        pits[position - 1] += 1
                                        position -= 1
                                        stone -= 1
                                    }
                                    player = (player + 1) % 2
                                    position = 0
                                    while remain > 0 {
                                        oppositepit[player][position] += 1
                                        position += 1
                                        remain -= 1
                                    }
                                    oppositepoint += 1
                                }
                                else if(stone - index > 8){
                                    remain = 6
                                    rremain = stone - remain - 2 - index
                                    stone = index
                                    playerpoint += 1
                                    while stone > 0 {
                                        pits[position - 1] += 1
                                        position -= 1
                                        stone -= 1
                                    }
                                    position = 5
                                    while rremain > 0 {
                                        pits[position] += 1
                                        position -= 1
                                        rremain -= 1
                                    }
                                    player = (player + 1) % 2
                                    position = 0
                                    while remain > 0 {
                                        oppositepit[player][position] += 1
                                        position += 1
                                        remain -= 1
                                    }
                                    oppositepoint += 1
                                    if(pits[position] == 1 && oppositepit[(player + 1) % 2][position] != 0) {
                                        playerpoint += oppositepit[(player + 1) % 2][position]
                                        oppositepit[(player + 1) % 2][position] = 0
                                        playerpoint += 1
                                        pits[position] = 0
                                        player = (player + 1) % 2
                                    }
                                    player = (player + 1) % 2
                                }
                                else {
                                    remain = stone - index - 1
                                    stone -= (remain + 1)
                                    playerpoint += 1
                                    while stone > 0 {
                                        pits[position - 1] += 1
                                        position -= 1
                                        stone -= 1
                                    }
                                    player = (player + 1) % 2
                                    position = 0
                                    while remain > 0 {
                                        oppositepit[player][position] += 1
                                        position += 1
                                        remain -= 1
                                    }
                                }
                            }
                        }
                    Text("\(pits[index])")
                        .font(.title2)
                }
            }
            Spacer()
        }
    }
}

struct MancalaPitView: View {
    @Binding var point: Int
    @Binding var playernow: Int
    let player: Int
    var body: some View {
        VStack {
            Text("\(point)")
                .font(.title)
            Capsule()
                .background(
                    Image("pitbackground")
                        .resizable()
                        .frame(width: 85, height: 270)
                        .scaledToFill()
                        .clipShape(Capsule())
                )
                .foregroundColor(.gray.opacity(0))
                .frame(width: 85, height: 270)
                .overlay(
                    Capsule()
                        .stroke(player == 0 ? Color.green : Color.blue, lineWidth: 7)
                )
            if(player == 0){
                Text("Player 1")
                    .font(.title)
                    .foregroundColor(playernow == 0 ? Color.red : Color.black)
            }
            else{
                Text("Player 2")
                    .font(.title)
                    .foregroundColor(playernow == 1 ? Color.red : Color.black)
            }
            
        }
    }
}
extension Array {
    func optionalElement(at index: Int) -> Element? {
        if index < count && index >= 0 {
            return self[index]
        } else {
            return nil
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .previewInterfaceOrientation(.landscapeLeft)
    }
}
