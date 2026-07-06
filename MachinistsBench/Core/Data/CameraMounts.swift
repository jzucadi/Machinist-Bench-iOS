// CameraMounts.swift — Camera lens mount reference data
// Verbatim from app.html CameraBayonets component (lines 5853–5864).
// 10-row table: mount, type, thread/throat, flange distance, notes.

import Foundation

// MARK: - CameraMount

public struct CameraMount: Sendable {
    /// Mount name, e.g. "Nikon F", "C-mount"
    public let mount:         String
    /// "Bayonet" or "Screw"
    public let mountType:     String
    /// Thread spec or throat diameter (e.g. "M42 × 1.0", "44 mm", "—")
    public let threadOrThroat: String
    /// Flange focal distance (e.g. "46.5 mm")
    public let flangeDistMm:  String
    /// Additional notes
    public let notes:         String

    public init(mount: String, mountType: String, threadOrThroat: String,
                flangeDistMm: String, notes: String) {
        self.mount          = mount
        self.mountType      = mountType
        self.threadOrThroat = threadOrThroat
        self.flangeDistMm   = flangeDistMm
        self.notes          = notes
    }
}

// MARK: - CameraMounts

public enum CameraMounts {

    /// 10-row camera mount table, verbatim from app.html CameraBayonets MOUNTS array.
    public static let all: [CameraMount] = [
        CameraMount(
            mount: "Nikon F",
            mountType: "Bayonet",
            threadOrThroat: "44 mm",
            flangeDistMm: "46.5 mm",
            notes: "3-lug bayonet, 1959\u{2013}present; not a thread."
        ),
        CameraMount(
            mount: "Canon EF",
            mountType: "Bayonet",
            threadOrThroat: "54 mm",
            flangeDistMm: "44.0 mm",
            notes: "Electronic bayonet, 1987; no mechanical aperture link."
        ),
        CameraMount(
            mount: "Canon RF",
            mountType: "Bayonet",
            threadOrThroat: "54 mm",
            flangeDistMm: "20.0 mm",
            notes: "Mirrorless, 2018; short flange distance."
        ),
        CameraMount(
            mount: "Sony E",
            mountType: "Bayonet",
            threadOrThroat: "46.1 mm",
            flangeDistMm: "18.0 mm",
            notes: "Mirrorless APS-C/full-frame, 2010."
        ),
        CameraMount(
            mount: "Micro Four Thirds",
            mountType: "Bayonet",
            threadOrThroat: "\u{2014}",
            flangeDistMm: "19.25 mm",
            notes: "Shared Olympus/Panasonic mirrorless mount."
        ),
        CameraMount(
            mount: "M42 (Pentax screw)",
            mountType: "Screw",
            threadOrThroat: "M42 \u{D7} 1.0",
            flangeDistMm: "45.46 mm",
            notes: "Universal 42 mm screw mount \u{2014} see Photographic threads."
        ),
        CameraMount(
            mount: "Leica M",
            mountType: "Bayonet",
            threadOrThroat: "\u{2014}",
            flangeDistMm: "27.8 mm",
            notes: "Rangefinder bayonet, 1954."
        ),
        CameraMount(
            mount: "Leica L39 (LTM)",
            mountType: "Screw",
            threadOrThroat: "M39 \u{D7} 1/26\"",
            flangeDistMm: "28.8 mm",
            notes: "Screw rangefinder mount \u{2014} see Photographic threads."
        ),
        CameraMount(
            mount: "T-mount (T2)",
            mountType: "Screw",
            threadOrThroat: "M42 \u{D7} 0.75",
            flangeDistMm: "55 mm",
            notes: "Adapter standard for telescopes & long lenses."
        ),
        CameraMount(
            mount: "C-mount",
            mountType: "Screw",
            threadOrThroat: "1\"-32",
            flangeDistMm: "17.526 mm",
            notes: "Cine/CCTV & microscope cameras."
        ),
    ]
}
