import Foundation

/// A single valid indexing solution for a dividing head
public struct IndexSolution: Sendable {
    /// The plate name (e.g. "Brown & Sharpe #1", "Holtzapffel")
    public let plate: String
    /// The hole circle size (number of holes in the ring used)
    public let circle: Int
    /// Number of full crank turns per division
    public let wholeTurns: Int
    /// Number of additional holes to advance on the circle
    public let holes: Int

    public init(plate: String, circle: Int, wholeTurns: Int, holes: Int) {
        self.plate = plate
        self.circle = circle
        self.wholeTurns = wholeTurns
        self.holes = holes
    }
}

/// Calculate dividing-head indexing for a given ratio and number of divisions.
///
/// - Parameters:
///   - ratio: Worm gear ratio of the dividing head (e.g. 40)
///   - divisions: Number of equal divisions required (e.g. 24)
///   - ornamental: If true, searches OT_PLATE and Holtzapffel sets; if false, searches standard B&S/Cincinnati plates
///
/// - Returns: A tuple of:
///   - `wholeTurns`: Integer full crank turns per division
///   - `frac`: Fractional remainder of a crank turn
///   - `exact`: True if frac < 1e-9 (exact whole turns, no plate needed)
///   - `solutions`: Array of valid IndexSolution values (empty when exact)
public func dividingHead(
    ratio: Int,
    divisions: Int,
    ornamental: Bool
) -> (wholeTurns: Int, frac: Double, exact: Bool, solutions: [IndexSolution]) {
    let turnsExact = Double(ratio) / Double(divisions)
    let wholeTurns = Int(floor(turnsExact))
    let frac = turnsExact - Double(wholeTurns)
    let exact = frac < 1e-9

    guard !exact else {
        return (wholeTurns: wholeTurns, frac: frac, exact: true, solutions: [])
    }

    var solutions: [IndexSolution] = []

    if ornamental {
        // Search OT_PLATE
        for h in ShopMathData.otPlate {
            if let sol = indexSolution(plate: "OT Plate", circle: h, frac: frac, wholeTurns: wholeTurns) {
                solutions.append(sol)
            }
        }
        // Search Holtzapffel
        for h in ShopMathData.holtzapffel {
            if let sol = indexSolution(plate: "Holtzapffel", circle: h, frac: frac, wholeTurns: wholeTurns) {
                solutions.append(sol)
            }
        }
    } else {
        // Search standard B&S and Cincinnati plates
        for plate in ShopMathData.dhPlates {
            for h in plate.circles {
                if let sol = indexSolution(plate: plate.name, circle: h, frac: frac, wholeTurns: wholeTurns) {
                    solutions.append(sol)
                }
            }
        }
    }

    return (wholeTurns: wholeTurns, frac: frac, exact: false, solutions: solutions)
}

// MARK: - Private helpers

private func indexSolution(plate: String, circle h: Int, frac: Double, wholeTurns: Int) -> IndexSolution? {
    let holesExact = frac * Double(h)
    let holesRounded = holesExact.rounded()
    let holesInt = Int(holesRounded)
    guard abs(holesExact - holesRounded) < 1e-6, holesInt > 0, holesInt < h else {
        return nil
    }
    return IndexSolution(plate: plate, circle: h, wholeTurns: wholeTurns, holes: holesInt)
}
