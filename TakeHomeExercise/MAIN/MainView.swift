//
//  MainView.swift
//  TakeHomeExercise
//
//  Created by Alexey L on 1/28/24.
//

import SwiftUI



// Top-level navigation split-view.
// Side-bar is collapsible. On macOS and iPad can show two panels (list and details) simultaneously.
// UserContext instance is driving UI updates and reacts to user input.
struct MainView: View {

    let title = "Aircover.ai"
    
    @StateObject var userContext = UserContext()
    
    var body: some View {
        VStack {
            
            NavigationView {
                List {
                    EmptyView()
                        .padding()
                    NavigationLink(tag: -1, selection: $userContext.selectedQueryTag) {
                        SignInView()
                    } label: {
                        SignInViewNavLink()
                            .frame(height: 50)
                    }
                    .padding()
                    .listRowSeparator(.hidden)
                    Divider()

                    ForEach(0..<userContext.meetings.count, id: \.self) { i in
                        let meetingContext = userContext.meetings[i]
                        NavigationLink(tag: i, selection: $userContext.selectedQueryTag) {
                            MeetingView(meetingContext: meetingContext)
                        } label: {
                            MeetingViewNavLink(meetingContext: meetingContext)
                                .frame(height: 50)
                        }
                        .listRowSeparator(.hidden)
                    }
                } // LIST
                .listStyle(.grouped)
                .navigationTitle(title)
                .toolbar {
                    ToolbarItemGroup(placement: ToolbarItemPlacement.bottomBar) {
                        VStack {
                            Divider()
                            HStack {
                                Button {
                                    userContext.meetings.append(MeetingContext())
                                    userContext.selectedQueryTag = userContext.meetings.count - 1
                                } label: {
                                    Image(systemName: "plus.circle")
                                }
                                .frame(alignment: .leading)
                                Button {
                                    if let i = userContext.selectedQueryTag {
                                        if i == userContext.meetings.count - 1 {
                                            userContext.selectedQueryTag? -= 1
                                        }
                                        userContext.meetings.remove(at: i)
                                    }
                                } label: {
                                    Image(systemName: "minus.circle")
                                }
                                .frame(alignment: .leading)
                                .disabled((userContext.selectedQueryTag ?? -1) < 0)
                                Text("count: \(userContext.meetings.count)")
                            }
                            .frame(maxWidth: .infinity, alignment: .leading)
                        }
                    }
                } // TOOLBAR
            } // NAVIGATION VIEW

        }
        .environmentObject(userContext)
    }
} // MAIN VIEW






//struct ContentView_Previews: PreviewProvider {
//    static var previews: some View {
//        MainView()
//    }
//}
