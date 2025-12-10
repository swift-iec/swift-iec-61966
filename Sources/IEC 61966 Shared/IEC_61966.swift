// IEC_61966.swift
// IEC 61966: Multimedia systems and equipment — Colour measurement and management

/// IEC 61966 namespace
///
/// IEC 61966 is a multi-part standard for colour measurement and management
/// in multimedia systems.
///
/// ## Parts
///
/// - **Part 2-1**: Default RGB colour space — sRGB (IEC 61966-2-1:1999)
/// - **Part 2-2**: Extended RGB colour space — scRGB
/// - **Part 2-4**: Adobe RGB (1998) colour image encoding
///
/// ## Usage
///
/// ```swift
/// import IEC_61966
///
/// // Create an sRGB color
/// let red = sRGB(r: 1, g: 0, b: 0)
///
/// // Convert from HSL
/// let color = sRGB(hsl: (h: 120, s: 1, l: 0.5))
/// ```
///
/// ## Reference
///
/// IEC 61966-2-1:1999 — Multimedia systems and equipment — Colour measurement
/// and management — Part 2-1: Colour management — Default RGB colour space — sRGB
public enum IEC_61966 {
    /// Part 2: Colour management
    public enum `2` {}
}
