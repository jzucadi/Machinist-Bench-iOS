import Foundation

/// Shop Math shared data constants
public enum ShopMathData {
    /// Material densities in lb/in³
    public static let barDensity: [String: Double] = [
        "steel": 0.2836,
        "stainless": 0.289,
        "aluminum": 0.0975,
        "brass": 0.307,
        "bronze": 0.318,
        "copper": 0.323,
        "castiron": 0.26,
        "titanium": 0.163,
        "lead": 0.4097,
        "nylon": 0.0412
    ]

    /// Dividing-head hole-circle plate sets (Brown & Sharpe and Cincinnati)
    public static let dhPlates: [(name: String, circles: [Int])] = [
        (name: "Brown & Sharpe #1", circles: [15, 16, 17, 18, 19, 20]),
        (name: "Brown & Sharpe #2", circles: [21, 23, 27, 29, 31, 33]),
        (name: "Brown & Sharpe #3", circles: [37, 39, 41, 43, 47, 49]),
        (name: "Cincinnati (high)", circles: [24, 25, 28, 30, 34, 37, 38, 39, 41, 42, 43])
    ]

    /// Ornamental turning plate hole circles
    public static let otPlate: [Int] = [24, 30, 36, 40, 48, 60, 72, 96]

    /// Holtzapffel ornamental turning plate hole circles
    public static let holtzapffel: [Int] = [96, 112, 120, 144, 180, 192, 360]

    /// Preset change-gear sets for screwcutting
    /// Keys: "imp" (imperial), "met" (metric with 127T), "mini" (mini-lathe)
    public static let gearSets: [String: [Int]] = [
        "imp":  [20, 25, 30, 35, 40, 45, 50, 55, 60, 65, 70, 75],
        "met":  [20, 25, 30, 35, 40, 45, 50, 55, 60, 63, 65, 70, 75, 80, 127],
        "mini": [20, 20, 30, 35, 40, 45, 50, 55, 57, 60, 65, 80, 127]
    ]
}
