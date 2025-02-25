// Copyright 2023–2025 Skip
// SPDX-License-Identifier: LGPL-3.0-only WITH LGPL-3.0-linking-exception
import Foundation
#if SKIP
import SkipFFI
#endif

private let CLibTidy = TidyLibrary.instance

public struct Tidy {
    public static var tidyVersion: String {
        String(cString: CLibTidy.tidyLibraryVersion())
    }

    public static var tidyReleaseDate: String {
        String(cString: CLibTidy.tidyReleaseDate())
    }

    public static var tidyPlatform: String {
        String(cString: CLibTidy.tidyPlatform())
    }
}

extension String {

    /// Tidies the given String into a valid XML document.
    public func tidy() throws -> String? {
        let tdoc = CLibTidy.tidyCreate()
        defer { CLibTidy.tidyRelease(tdoc) }

        _ = CLibTidy.tidyParseString(tdoc, self)
        _ = CLibTidy.tidyCleanAndRepair(tdoc)

        let outpBuffer = TidyBufferPtr()
        defer { outpBuffer.deallocate() }

        CLibTidy.tidyBufInit(outpBuffer)
        defer { CLibTidy.tidyBufFree(outpBuffer) }

        _ = CLibTidy.tidySaveBuffer(tdoc, outpBuffer)

        let size = outpBuffer.pointee.size
        if size <= 0 {
            return nil
        } else {
            let bp = outpBuffer.pointee.bp
            let data = Data(bytes: bp!, count: Int(size))
            let str = String(data: data, encoding: String.Encoding.utf8)

            // sadly, this seems to be the only way to prevent the generator header from being included in the output (which makes unit testing fragile)
            let generator = """
            <meta name="generator" content=
            "HTML Tidy for HTML5 for \(Tidy.tidyPlatform) version \(Tidy.tidyVersion)">

            """
            return str?.replacingOccurrences(of: generator, with: "")
        }
    }
}

public struct TidyUnavailableError : LocalizedError {
    public var errorDescription: String?
}
