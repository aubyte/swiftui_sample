//
//  AircoverAPI.swift
//  TakeHomeExercise
//
//  Created by Alexey L on 1/28/24.
//

import SwiftUI


// Marks response data as the one that can be passed back to UI (in callback).
protocol AircoverResponse {}


// MARK: - AUTHENTICATION DATA STRUCTURES


// Login info is sent to authenticate with the server.
struct LoginRequest: Codable {
    let username: String
    let password: String
    let magic_token: Bool
} // LOGIN REQUEST


// Data component of the received login info, on success.
struct LoginData: Codable {
    let access_token: String
    let refresh_token: String
    let magic_token: String

    let account_verified: Bool

    let customer_org_list: [String]
    
    // Linked features.
    let google_linked: Bool
    let google_scopes_need_update: Bool
    let zoom_linked: Bool
    let sfdc_linked: Bool
    let highspot_linked: Bool
    let ms_linked: Bool
    
    // Unused
    // expirations.
} // LOGIN DATA RESPONSE


// Login info is received after successful login request.
struct LoginResponse: Codable, AircoverResponse {
    let data: [LoginData]
    // Unused
    // let meta: []
} // LOGIN RESPONSE



// MARK: - MEETING DATA STRUCTURES

// Attendee component of a meeting.
struct Attendee: Codable {
    let company: String?
    let email: String?
    let name: String?
//    let zoom_user_id: String?
//    let in_meeting: Bool
} // ATTENDEE DATA

// Conference bridge component of a meeting.
struct ConferenceBridge: Codable {
    let country: String?
    let number: String?
    let passcode: String?
}

// Meeting info.
struct Meeting: Codable {
    let id: String?
    let attendees: [Attendee]
    let description: String?
    let start_time: String?
    let end_time: String?
    let room: String?
    let location: String?
    let owner: String?
    let summary: String?
    let conference_bridges: [ConferenceBridge]
    let customer: String?
    let allowed_org_list: [String]
    let prospect: String?
    let external_owner: String?
    let should_transcribe: Bool
    let customer_summary: String?
    let language: String?
    let last_updated: String?
} // MEETING DATA


// Collection of meeting info is received after meeting request.
struct MeetingResponse: Codable, AircoverResponse {
    let data: [[Meeting]]
    // Unused
    // let meta: []
}




// MARK: - AIRCOVER API



// Static API to communicate with Aircover servers.
// Requests are non-blocking asynchronous, using callbacks to return response data on main thread.
// 1. Authenticate with the server once. Then check authentication (expiration) in response info.
// 2. Retrieve a list of meeting events. Provide authentication token.
struct AircoverAPI {
    static let API_ROOT = "https://api.aircover.ai"
    static let LOGIN_ENDPOINT = "/auth/login/"
    static let MEETINGS_ENDPOINT = "/meetings/"
    
    static let LOGIN_PATH = API_ROOT + LOGIN_ENDPOINT
    static let MEETINGS_PATH = API_ROOT + MEETINGS_ENDPOINT
    
    
    
    
    // Send authentication request. Auth info/error is returned in a provided callback.
    // Callback parameters:
    //   - a valid login data, if no errors.
    //   - an error message otherwise.
    // Returns a cancellable task if request is successful.
    static func authenticate(loginRequest: LoginRequest,
                             callback: @escaping (AircoverResponse?, String?) -> Void) -> URLSessionDataTask? {

        guard let requestData = try? JSONEncoder().encode(loginRequest) else { return nil }
        guard let loginURL = URL(string: LOGIN_PATH) else { return nil }

        // 1. Set up a POST request.
        
        var request = URLRequest(url: loginURL, timeoutInterval: 10)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = requestData
        
        // 2. Prepare task to run, attach code to check response for errors before invoking callback on main thread.
        
        let task = makeTask(request: request,
                            decodableType: LoginResponse.self,
                            callback: callback)
        
        return task
    } // FUNC AUTHENTICATE
    
    
    
    
    // Send meeting info request. Meeting info/error is returned in a provided callback.
    // Callback parameters:
    //   - a collection of meeting info, if no errors.
    //   - an error message otherwise.
    // Returns a cancellable task if request is successful.
    static func getMeetingInfo(startDate: Date, endDate: Date, authToken: String,
                             callback: @escaping (AircoverResponse?, String?) -> Void) -> URLSessionDataTask? {

        // Convert dates to strings.
        let startDateISO = startDate.ISO8601Format()
        let endDateISO = endDate.ISO8601Format()
        let authorization = "Bearer " + authToken

        // URL for meetins endpoint uses query items as parameters.
        guard var urlComponents = URLComponents(string: MEETINGS_PATH) else { return nil }
        urlComponents.queryItems = [
            .init(name: "start", value: startDateISO),
            .init(name: "end", value: endDateISO),
        ]
        guard let meetingsURL = urlComponents.url else { return nil }
        
        print(meetingsURL.description)
        
        // 1. Set up a GET request.
        
        var request = URLRequest(url: meetingsURL, timeoutInterval: 10)
        request.httpMethod = "GET"
        request.setValue(authorization, forHTTPHeaderField: "Authorization")

        // 2. Prepare task to run, attach code to check response for errors before invoking callback on main thread.
        
        let task = makeTask(request: request,
                            decodableType: MeetingResponse.self,
                            callback: callback)
        
        return task
    } // FUNC GET MEETING INFO
    
    
    
    
    // Creates URL session task with a callback to handle common HTTP errors.
    // When response is received the parameter callback is posted to the main thread.
    // Resumes the task before returning it.
    private static func makeTask<T>(request: URLRequest,
                            decodableType: T.Type,
                            callback: @escaping (AircoverResponse?, String?) -> Void) -> URLSessionDataTask?
    where T : Decodable, T : AircoverResponse {
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            
            // Check response for errors and pass data back to caller.
            
            if let error = error {
                DispatchQueue.main.async { callback(nil, error.localizedDescription) }
            }
            else if let response = response as? HTTPURLResponse, response.statusCode != 200 {
                DispatchQueue.main.async { callback(nil, "Server error, HTTP code: \(response.statusCode)") }
            }
            else if let data = data {
                let decoder = JSONDecoder()
                if let loginResponse = try? decoder.decode(decodableType, from: data) {
                    DispatchQueue.main.async { callback(loginResponse, nil) }
                } else {
                    DispatchQueue.main.async { callback(nil, "JSON decoder error.") }
                }
            }
        } // DATA TASK
        
        // Run the task (non-blocking).
        
        task.resume()
        return task
    } // FUNC MAKE TASK
    
    
    
} // API

