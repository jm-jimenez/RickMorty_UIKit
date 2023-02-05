//
//  Scenario.swift
//  Technical-UIKit
//
//  Created by José María Jiménez on 2/2/23.
//

import Foundation

struct Scenario<Input, Output, Error> {
    private let useCase: UseCase<Input, Output, Error>
    private let input: Input

    init(useCase: UseCase<Input, Output, Error>, input: Input) {
        self.useCase = useCase
        self.input = input
    }

    func execute() -> ScenarioHandler<Input, Output, Error> {
        ScenarioHandler(useCase: useCase, input: input)
    }
}

extension Scenario where Input == Void {
    init(useCase: UseCase<Input, Output, Error>) {
        self.useCase = useCase
    }
}

final class ScenarioHandler<Input, Output, Error> {
    private let useCase: UseCase<Input, Output, Error>
    private let input: Input
    private var result: UseCaseResponse<Output, Error>?
    private var callbacks: [(UseCaseResponse<Output, Error>) -> Void] = []

    init(useCase: UseCase<Input, Output, Error>, input: Input) {
        self.useCase = useCase
        self.input = input
        run()
    }

    func onSuccess(_ onSuccess: @escaping (Output) -> Void) -> ScenarioHandler<Input, Output, Error> {
        observe { result in
            guard let output = try? result.getOkResult() else { return }
            DispatchQueue.main.async {
                onSuccess(output)
            }
        }
        return self
    }

    func onError(_ onError: @escaping (Error) -> Void) {
        observe { result in
            guard let error = try? result.getErrorResult() else { return }
            DispatchQueue.main.async {
                onError(error)
            }
        }
    }

    private func run() {
        let queue = DispatchQueue.global()
        let dispatchGroup = DispatchGroup()

        dispatchGroup.enter()
        queue.async(group: dispatchGroup) {
            self.result = self.useCase.execute(requestValues: self.input)
            dispatchGroup.leave()
        }
        dispatchGroup.notify(queue: queue) {
            self.callbacks.forEach { $0(self.result!) }
        }
    }

    private func observe(callback: @escaping (UseCaseResponse<Output, Error>) -> Void) {
        guard let result else {
            callbacks.append(callback)
            return
        }
        callback(result)
    }

    deinit {
        print("Scenario handler deinit")
    }
}

class UseCase<Input, Output, Error> {
    func execute(requestValues: Input) -> UseCaseResponse<Output, Error> { fatalError("Must be implemented on childs") }
}

struct UseCaseResponse<Output, Error> {
    private let okResult: Output?
    private let error: Error?

    static func ok(_ okResult: Output) -> UseCaseResponse<Output, Error> {
        UseCaseResponse(okResult: okResult)
    }

    static func error(_ error: Error) -> UseCaseResponse<Output, Error> {
        UseCaseResponse(error: error)
    }

    private init(okResult: Output? = nil, error: Error? = nil) {
        self.okResult = okResult
        self.error = error
    }

    func getOkResult() throws -> Output {
        guard let okResult else {
            throw NSError(domain: "", code: 0)
        }
        return okResult
    }

    func getErrorResult() throws -> Error {
        guard let error else {
            throw NSError(domain: "", code: 0)
        }
        return error
    }
}
