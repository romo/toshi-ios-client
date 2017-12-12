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
                let fontAttribute = [NSAttributedStringKey.font: Theme.preferredFootnote()]

                let boldAttribute = status.attributedText?.attributes(at: 0, effectiveRange: nil)
                expect(boldAttribute?[NSAttributedStringKey.font] as? UIFont).to(equal(Theme.bold(size: 13)))

                let boldAttribute2 = status.attributedText?.attributes(at: (status.attributedText?.string.count ?? 14) - 1, effectiveRange: nil)
                expect(boldAttribute2?[NSAttributedStringKey.font] as? UIFont).to(equal(Theme.bold(size: 13)))

                let normalAttributes = status.attributedText?.attributes(at: 8, effectiveRange: nil)
                expect(normalAttributes?[NSAttributedStringKey.font] as? UIFont).to(equal(Theme.preferredFootnote()))
            }
        }
    }
}
