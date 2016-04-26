// https://github.com/Quick/Quick

import Quick
import Nimble
import KRMLogger

class TableOfContentsSpec: QuickSpec {
    override func spec() {
        describe("these will be logged") {
            let logger = KRMLogger(name: "com.Karma.KRMLogger-Example")
            
            it("it can log") {
                logger.log(.Info, "Hello there")
            }
            
            it("it can log erros") {
                logger.log(.Error, "Hello there. This is an error")
            }
        }
    }
}
