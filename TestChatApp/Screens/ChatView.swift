import SwiftUI

struct ChatView: View {
    
    @EnvironmentObject var viewModel: chatsViewModel
    let chat: Chat
    @State private var text = ""
    @FocusState private var isFocused
    @State private var messageIDScrool: UUID?
    
    let date = Date()
    let chats = Chat.sampleChat
    
    var body: some View {
        
        NavigationView{
            VStack(spacing: 0){
                GeometryReader{ reader in
                    ScrollView{
                        ScrollViewReader{ scroolViewReader in
                            getMessagesView(viewWidth: reader.size.width)
                                .padding(.horizontal)
                                .onChange(of: messageIDScrool){_ in
                                    if let messageId = messageIDScrool {
                                        scrollTo(messageId: messageId, shouldAnimate: true, scrollReader: scroolViewReader)
                                    }
                                }
                                .onAppear{
                                    if let messageID = chat.messages.last?.id {
                                        scrollTo(messageId: messageID, anchor: .bottom, shouldAnimate: false, scrollReader: scroolViewReader)
                                    }
                                }
                        }
                    }
                }
                .padding(.bottom, 5)
                
                // Tool Bar
                toolBarView()
            }
            .navigationBarTitle("Test Chat Application",displayMode: .inline)
        }
        
    }
    
    func scrollTo(messageId: UUID, anchor: UnitPoint? = nil, shouldAnimate: Bool, scrollReader: ScrollViewProxy){
        DispatchQueue.main.async {
            withAnimation(shouldAnimate ? Animation.easeIn : nil){
                scrollReader.scrollTo(messageId, anchor: anchor)
            }
        }
    }
    
    // ToolBar View
    func toolBarView() -> some View {
        VStack{
            HStack{}.frame(height: 1).frame(maxWidth: .infinity).background(Color.gray.opacity(0.4))
            
            VStack{
                let height: CGFloat = 40
                HStack{
                    TextField("Message ...", text: $text)
                        .padding(.horizontal,10)
                        .frame( height: height)
                        .background(Color.white)
                        .clipShape(RoundedRectangle(cornerRadius: 20))
                        .overlay(RoundedRectangle(cornerRadius: 20).stroke(Color.gray.opacity(0.4),lineWidth: 1))
                        .focused($isFocused)
                    
                    Image("Shape")
                        .font(.system(size: 23))
                    
                    Button(action: sentMessage){
                        Image(systemName: "paperplane.fill")
                            .font(.system(size: 22))
                            .frame(width: height, height: height)
                            .foregroundColor(text.isEmpty ? .blue : .white)
                            .background(Circle().foregroundColor(text.isEmpty ? .white : .blue))
                    }.disabled(text.isEmpty)
                }
            }
            .padding(.horizontal)
            .padding(.vertical)
        }
        .background(.white)
    }
    
    // Sent Message
    func sentMessage(){
        if let message = viewModel.sentMessage(text, in: chat) {
            text = ""
            messageIDScrool = message.id
        }
    }
    
    // Person Image
    func PersonImage() -> some View {
        Image("person")
            .resizable()
            .scaledToFill()
            .frame(width: 35, height: 35)
            .cornerRadius(40)
    }
    
    // Person Name
    func PersonName() -> some View {
        Text(chat.person.name)
            .font(.system(size: 13))
            .padding(.leading, 5)
            .foregroundColor(Color.blue)
    }
    
    // Chat Message
    let columns = [GridItem(.flexible(minimum: 10))]
    func getMessagesView(viewWidth: CGFloat) -> some View {
        LazyVGrid(columns: columns, spacing: 0, pinnedViews: [.sectionHeaders] ){
            
            let sectionMessages = viewModel.getSectionMessage(for: chat)
            
            ForEach(sectionMessages.indices, id: \.self){ sextionIndex in
                
                let messages = sectionMessages[sextionIndex]
                
                Section(header: sectionHeaders(firstMessage: messages.first!)){
                    
                    ForEach(messages){message in
                        let isReceived = message.type == .Received
                        HStack{
                            ZStack{
                                HStack{
                                    isReceived ? PersonImage() : nil
                                    HStack{
                                        VStack{
                                            HStack{
                                                isReceived ? PersonName() : nil
                                                Spacer()
                                            }
                                            HStack{
                                                Text(message.text)
                                                    .font(.system(size: 15))
                                                Spacer()
                                            }
                                        }
                                        
                                        HStack(spacing: 2){
                                            Text(message.date.dayOfClock(date: message.date)!)
                                                .font(.system(size: 15))
                                                .foregroundColor(Color.gray)
                                            
                                            isReceived ? nil : Image("check")
                                                .resizable()
                                                .scaledToFit()
                                                .frame(width: 20, height: 20)
                                        }
                                        .padding(10)
                                        .padding(.trailing, -10)
                                        .padding(.bottom,-25)
                                    }
                                    .padding(.horizontal)
                                    .padding(.vertical,13)
                                    .background(isReceived ? Color.white : Color.green.opacity(0.3))
                                    .cornerRadius(13)
                                    .shadow(color: Color.black.opacity(0.2), radius: 2, x: 0, y: 0)
                                }
                            }
                            .frame(width: viewWidth * 0.7, alignment: isReceived ? .leading : .trailing)
                            .padding(.vertical)
                        }
                        .frame(maxWidth: .infinity, alignment: isReceived ? .leading : .trailing)
                        .id(message.id)
                    }
                }
            }
        }
    }
    
    // Message Data
    func sectionHeaders(firstMessage message: Message) -> some View {
        ZStack{
            Text(message.date.dayOfWeek(date: message.date)!)
                .foregroundColor(Color.black.opacity(0.7))
                .font(.system(size: 14, weight: .regular))
                .frame(width: 120)
                .padding(.vertical,5)
                .background(Color.gray.opacity(0.4))
                .cornerRadius(10)
        }
        .padding(.vertical,5)
        .frame(maxWidth: .infinity)
    }
}

struct ChatView_Previews: PreviewProvider {
    static var previews: some View {
        ChatView(chat: Chat.sampleChat[0])
            .environmentObject(chatsViewModel())
    }
}

