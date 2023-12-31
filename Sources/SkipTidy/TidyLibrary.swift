// This is free software: you can redistribute and/or modify it
// under the terms of the GNU Lesser General Public License 3.0
// as published by the Free Software Foundation https://fsf.org

import Foundation
#if !SKIP
import CLibTidy
#else
import SkipFFI
#endif

/// `TidyLibrary` is an encapsulation of `libtidy` functions and structures.
final class TidyLibrary {
    public static let instance = TidyLibrary()

    /* SKIP EXTERN */ public func tidyReleaseDate() -> ctmbstr {
        return CLibTidy.tidyReleaseDate()
    }

    /* SKIP EXTERN */ public func tidyLibraryVersion() -> ctmbstr {
        return CLibTidy.tidyLibraryVersion()
    }

    /* SKIP EXTERN */ public func tidyPlatform() -> ctmbstr {
        return CLibTidy.tidyPlatform()
    }

    /* SKIP EXTERN */ public func tidyCreate() -> TidyDoc {
        return CLibTidy.tidyCreate()
    }

    /* SKIP EXTERN */ public func tidyRelease(_ tdoc: TidyDoc) {
        CLibTidy.tidyRelease(tdoc)
    }

    /* SKIP EXTERN */ public func tidyParseString(_ tdoc: TidyDoc, _ content: ctmbstr?) -> Int32 {
        return CLibTidy.tidyParseString(tdoc, content)
    }

    /* SKIP EXTERN */ public func tidyCleanAndRepair(_ tdoc: TidyDoc) -> Int32 {
        return CLibTidy.tidyCleanAndRepair(tdoc)
    }

    /* SKIP EXTERN */ public func tidyRunDiagnostics(_ tdoc: TidyDoc) -> Int32 {
        return CLibTidy.tidyRunDiagnostics(tdoc)
    }

    /* SKIP EXTERN */ public func tidyReportDoctype(_ tdoc: TidyDoc) -> Int32 {
        return CLibTidy.tidyReportDoctype(tdoc)
    }

    /* SKIP EXTERN */ public func tidySaveBuffer(_ tdoc: TidyDoc, _ buf: TidyBufferPtr) -> Int32 {
        return CLibTidy.tidySaveBuffer(tdoc, buf)
    }

    /* SKIP EXTERN */ public func tidyBufInit(_ buf: TidyBufferPtr) {
        CLibTidy.tidyBufInit(buf)
    }

    /* SKIP EXTERN */ public func tidyBufFree(_ buf: TidyBufferPtr) {
        CLibTidy.tidyBufFree(buf)
    }

    private init() {
        #if SKIP
        do {
            // should be bundled from the CLibTidy module in jni/arm64-v8a/libtidy.so
            com.sun.jna.Native.register((TidyLibrary.self as kotlin.reflect.KClass).java, "tidy")
        } catch let error as java.lang.UnsatisfiedLinkError {
            // for Robolectric we link against out locally-built library version created by either Xcode or SwiftPM
            let libName = "SkipTidy"
            var frameworkPath: String
            if let bundlePath = ProcessInfo.processInfo.environment["XCTestBundlePath"] { // running from Xcode
                frameworkPath = bundlePath + "/../PackageFrameworks/\(libName).framework/\(libName)"
            } else { // SwiftPM doesn't set XCTestBundlePath and builds as a .dylib rather than a .framework
                let baseDir = FileManager.default.currentDirectoryPath + "/../../../../../.."
                frameworkPath = baseDir + "/x86_64-apple-macosx/debug/lib\(libName).dylib" // check for Intel
                if !FileManager.default.fileExists(atPath: frameworkPath) { // no x86_64 … try ARM
                    frameworkPath = baseDir + "/arm64-apple-macosx/debug/lib\(libName).dylib"
                }
            }

            com.sun.jna.Native.register((TidyLibrary.self as kotlin.reflect.KClass).java, frameworkPath)
        }
        #endif
    }
}

#if !SKIP
//public typealias ctmbstr = UnsafePointer<Int8>
public typealias TidyBufferPtr = UnsafeMutablePointer<TidyBuffer>

extension TidyBufferPtr {
    init() {
        self = TidyBufferPtr.allocate(capacity: MemoryLayout<TidyBufferPtr>.size)
    }
}

#else
typealias TidyDoc = OpaquePointer
typealias ctmbstr = String

/// Fake the cString call, since we are using JNA's String/pointer conversions
func String(cString: ctmbstr) -> String {
    //cString.getString(0)
    cString
}

// SKIP INSERT: @com.sun.jna.Structure.FieldOrder("allocator", "bp", "size", "allocated", "next")
final class TidyBufferPtr : SkipFFIStructure {
    // SKIP INSERT: @JvmField
    public var allocator: OpaquePointer?

    // SKIP INSERT: @JvmField
    public var bp: OpaquePointer?

    // SKIP INSERT: @JvmField
    public var size: Int32

    // SKIP INSERT: @JvmField
    public var allocated: Int32

    // SKIP INSERT: @JvmField
    public var next: Int32

    init() {
        allocator = nil
        bp = nil
        size = 0
        allocated = 0
        next = 0
    }
}

// fake UnsafeMutablePointer
extension TidyBufferPtr {
    var pointee: TidyBufferPtr { self }
    func deallocate() { clear() }
}

#endif
