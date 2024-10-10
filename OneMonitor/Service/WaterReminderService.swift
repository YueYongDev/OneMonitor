//
//  WaterReminderService.swift
//  OneMonitor
//
//  Created by 梁越勇 on 2024/10/10.
//

import Foundation

import Foundation

struct ChatAPIResponse: Codable {
    let choices: [Choice]
    
    struct Choice: Codable {
        let message: Message
        
        struct Message: Codable {
            let role: String
            let content: String
        }
    }
}

func sendMessageToDeepSeekAPI(userMessage: String, completion: @escaping (String?) -> Void) {
    guard let url = URL(string: "https://api.deepseek.com/chat/completions") else {
        print("Invalid URL")
        completion(nil)
        return
    }
    
    let apiKey = "sk-304dde750fab4ceaaea53afc1139997d" // 替换为你的 API Key
    
    let parameters: [String: Any] = [
        "model": "deepseek-chat",
        "messages": [
            ["role": "system", "content": "You are a helpful assistant."],
            ["role": "user", "content": userMessage]
        ],
        "stream": false
    ]
    
    // Convert parameters to JSON
    guard let jsonData = try? JSONSerialization.data(withJSONObject: parameters, options: []) else {
        print("Failed to serialize JSON")
        completion(nil)
        return
    }

    var request = URLRequest(url: url)
    request.httpMethod = "POST"
    request.setValue("application/json", forHTTPHeaderField: "Content-Type")
    request.setValue("Bearer \(apiKey)", forHTTPHeaderField: "Authorization")
    request.httpBody = jsonData
    
    let task = URLSession.shared.dataTask(with: request) { data, response, error in
        if let error = error {
            print("Error: \(error.localizedDescription)")
            completion(nil)
            return
        }
        
        guard let data = data else {
            print("No data received")
            completion(nil)
            return
        }
        
        // Parse the API response
        do {
            let apiResponse = try JSONDecoder().decode(ChatAPIResponse.self, from: data)
            let replyMessage = apiResponse.choices.first?.message.content
            completion(replyMessage)
        } catch {
            print("Failed to decode JSON: \(error.localizedDescription)")
            completion(nil)
        }
    }
    
    task.resume()
}
