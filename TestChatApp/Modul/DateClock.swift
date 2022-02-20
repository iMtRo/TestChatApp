import Foundation

extension Date {
    // Sorted Date Message
    func daysBetween(date: Date) -> Int {
        let calendar = Calendar.current
        let date1 = calendar.startOfDay(for: self)
        let date2 = calendar.startOfDay(for: date)
        if let daysBetween = calendar.dateComponents([.day], from: date1, to: date2).day{
            return daysBetween
        }
        return 0
    }
    // Day Month WeekDay
    func dayOfWeek(date: Date ) -> String? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "EE , MMM dd"
        
        return dateFormatter.string(from: date)
    }
    
    // Clock
    func dayOfClock(date: Date ) -> String? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "hh:mm"
        
        return dateFormatter.string(from: date).capitalized
    }
    
    
    
}


