import Foundation

struct Chat: Identifiable {
    var id: UUID{ person.id }
    let person: Person
    var messages: [Message]
}

struct Person: Identifiable {
    let id = UUID()
    let name: String
    let imgString: String
}

struct Message: Identifiable {
    
    enum MessageType {
        case Sent, Received
    }
    
    let id = UUID()
    let date: Date
    let text: String
    let type: MessageType
    
    init (_ text: String, type: MessageType, date: Date){
        self.date = date
        self.type = type
        self.text = text
    }
    
    init (_ text: String, type: MessageType) {
        self.init(text, type: type, date: Date())
    }
}

extension Chat {
    
    static let sampleChat = [
        Chat(person: Person(name: "iMtRo", imgString: "person"), messages: [
                Message("I will write from Japan", type: .Sent, date: Date(timeIntervalSinceNow: (-86400 * 5)-20324)),
                Message("Do you know what time is it?", type: .Received, date: Date(timeIntervalSinceNow: -86400 * 5)-15344),
                Message("Do you know what time is it?", type: .Received, date: Date(timeIntervalSinceNow: -86400 * 5)-12404),
                Message("Good bye!", type: .Sent, date: Date(timeIntervalSinceNow: -20000)),
                
              ]),
    ]
}
