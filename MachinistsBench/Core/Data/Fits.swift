import Foundation

// MARK: - ISO 286 Tolerance Band Data
// Verbatim from app.html ~line 4687
// Format: [bandMaxMm, IT6_µm, IT7_µm, IT11_µm, gEs_µm, kEi_µm, pEi_µm]
public let ISO_BANDS: [[Double]] = [
    [  3,  6, 10,  60,  -2, 0,  6],
    [  6,  8, 12,  75,  -4, 1, 12],
    [ 10,  9, 15,  90,  -5, 1, 15],
    [ 18, 11, 18, 110,  -6, 1, 18],
    [ 30, 13, 21, 130,  -7, 2, 22],
    [ 50, 16, 25, 160,  -9, 2, 26],
    [ 80, 19, 30, 190, -10, 2, 32],
    [120, 22, 35, 220, -12, 3, 37],
    [180, 25, 40, 250, -14, 3, 43],
    [250, 29, 46, 290, -15, 4, 50]
]

// MARK: - H11/c11 'c' Fundamental Deviation Table
// Verbatim from app.html ~line 4700
// Format: [bandMaxMm, es_µm]  (es is negative — shaft is below zero line)
public let C_ES: [[Double]] = [
    [  3, -60],
    [  6, -70],
    [ 10, -80],
    [ 18, -95],
    [ 30, -110],
    [ 40, -120],
    [ 50, -130],
    [ 65, -140],
    [ 80, -150],
    [100, -170],
    [120, -180],
    [140, -200],
    [160, -210],
    [180, -230],
    [200, -240],
    [225, -260],
    [250, -280]
]

// MARK: - Thermal Expansion Coefficients (×10⁻⁶ per °C)
// Verbatim from app.html ~line 437
public let CTE: [String: Double] = [
    "alum":    23.0,
    "al6061":  23.6,
    "brass":   20.5,
    "bronze":  18.0,
    "castiron": 10.8,
    "ductile": 11.6,
    "s12l14":  11.7,
    "lowc":    11.7,
    "medc":    11.5,
    "alloy":   12.3,
    "o1":      12.6,
    "tool":    11.5,
    "ss303":   17.3,
    "ss304":   17.3,
    "ss316":   16.0,
    "ss416":    9.9,
    "ti":       8.6,
    "inconel": 13.0,
    "plastic": 90.0
]
