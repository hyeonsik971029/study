# Combine과 Async/Await

# 목차

# 1. Combine이란

iOS 13에서 도입한 선언적 비동기 및 이벤트 기반 프로그래밍을 위한 프레임워크로, Publisher와 Subscriber를 기반으로 하여 데이터 스트림을 다루고 변환하는 데 사용된다.

# 2. Combine 요소

- Publisher: 데이터 스트림을 생성하고 이벤트를 발행하는 객체
- Subscriber: Publisher에서 발행된 이벤트를 구독하고 처리하는 객체
- Operators: 데이터 스트림을 변환, 필터링 및 결합하는 데 사용되는 메서드
- Subject: Publisher와 Subscriber의 역할을 동시에 수행할 수 있는 객체
- Schedulers: 비동기적인 작업을 처리하기 위한 스케줄러, 실행 컨텍스트를 제어
- Cancellable: 데이터 스트림의 구독을 취소하고 메모리 누수를 방지하는 인터페이스
- Sink: 데이터 스트림의 최종 결과를 처리하는 메서드, Subscriber와 비슷한 역할

## 2.1. Publisher && Subscriber예제

```swift
// 정수 배열을 발행하는 publisher
let publisher = [1, 2, 3, 4, 5].publisher

// subscriber 생성
let subscriber = Subscriber.Sink<Int, Never>(
		receiveCompletion: { compeltion in
				switch completion {
						case .finished:
								// TODO: 이벤트 종료 시
				}
		},
		receiveValue: { value in
				// TODO: 값 조작
		}
}

// Publisher와 Subscriber를 연결하여 데이터 스트림 처리
publisher.subscriber(subscriber)
```

## 2.2. Operators 예제

Map: 데이터 스트림에서 각 값을 변환하는 Operator

```swift
let Publisher = (1...5).publisher
let modifiedPublisher = publisher.map { $0 * 2 }

modifiedPublisher.sink { value in
		print(value) // 출력: 2, 4, 6, 8, 10
}
```

Filter: 조건을 만족하는 값만을 발행하는 Operator

```swift
let Publisher = (1...5).publisher
let filteredPublisher = publisher.filter { $0 % 2 == 0 }

filteredPublisher.sink { value in
		print(value) // 출력: 2, 4
}
```

CompactMap: nil이 아닌 값을 발행하는 Operator

```swift
let strings = ["1", "2", "3", "4", "not a number"]
let publisher = strings.publisher

let compactMappedPublisher = publisher.compactMap { Int($0) }

compactMappedPublisher.sink { value in
    print(value) // 출력: 1, 2, 3, 4
}
```

Merge: 여러 개의 데이터 스트림을 병합하는 Operator

```swift
let publisher1 = [1, 2, 3].publisher
let publisher2 = [4, 5, 6].publisher

let mergedPublisher = Publishers.Merge(publisher1, publisher2)

mergedPublisher.sink { value in
    print(value) // 출력: 1, 2, 3, 4, 5, 6
}
```

CombineLatest: 최신 값들을 결합하여 새로운 값을 발행하는 Operator

```swift
let publisher1 = PassthroughSubject<Int, Never>()
let publisher2 = PassthroughSubject<String, Never>()

let combinedPublisher = publisher1.combineLatest(publisher2)

combinedPublisher.sink { value in
    print(value) // (1, "A"), (2, "A"), (2, "B"), (3, "B")
}

publisher1.send(1)
publisher2.send("A")
publisher1.send(2)
publisher2.send("B")
publisher1.send(3)
```

Zip: 두 개 이상의 Publisher에서 값을 쌍으로 결합하여 새로운 값을 발행하는 Operator

```swift
let publisher1 = PassthroughSubject<Int, Never>()
let publisher2 = PassthroughSubject<String, Never>()

let zippedPublisher = publisher1.zip(publisher2)

zippedPublisher.sink { value in
    print(value) // (1, "A"), (2, "B"), (3, "C")
}

publisher1.send(1)
publisher2.send("A")
publisher1.send(2)
publisher2.send("B")
publisher1.send(3)
publisher2.send("C")
```

Scan: 초기값과 클로저를 사용하여 연속적인 계산을 수행하고 결과를 발행하는 Operator

```swift
let publisher = (1...5).publisher
let scannedPublisher = publisher.scan(0, +)

scannedPublisher.sink { value in
    print(value) // 출력: 0, 1, 3, 6, 10, 15
}
```

Debounce: 일정 시간 동안 값이 발생하지 않을 때에만 값을 발행하는 Operator

```swift
let publisher = PassthroughSubject<String, Never>()
let debouncedPublisher = publisher.debounce(
		for: .seconds(1),
		scheduler: DispatchQueue.main
)

debouncedPublisher.sink { value in
    print(value) // 출력: "C"
}

publisher.send("A")
publisher.send("B")
DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
    publisher.send("C")
}
```

SwitchToLatest: Publisher가 발행하는 각 값에 대해 새로운 Inner Publisher를 구독하고 가장 최신의 Inner Publisher에서 값을 발행하는 Operator

```swift
let outerPublisher = PassthroughSubject<PassthroughSubject<Int, Never>, Never>()
let switchedPublisher = outerPublisher.switchToLatest()

switchedPublisher.sink { value in
    print(value) // 출력: 1, 4
}

let innerPublisher1 = PassthroughSubject<Int, Never>()
let innerPublisher2 = PassthroughSubject<Int, Never>()

outerPublisher.send(innerPublisher1)
innerPublisher1.send(1)

DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
    outerPublisher.send(innerPublisher2)
    innerPublisher2.send(4)
}
```

Throttle: 일정 시간 동안 값을 발행하지 않고 기다리고, 해당 기간 내에 발생하는 모든 값 중 가장 최근의 값을 발행하는 Operator

```swift
let publisher = PassthroughSubject<String, Never>()
let throttledPublisher = publisher.throttle(
		for: .seconds(1),
		scheduler: DispatchQueue.main,
		latest: true
)

throttledPublisher.sink { value in
    print(value) // 출력: "A", "C"
}

publisher.send("A")
DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
    publisher.send("B")
}
DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
    publisher.send("C")
}
```

Delay: 값을 발행하는 데 일정한 시간 지연을 추가하는 Operator

```swift
let publisher = PassthroughSubject<String, Never>()
let delayedPublisher = publisher.delay(for: .seconds(1), scheduler: DispatchQueue.main)

delayedPublisher.sink { value in
    print(value) // 출력: "A", "", "B", "", "C"
}

publisher.send("A")
publisher.send("B")
publisher.send("C")
```

ReplaceError: 오류가 발생했을 때 특정 값을 발행하거나 다른 Publisher로 대체하는 Operator

```swift
enum MyError: Error {
    case someError
}

let publisher = PassthroughSubject<Int, MyError>()
let replacedPublisher = publisher.replaceError(with: -1)

replacedPublisher.sink { value in
    print(value) // 출력: 1, 2, -1
}

publisher.send(1)
publisher.send(2)
publisher.send(completion: .failure(.someError))
```

Retry: 오류가 발생했을 때 지정된 횟수만큼 재시도하는 Operator

```swift
enum MyError: Error {
    case someError
}

var attempts = 0

let publisher = PassthroughSubject<Int, MyError>()
let retriedPublisher = publisher.retry(2)

retriedPublisher.sink { value in
    print(value) // 출력: 1, 2
}

publisher.send(1)
publisher.send(2)
publisher.send(completion: .failure(.someError))
```

## 2.3. subject 예제

PassthroughSubject: 새로운 값을 수신할 대마다 해당 값을 구독자에게 전달한다.

```swift
let subject = PassthroughSubject<Int, Never>()

subject.send(1) // 구독자에게 1을 전달

let subscription = subject.sink { value in
    print(value) // 출력: 1, 2
}

subject.send(2) // 구독자에게 2를 전달
```

CurrentValueSubject = 현재 값을 유지하고, 새로운 값을 수신할 때마다 해당 값을 업데이트하고 구독자에게 전달한다.

```swift
let subject = CurrentValueSubject<Int, Never>(0)

let subscription = subject.sink { value in
    print(value) // 출력: 1, 2
}

subject.send(1) // 구독자에게 1을 전달

print(subject.value) // 출력: 1

subject.send(2) // 구독자에게 2를 전달
```

Published: 속성 래퍼를 사용하여 속성의 변경 사항을 자동으로 게시하는 Subject

```swift
class MyClass {
    @Published var value: Int = 0
}

let obj = MyClass()
let subscription = obj.$value.sink { value in
    print(value) // 출력: 1
}

obj.value = 1 // 변경 사항을 구독자에게 자동으로 전달
```

# 3. Async/Await이란

Swift 5.5부터 도입되었고, 비동기 코드를 작성하고 처리하는 방법을 개선하는 데 사용된다. 기존의 Completion handlers, Delegates 및 DispatchQueue와 같은 비동기 코드 패턴을 대체한다.

## 3.1. Async 함수

async 키워드는 비동기 작업을 수행하는 함수를 선언할 때 사용된다.

async함수는 동시성으로 실행되며, 비동기 작업이 완료될 때까지 호출자에게 반환하지 않는다.

```swift
func asyncFunc() async -> SomeData {
		return await someAsyncOperation()
}
```

## 3.2. Await 키워드

await 키워드는 비동기 작업의 결과를 기다리고 해당 작업이 완료될 때까지 실행을 일시 중단 한다.

await는 async 함수 내에서만 사용할 수 있다.

```swift
async func asyncFunc() {
		do {
				let data = try await someAsyncOperation()
				// TODO: 데이터 처리
		} catch { }
}
```

## 3.3. 비동기 함수

### 3.3.1 withCheckedThrowingContinuation

swift 5.5부터 도입된 비동기 함수에서 결과를 반환하는 데 사용되는 함수이다. 이 함수는 Continuation을 생성하고 해당 Continuation에 결과를 반환할 수 있는 클로저를 제공한다.

Continuation은 일반적인 클로저와 유사하지만, 비동기적인 결과나 에러를 처리할 수 있다. 따라서 이 함수를 사용하면 비동기적인 작업의 결과나 에러를 직접 처리하고, 필요한 경우 클로저 내에서 throw할 수 있다.

```swift
try await withCheckedThrowingContinuation { continuation in
		continuation.resume(returning: value) // 클로저 내에서 결과를 반환
		continuation.resume(throwing: error) // 클로저 내에서 에러 처리
}
```

### 3.3.2. **withCheckedContinuation**

withCheckedThrowingContinuation와 유사하지만 클로저 내에서 에러를 throw하지 않고, 결과를 처리할 때 옵셔널 값으로 처리할 수 있다.

```swift
try await withCheckedThrowingContinuation { continuation in
		continuation.resume(returning: value) // 클로저 내에서 결과를 반환
		continuation.resume(returning: nil) // 클로저 내에서 결과가 없는 경우
}
```

## 3.4. Task

task는 비동기 작업을 나타내는 구조체이다.

task를 생성하고 실행하여 비동기 작업을 관리한다.

```swift
Task {
		let result = await someAsyncOperation()
}
```

### 3.4.1. Cancellation and Timeouts

async/await는 취소 및 시간 초과를 지원한다.

작업을 취소하려면 Task.cancel()을 호출한다.

시간 초과를 설정하려면 Task.withTaskCancellationHandler를 사용한다.

```swift
Task.withCancellationHandler({
		// TODO: 작업 취소 시 실행되는 코드
}) {
		// TODO: 비동기 작업
}
```

## 3.5. 예제

```swift
// 이미지를 비동기적으로 다운로드하는 함수
func loadImageAsync(url: URL) async throws -> UIImage {
    return try await withCheckedThrowingContinuation { continuation in
        let task = Task {
            do {
                let (data, _) = try await URLSession.shared.data(from: url)
                if let image = UIImage(data: data) {
                    continuation.resume(returning: image)
                } else {
                    throw NSError(
		                    domain: "ImageLoadingError",
		                    code: 0,
		                    userInfo: [
				                    NSLocalizedDescriptionKey: "Failed to load image"
				                ]
				            )
                }
            } catch {
                continuation.resume(throwing: error)
            }
        }
        
        // 시간 초과를 설정합니다.
        task.cancelAfter(.seconds(5)) // 5초로 설정
        
        // 시간 초과 시에 호출되는 핸들러
        task.withTaskCancellationHandler {
            continuation.resume(
		            throwing: NSError(
				            domain: "ImageLoadingError",
				            code: 0,
				            userInfo: [
						            NSLocalizedDescriptionKey: "Image loading timed out"
						        ]
						    )
						)
        }
    }
}

// 비동기 작업을 호출하는 함수
func fetchAndDisplayImage() async {
    let imageURL = URL(string: "https://example.com/image.jpg")!
    do {
        let image = try await loadImageAsync(url: imageURL)
        // 이미지를 UI에 표시하는 코드
        DispatchQueue.main.async {
            // 예시로 UIImageView에 이미지를 설정하는 코드
            let imageView = UIImageView(image: image)
            imageView.frame = CGRect(x: 0, y: 0, width: 200, height: 200)
            imageView.contentMode = .scaleAspectFit
            // 이 imageView를 화면에 추가하는 등의 작업을 수행할 수 있습니다.
            // 예를 들어, UIViewController의 view에 추가하는 등
        }
    } catch {
        print("Error loading image: \(error.localizedDescription)")
    }
}

// fetchAndDisplayImage() 함수를 호출하여 이미지를 비동기적으로 불러옵니다.
fetchAndDisplayImage()
```

# 4. Counter 예제

```swift
import Combine
import Foundation

final class CounterViewReactor {
    @Published private var state: State
    private var cancellables = Set<AnyCancellable>()

    init() {
        self.state = State(
            value: 0,
            isLoading: false,
            alertMessage: nil
        )
    }

    // Action 정의
    enum Action {
        case increase
        case decrease
    }

    // Mutation 정의
    enum Mutation {
        case increaseValue
        case decreaseValue
        case setLoading(Bool)
        case setAlertMessage(String?)
    }

    // 상태 정의
    struct State {
        var value: Int
        var isLoading: Bool
        var alertMessage: String?
    }

    // Action을 Mutation으로 변환하는 함수
    private func mutate(action: Action) -> AnyPublisher<Mutation, Never> {
        switch action {
        case .increase:
            return Just(Mutation.setLoading(true))
                .append(Just(Mutation.increaseValue)
		                .delay(
				                for: .milliseconds(500),
					               scheduler: DispatchQueue.main
					           )
                .append(Just(Mutation.setLoading(false)))
                .append(Just(Mutation.setAlertMessage("increased!")))
                .eraseToAnyPublisher()
        case .decrease:
            return Just(Mutation.setLoading(true))
								.append(Just(Mutation.decreaseValue)
		                .delay(
				                for: .milliseconds(500),
					               scheduler: DispatchQueue.main
					           )
                .append(Just(Mutation.setLoading(false)))
                .append(Just(Mutation.setAlertMessage("decreased!")))
                .eraseToAnyPublisher()
        }
    }

    // Mutation을 사용하여 새로운 상태를 생성하는 함수
    private func reduce(state: State, mutation: Mutation) -> State {
        var newState = state
        switch mutation {
        case .increaseValue:
            newState.value += 1
        case .decreaseValue:
            newState.value -= 1
        case .setLoading(let isLoading):
            newState.isLoading = isLoading
        case .setAlertMessage(let message):
            newState.alertMessage = message
        }
        return newState
    }
}
```