public import IEC_61966_Shared
import ISO_9899


extension IEC_61966.`2`.`1` {
    public struct LinearSRGB: Sendable, Hashable {

        public let r: LinearLight

        public let g: LinearLight

        public let b: LinearLight

        public init(r: LinearLight, g: LinearLight, b: LinearLight) {
            self.r = r
            self.g = g
            self.b = b
        }
    }
}
