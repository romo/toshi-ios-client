import XCTest
import UIKit
import Quick
import Nimble
@testable import Toshi

class SofaStatusTests: QuickSpec {

    override func spec() {
        describe("Sofa status added") {
            let sofaString = "SOFA::Status:{\"type\":\"added\",\"subject\":\"Robert\",\"object\":\"Marek\"}"
            let status = SofaStatus(content: sofaString)

            it("creates a sofa status from a sofa string") {
                expect(status.statusType).to(equal(SofaStatus.StatusType.added))
                expect(status.subject).to(equal("Robert"))
                expect(status.object).to(equal("Marek"))
            }

            it("creates an attributed string with bold parts for the names") {
                guard let attributedText = status.attributedText else {
                    XCTFail("no attributed text set on sofa status")
                    return
                }

                let fontAttribute = [NSAttributedStringKey.font: Theme.preferredFootnote()]

                let robertRange = attributedText.string.nsRange(forSubstring: "Robert")
                let boldAttribute = attributedText.attributes(at: robertRange.location, effectiveRange: nil)
                expect(boldAttribute[NSAttributedStringKey.font] as? UIFont).to(equal(Theme.bold(size: 13)))

                let marekRange = attributedText.string.nsRange(forSubstring: "Marek")
                let boldAttribute2 = attributedText.attributes(at: marekRange.location, effectiveRange: nil)
                expect(boldAttribute2[NSAttributedStringKey.font] as? UIFont).to(equal(Theme.bold(size: 13)))

                let allRange = attributedText.string.nsRange(forSubstring: "added")
                let normalAttributes = attributedText.attributes(at: allRange.location, effectiveRange: nil)
                expect(normalAttributes[NSAttributedStringKey.font] as? UIFont).to(equal(Theme.preferredFootnote()))
            }
        }
    }
}
