//
//  MeetingContext.swift
//  TakeHomeExercise
//
//  Created by Alexey L on 1/28/24.
//

import SwiftUI


// Meeting info (query and results) sent to/received from Aircover.
// User must be signed in. See UserContext.
class MeetingContext: ObservableObject {
    
    @Published var startDate = Date()
    @Published var endDate = Calendar.current.date(byAdding: .month, value: 1, to: Date()) ?? Date()
    
    @Published var meetingResponse: MeetingResponse?
    
} // REQUEST CONTEXT

