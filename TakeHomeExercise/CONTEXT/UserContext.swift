//
//  UserContext.swift
//  TakeHomeExercise
//
//  Created by Alexey L on 1/28/24.
//

import SwiftUI


// Main app context.
// UI binds to published properties and reacts to updates.
class UserContext: ObservableObject {
    // User name and login response are set after successful login request.
    @Published var userName: String? {
        didSet {
            userImageText = userName != nil ? Resources.Login.USER_IMAGE_AUTHENTICATED : Resources.Login.USER_IMAGE_UNKNOWN
            displayName = userName ?? Resources.Login.USER_NOT_SIGNED_IN
            if userName != nil && meetings.isEmpty {
                meetings.append(MeetingContext())
            }
        }
    }
    @Published var loginResponse: LoginResponse?
    
    @Published var meetings = [MeetingContext()]
    @Published var selectedQueryTag: Int? {
        didSet {
            clearErrorMessages()
        }
    }
    
    // For UI use.
    @Published var userImageText = Resources.Login.USER_IMAGE_UNKNOWN
    @Published var displayName = Resources.Login.USER_NOT_SIGNED_IN
    
    // Use to disable controls etc.
    @Published var authenticationInProgress = false
    // Could be moved to individual meeting context
    // to enable concurrent meeting queries.
    @Published var meetingRequestInProgress = false

    // Error messages.
    @Published var authErrorMessage: String?
    @Published var meetingErrorMessage: String?
    
    
    // Cancellable tasks.
    var cancellableAuthTask: URLSessionDataTask?
    // Could be moved to individual meeting context
    // to enable concurrent meeting queries.
    var cancellableMeetingsTask: URLSessionDataTask?

    
    
    // MARK: - FUNCS
    
    // Resets error messages,
    func clearErrorMessages() {
        authErrorMessage = nil
        meetingErrorMessage = nil
    }
    
    
    // Begins async auth request.
    // Internal callback will process results.
    func initiateAuthentication(userName: String, password: String) {
        clearErrorMessages()
        
        let loginRequest = LoginRequest(username: userName,
                                        password: password,
                                        magic_token: true)

        cancellableAuthTask =
        AircoverAPI.authenticate(loginRequest: loginRequest) { response, errorText in
            self.authenticationInProgress = false
            if let errorText = errorText {
                self.authErrorMessage = errorText
                return
            }
            guard let authResponse = response as? LoginResponse else {
                self.authErrorMessage = "Unexpected authentication response."
                return
            }
            // Success, notify UI.
            self.userName = userName
            self.loginResponse = authResponse
        }
        if cancellableAuthTask == nil {
            self.authErrorMessage = "Cannot initiate authentication."
        }
        authenticationInProgress = cancellableAuthTask != nil
    } // FUNC INITIATE AUTHENTICATION

    
    
    // Updates time interval and begins async query for meetings.
    // Internal callback will process results.
    func initiateMeetingsRequest(startDate: Date, endDate: Date) {
        clearErrorMessages()
        
        guard let queryID = selectedQueryTag, queryID >= 0 && queryID < meetings.count else {
            meetingErrorMessage = "Select a meeting query, then try again."
            return
        }
        
        let meetingContext = meetings[queryID]
        meetingContext.startDate = startDate
        meetingContext.endDate = endDate
        
        guard let authToken = loginResponse?.data[0].magic_token else {
            meetingErrorMessage = "Authentication required."
            return
        }
        
        cancellableMeetingsTask =
        AircoverAPI.getMeetingInfo(startDate: startDate, endDate: endDate, authToken: authToken) { response, errorText in
            self.meetingRequestInProgress = false
            if let errorText = errorText {
                self.meetingErrorMessage = errorText
                return
            }
            guard let meetingResponse = response as? MeetingResponse else {
                self.authErrorMessage = "Unexpected meeting response."
                return
            }
            // Success, notify UI.
            meetingContext.meetingResponse = meetingResponse
        }
        if cancellableMeetingsTask == nil {
            self.meetingErrorMessage = "Cannot initiate a meeting query."
        }
        meetingRequestInProgress = cancellableMeetingsTask != nil

    } // FUNC INITIATE MEETING REQUEST
    

    // Cancel task in progress.
    func cancelAuthentication() {
        clearErrorMessages()
        cancellableAuthTask?.cancel()
    }
    
    // Cancel task in progress.
    func cancelMeetingQuery() {
        clearErrorMessages()
        cancellableMeetingsTask?.cancel()
    }
    
    
    
    // MARK: - TEST FUNCS
    
    func initiateAuthenticationTest(userName: String, password: String) {
        clearErrorMessages()
        authenticationInProgress = true
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            self.userName = userName
            self.loginResponse = nil
            self.authenticationInProgress = false
        }
    } // FUNC INITIATE AUTH TEST
    
    func cancelAuthenticationTest() {
        // No actual task to cancel.
        authErrorMessage = "Cancelled by user. And some lengthy text to fill in this error message."
    } // FUNC CANCEL TEST
    

} // USER CONTEXT

