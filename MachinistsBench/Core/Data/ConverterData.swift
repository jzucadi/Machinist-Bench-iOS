import Foundation

// MARK: - Data types

public struct ConvUnit: Sendable {
    public let key: String
    public let label: String
    public let factor: Double  // factor = (1 unit) expressed in the category's base unit; 0 for temperature

    public init(key: String, label: String, factor: Double = 0) {
        self.key = key
        self.label = label
        self.factor = factor
    }
}

public struct ConvCategory: Sendable {
    public let key: String
    public let name: String
    public let base: String
    public let units: [ConvUnit]
    public let isTemperature: Bool

    public init(key: String, name: String, base: String, units: [ConvUnit], isTemperature: Bool = false) {
        self.key = key
        self.name = name
        self.base = base
        self.units = units
        self.isTemperature = isTemperature
    }
}

// MARK: - Converter namespace

public enum Converter {

    public static let categories: [ConvCategory] = [
        // Length (base: mm)
        ConvCategory(key: "len", name: "Length", base: "mm", units: [
            ConvUnit(key: "in",   label: "inch",           factor: 25.4),
            ConvUnit(key: "mm",   label: "mm",             factor: 1),
            ConvUnit(key: "cm",   label: "cm",             factor: 10),
            ConvUnit(key: "ft",   label: "foot",           factor: 304.8),
            ConvUnit(key: "yd",   label: "yard",           factor: 914.4),
            ConvUnit(key: "thou", label: "thou (mil)",     factor: 0.0254),
            ConvUnit(key: "m",    label: "metre",          factor: 1e3),
            ConvUnit(key: "µm",   label: "micron",         factor: 1e-3),
            ConvUnit(key: "km",   label: "km",             factor: 1e6),
            ConvUnit(key: "mile", label: "mile",           factor: 1_609_344),
            ConvUnit(key: "nmi",  label: "nautical mile",  factor: 1_852e3),
            ConvUnit(key: "fur",  label: "furlong",        factor: 201_168),
        ]),

        // Area (base: mm²)
        ConvCategory(key: "area", name: "Area", base: "mm\u{00B2}", units: [
            ConvUnit(key: "in2",  label: "in\u{00B2}",    factor: 645.16),
            ConvUnit(key: "ft2",  label: "ft\u{00B2}",    factor: 92_903.04),
            ConvUnit(key: "yd2",  label: "yd\u{00B2}",    factor: 836_127.36),
            ConvUnit(key: "mm2",  label: "mm\u{00B2}",    factor: 1),
            ConvUnit(key: "cm2",  label: "cm\u{00B2}",    factor: 100),
            ConvUnit(key: "m2",   label: "m\u{00B2}",     factor: 1e6),
            ConvUnit(key: "acre", label: "acre",           factor: 4_046_856_422.4),
            ConvUnit(key: "ha",   label: "hectare",        factor: 1e10),
            ConvUnit(key: "mi2",  label: "mi\u{00B2}",    factor: 2_589_988_110_336),
            ConvUnit(key: "km2",  label: "km\u{00B2}",    factor: 1e12),
        ]),

        // Volume (base: mL)
        ConvCategory(key: "vol", name: "Volume", base: "mL", units: [
            ConvUnit(key: "in3",    label: "in\u{00B3}",          factor: 16.387064),
            ConvUnit(key: "ft3",    label: "ft\u{00B3}",          factor: 28_316.846592),
            ConvUnit(key: "yd3",    label: "yd\u{00B3}",          factor: 764_554.857984),
            ConvUnit(key: "ml",     label: "mL / cm\u{00B3}",     factor: 1),
            ConvUnit(key: "l",      label: "litre",                factor: 1e3),
            ConvUnit(key: "m3",     label: "m\u{00B3}",           factor: 1e6),
            ConvUnit(key: "flozUS", label: "fl oz (US)",           factor: 29.5735295625),
            ConvUnit(key: "flozUK", label: "fl oz (imp)",          factor: 28.4130625),
            ConvUnit(key: "ptUS",   label: "pint (US liq)",        factor: 473.176473),
            ConvUnit(key: "ptUK",   label: "pint (imp)",           factor: 568.26125),
            ConvUnit(key: "qtUS",   label: "quart (US)",           factor: 946.352946),
            ConvUnit(key: "galUS",  label: "gallon (US)",          factor: 3_785.411784),
            ConvUnit(key: "galUK",  label: "gallon (imp)",         factor: 4_546.09),
        ]),

        // Mass (base: g)
        ConvCategory(key: "wt", name: "Mass", base: "g", units: [
            ConvUnit(key: "lb",     label: "pound",                 factor: 453.59237),
            ConvUnit(key: "kg",     label: "kg",                    factor: 1e3),
            ConvUnit(key: "g",      label: "gram",                  factor: 1),
            ConvUnit(key: "oz",     label: "ounce",                 factor: 28.3495231),
            ConvUnit(key: "gr",     label: "grain",                 factor: 0.06479891),
            ConvUnit(key: "tonS",   label: "ton (short 2000 lb)",   factor: 907_184.74),
            ConvUnit(key: "tonL",   label: "ton (long 2240 lb)",    factor: 1_016_046.9088),
            ConvUnit(key: "tonne",  label: "tonne",                 factor: 1e6),
            ConvUnit(key: "cwtUS",  label: "cwt (US 100 lb)",       factor: 45_359.237),
            ConvUnit(key: "cwtUK",  label: "cwt (UK 112 lb)",       factor: 50_802.34544),
        ]),

        // Force (base: N)
        ConvCategory(key: "force", name: "Force", base: "N", units: [
            ConvUnit(key: "lbf",   label: "lbf",            factor: 4.44822162),
            ConvUnit(key: "N",     label: "newton",         factor: 1),
            ConvUnit(key: "kgf",   label: "kgf",            factor: 9.80665),
            ConvUnit(key: "kN",    label: "kN",             factor: 1e3),
            ConvUnit(key: "ozf",   label: "ozf",            factor: 0.278013851),
            ConvUnit(key: "tonfL", label: "tonf (long)",    factor: 9_964.01642),
            ConvUnit(key: "tonfS", label: "tonf (short)",   factor: 8_896.44323),
        ]),

        // Pressure (base: kPa)
        ConvCategory(key: "pr", name: "Pressure", base: "kPa", units: [
            ConvUnit(key: "psi",  label: "psi",               factor: 6.89476),
            ConvUnit(key: "bar",  label: "bar",               factor: 100),
            ConvUnit(key: "kPa",  label: "kPa",               factor: 1),
            ConvUnit(key: "MPa",  label: "MPa",               factor: 1e3),
            ConvUnit(key: "atm",  label: "atm",               factor: 101.325),
            ConvUnit(key: "inHg", label: "inHg (0 \u{00B0}C)", factor: 3.386389),
            ConvUnit(key: "mbar", label: "mbar / hPa",        factor: 0.1),
            ConvUnit(key: "Pa",   label: "Pa",                factor: 1e-3),
            ConvUnit(key: "ksi",  label: "ksi",               factor: 6_894.757),
            ConvUnit(key: "tsi",  label: "ton/in\u{00B2} (long)", factor: 15_444.26),
        ]),

        // Torque (base: Nm)
        ConvCategory(key: "tq", name: "Torque", base: "Nm", units: [
            ConvUnit(key: "ftlb",  label: "ft\u{00B7}lb",    factor: 1.35581795),
            ConvUnit(key: "inlb",  label: "in\u{00B7}lb",    factor: 0.112984829),
            ConvUnit(key: "Nm",    label: "N\u{00B7}m",      factor: 1),
            ConvUnit(key: "Ncm",   label: "N\u{00B7}cm",     factor: 0.01),
            ConvUnit(key: "kgfm",  label: "kgf\u{00B7}m",   factor: 9.80665),
            ConvUnit(key: "kgfcm", label: "kgf\u{00B7}cm",  factor: 0.0980665),
            ConvUnit(key: "ozfin", label: "ozf\u{00B7}in",  factor: 0.00706155),
        ]),

        // Speed (base: m/s)
        ConvCategory(key: "spd", name: "Speed", base: "m/s", units: [
            ConvUnit(key: "fpm",  label: "ft/min (SFM)",  factor: 0.00508),
            ConvUnit(key: "mmin", label: "m/min",         factor: 0.0166666667),
            ConvUnit(key: "fps",  label: "ft/s",          factor: 0.3048),
            ConvUnit(key: "ms",   label: "m/s",           factor: 1),
            ConvUnit(key: "mph",  label: "mph",           factor: 0.44704),
            ConvUnit(key: "kmh",  label: "km/h",          factor: 0.277777778),
            ConvUnit(key: "kn",   label: "knot",          factor: 0.514444444),
        ]),

        // Flow (base: L/s)
        ConvCategory(key: "flow", name: "Flow", base: "L/s", units: [
            ConvUnit(key: "cfm",   label: "ft\u{00B3}/min (CFM)", factor: 0.471947443),
            ConvUnit(key: "ls",    label: "L/s",                  factor: 1),
            ConvUnit(key: "lmin",  label: "L/min",                factor: 0.0166666667),
            ConvUnit(key: "gpmUS", label: "gal/min (US)",         factor: 0.0630901964),
            ConvUnit(key: "gpmUK", label: "gal/min (imp)",        factor: 0.0757681667),
            ConvUnit(key: "m3h",   label: "m\u{00B3}/h",         factor: 0.277777778),
        ]),

        // Energy (base: J)
        ConvCategory(key: "en", name: "Energy", base: "J", units: [
            ConvUnit(key: "ftlbf", label: "ft\u{00B7}lbf",  factor: 1.35581795),
            ConvUnit(key: "J",     label: "joule",           factor: 1),
            ConvUnit(key: "kJ",    label: "kJ",              factor: 1e3),
            ConvUnit(key: "MJ",    label: "MJ",              factor: 1e6),
            ConvUnit(key: "btu",   label: "BTU",             factor: 1_055.05585),
            ConvUnit(key: "kwh",   label: "kWh",             factor: 3_600_000),
        ]),

        // Power (base: W)
        ConvCategory(key: "pw", name: "Power", base: "W", units: [
            ConvUnit(key: "hp",    label: "hp (mech)",       factor: 745.699872),
            ConvUnit(key: "W",     label: "watt",            factor: 1),
            ConvUnit(key: "kW",    label: "kW",              factor: 1e3),
            ConvUnit(key: "hpe",   label: "hp (electric)",   factor: 746),
            ConvUnit(key: "ps",    label: "PS (metric hp)",  factor: 735.49875),
            ConvUnit(key: "btuh",  label: "BTU/hr",          factor: 0.29307107),
            ConvUnit(key: "ftlbs", label: "ft\u{00B7}lbf/s", factor: 1.35581795),
        ]),

        // Temperature (special — offset-based, not factor-based)
        ConvCategory(key: "tmp", name: "Temperature", base: "\u{00B0}C", units: [
            ConvUnit(key: "C", label: "\u{00B0}C"),
            ConvUnit(key: "F", label: "\u{00B0}F"),
            ConvUnit(key: "K", label: "K"),
        ], isTemperature: true),
    ]

    public static func category(_ key: String) -> ConvCategory? {
        categories.first(where: { $0.key == key })
    }
}
