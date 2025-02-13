//
//  MeetingDetailsView.swift
//  TakeHomeExercise
//
//  Created by Alexey L on 1/30/24.
//

import SwiftUI


// Shows a list of meetings.
struct MeetingListView: View {
    let mr: MeetingResponse
    let infoWidth: Double
    
    var body: some View {
        VStack(alignment: .leading) {
            ForEach(0..<mr.data[0].count, id: \.self) { i in
                let meeting = mr.data[0][i]
                MeetingDetailsView(index: i, meeting: meeting, infoWidth: infoWidth)
            }
        }
        .toolbar {
            ToolbarItemGroup(placement: ToolbarItemPlacement.bottomBar) {
                VStack {
                    HStack {
                        Text("Event count: \(mr.data[0].count)")
                    }
                    .padding(.horizontal)
                    .frame(maxWidth: .infinity, alignment: .leading)
                }
            }
        } // TOOLBAR
    }
}





//struct MeetingDetailsView_Previews: PreviewProvider {
//    static var previews: some View {
//        MeetingDetailsView()
//    }
//}
