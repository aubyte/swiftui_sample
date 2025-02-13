//
//  MeetingView.swift
//  TakeHomeExercise
//
//  Created by Alexey L on 1/30/24.
//

import SwiftUI


// Shows minimum user details on a navigation link.
struct MeetingViewNavLink: View {
    @ObservedObject var meetingContext: MeetingContext
    
    var body: some View {
        HStack {
            Image(systemName: "calendar").resizable().scaledToFit()
                .padding()
                .foregroundColor(.gray)
            
            VStack {
                Text(meetingContext.startDate.formatted(date: .numeric, time: .shortened))
                Text(meetingContext.endDate.formatted(date: .numeric, time: .shortened))
            }
            .lineLimit(1)
            .font(.footnote)
            .frame(maxWidth: .infinity, alignment: .leading)
        }
        .padding(.horizontal)
    }
} // LOGIN VIEW NAV LINK



// Main meetings view, with a scrolable area. Contains sections:
// - to enter date interval,
// - a button to init/cancel a query,
// - a list view with meeting details returned by a server.
struct MeetingView: View {
    @EnvironmentObject var userContext: UserContext
    @ObservedObject var meetingContext: MeetingContext
    
    @State var startDate = Date()
    @State var endDate = Date()
    
    var body: some View {
        GeometryReader { geo in
            
            let imageSize = geo.size.width * Resources.Login.USER_IMAGE_SIZE
            let pickerWidth = geo.size.width * Resources.Login.TEXT_FIELD_WIDTH
            let infoWidth = geo.size.width
            let labelWidth = infoWidth * 0.2
            
            ScrollView(.vertical) {
                VStack {

                    
                    // 1. Calendar image, start/end date pickers.
                    
                    HStack {
                        Image(systemName: "calendar").resizable().scaledToFit()
                            .frame(width: imageSize, height: imageSize)
                            .foregroundColor(.gray)
                        
                        VStack(alignment: .leading) {
                            VStack(alignment: .leading) {
                                HStack {
                                    Text("Start date:")
                                        .padding(.horizontal)
                                        .padding(.vertical, 10)
                                        .frame(width: labelWidth, alignment: .trailing)
                                    DatePicker(selection: $startDate, displayedComponents: [.date, .hourAndMinute]) {
                                        Image(systemName: "calendar.badge.clock").resizable().scaledToFit()
                                            .frame(width: 24, height: 24)
                                            .foregroundColor(.gray)
                                    }
                                        .datePickerStyle(.compact)
                                        .padding(.horizontal)
                                        .padding(.vertical, 10)
                                        .frame(width: pickerWidth, alignment: .trailing)
                                        .background {
                                            RoundedRectangle(cornerRadius: 10).fill(.tertiary.opacity(0.5))
                                        }
                                        .frame(alignment: .trailing)
                                }
                                HStack {
                                    Text("End date:")
                                        .padding(.horizontal)
                                        .padding(.vertical, 10)
                                        .frame(width: labelWidth, alignment: .trailing)
                                    DatePicker(selection: $endDate, displayedComponents: [.date, .hourAndMinute]) {
                                        Image(systemName: "calendar.badge.clock").resizable().scaledToFit()
                                            .frame(width: 24, height: 24)
                                            .foregroundColor(.gray)
                                    }
                                        .datePickerStyle(.compact)
                                        .padding(.horizontal)
                                        .padding(.vertical, 10)
                                        .frame(alignment: .leading)
                                        .frame(width: pickerWidth, alignment: .trailing)
                                        .background {
                                            RoundedRectangle(cornerRadius: 10).fill(.tertiary.opacity(0.5))
                                        }
                                        .frame(alignment: .trailing)
                                }
                            } // VSTACK
                            .opacity(userContext.meetingRequestInProgress ? 0.25 : 1)
                            .disabled(userContext.meetingRequestInProgress)
                            

                            // 2. A query button.
                            
                            HStack {
                                HStack {
                                    Group {
                                        if userContext.meetingRequestInProgress {
                                            ProgressView()
                                                .progressViewStyle(.circular)
                                        } else if let errorMessage = userContext.meetingErrorMessage {
                                            Text(errorMessage)
                                                .foregroundColor(.red)
                                        } else if meetingContext.meetingResponse != nil {
                                            Image(systemName: "checkmark.icloud").resizable().scaledToFit()
                                                .frame(width: 24, height: 24)
                                                .foregroundColor(.green)
                                        }
                                    }
                                    .transition(.opacity.combined(with: .scale))
                                }
                                .padding()
                                .frame(width: labelWidth, alignment: .trailing)
                                
                                Button {
                                    if userContext.meetingRequestInProgress {
                                        userContext.cancelMeetingQuery()
                                    } else {
                                        userContext.initiateMeetingsRequest(startDate: startDate, endDate: endDate)
                                    }
                                } label: {
                                    Text(userContext.meetingRequestInProgress ? "Cancel" : "Get Events")
                                        .padding()
                                        .frame(width: pickerWidth)
                                        .background {
                                            RoundedRectangle(cornerRadius: 10).fill(.tertiary)
                                        }
                                        .frame(alignment: .trailing)
                                }
                            }
                        } // VSTACK
                    } // HSTACK
                    .padding()

                    

                    // 3. Meeting response info.
                    
                    if let meetingResponse = meetingContext.meetingResponse {
                        VStack(alignment: .leading) {
                            MeetingListView(mr: meetingResponse, infoWidth: infoWidth)
                        }
                        .padding()
                        .background {
                            RoundedRectangle(cornerRadius: 10).fill(.tertiary.opacity(0.1))
                        }
                        .padding()
                        .frame(width: infoWidth)
                        .transition(.opacity.combined(with: .scale))
                    } // IF

                } // VSTACK
                .padding(.top)
                .animation(.easeInOut(duration: 0.2), value: userContext.meetingRequestInProgress)
            } // SCROLL VIEW
            .position(x: geo.size.width / 2, y: geo.size.height / 2)
            .onAppear {
                startDate = meetingContext.startDate
                endDate = meetingContext.endDate
            }
        } // GEO
    }
} // MEETING VIEW







//struct MeetingView_Previews: PreviewProvider {
//    static var previews: some View {
//        MeetingView()
//    }
//}
