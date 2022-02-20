import Foundation

class chatsViewModel: ObservableObject {
    
    @Published var chats = Chat.sampleChat
    
    func getSortedFilteredChats(query: String ) -> [Chat]{
        let sortedChat = chats.sorted {
            guard let date1 = $0.messages.last?.date else { return false }
            guard let date2 = $1.messages.last?.date else { return false }
            return date1 > date2
        }
        
        if query == "" {
            return sortedChat
        }
        
        return sortedChat.filter{ $0.person.name.lowercased().contains(query.lowercased()) }
    }
    
    func getSectionMessage(for chat: Chat) -> [[Message]] {
        
        var res = [[Message]]()
        var tmp = [Message]()
        for message in chat.messages {
            if let firstMessage = tmp.first {
                let daysBettwen = firstMessage.date.daysBetween(date: message.date)
                if daysBettwen >= 1 {
                    res.append(tmp)
                    tmp.removeAll()
                    tmp.append(message)
                }else{
                    tmp.append(message)
                }
            }else {
                tmp.append(message)
            }
        }
        res.append(tmp)
        
        return res
        
    }
    
    
    func sentMessage(_ text: String, in chat: Chat) -> Message? {
        
        if let index = chats.firstIndex(where: { $0.id == chat.id }) {
            let message = Message(text, type: .Sent, date: Date())
            chats[index].messages.append(message)
            return message
        }
        return nil
    }
    
}
