
// MARK: - Editor Action

/// An action contribution
public struct IEditorAction: Codable, Sendable {
    /// The action ID
    public let id: String
    /// The action label
    public let label: String
    /// An optional alias
    public let alias: String?
    
    public init(id: String, label: String, alias: String? = nil) {
        self.id = id
        self.label = label
        self.alias = alias
    }
}

// MARK: - Command

/// A command that can be executed
public struct ICommand: Codable, Sendable {
    /// The command ID
    public let id: String
    /// The command title
    public let title: String
    /// The command arguments
    public let arguments: [String]?
    
    public init(id: String, title: String, arguments: [String]? = nil) {
        self.id = id
        self.title = title
        self.arguments = arguments
    }
}

// MARK: - Editor Contribution

/// Describes an editor contribution
public struct EditorContribution: Codable, Sendable {
    /// The contribution ID
    public let id: String
    /// Whether the contribution is visible
    public let enabled: Bool
    
    public init(id: String, enabled: Bool) {
        self.id = id
        self.enabled = enabled
    }
}

// MARK: - View Zone

/// A view zone is a full horizontal rectangle that occupies an entire row
public struct IViewZone: Codable, Sendable {
    /// The line number after which this zone should appear
    public let afterLineNumber: Int
    /// The column after which this zone should appear
    public let afterColumn: Int?
    /// Suppress mouse down events
    public let suppressMouseDown: Bool?
    /// The height in lines for this zone
    public let heightInLines: Int?
    /// The minimum width in pixels for this zone
    public let minWidth: Int?
    /// The DOM node for this zone
    public let domNode: String?
    /// Callback when the zone's position changed
    public let onDomNodeTop: String?
    /// Callback when the zone's height changed
    public let onComputedHeight: String?
    
    public init(
        afterLineNumber: Int,
        afterColumn: Int? = nil,
        suppressMouseDown: Bool? = nil,
        heightInLines: Int? = nil,
        minWidth: Int? = nil,
        domNode: String? = nil,
        onDomNodeTop: String? = nil,
        onComputedHeight: String? = nil
    ) {
        self.afterLineNumber = afterLineNumber
        self.afterColumn = afterColumn
        self.suppressMouseDown = suppressMouseDown
        self.heightInLines = heightInLines
        self.minWidth = minWidth
        self.domNode = domNode
        self.onDomNodeTop = onDomNodeTop
        self.onComputedHeight = onComputedHeight
    }
}

// MARK: - Content Widget

/// A position for a content widget
public struct IContentWidgetPosition: Codable, Sendable {
    /// Desired position
    public let position: Position
    /// Placement preference
    public let preference: [ContentWidgetPositionPreference]?
    
    public init(position: Position, preference: [ContentWidgetPositionPreference]? = nil) {
        self.position = position
        self.preference = preference
    }
}

// MARK: - Content Widget

/// A widget that can be placed in the content area
public struct IContentWidget: Codable, Sendable {
    /// The widget ID
    public let id: String
    /// The DOM node
    public let domNode: String?
    /// Position of the widget
    public let position: IContentWidgetPosition?
    
    public init(id: String, domNode: String? = nil, position: IContentWidgetPosition? = nil) {
        self.id = id
        self.domNode = domNode
        self.position = position
    }
}

// MARK: - Overlay Widget

/// Position for an overlay widget
public struct IOverlayWidgetPosition: Codable, Sendable {
    /// Placement preference
    public let preference: OverlayWidgetPositionPreference?
    
    public init(preference: OverlayWidgetPositionPreference? = nil) {
        self.preference = preference
    }
}

// MARK: - Overlay Widget

/// A widget that can be placed as an overlay
public struct IOverlayWidget: Codable, Sendable {
    /// The widget ID
    public let id: String
    /// The DOM node
    public let domNode: String?
    /// Position of the widget
    public let position: IOverlayWidgetPosition?
    
    public init(id: String, domNode: String? = nil, position: IOverlayWidgetPosition? = nil) {
        self.id = id
        self.domNode = domNode
        self.position = position
    }
}

// MARK: - Mouse Target

/// Information about the target of a mouse event
public struct IMouseTarget: Codable, Sendable {
    /// The target element
    public let element: String?
    /// The target type
    public let type: MouseTargetType
    /// The mouse column
    public let mouseColumn: Int
    /// The position
    public let position: Position?
    /// The range
    public let range: IRange?
    /// The detail
    public let detail: String?
    
    public init(
        element: String? = nil,
        type: MouseTargetType,
        mouseColumn: Int,
        position: Position? = nil,
        range: IRange? = nil,
        detail: String? = nil
    ) {
        self.element = element
        self.type = type
        self.mouseColumn = mouseColumn
        self.position = position
        self.range = range
        self.detail = detail
    }
}

// MARK: - Editor Mouse Event

/// An event from the editor mouse
public struct IEditorMouseEvent: Codable, Sendable {
    /// The mouse event
    public let event: String
    /// The mouse target
    public let target: IMouseTarget
    
    public init(event: String, target: IMouseTarget) {
        self.event = event
        self.target = target
    }
}

// MARK: - Partial Editor Mouse Event

/// A partial mouse event (used for hover)
public struct IPartialEditorMouseEvent: Codable, Sendable {
    /// The mouse event
    public let event: String
    /// The mouse target
    public let target: IMouseTarget?
    
    public init(event: String, target: IMouseTarget? = nil) {
        self.event = event
        self.target = target
    }
}
