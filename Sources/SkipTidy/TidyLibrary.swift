// This is free software: you can redistribute and/or modify it
// under the terms of the GNU Lesser General Public License 3.0
// as published by the Free Software Foundation https://fsf.org

import Foundation
#if !SKIP
import CLibTidy
#else
import SkipFFI
#endif

//let x = CLibTidy.tidyCreate()

struct TidyDoc {
}


#if !SKIP
public typealias ctmbstr = UnsafePointer<Int8>
#else
public typealias ctmbstr = OpaquePointer
//func String(cString: ctmbstr) -> String { cString.getString(0) }
#endif

/// `TidyLibrary` is an encapsulation of `libtidy` functions and structures.
public final class TidyLibrary {
    public static let instance = TidyLibrary()

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

    // SKIP EXTERN
    public func tidyReleaseDate() -> ctmbstr {
        return CLibTidy.tidyReleaseDate()
    }

    // SKIP EXTERN
    public func tidyLibraryVersion() -> ctmbstr {
        return CLibTidy.tidyLibraryVersion()
    }

    // SKIP EXTERN
    public func tidyPlatform() -> ctmbstr {
        return CLibTidy.tidyPlatform()
    }

    //    public var Z_OK: Int32 {
    //        #if !SKIP
    //        assert(zlib.Z_OK == 0, "\(zlib.Z_OK)")
    //        #endif
    //        return 0
    //    }


//    public var ZLIB_VERSION: String {
//        return zlibVersion()
//    }


    //    // SKIP EXTERN
    //    public func zlibVersion() -> String {
    //        String(cString: zlib.zlibVersion()!)
    //    }
    //
    //    // SKIP EXTERN
    //    public func zError(code: Int32) -> String {
    //        String(cString: zlib.zError(code)!)
    //    }


    //    #if !SKIP
    //    public typealias z_stream = zlib.z_stream
    //    #else
    //    // SKIP INSERT: @com.sun.jna.Structure.FieldOrder("next_in", "avail_in", "total_in", "next_out", "avail_out", "total_out", "msg", "state", "zalloc", "zfree", "opaque", "data_type", "adler", "reserved")
    //    public final class z_stream : SkipFFIStructure {
    //        // otherwise: "JvmField cannot be applied to a property with a custom accessor" due to accessor being created for this type
    //        // SKIP REPLACE: @JvmField var next_in: OpaquePointer?
    //        public var next_in: OpaquePointer?
    //        // SKIP INSERT: @JvmField
    //        public var avail_in: Int32
    //        // SKIP INSERT: @JvmField
    //        public var total_in: Int64
    //
    //        // SKIP REPLACE: @JvmField var next_out: OpaquePointer?
    //        public var next_out: OpaquePointer?
    //        // SKIP INSERT: @JvmField
    //        public var avail_out: Int32
    //        // SKIP INSERT: @JvmField
    //        public var total_out: Int64
    //
    //        // SKIP INSERT: @JvmField
    //        public var msg: String?
    //        // SKIP REPLACE: @JvmField var state: OpaquePointer?
    //        public var state: OpaquePointer?
    //
    //        // SKIP REPLACE: @JvmField var zalloc: OpaquePointer?
    //        public var zalloc: OpaquePointer?
    //        // SKIP REPLACE: @JvmField var zfree: OpaquePointer?
    //        public var zfree: OpaquePointer?
    //        // SKIP REPLACE: @JvmField var opaque: OpaquePointer?
    //        public var opaque: OpaquePointer?
    //
    //        // SKIP INSERT: @JvmField
    //        public var data_type: Int32
    //        // SKIP INSERT: @JvmField
    //        public var adler: Int32
    //        // SKIP INSERT: @JvmField
    //        public var reserved: Int64
    //
    //        public init(next_in: OpaquePointer? = nil, avail_in: Int32 = 0, total_in: Int64 = 0, next_out: OpaquePointer? = nil, avail_out: Int32 = 0, total_out: Int64 = 0, msg: String? = nil, state: OpaquePointer? = nil, zalloc: OpaquePointer? = nil, zfree: OpaquePointer? = nil, opaque: OpaquePointer? = nil, data_type: Int32 = 0, adler: Int32 = 0, reserved: Int64 = 0) {
    //            self.next_in = next_in
    //            self.avail_in = avail_in
    //            self.total_in = total_in
    //            self.next_out = next_out
    //            self.avail_out = avail_out
    //            self.total_out = total_out
    //            self.msg = msg
    //            self.state = state
    //            self.zalloc = zalloc
    //            self.zfree = zfree
    //            self.opaque = opaque
    //            self.data_type = data_type
    //            self.adler = adler
    //            self.reserved = reserved
    //        }
    //    }
    //    #endif

    /*
     gzip header information passed to and from zlib routines.  See RFC 1952
     for more details on the meanings of these fields.
     */
    //    public struct gz_header_s {
    //        public init()
    //        public init(text: Int32, time: UInt64, xflags: Int32, os: Int32, extra: UnsafeMutablePointer<UInt8>!, extra_len: UInt32, extra_max: UInt32, name: UnsafeMutablePointer<UInt8>!, name_max: UInt32, comment: UnsafeMutablePointer<UInt8>!, comm_max: UInt32, hcrc: Int32, done: Int32)
    //        public var text: Int32 /* true if compressed data believed to be text */
    //        public var time: UInt64 /* modification time */
    //        public var xflags: Int32 /* extra flags (not used when writing a gzip file) */
    //        public var os: Int32 /* operating system */
    //        public var extra: UnsafeMutablePointer<UInt8>! /* pointer to extra field or Z_NULL if none */
    //        public var extra_len: UInt32 /* extra field length (valid if extra != Z_NULL) */
    //        public var extra_max: UInt32 /* space at extra (only when reading header) */
    //        public var name: UnsafeMutablePointer<UInt8>! /* pointer to zero-terminated file name or Z_NULL */
    //        public var name_max: UInt32 /* space at name (only when reading header) */
    //        public var comment: UnsafeMutablePointer<UInt8>! /* pointer to zero-terminated comment or Z_NULL */
    //        public var comm_max: UInt32 /* space at comment (only when reading header) */
    //        public var hcrc: Int32 /* true if there was or will be a header crc */
    //        public var done: Int32 /* true when done reading gzip header (not used when writing a gzip file) */
    //    }
    //    public typealias gz_header = gz_header_s
    //    public typealias gz_headerp = UnsafeMutablePointer<gz_header>

    //    #if SKIP
    //    // SKIP INSERT: @com.sun.jna.Structure.FieldOrder("have", "next", "pos")
    //    public final class gzFile_s : SkipFFIStructure {
    //        // SKIP REPLACE: @JvmField var have: Int // Unsigned types use the same mappings as signed types
    //        public var have: UInt32
    //        // SKIP REPLACE: @JvmField var next: com.sun.jna.ptr.PointerByReference
    //        public var next: UnsafeMutablePointer<UInt8>!
    //        // SKIP REPLACE: @JvmField var pos: Long
    //        public var pos: Int64
    //
    //        init(have: Int, next: UnsafeMutablePointer<UInt8>!, pos: Int64) {
    //            self.have = have
    //            self.next = next
    //            self.pos = pos
    //        }
    //    }
    //
    //    public typealias gzFile = UnsafeMutablePointer<gzFile_s> /* semi-opaque gzip file descriptor */
    //    #endif

    //    public typealias in_func = @convention(c) (UnsafeMutableRawPointer?, UnsafeMutablePointer<UnsafeMutablePointer<UInt8>?>?) -> UInt32
    //
    //    public typealias out_func = @convention(c) (UnsafeMutableRawPointer?, UnsafeMutablePointer<UInt8>?, UInt32) -> Int32

    //    // SKIP EXTERN
    //    public func zlibCompileFlags() -> ZUInt { return zlib.zlibCompileFlags() }

    //    #if SKIP
    //    // needed for JNA mappings to line up
    //    public typealias ZUInt = Int
    //    public typealias ZUInt32 = Int
    //    #else
    //    public typealias ZUInt = UInt
    //    public typealias ZUInt32 = UInt32
    //    #endif


    //    // SKIP EXTERN
    //    public func adler32(_ adler: ZUInt, _ buf: UnsafePointer<UInt8>!, _ len: ZUInt32) -> ZUInt { return zlib.adler32(adler, buf, len) }
    //    // SKIP EXTERN
    //    public func adler32_z(_ adler: ZUInt, _ buf: UnsafePointer<UInt8>!, _ len: Int) -> ZUInt { return zlib.adler32_z(adler, buf, len) }
    //    // SKIP EXTERN
    //    public func crc32(_ crc: ZUInt, _ buf: UnsafePointer<UInt8>!, _ len: ZUInt32) -> ZUInt { return zlib.crc32(crc, buf, len) }
    //    // SKIP EXTERN
    //    public func crc32_z(_ crc: ZUInt, _ buf: UnsafePointer<UInt8>!, _ len: Int) -> ZUInt { return zlib.crc32_z(crc, buf, len) }
    //    // SKIP EXTERN
    //    //public func crc32_combine_op(_ crc1: UInt64, _ crc2: UInt64, _ op: UInt64) -> UInt64 { return zlib.crc32_combine_op(crc1, crc2, op) }
    //    // SKIP EXTERN
    //    public func adler32_combine(_ a1: ZUInt, _ a2: ZUInt, _ a3: Int) -> ZUInt { return zlib.adler32_combine(a1, a2, a3) }
    //    // SKIP EXTERN
    //    public func crc32_combine(_ a1: ZUInt, _ a2: ZUInt, _ a3: Int) -> ZUInt { return zlib.crc32_combine(a1, a2, a3) }
    //    // SKIP EXTERN
    ////    public func crc32_combine_gen(_ a1: Int) -> ZUInt { return zlib.crc32_combine_gen(a1) }
}
