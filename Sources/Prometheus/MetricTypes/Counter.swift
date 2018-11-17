public class Counter<NumType: Numeric, Labels: MetricLabels>: Metric {
    public let name: String
    public let help: String?
    
    internal var value: NumType

    internal var metrics: [Labels: NumType] = [:]
    
    public init(_ name: String, _ help: String? = nil, _ initialValue: NumType = 0) {
        self.name = name
        self.help = help
        self.value = initialValue
    }
    
    public func getMetric() -> String {
        var output = [String]()
        
        if let help = help {
            output.append("# HELP \(name) \(help)")
        }
        
        output.append("# TYPE \(name) counter")
        output.append("\(name) \(value)")

        metrics.forEach { (labels, value) in
            let labelsString = encodeLabels(labels)
            output.append("\(name)\(labelsString) \(value)")
        }
        
        return output.joined(separator: "\n")
    }
    
    @discardableResult
    public func inc(_ amount: NumType = 1, _ labels: Labels? = nil) -> NumType {
        if let labels = labels {
            var val = self.metrics[labels] ?? 0
            val += amount
            self.metrics[labels] = val
            return val
        } else {
            self.value += amount
            return self.value
        }
    }
    
    public func get(_ labels: Labels? = nil) -> NumType {
        if let labels = labels {
            return self.metrics[labels] ?? 0
        } else {
            return self.value
        }
    }
}

