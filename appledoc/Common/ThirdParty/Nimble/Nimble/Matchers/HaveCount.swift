import Foundation

/// A Nimble matcher that succeeds when the actual CollectionType's count equals
/// the expected value
public func haveCount<T: Collection>(_ expectedValue: T.Index.Distance) -> NonNilMatcherFunc<T> {
    return NonNilMatcherFunc { actualExpression, failureMessage in
        if let actualValue = try actualExpression.evaluate() {
            failureMessage.postfixMessage = "have \(actualValue) with count \(expectedValue)"
            let result = expectedValue == actualValue.count
            failureMessage.actualValue = "\(actualValue.count)"
            return result
        } else {
            return false
        }
    }
}

/// A Nimble matcher that succeeds when the actual collection's count equals
/// the expected value
public func haveCount(_ expectedValue: Int) -> MatcherFunc<NMBCollection> {
    return MatcherFunc { actualExpression, failureMessage in
        if let actualValue = try actualExpression.evaluate() {
            failureMessage.postfixMessage = "have \(actualValue) with count \(expectedValue)"
            let result = expectedValue == actualValue.count
            failureMessage.actualValue = "\(actualValue.count)"
            return result
        } else {
            return false
        }
    }
}

extension NMBObjCMatcher {
    public class func haveCountMatcher(_ expected: NSNumber) -> NMBObjCMatcher {
        return NMBObjCMatcher(canMatchNil: false) { actualExpression, failureMessage in
            let location = actualExpression.location
            let actualValue = try! actualExpression.evaluate()
            if let value = actualValue as? NMBCollection {
                let expr = Expression(expression: ({ value as NMBCollection}), location: location)
                return try! haveCount(expected.intValue).matches(expr, failureMessage: failureMessage)
            } else if let actualValue = actualValue {
                failureMessage.postfixMessage = "get type of NSArray, NSSet, NSDictionary, or NSHashTable"
                failureMessage.actualValue = "\(NSStringFromClass(type(of: actualValue)))"
            }
            return false
        }
    }
}
