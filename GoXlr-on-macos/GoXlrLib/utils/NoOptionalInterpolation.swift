//
//  NoOptionalInterpolation.swift
//  Pods
//
//  Created by Thanh Pham on 5/27/16.
//
//

/// Anything that can be unwrapped.
public protocol Unwrappable {

    /// Returns the unwrapped value of the receiver.
    func unwrap() -> Any?
}

extension Optional: Unwrappable {

    /// Returns the unwrapped value of the `Optional`.
    public func unwrap() -> Any? {
        switch self {
        case nil:
            return nil
        case let unwrappable as Unwrappable:
            return unwrappable.unwrap()
        case let any:
            return any
        }
    }
}

/// A wrapped `Unwrappable` to prevent it from being unwrapped.
public struct WrappedUnwrappable {
    let unwrappable: Unwrappable
}

extension WrappedUnwrappable: Unwrappable {

    /// Returns the `Unwrappable` value of the receiver.
    public func unwrap() -> Any? {
        return unwrappable
    }
}

postfix operator *

/**
 Wraps an `Unwrappable` to prevent it from being unwrapped.

 - Parameter unwrappable: the given unwrappable.
 - Returns: a `WrappedUnwrappable` containing the given `Unwrappable`.
 */
public postfix func *(unwrappable: Unwrappable) -> WrappedUnwrappable {
    return WrappedUnwrappable(unwrappable: unwrappable)
}

public extension String {

    /// Creates an instance containing the unwrappable's representation.
    init(stringInterpolationSegment expr: Unwrappable) {
        if let unwrapped = expr.unwrap() {
            self.init(stringInterpolationSegment: unwrapped)
        } else {
            self.init()
        }
    }

    init<T>(stringInterpolationSegment expr: Optional<T>) {
        self.init(stringInterpolationSegment: expr as Unwrappable)
    }

    init(stringInterpolationSegment expr: WrappedUnwrappable) {
        self.init(stringInterpolationSegment: expr as Unwrappable)
    }
}

/// Anything that can present an `Int`.
protocol Intable {

    /// Returns `Int` value of the receiver.
    func int() -> Int
}

extension Int: Intable {

    /// Returns self.
    func int() -> Int {
        return self
    }
}

extension Intable where Self: Unwrappable {

    /// Returns the unwrapped value if it is an `Int`. Otherwise, returns `0`.
    func int() -> Int {
        if let int = self.unwrap() as? Int {
            return int
        } else {
            return 0
        }
    }
}

extension Optional: Intable {}

/// Anything that can present a word.
protocol Wordable {

    /// The singular form of the word.
    var singularForm: String { get }

    /// The plural form of the word.
    var pluralForm: String { get }
}

/// An implementation of the `Wordable` protocol.
public struct Word: Wordable {

    /// The singular form of the word.
    public var singularForm: String

    /// The plural form of the word.
    public var pluralForm: String
}

/// `Pluralizer` makes the plural form of a word from its singular form.
public protocol Pluralizer {

    /**
     Returns the plural form of the given word.

     - Parameter word: the given word, in singular form.
     - Returns: the plural form.
     */
    static func apply(_ word: String) -> String
}

/// `SimplePluralizer` appends an "s" to a word to make its plural form.
open class SimplePluralizer: Pluralizer {

    /**
     Returns the plural form of the given word by appending an "s".

     - Parameter word: the given word, in singular form.
     - Returns: the plural form.
     */
    open class func apply(_ word: String) -> String {
        return word.count == 0 ? "" : word + "s"
    }
}

/// `PluralizerType` holds the type of a pluralizer used for pluralization. The type must conforms to the `Pluralizer` protocol.
public var PluralizerType: Pluralizer.Type = SimplePluralizer.self

extension String: Wordable {

    /// Holds the singular form of the word.
    public var singularForm: String {
        get {
            return self
        }
    }

    /// Holds the plural form of the word.
    public var pluralForm: String {
        return PluralizerType.apply(self)
    }
}

extension Wordable where Self: Unwrappable {

    /// Returns the interpolation presentation of the receiver.
    var singularForm: String {
        get {
            return "\(self as Unwrappable)"
        }
    }

    /// Returns the plural form using the specified `PluralizerType`.
    var pluralForm: String {
        return PluralizerType.apply(self.singularForm)
    }
}

extension Optional: Wordable {}

precedencegroup PluralizationPrecedence {
    higherThan: ComparisonPrecedence
    lowerThan: CastingPrecedence
}

infix operator ~: PluralizationPrecedence

func ~(amount: Intable, word: Wordable) -> String {
    let quantity = amount.int()
    let pluralizedWord = quantity == 1 ? word.singularForm : word.pluralForm
    return String(quantity) + (pluralizedWord.count == 0 ? "" : " ") + pluralizedWord
}

/**
 Returns a pluralized string for the given `amount` and `word`.

 - Parameter amount: the amount.
 - Parameter word: the word.
 - Returns: the pluralized string for the given parameters.
 */
public func ~(amount: Int, word: String) -> String {
    return amount as Intable ~ word as Wordable
}

/**
 Returns a pluralized string for the given `amount` and `word`.

 - Parameter amount: the amount.
 - Parameter word: the word.
 - Returns: the pluralized string for the given parameters.
 */
public func ~(amount: Int, word: Word) -> String {
    return amount as Intable ~ word as Wordable
}

func ~(word: Wordable, amount: Intable) -> String {
    return amount.int() == 1 ? word.singularForm : word.pluralForm
}

/**
 Returns a pluralized string for the given `amount` and `word`, omitting the quantity.

 - Parameter word: the word.
 - Parameter amount: the amount.
 - Returns: the pluralized string for the given parameters, omitting the quantity.
 */
public func ~(word: String, amount: Int) -> String {
    return word as Wordable ~ amount as Intable
}

/**
 Returns a pluralized string for the given `amount` and `word`, omitting the quantity.

 - Parameter word: the word.
 - Parameter amount: the amount.
 - Returns: the pluralized string for the given parameters, omitting the quantity.
 */
public func ~(word: Word, amount: Int) -> String {
    return word as Wordable ~ amount as Intable
}

/**
 Returns a pluralized string for the given `amount` and `word`. Depending on the order of the parameters, the quantity could be or not be omitted.

 - Parameter optional1: either the amount or the word.
 - Parameter optional2: the remaining parameter.
 - Returns: the pluralized string for the given parameters, the quantity could be ommited depending on the order of the parameters.
 */
public func ~(optional1: Unwrappable, optional2: Unwrappable) -> String {
    let unwrapped1 = optional1.unwrap()
    let unwrapped2 = optional2.unwrap()
    if unwrapped1 is Int || unwrapped2 is String {
        return (unwrapped1 as Intable) ~ (unwrapped2 as Wordable)
    }
    return (unwrapped1 as Wordable) ~ (unwrapped2 as Intable)
}

/**
 Returns a `Word` from the given forms of a word.

 - Parameter singularForm: the singular form the word.
 - Parameter pluralForm: the plural form the word.
 - Returns: a `Word` form the given forms.
 */
public func /(singularForm: String, pluralForm: String) -> Word {
    return Word(singularForm: singularForm, pluralForm: pluralForm)
}
