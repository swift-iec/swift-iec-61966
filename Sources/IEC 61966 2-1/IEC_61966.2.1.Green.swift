internal import ASCII
public import IEC_61966_Shared


extension IEC_61966.`2`.`1` {
    public struct Green: Sendable, Hashable {

        public let value: Double

        public init(_ value: Double) throws(Error) {
            guard value >= 0 && value <= 1 else {
                throw Error(value: value)
            }
            self.value = value
        }
    }
}
