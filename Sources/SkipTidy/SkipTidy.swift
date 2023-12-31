// This is free software: you can redistribute and/or modify it
// under the terms of the GNU Lesser General Public License 3.0
// as published by the Free Software Foundation https://fsf.org

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
    public func tidy() throws -> String {

        let tdoc = CLibTidy.tidyCreate()
        defer { CLibTidy.tidyRelease(tdoc) }

        let _ = CLibTidy.tidyParseString(tdoc, self)

        #if !SKIP

//        let errBuffer = SwLibTidyBuffer()
//        let _ = tidySetErrorBuffer( tdoc, errbuf: errBuffer )
//        _ = tidyParseString( tdoc, self)
//        _ = tidyCleanAndRepair( tdoc )
//
//        let outpBuffer = SwLibTidyBuffer()
//        _ = tidySaveBuffer( tdoc, outpBuffer )
//
//        _ = tidyOptResetToSnapshot( tdoc )     /* needed to restore user option values! */
//
//        return outpBuffer.StringValue() ?? self

        return self
        #else
        return self
        #endif
    }
}

public struct TidyUnavailableError : LocalizedError {
    public var errorDescription: String?
}
