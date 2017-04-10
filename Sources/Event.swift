import Foundation

public struct Event {
    public var subComponents = [IcsElement]()
    public var otherAttrs = [String:String]()

    // required
    public var uid: String!
    public var dtstamp: Date!

    // optional
    // public var organizer: Organizer? = nil
    public var location: String?
    public var summary: String?
    public var descr: String?
    // public var class: some enum type?
    public var dtstart: Date?
    public var dtend: Date?

    public init(uid: String? = NSUUID().uuidString, dtstamp: Date? = Date()) {
        self.uid = uid
        self.dtstamp = dtstamp
    }
}

extension Event: IcsElement {
    public mutating func addAttribute(attr: String, _ value: String) {
        switch attr {
        case "UID":
            uid = value
        case "DTSTAMP":
            dtstamp = iCal.dateFromString(value)
        case "DTSTART":
            dtstart = iCal.dateFromString(value)
        case "DTEND":
            dtend = iCal.dateFromString(value)
        // case "ORGANIZER":
        //     organizer
        case "SUMMARY":
            summary = value
        case "DESCRIPTION":
            descr = value
        default:
            otherAttrs[attr] = value
        }
    }

    public func toCal() -> String {
        var str = "BEGIN:VEVENT\n"

        if let uid = uid {
            str += "UID:\(uid)\n"
        }

        if let dtstamp = dtstamp {
            str += "DTSTAMP:\(iCal.stringFromDate(dtstamp))\n"
        }

        if let summary = summary {
            str += "SUMMARY:\(summary)\n"
        }

        if let descr = descr {
            str += "DESCRIPTION:\(descr)\n"
        }

        if let dtstart = dtstart {
            str += "DTSTART:\(iCal.stringFromDate(dtstart))\n"
        }

        if let dtend = dtend {
            str += "DTEND:\(iCal.stringFromDate(dtend))\n"
        }

        for (key, val) in otherAttrs {
            str += "\(key):\(val)\n"
        }

        for component in subComponents {
            str += "\(component.toCal())\n"
        }

        str += "END:VEVENT"
        return str
    }
}

extension Event: Equatable {}

public func ==(lhs: Event, rhs: Event) -> Bool {
    return lhs.uid == rhs.uid
}

extension Event: CustomStringConvertible {
    public var description: String {
        return "\(iCal.stringFromDate(dtstamp)): \(summary ?? "")"
    }
}
