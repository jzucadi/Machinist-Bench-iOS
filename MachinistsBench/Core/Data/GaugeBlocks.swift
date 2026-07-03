import Foundation

/// Standard gauge block sets verbatim from app.html (GB_SET / GB_SET_MM).
public enum GaugeBlocks {
    /// 81-piece standard inch set: 9 ten-thousandths + 49 thousandths + 19 fifty-step + 4 inch blocks.
    public static let inchSet: [Double] = [
        // 9 ten-thousandths (wear) blocks: 0.1001–0.1009
        0.1001, 0.1002, 0.1003, 0.1004, 0.1005, 0.1006, 0.1007, 0.1008, 0.1009,
        // 49 thousandths blocks: 0.101–0.149
        0.101, 0.102, 0.103, 0.104, 0.105, 0.106, 0.107, 0.108, 0.109,
        0.11,  0.111, 0.112, 0.113, 0.114, 0.115, 0.116, 0.117, 0.118, 0.119,
        0.12,  0.121, 0.122, 0.123, 0.124, 0.125, 0.126, 0.127, 0.128, 0.129,
        0.13,  0.131, 0.132, 0.133, 0.134, 0.135, 0.136, 0.137, 0.138, 0.139,
        0.14,  0.141, 0.142, 0.143, 0.144, 0.145, 0.146, 0.147, 0.148, 0.149,
        // 19 fifty-thousandths (0.050–0.950)
        0.05, 0.1, 0.15, 0.2, 0.25, 0.3, 0.35, 0.4, 0.45,
        0.5,  0.55, 0.6, 0.65, 0.7, 0.75, 0.8, 0.85, 0.9, 0.95,
        // 4 inch blocks
        1.0, 2.0, 3.0, 4.0
    ]

    /// 88-piece standard metric set: 1.0005 + 9 micron-step + 49 hundredth-step + 19 half-mm-step + 10 ten-mm blocks.
    /// Matches JS: Array.from({length:49}, (_,i) => +(1.01+0.01*i).toFixed(2))
    ///             Array.from({length:19}, (_,i) => +(0.5+0.5*i).toFixed(1))
    ///             Array.from({length:10}, (_,i) => 10*(i+1))
    public static let metricSet: [Double] = {
        var set: [Double] = []
        // 1 half-micron block: 1.0005
        set.append(1.0005)
        // 9 micron-step blocks: 1.001–1.009
        for i in 1 ... 9 {
            set.append(Double(String(format: "%.3f", 1.0 + Double(i) * 0.001))!)
        }
        // 49 hundredth-step blocks: 1.01–1.49 (JS: +(1.01+0.01*i).toFixed(2))
        for i in 0 ..< 49 {
            set.append(Double(String(format: "%.2f", 1.01 + 0.01 * Double(i)))!)
        }
        // 19 half-mm blocks: 0.5–9.5 (JS: +(0.5+0.5*i).toFixed(1))
        for i in 0 ..< 19 {
            set.append(Double(String(format: "%.1f", 0.5 + 0.5 * Double(i)))!)
        }
        // 10 ten-mm blocks: 10–100 (JS: 10*(i+1))
        for i in 1 ... 10 {
            set.append(Double(10 * i))
        }
        return set
    }()
}
