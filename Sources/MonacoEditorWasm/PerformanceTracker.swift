import JavaScriptKit

// MARK: - Performance Monitor
struct PerformanceTracker {
    nonisolated(unsafe) static var parseTimes: [Double] = []
    nonisolated(unsafe) static var completionTimes: [Double] = []
    nonisolated(unsafe) static var hoverTimes: [Double] = []
    
    static func updateParseMetrics(duration: Double) {
        parseTimes.append(duration)
        if parseTimes.count > 100 { parseTimes.removeFirst() }
        
        let avg = parseTimes.reduce(0, +) / Double(parseTimes.count)
        let percentage = min(100, (duration / 1000.0) * 100) // Scale: 1s = 100%
        
        updateMonitor(
            timeId: "parse-time",
            barId: "parse-bar",
            countId: "parse-count",
            avgId: "avg-parse",
            duration: duration,
            count: parseTimes.count,
            average: avg,
            percentage: percentage
        )
    }
    
    static func updateCompletionMetrics(duration: Double) {
        completionTimes.append(duration)
        if completionTimes.count > 100 { completionTimes.removeFirst() }
        
        let avg = completionTimes.reduce(0, +) / Double(completionTimes.count)
        let percentage = min(100, (duration / 50.0) * 100) // Scale: 50ms = 100%
        
        updateMonitor(
            timeId: "completion-time",
            barId: "completion-bar",
            countId: "completion-count",
            avgId: "avg-completion",
            duration: duration,
            count: completionTimes.count,
            average: avg,
            percentage: percentage
        )
    }
    
    static func updateHoverMetrics(duration: Double) {
        hoverTimes.append(duration)
        if hoverTimes.count > 100 { hoverTimes.removeFirst() }
        
        let percentage = min(100, (duration / 50.0) * 100) // Scale: 50ms = 100%
        
        updateMonitor(
            timeId: "hover-time",
            barId: "hover-bar",
            countId: "hover-count",
            avgId: nil,
            duration: duration,
            count: hoverTimes.count,
            average: nil,
            percentage: percentage
        )
    }
    
    private static func updateMonitor(
        timeId: String,
        barId: String,
        countId: String,
        avgId: String?,
        duration: Double,
        count: Int,
        average: Double?,
        percentage: Double
    ) {
        let document = JSObject.global.document
        
        // Update time display
        if let timeEl = document.getElementById(timeId).object {
            timeEl.textContent = .string(String(format: "%.1fms", duration))
        }
        
        // Update bar
        if let barEl = document.getElementById(barId).object {
            barEl.style.width = .string("\(Int(percentage))%")
            
            // Update color based on performance
            _ = barEl.classList.remove("warning")
            _ = barEl.classList.remove("danger")
            if percentage > 80 {
                _ = barEl.classList.add("danger")
            } else if percentage > 50 {
                _ = barEl.classList.add("warning")
            }
        }
        
        // Update count
        if let countEl = document.getElementById(countId).object {
            countEl.textContent = .string("\(count)")
        }
        
        // Update average if provided
        if let avgId = avgId, let avg = average {
            if let avgEl = document.getElementById(avgId).object {
                avgEl.textContent = .string(String(format: "%.1fms", avg))
            }
        }
    }
}

func measureTime<T>(_ operation: () -> T) -> (result: T, duration: Double) {
    let start = JSObject.global.performance.now().number ?? 0
    let result = operation()
    let end = JSObject.global.performance.now().number ?? 0
    return (result, end - start)
}
