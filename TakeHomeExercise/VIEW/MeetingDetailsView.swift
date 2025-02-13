//
//  MeetingDetailsView.swift
//  TakeHomeExercise
//
//  Created by Alexey L on 1/30/24.
//

import SwiftUI

struct MeetingDetailsView: View {
    let index: Int
    let meeting: Meeting
    let infoWidth: Double

    @State var expanded = false
    
    var body: some View {
        HStack(alignment: .firstTextBaseline) {
            Image(systemName: "chevron.right")
                .rotationEffect(.degrees(expanded ? 90 : 0))
            
            VStack(alignment: .leading) {
                InfoFieldView(name: (index + 1).description, value: meeting.owner, infoWidth: infoWidth)
                if expanded {
                    VStack {
                        VStack {
                            InfoFieldView(name: "ID:", value: meeting.id, infoWidth: infoWidth)
                            InfoFieldView(name: "Attendees:", value: meeting.attendees[0].name, infoWidth: infoWidth)
                            InfoFieldView(name: "Summary:", value: meeting.summary, infoWidth: infoWidth)
                            InfoFieldView(name: "Description:", value: meeting.description, infoWidth: infoWidth)
                            InfoFieldView(name: "Start:", value: meeting.start_time, infoWidth: infoWidth)
                            InfoFieldView(name: "End:", value: meeting.end_time, infoWidth: infoWidth)
                            InfoFieldView(name: "Room:", value: meeting.room, infoWidth: infoWidth)
                            InfoFieldView(name: "Location", value: meeting.location, infoWidth: infoWidth)
                        }
                        VStack {
                            InfoFieldView(name: "Conference bridges:", value: meeting.conference_bridges[0].number, infoWidth: infoWidth)
                            InfoFieldView(name: "Customer:", value: meeting.customer, infoWidth: infoWidth)
                            InfoFieldView(name: "Allowed org list:", value: meeting.allowed_org_list[0], infoWidth: infoWidth)
                            InfoFieldView(name: "Prospect:", value: meeting.prospect, infoWidth: infoWidth)
                            InfoFieldView(name: "Owner:", value: meeting.external_owner, infoWidth: infoWidth)
                            InfoFieldView(name: "Should transcribe:", value: meeting.should_transcribe.description, infoWidth: infoWidth)
                            InfoFieldView(name: "Customer summary:", value: meeting.customer_summary, infoWidth: infoWidth)
                            InfoFieldView(name: "Language:", value: meeting.language, infoWidth: infoWidth)
                            InfoFieldView(name: "Last updated:", value: meeting.last_updated, infoWidth: infoWidth)
                            //                    InfoFieldView(name: "", value: meeting., infoWidth: infoWidth)
                        }
                    }
                    .background {
                        RoundedRectangle(cornerRadius: 10).fill(.teal.opacity(0.1))
                    }
                    .transition(.opacity.combined(with: .move(edge: .top)))
                }
            }
        }
        .padding()
        .background {
            RoundedRectangle(cornerRadius: 10).fill(.tertiary.opacity(0.1))
        }
        .padding()
        .animation(.easeInOut, value: expanded)
        .onTapGesture {
            expanded.toggle()
        }
    }
}






//struct MeetingDetailsView_Previews: PreviewProvider {
//    static var previews: some View {
//        MeetingDetailsView()
//    }
//}
