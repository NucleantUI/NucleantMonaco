import Foundation
import MonacoApi

// MARK: - Color Extensions (Foundation-dependent)

extension Color {
    /// Create color from hex string (e.g., "#FF0000" or "#FF0000FF")
    ///
    /// Supports:
    /// - 6-character hex: "#RRGGBB" (alpha defaults to 1.0)
    /// - 8-character hex: "#RRGGBBAA"
    ///
    /// - Parameter hex: Hex color string with or without # prefix
    /// - Returns: Color instance or nil if parsing fails
    public static func fromHex(_ hex: String) -> Color? {
        var hexSanitized = hex.trimmingCharacters(in: .whitespacesAndNewlines)
        hexSanitized = hexSanitized.replacingOccurrences(of: "#", with: "")
        
        var rgb: UInt64 = 0
        guard Scanner(string: hexSanitized).scanHexInt64(&rgb) else { return nil }
        
        let length = hexSanitized.count
        let r, g, b, a: Double
        
        if length == 6 {
            r = Double((rgb & 0xFF0000) >> 16) / 255.0
            g = Double((rgb & 0x00FF00) >> 8) / 255.0
            b = Double(rgb & 0x0000FF) / 255.0
            a = 1.0
        } else if length == 8 {
            r = Double((rgb & 0xFF000000) >> 24) / 255.0
            g = Double((rgb & 0x00FF0000) >> 16) / 255.0
            b = Double((rgb & 0x0000FF00) >> 8) / 255.0
            a = Double(rgb & 0x000000FF) / 255.0
        } else {
            return nil
        }
        
        return Color(red: r, green: g, blue: b, alpha: a)
    }
    
    /// Convert to hex string
    ///
    /// - Parameter includeAlpha: Whether to include alpha channel (defaults to false)
    /// - Returns: Hex string in format "#RRGGBB" or "#RRGGBBAA"
    public func toHex(includeAlpha: Bool = false) -> String {
        let r = Int(red * 255)
        let g = Int(green * 255)
        let b = Int(blue * 255)
        let a = Int(alpha * 255)
        
        if includeAlpha {
            return String(format: "#%02X%02X%02X%02X", r, g, b, a)
        } else {
            return String(format: "#%02X%02X%02X", r, g, b)
        }
    }
}
