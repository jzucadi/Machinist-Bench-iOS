# Machinist's Bench iOS — Milestone 1 (Vertical Slice) Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.
>
> **SwiftUI reference skills (installed globally):** When writing SwiftUI in Tasks 6–9, consult `swiftui-skills` (idiomatic Apple-native patterns) and `swiftui-expert-skill` (state/`@Observable`, performance), use `swiftui-design-skill` for theme/component aesthetics, and run a `swiftui-pro` review pass at the end. `ponytail` is active: build the smallest thing that works.

**Goal:** Ship a native SwiftUI iOS app with a working Turning calculator, the Catppuccin-Mocha theme, the shared component library, and Imperial/Metric — proving the end-to-end pattern that the other 14 sections will follow.

**Architecture:** Pure-logic (Units, Data, Calc) lives in `MachinistsBench/Core/` and is compiled two ways: by the iOS app target (Xcode 16 filesystem-synchronized group) and by a SwiftPM package (`Package.swift`, `path:` pointed at the same folder) so logic is unit-tested headlessly with `swift test` — no Xcode test target, no simulator needed for logic tests. UI (Theme, Components, Sections, App) lives in `MachinistsBench/` and is verified by `xcodebuild` + running in the simulator.

**Tech Stack:** Swift 6, SwiftUI, iOS 17+, Xcode 16.1, SwiftPM (test only). Zero third-party runtime dependencies.

## Global Constraints

- iOS deployment target: **17.0**. Swift language version: **6.0**.
- Zero third-party runtime dependencies. SwiftPM is used only for headless logic tests.
- Pure-logic files in `MachinistsBench/Core/` MUST NOT import SwiftUI/UIKit (they compile on the macOS host under `swift test`). Public symbols where tests need them.
- Palette: Catppuccin **Mocha**. Accent remap: web blue→blue, teal→teal, amber→peach, violet→mauve, green→green, orange→peach, red→red.
- Ported math and data must match `app.html` **verbatim** (formulas, constants, rounding).
- Bundle id base: `com.machinistsbench.app`. App display name: `Machinist's Bench`.
- Commit after every task. Branch: `ios-swiftui-port`.

## Prerequisites (run once, before Task 1)

```bash
xcodebuild -version          # expect Xcode 16.1  (already switched via xcode-select)
xcodebuild -downloadPlatform iOS   # ~7GB, installs an iOS simulator runtime; required to run the app
xcrun simctl list devices available | grep iPhone   # confirm at least one iPhone simulator exists
```

If no iPhone simulator is listed after the download, create one:
`xcrun simctl create "iPhone 16" "iPhone 16"`

## File Structure

```
Machinist-App/                                  (repo root, branch ios-swiftui-port)
  Package.swift                                 # SwiftPM: lib MachinistsCore + tests (path → MachinistsBench/Core)
  .gitignore                                    # add .build/, *.xcuserdata, DerivedData
  MachinistsBench.xcodeproj/project.pbxproj     # app project (synchronized group)
  MachinistsBench/
    App.swift                                   # @main; root = home screen
    Theme/
      Catppuccin.swift                          # Mocha palette + Accent role enum
      Typography.swift                          # font roles (SF fallback; bundled fonts later)
    Components/
      Panel.swift  Field.swift  NumberInput.swift  Segmented.swift
      Readout.swift  NoteView.swift  SpeedInput.swift
    Sections/Turning/TurningView.swift
    Home/HomeView.swift  Home/SectionCatalog.swift
    Core/                                        # PURE logic (also compiled by SwiftPM)
      Units.swift
      Data/Materials.swift
      Calc/Turning.swift
  Tests/MachinistsCoreTests/
    UnitsTests.swift  MaterialsTests.swift  TurningCalcTests.swift
```

---

### Task 1: Xcode app project scaffold that builds and runs

**Files:**
- Create: `MachinistsBench.xcodeproj/project.pbxproj`
- Create: `MachinistsBench/App.swift`
- Create: `.gitignore`

**Interfaces:**
- Produces: an `MachinistsBench` app target whose sources are the filesystem-synchronized `MachinistsBench/` folder; an entry point `MachinistsBenchApp` (`@main`).

- [ ] **Step 1: Create `.gitignore`**

```gitignore
.build/
DerivedData/
*.xcuserstate
**/xcuserdata/
.DS_Store
```

- [ ] **Step 2: Create `MachinistsBench/App.swift`** (minimal, proves launch)

```swift
import SwiftUI

@main
struct MachinistsBenchApp: App {
    var body: some Scene {
        WindowGroup {
            Text("Machinist's Bench")
                .font(.title)
        }
    }
}
```

- [ ] **Step 3: Create `MachinistsBench.xcodeproj/project.pbxproj`**

Uses an Xcode-16 filesystem-synchronized root group, so every `.swift` file added under `MachinistsBench/` in later tasks is compiled automatically with **no further pbxproj edits**. `GENERATE_INFOPLIST_FILE = YES` synthesizes Info.plist (no plist file needed).

```
// !$*UTF8*$!
{
	archiveVersion = 1;
	classes = {
	};
	objectVersion = 77;
	objects = {

/* Begin PBXFileSystemSynchronizedRootGroup section */
		777777777777777777777777 /* MachinistsBench */ = {
			isa = PBXFileSystemSynchronizedRootGroup;
			path = MachinistsBench;
			sourceTree = "<group>";
		};
/* End PBXFileSystemSynchronizedRootGroup section */

/* Begin PBXFrameworksBuildPhase section */
		555555555555555555555555 /* Frameworks */ = {
			isa = PBXFrameworksBuildPhase;
			buildActionMask = 2147483647;
			files = (
			);
			runOnlyForDeploymentPostprocessing = 0;
		};
/* End PBXFrameworksBuildPhase section */

/* Begin PBXGroup section */
		888888888888888888888888 = {
			isa = PBXGroup;
			children = (
				777777777777777777777777 /* MachinistsBench */,
				999999999999999999999999 /* Products */,
			);
			sourceTree = "<group>";
		};
		999999999999999999999999 /* Products */ = {
			isa = PBXGroup;
			children = (
				333333333333333333333333 /* MachinistsBench.app */,
			);
			name = Products;
			sourceTree = "<group>";
		};
/* End PBXGroup section */

/* Begin PBXNativeTarget section */
		222222222222222222222222 /* MachinistsBench */ = {
			isa = PBXNativeTarget;
			buildConfigurationList = BBBBBBBBBBBBBBBBBBBBBBBB /* Build configuration list for PBXNativeTarget "MachinistsBench" */;
			buildPhases = (
				444444444444444444444444 /* Sources */,
				555555555555555555555555 /* Frameworks */,
				666666666666666666666666 /* Resources */,
			);
			buildRules = (
			);
			dependencies = (
			);
			fileSystemSynchronizedGroups = (
				777777777777777777777777 /* MachinistsBench */,
			);
			name = MachinistsBench;
			productName = MachinistsBench;
			productReference = 333333333333333333333333 /* MachinistsBench.app */;
			productType = "com.apple.product-type.application";
		};
/* End PBXNativeTarget section */

/* Begin PBXProject section */
		111111111111111111111111 /* Project object */ = {
			isa = PBXProject;
			attributes = {
				BuildIndependentTargetsInParallel = 1;
				LastSwiftUpdateCheck = 1610;
				LastUpgradeCheck = 1610;
				TargetAttributes = {
					222222222222222222222222 = {
						CreatedOnToolsVersion = 16.1;
					};
				};
			};
			buildConfigurationList = AAAAAAAAAAAAAAAAAAAAAAAA /* Build configuration list for PBXProject "MachinistsBench" */;
			compatibilityVersion = "Xcode 15.0";
			developmentRegion = en;
			hasScannedForEncodings = 0;
			knownRegions = (
				en,
				Base,
			);
			mainGroup = 888888888888888888888888;
			productRefGroup = 999999999999999999999999 /* Products */;
			projectDirPath = "";
			projectRoot = "";
			targets = (
				222222222222222222222222 /* MachinistsBench */,
			);
		};
/* End PBXProject section */

/* Begin PBXResourcesBuildPhase section */
		666666666666666666666666 /* Resources */ = {
			isa = PBXResourcesBuildPhase;
			buildActionMask = 2147483647;
			files = (
			);
			runOnlyForDeploymentPostprocessing = 0;
		};
/* End PBXResourcesBuildPhase section */

/* Begin PBXSourcesBuildPhase section */
		444444444444444444444444 /* Sources */ = {
			isa = PBXSourcesBuildPhase;
			buildActionMask = 2147483647;
			files = (
			);
			runOnlyForDeploymentPostprocessing = 0;
		};
/* End PBXSourcesBuildPhase section */

/* Begin XCBuildConfiguration section */
		CCCCCCCCCCCCCCCCCCCCCCCC /* Debug */ = {
			isa = XCBuildConfiguration;
			buildSettings = {
				ALWAYS_SEARCH_USER_PATHS = NO;
				CLANG_ENABLE_MODULES = YES;
				ENABLE_STRICT_OBJC_MSGSEND = YES;
				GCC_NO_COMMON_BLOCKS = YES;
				IPHONEOS_DEPLOYMENT_TARGET = 17.0;
				ONLY_ACTIVE_ARCH = YES;
				SDKROOT = iphoneos;
				SWIFT_OPTIMIZATION_LEVEL = "-Onone";
				SWIFT_VERSION = 6.0;
			};
			name = Debug;
		};
		DDDDDDDDDDDDDDDDDDDDDDDD /* Release */ = {
			isa = XCBuildConfiguration;
			buildSettings = {
				ALWAYS_SEARCH_USER_PATHS = NO;
				CLANG_ENABLE_MODULES = YES;
				ENABLE_STRICT_OBJC_MSGSEND = YES;
				GCC_NO_COMMON_BLOCKS = YES;
				IPHONEOS_DEPLOYMENT_TARGET = 17.0;
				SDKROOT = iphoneos;
				SWIFT_COMPILATION_MODE = wholemodule;
				SWIFT_VERSION = 6.0;
				VALIDATE_PRODUCT = YES;
			};
			name = Release;
		};
		EEEEEEEEEEEEEEEEEEEEEEEE /* Debug */ = {
			isa = XCBuildConfiguration;
			buildSettings = {
				ASSETCATALOG_COMPILER_GLOBAL_ACCENT_COLOR_NAME = AccentColor;
				CODE_SIGN_STYLE = Automatic;
				CURRENT_PROJECT_VERSION = 1;
				ENABLE_PREVIEWS = YES;
				GENERATE_INFOPLIST_FILE = YES;
				INFOPLIST_KEY_CFBundleDisplayName = "Machinist's Bench";
				INFOPLIST_KEY_UIApplicationSceneManifest_Generation = YES;
				INFOPLIST_KEY_UILaunchScreen_Generation = YES;
				INFOPLIST_KEY_UISupportedInterfaceOrientations = "UIInterfaceOrientationPortrait";
				MARKETING_VERSION = 1.0;
				PRODUCT_BUNDLE_IDENTIFIER = com.machinistsbench.app;
				PRODUCT_NAME = "$(TARGET_NAME)";
				SWIFT_EMIT_LOC_STRINGS = YES;
				SWIFT_VERSION = 6.0;
				TARGETED_DEVICE_FAMILY = 1;
			};
			name = Debug;
		};
		FFFFFFFFFFFFFFFFFFFFFFFF /* Release */ = {
			isa = XCBuildConfiguration;
			buildSettings = {
				ASSETCATALOG_COMPILER_GLOBAL_ACCENT_COLOR_NAME = AccentColor;
				CODE_SIGN_STYLE = Automatic;
				CURRENT_PROJECT_VERSION = 1;
				ENABLE_PREVIEWS = YES;
				GENERATE_INFOPLIST_FILE = YES;
				INFOPLIST_KEY_CFBundleDisplayName = "Machinist's Bench";
				INFOPLIST_KEY_UIApplicationSceneManifest_Generation = YES;
				INFOPLIST_KEY_UILaunchScreen_Generation = YES;
				INFOPLIST_KEY_UISupportedInterfaceOrientations = "UIInterfaceOrientationPortrait";
				MARKETING_VERSION = 1.0;
				PRODUCT_BUNDLE_IDENTIFIER = com.machinistsbench.app;
				PRODUCT_NAME = "$(TARGET_NAME)";
				SWIFT_EMIT_LOC_STRINGS = YES;
				SWIFT_VERSION = 6.0;
				TARGETED_DEVICE_FAMILY = 1;
			};
			name = Release;
		};
/* End XCBuildConfiguration section */

/* Begin XCConfigurationList section */
		AAAAAAAAAAAAAAAAAAAAAAAA /* Build configuration list for PBXProject "MachinistsBench" */ = {
			isa = XCConfigurationList;
			buildConfigurations = (
				CCCCCCCCCCCCCCCCCCCCCCCC /* Debug */,
				DDDDDDDDDDDDDDDDDDDDDDDD /* Release */,
			);
			defaultConfigurationIsVisible = 0;
			defaultConfigurationName = Release;
		};
		BBBBBBBBBBBBBBBBBBBBBBBB /* Build configuration list for PBXNativeTarget "MachinistsBench" */ = {
			isa = XCConfigurationList;
			buildConfigurations = (
				EEEEEEEEEEEEEEEEEEEEEEEE /* Debug */,
				FFFFFFFFFFFFFFFFFFFFFFFF /* Release */,
			);
			defaultConfigurationIsVisible = 0;
			defaultConfigurationName = Release;
		};
/* End XCConfigurationList section */
	};
	rootObject = 111111111111111111111111 /* Project object */;
}
```

- [ ] **Step 4: Build for the simulator (this is the scaffold's test)**

Run:
```bash
xcodebuild build -project MachinistsBench.xcodeproj -scheme MachinistsBench \
  -destination 'generic/platform=iOS Simulator' 2>&1 | tail -5
```
Expected: `** BUILD SUCCEEDED **`. (If the scheme isn't found, run once: `xcodebuild -list -project MachinistsBench.xcodeproj` — Xcode auto-creates the `MachinistsBench` scheme on first build.)

- [ ] **Step 5: Launch in the simulator (visual confirm)**

```bash
xcrun simctl boot "iPhone 16" 2>/dev/null; open -a Simulator
APP=$(xcodebuild -project MachinistsBench.xcodeproj -scheme MachinistsBench -showBuildSettings -destination 'generic/platform=iOS Simulator' 2>/dev/null | awk -F'= ' '/ BUILT_PRODUCTS_DIR /{d=$2} / FULL_PRODUCT_NAME /{n=$2} END{print d"/"n}')
# rebuild for the booted sim, then install+launch:
xcodebuild build -project MachinistsBench.xcodeproj -scheme MachinistsBench -destination 'platform=iOS Simulator,name=iPhone 16' >/dev/null
xcrun simctl install booted "$APP" && xcrun simctl launch booted com.machinistsbench.app
```
Expected: app launches showing "Machinist's Bench".

- [ ] **Step 6: Commit**

```bash
git add .gitignore MachinistsBench.xcodeproj MachinistsBench/App.swift
git commit -m "Scaffold iOS app project (synchronized group, builds + runs)"
```

---

### Task 2: SwiftPM Core package for headless logic tests

**Files:**
- Create: `Package.swift`
- Create: `MachinistsBench/Core/CoreVersion.swift` (placeholder symbol so the module isn't empty)
- Test: `Tests/MachinistsCoreTests/SmokeTests.swift`

**Interfaces:**
- Produces: SwiftPM library module `MachinistsCore` compiled from `MachinistsBench/Core/`; test target `MachinistsCoreTests` runnable via `swift test`.

- [ ] **Step 1: Create `Package.swift`**

```swift
// swift-tools-version: 6.0
import PackageDescription

let package = Package(
    name: "MachinistsCore",
    platforms: [.iOS(.v17), .macOS(.v14)],
    targets: [
        .target(name: "MachinistsCore", path: "MachinistsBench/Core"),
        .testTarget(
            name: "MachinistsCoreTests",
            dependencies: ["MachinistsCore"],
            path: "Tests/MachinistsCoreTests"
        ),
    ]
)
```

- [ ] **Step 2: Create `MachinistsBench/Core/CoreVersion.swift`**

```swift
public enum Core {
    public static let version = "1.0"
}
```

- [ ] **Step 3: Write the smoke test** `Tests/MachinistsCoreTests/SmokeTests.swift`

```swift
import XCTest
@testable import MachinistsCore

final class SmokeTests: XCTestCase {
    func testModuleLoads() {
        XCTAssertEqual(Core.version, "1.0")
    }
}
```

- [ ] **Step 4: Run tests — verify they pass**

Run: `swift test 2>&1 | tail -5`
Expected: `Test Suite 'All tests' passed` (1 test).

- [ ] **Step 5: Confirm the app still builds** (Core is now also in the synchronized group)

Run: `xcodebuild build -project MachinistsBench.xcodeproj -scheme MachinistsBench -destination 'generic/platform=iOS Simulator' 2>&1 | tail -3`
Expected: `** BUILD SUCCEEDED **`

- [ ] **Step 6: Commit**

```bash
git add Package.swift MachinistsBench/Core Tests/
git commit -m "Add SwiftPM Core package for headless logic tests"
```

---

### Task 3: Units (Imperial/Metric) — conversions

**Files:**
- Create: `MachinistsBench/Core/Units.swift`
- Test: `Tests/MachinistsCoreTests/UnitsTests.swift`

**Interfaces:**
- Produces:
  - `public enum UnitSystem: String, CaseIterable { case imperial, metric }`
  - `public enum Convert` with: `static func mPerMin(fromSFM sfm: Double) -> Double` (×0.3048), `static func cm3(fromCubicInchPerMin v: Double) -> Double` (×16.387064), `static func mm(fromInch v: Double) -> Double` (×25.4).

- [ ] **Step 1: Write the failing test** `Tests/MachinistsCoreTests/UnitsTests.swift`

```swift
import XCTest
@testable import MachinistsCore

final class UnitsTests: XCTestCase {
    func testSFMtoMetersPerMin() {
        XCTAssertEqual(Convert.mPerMin(fromSFM: 400), 121.92, accuracy: 1e-9)
    }
    func testCubicInchToCubicCm() {
        XCTAssertEqual(Convert.cm3(fromCubicInchPerMin: 2.88), 47.19474432, accuracy: 1e-6)
    }
    func testInchToMM() {
        XCTAssertEqual(Convert.mm(fromInch: 0.012), 0.3048, accuracy: 1e-9)
    }
    func testUnitSystemCases() {
        XCTAssertEqual(UnitSystem.allCases, [.imperial, .metric])
    }
}
```

- [ ] **Step 2: Run — verify it fails**

Run: `swift test --filter UnitsTests 2>&1 | tail -5`
Expected: FAIL — `cannot find 'Convert' in scope`.

- [ ] **Step 3: Implement** `MachinistsBench/Core/Units.swift`

```swift
import Foundation

public enum UnitSystem: String, CaseIterable, Sendable {
    case imperial, metric
}

public enum Convert {
    public static func mPerMin(fromSFM sfm: Double) -> Double { sfm * 0.3048 }
    public static func cm3(fromCubicInchPerMin v: Double) -> Double { v * 16.387064 }
    public static func mm(fromInch v: Double) -> Double { v * 25.4 }
}
```

- [ ] **Step 4: Run — verify it passes**

Run: `swift test --filter UnitsTests 2>&1 | tail -5`
Expected: PASS (4 tests).

- [ ] **Step 5: Commit**

```bash
git add MachinistsBench/Core/Units.swift Tests/MachinistsCoreTests/UnitsTests.swift
git commit -m "Add Units conversions (SFM, MRR, inch) with tests"
```

---

### Task 4: Materials data (verbatim from app.html)

**Files:**
- Create: `MachinistsBench/Core/Data/Materials.swift`
- Test: `Tests/MachinistsCoreTests/MaterialsTests.swift`

**Interfaces:**
- Produces:
  - `public struct Material: Identifiable, Sendable { public let id: String; public let name: String; public let hardness: String; public let hssSFM: ClosedRange<Int>; public let carbideSFM: ClosedRange<Int>; public let feedIPR: Double; public let kp: Double }`
  - `public enum Materials { public static let all: [Material] }` in the exact order below; `public static func byID(_ id: String) -> Material?`.
- Field mapping from `app.html` `MAT`: `id`=key, `name`=`n`, `hardness`=`hb`, `hssSFM`=`t[0]...t[1]`, `carbideSFM`=`tc[0]...tc[1]`, `feedIPR`=`fT`, `kp`=`kp`.

- [ ] **Step 1: Write the failing test** `Tests/MachinistsCoreTests/MaterialsTests.swift`

```swift
import XCTest
@testable import MachinistsCore

final class MaterialsTests: XCTestCase {
    func testCount() { XCTAssertEqual(Materials.all.count, 19) }

    func testOrderFirstAndLast() {
        XCTAssertEqual(Materials.all.first?.id, "alum")
        XCTAssertEqual(Materials.all.last?.id, "plastic")
    }

    func testLowCarbon() {
        let m = Materials.byID("lowc")!
        XCTAssertEqual(m.name, "Low-Carbon Steel (1018)")
        XCTAssertEqual(m.carbideSFM, 350...550)
        XCTAssertEqual(m.feedIPR, 0.012, accuracy: 1e-9)
        XCTAssertEqual(m.kp, 1.0, accuracy: 1e-9)
    }

    func testTitanium() {
        let m = Materials.byID("ti")!
        XCTAssertEqual(m.hssSFM, 30...50)
        XCTAssertEqual(m.kp, 1.2, accuracy: 1e-9)
    }

    func testInconel() {
        XCTAssertEqual(Materials.byID("inconel")!.kp, 2.2, accuracy: 1e-9)
    }
}
```

- [ ] **Step 2: Run — verify it fails**

Run: `swift test --filter MaterialsTests 2>&1 | tail -5`
Expected: FAIL — `cannot find 'Materials' in scope`.

- [ ] **Step 3: Implement** `MachinistsBench/Core/Data/Materials.swift` (all 19, verbatim)

```swift
public struct Material: Identifiable, Sendable {
    public let id: String
    public let name: String
    public let hardness: String
    public let hssSFM: ClosedRange<Int>
    public let carbideSFM: ClosedRange<Int>
    public let feedIPR: Double
    public let kp: Double
}

public enum Materials {
    public static let all: [Material] = [
        Material(id: "alum",     name: "Aluminum (wrought)",          hardness: "~95 HB",     hssSFM: 250...400, carbideSFM: 600...1200, feedIPR: 0.012, kp: 0.25),
        Material(id: "al6061",   name: "Aluminum 6061-T6",            hardness: "~95 HB",     hssSFM: 250...400, carbideSFM: 600...1200, feedIPR: 0.012, kp: 0.28),
        Material(id: "brass",    name: "Brass (free-cutting)",        hardness: "~120 HB",    hssSFM: 150...300, carbideSFM: 400...700,  feedIPR: 0.010, kp: 0.55),
        Material(id: "bronze",   name: "Bronze (leaded)",             hardness: "~150 HB",    hssSFM: 90...150,  carbideSFM: 200...400,  feedIPR: 0.010, kp: 0.65),
        Material(id: "castiron", name: "Cast Iron (gray, soft)",      hardness: "120–150 HB", hssSFM: 80...120,  carbideSFM: 250...400,  feedIPR: 0.012, kp: 0.55),
        Material(id: "ductile",  name: "Cast Iron (ductile/nodular)", hardness: "170–200 HB", hssSFM: 60...100,  carbideSFM: 200...350,  feedIPR: 0.011, kp: 0.80),
        Material(id: "s12l14",   name: "12L14 Steel (free-mach.)",    hardness: "~160 HB",    hssSFM: 110...160, carbideSFM: 400...700,  feedIPR: 0.013, kp: 0.90),
        Material(id: "lowc",     name: "Low-Carbon Steel (1018)",     hardness: "~125 HB",    hssSFM: 90...130,  carbideSFM: 350...550,  feedIPR: 0.012, kp: 1.00),
        Material(id: "medc",     name: "Medium-Carbon Steel (1045)",  hardness: "~180 HB",    hssSFM: 70...100,  carbideSFM: 300...450,  feedIPR: 0.011, kp: 1.10),
        Material(id: "alloy",    name: "Alloy Steel (4140)",          hardness: "~200 HB",    hssSFM: 60...90,   carbideSFM: 250...400,  feedIPR: 0.010, kp: 1.40),
        Material(id: "o1",       name: "O-1 Tool Steel (annealed)",   hardness: "~190 HB",    hssSFM: 55...80,   carbideSFM: 220...375,  feedIPR: 0.009, kp: 1.50),
        Material(id: "tool",     name: "Tool Steel (annealed)",       hardness: "~220 HB",    hssSFM: 50...70,   carbideSFM: 200...350,  feedIPR: 0.009, kp: 1.40),
        Material(id: "ss303",    name: "Stainless 303 (free-mach.)",  hardness: "~160 HB",    hssSFM: 70...100,  carbideSFM: 250...400,  feedIPR: 0.009, kp: 1.40),
        Material(id: "ss304",    name: "Stainless 304 (austenitic)",  hardness: "~150 HB",    hssSFM: 50...80,   carbideSFM: 200...350,  feedIPR: 0.008, kp: 1.40),
        Material(id: "ss316",    name: "Stainless 316 (austenitic)",  hardness: "~160 HB",    hssSFM: 40...70,   carbideSFM: 175...300,  feedIPR: 0.007, kp: 1.50),
        Material(id: "ss416",    name: "Stainless 416 (free-mach.)",  hardness: "~180 HB",    hssSFM: 80...120,  carbideSFM: 300...450,  feedIPR: 0.009, kp: 1.30),
        Material(id: "ti",       name: "Titanium (Ti-6Al-4V)",        hardness: "~330 HB",    hssSFM: 30...50,   carbideSFM: 100...200,  feedIPR: 0.007, kp: 1.20),
        Material(id: "inconel",  name: "Inconel / Superalloy",        hardness: "~300 HB",    hssSFM: 15...30,   carbideSFM: 60...120,   feedIPR: 0.006, kp: 2.20),
        Material(id: "plastic",  name: "Plastic / Nylon / Delrin",    hardness: "—",          hssSFM: 200...500, carbideSFM: 400...1000, feedIPR: 0.012, kp: 0.10),
    ]

    public static func byID(_ id: String) -> Material? { all.first { $0.id == id } }
}
```

- [ ] **Step 4: Run — verify it passes**

Run: `swift test --filter MaterialsTests 2>&1 | tail -5`
Expected: PASS (5 tests).

- [ ] **Step 5: Commit**

```bash
git add MachinistsBench/Core/Data/Materials.swift Tests/MachinistsCoreTests/MaterialsTests.swift
git commit -m "Add Materials table (19 entries, verbatim) with tests"
```

---

### Task 5: Turning calculator (pure functions)

**Files:**
- Create: `MachinistsBench/Core/Calc/Turning.swift`
- Test: `Tests/MachinistsCoreTests/TurningCalcTests.swift`

Source of truth: `app.html` `Turning` (lines ~898–930), `coatFactor`/`lubeFactor` (lines ~461–477), `COAT_F` (line ~460).

**Interfaces:**
- Produces:
  - `public enum Tool: String, CaseIterable, Sendable { case hss, carbide }`
  - `public enum Coating: String, CaseIterable, Sendable { case none, tin, ticn, tialn, alcrn }`
  - `public enum Lube: String, CaseIterable, Sendable { case flood, oil, dry }`
  - `public func coatFactor(tool: Tool, coating: Coating) -> Double`
  - `public func lubeFactor(materialID: String, lube: Lube) -> Double`
  - `public struct TurningResult: Sendable { public let rpm, ipm, mrr, cutHP, motorHP, laf, fProg: Double }`
  - `public func turning(diameterIn: Double, docIn: Double, sfm: Double, feedIPR: Double, efficiency: Double, leadDeg: Double, kp: Double) -> TurningResult?` — returns `nil` if any of diameter/doc/sfm/feed is NaN or ≤ 0 (mirrors web guard).
  - `public func recommendedSFM(material: Material, tool: Tool, coating: Coating, lube: Lube) -> ClosedRange<Int>` — applies lube×coat factors to the SFM range, rounded (web `rngAdj`).

- [ ] **Step 1: Write the failing test** `Tests/MachinistsCoreTests/TurningCalcTests.swift`

```swift
import XCTest
@testable import MachinistsCore

final class TurningCalcTests: XCTestCase {
    func testCoatFactor() {
        XCTAssertEqual(coatFactor(tool: .carbide, coating: .none), 1.0, accuracy: 1e-9)
        XCTAssertEqual(coatFactor(tool: .carbide, coating: .tialn), 1.5, accuracy: 1e-9)
        XCTAssertEqual(coatFactor(tool: .hss, coating: .tialn), 1.2, accuracy: 1e-9) // 1+(1.5-1)*0.4
    }

    func testLubeFactor() {
        XCTAssertEqual(lubeFactor(materialID: "lowc", lube: .oil), 0.85, accuracy: 1e-9)
        XCTAssertEqual(lubeFactor(materialID: "lowc", lube: .dry), 0.70, accuracy: 1e-9)
        XCTAssertEqual(lubeFactor(materialID: "castiron", lube: .dry), 1.0, accuracy: 1e-9)
        XCTAssertEqual(lubeFactor(materialID: "ductile", lube: .oil), 1.0, accuracy: 1e-9)
    }

    func testTurningSquareEdge() {
        let r = turning(diameterIn: 1.5, docIn: 0.05, sfm: 400, feedIPR: 0.012,
                        efficiency: 0.8, leadDeg: 90, kp: 1.0)!
        XCTAssertEqual(r.rpm, 1018.5916357881301, accuracy: 1e-4)
        XCTAssertEqual(r.ipm, 12.223099629457561, accuracy: 1e-4)
        XCTAssertEqual(r.mrr, 2.88, accuracy: 1e-9)
        XCTAssertEqual(r.cutHP, 2.88, accuracy: 1e-9)
        XCTAssertEqual(r.motorHP, 3.6, accuracy: 1e-9)
        XCTAssertEqual(r.laf, 1.0, accuracy: 1e-9)
    }

    func testTurningLeadAngleThinsChip() {
        let r = turning(diameterIn: 1.5, docIn: 0.05, sfm: 400, feedIPR: 0.012,
                        efficiency: 0.8, leadDeg: 45, kp: 1.0)!
        XCTAssertEqual(r.laf, 1.4142135623730951, accuracy: 1e-9)
        XCTAssertEqual(r.fProg, 0.016970562748477142, accuracy: 1e-9)
        XCTAssertEqual(r.mrr, 4.072935059634514, accuracy: 1e-6)
    }

    func testTurningGuardRejectsBadInput() {
        XCTAssertNil(turning(diameterIn: 0, docIn: 0.05, sfm: 400, feedIPR: 0.012,
                             efficiency: 0.8, leadDeg: 90, kp: 1.0))
    }

    func testRecommendedSFM() {
        let lowc = Materials.byID("lowc")!
        // carbide/none/oil → 350...550 × 0.85 → round(297.5)=298 ... round(467.5)=468
        XCTAssertEqual(recommendedSFM(material: lowc, tool: .carbide, coating: .none, lube: .oil), 298...468)
    }
}
```

- [ ] **Step 2: Run — verify it fails**

Run: `swift test --filter TurningCalcTests 2>&1 | tail -5`
Expected: FAIL — `cannot find 'turning' in scope`.

- [ ] **Step 3: Implement** `MachinistsBench/Core/Calc/Turning.swift`

```swift
import Foundation

public enum Tool: String, CaseIterable, Sendable { case hss, carbide }
public enum Coating: String, CaseIterable, Sendable { case none, tin, ticn, tialn, alcrn }
public enum Lube: String, CaseIterable, Sendable { case flood, oil, dry }

private let coatF: [Coating: Double] = [.none: 1, .tin: 1.2, .ticn: 1.3, .tialn: 1.5, .alcrn: 1.6]

public func coatFactor(tool: Tool, coating: Coating) -> Double {
    let cf = coatF[coating] ?? 1
    return tool == .hss ? 1 + (cf - 1) * 0.4 : cf
}

public func lubeFactor(materialID: String, lube: Lube) -> Double {
    if materialID == "castiron" || materialID == "ductile" { return 1 }
    switch lube {
    case .oil: return 0.85
    case .dry: return 0.70
    case .flood: return 1
    }
}

public struct TurningResult: Sendable {
    public let rpm, ipm, mrr, cutHP, motorHP, laf, fProg: Double
}

public func turning(diameterIn d: Double, docIn c: Double, sfm: Double, feedIPR: Double,
                    efficiency: Double, leadDeg: Double, kp: Double) -> TurningResult? {
    let eff = efficiency > 0 ? efficiency : 0.8
    let lead = leadDeg > 0 ? leadDeg : 90
    for v in [d, c, sfm, feedIPR] where v.isNaN || v <= 0 { return nil }
    let laf = (lead > 0 && lead < 90) ? 1 / sin(lead * .pi / 180) : 1
    let fProg = feedIPR * laf
    let rpm = sfm * 12 / (.pi * d)
    let ipm = rpm * fProg
    let mrr = 12 * sfm * fProg * c
    let cutHP = kp * mrr
    return TurningResult(rpm: rpm, ipm: ipm, mrr: mrr, cutHP: cutHP,
                         motorHP: cutHP / eff, laf: laf, fProg: fProg)
}

public func recommendedSFM(material: Material, tool: Tool, coating: Coating, lube: Lube) -> ClosedRange<Int> {
    let range = tool == .hss ? material.hssSFM : material.carbideSFM
    let lf = lubeFactor(materialID: material.id, lube: lube)
    let cf = coatFactor(tool: tool, coating: coating)
    let lo = Int((Double(range.lowerBound) * lf * cf).rounded())
    let hi = Int((Double(range.upperBound) * lf * cf).rounded())
    return lo...hi
}
```

Note: parameter labels in the signature are `diameterIn d:` etc.; the test calls `turning(diameterIn:docIn:sfm:feedIPR:efficiency:leadDeg:kp:)`. Keep them matching exactly.

- [ ] **Step 4: Run — verify it passes**

Run: `swift test --filter TurningCalcTests 2>&1 | tail -5`
Expected: PASS (7 tests). Then run the whole suite: `swift test 2>&1 | tail -3` → all pass.

- [ ] **Step 5: Commit**

```bash
git add MachinistsBench/Core/Calc/Turning.swift Tests/MachinistsCoreTests/TurningCalcTests.swift
git commit -m "Add Turning calc (rpm/ipm/mrr/power, coat+lube factors) with golden tests"
```

---

### Task 6: Catppuccin theme

**Files:**
- Create: `MachinistsBench/Theme/Catppuccin.swift`
- Create: `MachinistsBench/Theme/Typography.swift`

Consult `swiftui-design-skill` for applying the palette without a generic look. Fonts: use SF Pro / SF Mono via `.system` roles now; bundling Chakra Petch + JetBrains Mono is deferred (not needed for the slice).
```
ponytail: SF system fonts now; bundle custom fonts only if the look demands it later.
```

**Interfaces:**
- Produces:
  - `enum Catppuccin` with Mocha colors as `static let`: `base` (#1e1e2e), `mantle` (#181825), `surface0` (#313244), `surface1` (#45475a), `text` (#cdd6f4), `subtext0` (#a6adc8), `overlay0` (#6c7086), `blue` (#89b4fa), `teal` (#94e2d5), `green` (#a6e3a1), `peach` (#fab387), `mauve` (#cba6f7), `red` (#f38ba8), plus `init` helper `static func hex(_:) -> Color`.
  - `enum Accent: String { case blue, teal, peach, mauve, green, red; var color: Color }` (section accent roles).
  - `enum AppFont { static func display(_ size: CGFloat) -> Font; static func mono(_ size: CGFloat) -> Font; static func body(_ size: CGFloat) -> Font }`.

- [ ] **Step 1: Implement** `MachinistsBench/Theme/Catppuccin.swift`

```swift
import SwiftUI

enum Catppuccin {
    static func hex(_ v: UInt32) -> Color {
        Color(red: Double((v >> 16) & 0xFF) / 255,
              green: Double((v >> 8) & 0xFF) / 255,
              blue: Double(v & 0xFF) / 255)
    }
    // Mocha
    static let base     = hex(0x1e1e2e)
    static let mantle   = hex(0x181825)
    static let surface0 = hex(0x313244)
    static let surface1 = hex(0x45475a)
    static let text     = hex(0xcdd6f4)
    static let subtext0 = hex(0xa6adc8)
    static let overlay0 = hex(0x6c7086)
    static let blue     = hex(0x89b4fa)
    static let teal     = hex(0x94e2d5)
    static let green    = hex(0xa6e3a1)
    static let peach    = hex(0xfab387)
    static let mauve    = hex(0xcba6f7)
    static let red      = hex(0xf38ba8)
}

enum Accent: String, CaseIterable {
    case blue, teal, peach, mauve, green, red
    var color: Color {
        switch self {
        case .blue: return Catppuccin.blue
        case .teal: return Catppuccin.teal
        case .peach: return Catppuccin.peach
        case .mauve: return Catppuccin.mauve
        case .green: return Catppuccin.green
        case .red: return Catppuccin.red
        }
    }
}
```

- [ ] **Step 2: Implement** `MachinistsBench/Theme/Typography.swift`

```swift
import SwiftUI

enum AppFont {
    static func display(_ size: CGFloat) -> Font { .system(size: size, weight: .bold, design: .rounded) }
    static func mono(_ size: CGFloat) -> Font { .system(size: size, weight: .medium, design: .monospaced) }
    static func body(_ size: CGFloat) -> Font { .system(size: size, weight: .regular) }
}
```

- [ ] **Step 3: Verify the app builds with the theme**

Run: `xcodebuild build -project MachinistsBench.xcodeproj -scheme MachinistsBench -destination 'generic/platform=iOS Simulator' 2>&1 | tail -3`
Expected: `** BUILD SUCCEEDED **`

- [ ] **Step 4: Commit**

```bash
git add MachinistsBench/Theme
git commit -m "Add Catppuccin Mocha theme + typography roles"
```

---

### Task 7: Shared component library (Turning subset)

**Files:**
- Create: `MachinistsBench/Components/Panel.swift`
- Create: `MachinistsBench/Components/Field.swift`
- Create: `MachinistsBench/Components/NumberInput.swift`
- Create: `MachinistsBench/Components/Segmented.swift`
- Create: `MachinistsBench/Components/Readout.swift`
- Create: `MachinistsBench/Components/NoteView.swift`
- Create: `MachinistsBench/Components/SpeedInput.swift`

Consult `swiftui-skills` for idiomatic patterns. These mirror the web primitives; build only what Turning needs. DataTable + Collapse are deferred to the first section that uses them.
```
ponytail: build the 7 components Turning consumes; defer DataTable/Collapse to their first consumer.
```

**Interfaces (consumed by Task 8):**
- `Panel(title: String, accent: Accent, subtitle: String? = nil) { content }` — titled card.
- `Field(label: String, hint: String? = nil) { content }` — labeled row.
- `NumberInput(value: Binding<Double>, step: Double, accent: Accent)` — decimal entry.
- `Segmented<T: Hashable>(selection: Binding<T>, options: [(T, String)], accent: Accent)`.
- `Readout(label: String, value: String, unit: String, sub: String? = nil, accent: Accent, big: Bool = false)`.
- `NoteView(tone: NoteTone = .info, text: String)` where `enum NoteTone { case info, warn, bad, good }`.
- `SpeedInput(sfm: Binding<Double>, system: UnitSystem, accent: Accent)` — shows SFM or m/min depending on `system`, stores SFM.

- [ ] **Step 1: Implement `Panel.swift`**

```swift
import SwiftUI

struct Panel<Content: View>: View {
    let title: String
    let accent: Accent
    var subtitle: String? = nil
    @ViewBuilder var content: Content

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            VStack(alignment: .leading, spacing: 2) {
                Text(title).font(AppFont.display(18)).foregroundStyle(accent.color)
                if let subtitle {
                    Text(subtitle).font(AppFont.mono(11)).foregroundStyle(Catppuccin.subtext0)
                }
            }
            content
        }
        .padding(16)
        .background(Catppuccin.mantle, in: RoundedRectangle(cornerRadius: 14))
        .overlay(RoundedRectangle(cornerRadius: 14).strokeBorder(accent.color.opacity(0.25)))
    }
}
```

- [ ] **Step 2: Implement `Field.swift`**

```swift
import SwiftUI

struct Field<Content: View>: View {
    let label: String
    var hint: String? = nil
    @ViewBuilder var content: Content

    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            HStack {
                Text(label).font(AppFont.mono(11)).foregroundStyle(Catppuccin.subtext0)
                Spacer()
                if let hint {
                    Text(hint).font(AppFont.mono(10)).foregroundStyle(Catppuccin.overlay0)
                }
            }
            content
        }
    }
}
```

- [ ] **Step 3: Implement `NumberInput.swift`**

```swift
import SwiftUI

struct NumberInput: View {
    @Binding var value: Double
    let step: Double
    let accent: Accent

    var body: some View {
        HStack(spacing: 8) {
            TextField("", value: $value, format: .number)
                .keyboardType(.decimalPad)
                .font(AppFont.mono(16))
                .foregroundStyle(Catppuccin.text)
            Stepper("", value: $value, step: step).labelsHidden()
        }
        .padding(.horizontal, 12).padding(.vertical, 8)
        .background(Catppuccin.surface0, in: RoundedRectangle(cornerRadius: 8))
        .overlay(RoundedRectangle(cornerRadius: 8).strokeBorder(accent.color.opacity(0.2)))
    }
}
```

- [ ] **Step 4: Implement `Segmented.swift`**

```swift
import SwiftUI

struct Segmented<T: Hashable>: View {
    @Binding var selection: T
    let options: [(T, String)]
    let accent: Accent

    var body: some View {
        HStack(spacing: 4) {
            ForEach(options, id: \.0) { value, label in
                let on = value == selection
                Button { selection = value } label: {
                    Text(label)
                        .font(AppFont.display(13))
                        .padding(.horizontal, 14).padding(.vertical, 7)
                        .frame(maxWidth: .infinity)
                        .foregroundStyle(on ? accent.color : Catppuccin.subtext0)
                        .background(on ? accent.color.opacity(0.15) : .clear,
                                    in: RoundedRectangle(cornerRadius: 8))
                        .overlay(RoundedRectangle(cornerRadius: 8)
                            .strokeBorder(on ? accent.color : Catppuccin.surface1, lineWidth: 1))
                }
                .buttonStyle(.plain)
            }
        }
    }
}
```

- [ ] **Step 5: Implement `Readout.swift`**

```swift
import SwiftUI

struct Readout: View {
    let label: String
    let value: String
    let unit: String
    var sub: String? = nil
    let accent: Accent
    var big: Bool = false

    var body: some View {
        VStack(alignment: .leading, spacing: 3) {
            Text(label.uppercased()).font(AppFont.mono(10)).foregroundStyle(Catppuccin.subtext0)
            HStack(alignment: .firstTextBaseline, spacing: 4) {
                Text(value).font(AppFont.display(big ? 30 : 20)).foregroundStyle(accent.color)
                Text(unit).font(AppFont.mono(12)).foregroundStyle(Catppuccin.subtext0)
            }
            if let sub {
                Text(sub).font(AppFont.mono(10)).foregroundStyle(Catppuccin.overlay0)
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(12)
        .background(Catppuccin.surface0, in: RoundedRectangle(cornerRadius: 10))
    }
}
```

- [ ] **Step 6: Implement `NoteView.swift`**

```swift
import SwiftUI

enum NoteTone { case info, warn, bad, good }

struct NoteView: View {
    var tone: NoteTone = .info
    let text: String

    private var color: Color {
        switch tone {
        case .info: return Catppuccin.blue
        case .warn: return Catppuccin.peach
        case .bad:  return Catppuccin.red
        case .good: return Catppuccin.green
        }
    }

    var body: some View {
        Text(text)
            .font(AppFont.body(13))
            .foregroundStyle(Catppuccin.text)
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(12)
            .background(color.opacity(0.12), in: RoundedRectangle(cornerRadius: 10))
            .overlay(RoundedRectangle(cornerRadius: 10).strokeBorder(color.opacity(0.4)))
    }
}
```

- [ ] **Step 7: Implement `SpeedInput.swift`**

```swift
import SwiftUI

// Stores SFM; displays SFM (imperial) or m/min (metric). 1 SFM = 0.3048 m/min.
struct SpeedInput: View {
    @Binding var sfm: Double
    let system: UnitSystem
    let accent: Accent

    private var displayBinding: Binding<Double> {
        Binding(
            get: { system == .metric ? (sfm * 0.3048) : sfm },
            set: { newValue in sfm = system == .metric ? (newValue / 0.3048) : newValue }
        )
    }

    var body: some View {
        HStack(spacing: 8) {
            TextField("", value: displayBinding, format: .number.precision(.fractionLength(0)))
                .keyboardType(.numberPad)
                .font(AppFont.mono(16))
                .foregroundStyle(Catppuccin.text)
            Text(system == .metric ? "m/min" : "SFM")
                .font(AppFont.mono(11)).foregroundStyle(Catppuccin.subtext0)
        }
        .padding(.horizontal, 12).padding(.vertical, 8)
        .background(Catppuccin.surface0, in: RoundedRectangle(cornerRadius: 8))
        .overlay(RoundedRectangle(cornerRadius: 8).strokeBorder(accent.color.opacity(0.2)))
    }
}
```

- [ ] **Step 8: Verify the app builds**

Run: `xcodebuild build -project MachinistsBench.xcodeproj -scheme MachinistsBench -destination 'generic/platform=iOS Simulator' 2>&1 | tail -3`
Expected: `** BUILD SUCCEEDED **`

- [ ] **Step 9: Commit**

```bash
git add MachinistsBench/Components
git commit -m "Add shared component library (Turning subset)"
```

---

### Task 8: Turning section view

**Files:**
- Create: `MachinistsBench/Sections/Turning/TurningView.swift`

Wires Core (Task 3–5) to Components (Task 7). Mirrors the web Turning UI: material/tool/coating/stock Ø/DOC/surface-speed/feed/lead/efficiency/fluid inputs → RPM, feed, MRR, power readouts, plus range warning Note. Defaults match `app.html`: material `lowc`, tool carbide, coat none, Ø 1.5", DOC 0.05", feed 0.012 ipr, lead 90, eff 0.80, lube oil; surface speed seeds to the midpoint of the recommended range.

**Interfaces:**
- Produces: `struct TurningView: View { let system: UnitSystem }`.

- [ ] **Step 1: Implement `TurningView.swift`**

```swift
import SwiftUI

struct TurningView: View {
    let system: UnitSystem

    @State private var materialID = "lowc"
    @State private var tool: Tool = .carbide
    @State private var coating: Coating = .none
    @State private var lube: Lube = .oil
    @State private var diameter = 1.5
    @State private var doc = 0.05
    @State private var sfm = 450.0
    @State private var feed = 0.012
    @State private var lead = 90.0
    @State private var eff = 0.80
    @State private var didSeed = false

    private var material: Material { Materials.byID(materialID) ?? Materials.all[0] }
    private var recRange: ClosedRange<Int> {
        recommendedSFM(material: material, tool: tool, coating: coating, lube: lube)
    }
    private var result: TurningResult? {
        turning(diameterIn: diameter, docIn: doc, sfm: sfm, feedIPR: feed,
                efficiency: eff, leadDeg: lead, kp: material.kp)
    }
    private var inRange: Bool {
        Int(sfm) >= recRange.lowerBound && Int(sfm) <= recRange.upperBound
    }

    var body: some View {
        ScrollView {
            VStack(spacing: 16) {
                Panel(title: "Turning — Lathe", accent: .blue,
                      subtitle: "RPM · feed · metal-removal · spindle power") {
                    inputs
                }
                if let r = result {
                    Panel(title: "Results", accent: .teal) { readouts(r) }
                    NoteView(tone: inRange ? .good : .warn, text: rangeNote)
                }
            }
            .padding(16)
        }
        .background(Catppuccin.base)
        .onAppear { seedSFM() }
        .onChange(of: materialID) { reseed() }
        .onChange(of: tool) { reseed() }
        .onChange(of: coating) { reseed() }
        .onChange(of: lube) { reseed() }
        .onChange(of: materialID) { feed = material.feedIPR }
    }

    @ViewBuilder private var inputs: some View {
        Field(label: "Material", hint: material.hardness) {
            Picker("", selection: $materialID) {
                ForEach(Materials.all) { Text($0.name).tag($0.id) }
            }.pickerStyle(.menu).tint(Catppuccin.blue)
        }
        Field(label: "Tool") {
            Segmented(selection: $tool, options: [(.hss, "HSS"), (.carbide, "Carbide")], accent: .blue)
        }
        Field(label: "Coating", hint: String(format: "×%.2f SFM", coatFactor(tool: tool, coating: coating))) {
            Picker("", selection: $coating) {
                Text("None").tag(Coating.none); Text("TiN").tag(Coating.tin)
                Text("TiCN").tag(Coating.ticn); Text("TiAlN").tag(Coating.tialn)
                Text("AlCrN").tag(Coating.alcrn)
            }.pickerStyle(.menu).tint(Catppuccin.blue)
        }
        Field(label: "Stock Ø", hint: system == .metric ? "mm" : "in") {
            NumberInput(value: $diameter, step: system == .metric ? 1 : 0.0625, accent: .blue)
        }
        Field(label: "Depth of Cut", hint: system == .metric ? "mm" : "in") {
            NumberInput(value: $doc, step: system == .metric ? 0.1 : 0.005, accent: .blue)
        }
        Field(label: "Surface Speed", hint: "rec \(recRange.lowerBound)–\(recRange.upperBound) SFM") {
            SpeedInput(sfm: $sfm, system: system, accent: .blue)
        }
        Field(label: "Feed", hint: system == .metric ? "mm/rev" : "in/rev") {
            NumberInput(value: $feed, step: system == .metric ? 0.01 : 0.001, accent: .blue)
        }
        Field(label: "Lead Angle", hint: "90° = square edge") {
            NumberInput(value: $lead, step: 5, accent: .blue)
        }
        Field(label: "Spindle Efficiency", hint: "0–1") {
            NumberInput(value: $eff, step: 0.05, accent: .blue)
        }
        Field(label: "Cutting Fluid") {
            Segmented(selection: $lube, options: [(.flood, "Flood"), (.oil, "Brushed oil"), (.dry, "Dry")], accent: .blue)
        }
    }

    @ViewBuilder private func readouts(_ r: TurningResult) -> some View {
        Readout(label: "Spindle Speed", value: "\(Int(r.rpm.rounded()))", unit: "RPM",
                sub: "\(Int(sfm.rounded())) SFM · \(Int(Convert.mPerMin(fromSFM: sfm).rounded())) m/min",
                accent: .blue, big: true)
        Readout(label: "Feed Rate",
                value: system == .metric ? "\(Int((r.ipm * 25.4).rounded()))" : String(format: "%.2f", r.ipm),
                unit: system == .metric ? "mm/min" : "IPM", accent: .teal, big: true)
        Readout(label: "Metal Removal",
                value: system == .metric ? String(format: "%.1f", Convert.cm3(fromCubicInchPerMin: r.mrr)) : String(format: "%.2f", r.mrr),
                unit: system == .metric ? "cm³/min" : "in³/min", accent: .green, big: true)
        Readout(label: "Cutting Power", value: String(format: "%.2f", r.cutHP),
                unit: "hp", sub: "Kp=\(material.kp)", accent: .peach)
        Readout(label: "Motor Power (est)", value: String(format: "%.2f", r.motorHP),
                unit: "hp", sub: "η=\(String(format: "%.2f", eff))", accent: .peach)
    }

    private var rangeNote: String {
        if inRange {
            return "✔ Surface speed is within the recommended range for this material, tool, and fluid."
        }
        let dir = Int(sfm) < recRange.lowerBound ? "Below" : "Above"
        let why = Int(sfm) < recRange.lowerBound
            ? "risk of built-up edge and poor finish." : "expect accelerated tool wear."
        return "⚠ \(dir) the recommended \(recRange.lowerBound)–\(recRange.upperBound) SFM — \(why)"
    }

    private func seedSFM() {
        guard !didSeed else { return }
        didSeed = true
        reseed()
        feed = material.feedIPR
    }
    private func reseed() {
        sfm = Double((recRange.lowerBound + recRange.upperBound) / 2)
    }
}

#Preview {
    TurningView(system: .imperial)
}
```

- [ ] **Step 2: Temporarily set the app root to `TurningView` to confirm it renders**

In `MachinistsBench/App.swift`, replace the body's `Text(...)` with `TurningView(system: .imperial)`:

```swift
import SwiftUI

@main
struct MachinistsBenchApp: App {
    var body: some Scene {
        WindowGroup {
            TurningView(system: .imperial)
        }
    }
}
```

- [ ] **Step 3: Build and run in the simulator**

```bash
xcodebuild build -project MachinistsBench.xcodeproj -scheme MachinistsBench -destination 'platform=iOS Simulator,name=iPhone 16' 2>&1 | tail -3
xcrun simctl boot "iPhone 16" 2>/dev/null; open -a Simulator
APP=$(xcodebuild -project MachinistsBench.xcodeproj -scheme MachinistsBench -showBuildSettings -destination 'platform=iOS Simulator,name=iPhone 16' 2>/dev/null | awk -F'= ' '/ BUILT_PRODUCTS_DIR /{d=$2} / FULL_PRODUCT_NAME /{n=$2} END{print d"/"n}')
xcrun simctl install booted "$APP" && xcrun simctl launch booted com.machinistsbench.app
```
Expected: `** BUILD SUCCEEDED **`, then the Turning calculator renders; changing material/Ø/speed updates RPM/feed/MRR and the range note flips good/warn. Spot-check against `app.html` (defaults → RPM ≈ 1018 at 400 SFM, Ø 1.5).

- [ ] **Step 4: Commit**

```bash
git add MachinistsBench/Sections/Turning/TurningView.swift MachinistsBench/App.swift
git commit -m "Add Turning section view (full slice rendering in simulator)"
```

---

### Task 9: Home screen + navigation + Imperial/Metric toggle

**Files:**
- Create: `MachinistsBench/Home/SectionCatalog.swift`
- Create: `MachinistsBench/Home/HomeView.swift`
- Modify: `MachinistsBench/App.swift`

Grouped home (Cutting / Calculate & Measure / Reference) listing all 15 sections; only **Turning** navigates in Milestone 1 — the rest show a "Coming soon" disabled row (added in later milestones). Imperial/Metric is a toolbar toggle persisted with `@AppStorage` and passed into sections.

**Interfaces:**
- Produces:
  - `struct SectionItem: Identifiable { let id: String; let name: String; let accent: Accent; let available: Bool }`
  - `enum SectionCatalog { static let groups: [(String, [SectionItem])] }`
  - `struct HomeView: View`.

- [ ] **Step 1: Implement `SectionCatalog.swift`**

```swift
import Foundation

struct SectionItem: Identifiable {
    let id: String
    let name: String
    let accent: Accent
    let available: Bool
}

enum SectionCatalog {
    static let groups: [(String, [SectionItem])] = [
        ("Cutting", [
            SectionItem(id: "turn", name: "Turning", accent: .blue, available: true),
            SectionItem(id: "drill", name: "Drilling", accent: .teal, available: false),
            SectionItem(id: "mill", name: "Milling", accent: .peach, available: false),
            SectionItem(id: "tap", name: "Tapping", accent: .mauve, available: false),
            SectionItem(id: "thread", name: "Threading", accent: .green, available: false),
            SectionItem(id: "bore", name: "Boring", accent: .peach, available: false),
            SectionItem(id: "ream", name: "Reaming", accent: .teal, available: false),
            SectionItem(id: "saw", name: "Band Saw", accent: .mauve, available: false),
        ]),
        ("Calculate & Measure", [
            SectionItem(id: "math", name: "Shop Math", accent: .mauve, available: false),
            SectionItem(id: "conv", name: "Converter", accent: .blue, available: false),
            SectionItem(id: "layout", name: "Layout", accent: .blue, available: false),
            SectionItem(id: "scale", name: "Scale", accent: .mauve, available: false),
        ]),
        ("Reference", [
            SectionItem(id: "threads", name: "Threads", accent: .blue, available: false),
            SectionItem(id: "rose", name: "Rose Engine", accent: .red, available: false),
            SectionItem(id: "ref", name: "Reference", accent: .blue, available: false),
        ]),
    ]
}
```

- [ ] **Step 2: Implement `HomeView.swift`**

```swift
import SwiftUI

struct HomeView: View {
    @AppStorage("unitSystem") private var unitRaw = UnitSystem.imperial.rawValue
    private var system: UnitSystem { UnitSystem(rawValue: unitRaw) ?? .imperial }

    var body: some View {
        NavigationStack {
            List {
                ForEach(SectionCatalog.groups, id: \.0) { groupName, items in
                    Section(groupName) {
                        ForEach(items) { item in row(item) }
                    }
                }
            }
            .scrollContentBackground(.hidden)
            .background(Catppuccin.base)
            .navigationTitle("Machinist's Bench")
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Picker("Units", selection: $unitRaw) {
                        Text("Imperial").tag(UnitSystem.imperial.rawValue)
                        Text("Metric").tag(UnitSystem.metric.rawValue)
                    }.pickerStyle(.segmented)
                }
            }
        }
        .tint(Catppuccin.blue)
    }

    @ViewBuilder private func row(_ item: SectionItem) -> some View {
        if item.available, item.id == "turn" {
            NavigationLink {
                TurningView(system: system).navigationTitle(item.name)
            } label: { label(item) }
        } else {
            label(item).foregroundStyle(Catppuccin.overlay0)
        }
    }

    private func label(_ item: SectionItem) -> some View {
        HStack {
            Circle().fill(item.accent.color).frame(width: 9, height: 9)
            Text(item.name).font(AppFont.display(15))
            Spacer()
            if !item.available {
                Text("soon").font(AppFont.mono(10)).foregroundStyle(Catppuccin.overlay0)
            }
        }
        .listRowBackground(Catppuccin.mantle)
    }
}

#Preview { HomeView() }
```

- [ ] **Step 3: Point the app root at `HomeView`** (`MachinistsBench/App.swift`)

```swift
import SwiftUI

@main
struct MachinistsBenchApp: App {
    var body: some Scene {
        WindowGroup {
            HomeView()
        }
    }
}
```

- [ ] **Step 4: Build and run in the simulator**

```bash
xcodebuild build -project MachinistsBench.xcodeproj -scheme MachinistsBench -destination 'platform=iOS Simulator,name=iPhone 16' 2>&1 | tail -3
APP=$(xcodebuild -project MachinistsBench.xcodeproj -scheme MachinistsBench -showBuildSettings -destination 'platform=iOS Simulator,name=iPhone 16' 2>/dev/null | awk -F'= ' '/ BUILT_PRODUCTS_DIR /{d=$2} / FULL_PRODUCT_NAME /{n=$2} END{print d"/"n}')
xcrun simctl boot "iPhone 16" 2>/dev/null; open -a Simulator
xcrun simctl install booted "$APP" && xcrun simctl launch booted com.machinistsbench.app
```
Expected: home screen with three groups; tapping **Turning** pushes the calculator; the Imperial/Metric toggle persists across relaunch and changes Turning's units/labels. Other rows show "soon" and don't navigate.

- [ ] **Step 5: Final regression — run the whole logic suite**

Run: `swift test 2>&1 | tail -3`
Expected: all tests pass.

- [ ] **Step 6: Commit**

```bash
git add MachinistsBench/Home MachinistsBench/App.swift
git commit -m "Add grouped home screen, navigation, persisted Imperial/Metric toggle"
```

- [ ] **Step 7 (optional): `swiftui-pro` review pass**

Run a `swiftui-pro` review over `MachinistsBench/` and address any high-value findings (state churn, view identity, accessibility). Keep changes minimal (`ponytail`).

---

## Self-Review

**Spec coverage:**
- Faithful base + native polish → Theme (T6), components (T7), grouped NavigationStack home (T9). ✓
- Catppuccin Mocha + accent remap → Catppuccin.swift / Accent (T6). ✓
- Diagrams deferred → none in scope. ✓
- Vertical slice (shell + theme + units + components + Turning) → T1–T9. ✓
- iPhone / iOS 17 / TestFlight → `TARGETED_DEVICE_FAMILY=1`, `IPHONEOS_DEPLOYMENT_TARGET=17.0`, automatic signing (T1). ✓
- Zero deps → no SPM runtime deps; test-only package. ✓
- Verbatim data/math → Materials (T4), Turning calc (T5), golden tests. ✓
- Error handling (blank on bad input) → `turning()` returns nil; view hides results (T5, T8). ✓
- Out-of-range warning Note → `inRange` + `NoteView` (T8). ✓
- Persisted unit preference → `@AppStorage` (T9). ✓
- Golden-value XCTest, no UI tests → T2–T5. ✓

**Placeholder scan:** No TBD/TODO; all code and test values are concrete; `CoreVersion.swift` is a real (small) symbol, not a stub for later removal.

**Type consistency:** `turning(diameterIn:docIn:sfm:feedIPR:efficiency:leadDeg:kp:)`, `TurningResult` fields (`rpm/ipm/mrr/cutHP/motorHP/laf/fProg`), `recommendedSFM(material:tool:coating:lube:)`, `Material` fields, `Accent`, and component initializers are used identically across T5/T7/T8/T9. ✓

## Notes on later milestones (not part of this plan)

Each subsequent section (Drilling, Milling, …) follows the T4/T5/T8 pattern: port its data + calc into `Core/` with golden tests, build its view from the shared components, flip its `SectionCatalog` entry to `available: true`, and add a `NavigationLink`. DataTable + Collapse components get built with the first section that needs them. Diagrams are Milestone 5.
