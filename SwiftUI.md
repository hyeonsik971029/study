# SwiftUI

# 목차

# 1. UIKit과 SwiftUI 차이

1. **선언적 구문(Declarative Syntax):** SwiftUI는 선언적
구문을 사용하여 UI를 정의한다. 즉, 어떻게 표현할지를 선언하고, SwiftUI가
이를 처리하도록 맡긴다.
2. **실시간 미리보기(Real-time Preview):** SwiftUI는
코드를 수정하는 즉시 미리보기를 업데이트하여 디자인의 변화를 실시간으로
확인할 수 있다.
3. **단일 파일 구조(Single File Structure):** SwiftUI는
주로 하나의 파일에 모든 코드를 작성하는 단일 파일 구조를 사용한다. 이는
코드를 조직하고 유지보수하기 쉽게 만들어 준다.

# 2. some이란

프로젝트를 처음 생성하면 ContentView라는 Struct가 생성된다.

```swift
struct ContentView: View {
	var body: some view {
		Text("Hello World")
			.padding()
	}
}
```

위의 코드에서 처음으로 막히는 코드는 some이라는 키워드일 것이다.

some은 Swift 5.1에서 처음 등장한 키워드로 반환 타입 앞에 붙을 경우,
반환 타입이 불분명한 타입(Opaque Type)인 것을 나타낸다.

불분명한 타입을 역 제네릭 타입(reverse generic types)라고 한다.

## 2.1. 제네릭 타입(generic Types)

```swift
func swap<T>(a: inout T, b: inout T) { ... }
```

위의 함수는 일반적인 제네릭 함수로 타입에 의존하지 않는 범용적인
코드로 만들어 준다.

※ 제네릭을 사용할 경우 실제 어떤 타입이 들어올지 당연히 알 수 없기
때문에 함수 내에서 제한적으로 사용할 수 밖에 없다.

따라서, 제네릭 타입에 제약이 필요한데 아래와 같은 프로토콜로 제한할
수 있다.

```swift
func swap<T>(a: inout T, b: inout T) where T: Equatable { ... }
```

함수 내부에선 a와 b가 어떤 타입인지 모르지만, Eqatable을 채택하고
있기 때문에 a와 b에 한해서 비교 연산자는 사용가능하다.

제네릭의 경우 함수 구현 내부에서는 실제 타입에 대해 알 수 없고 아래와
같이 외부에서 알 수 있다.

```swift
var a: String = "A"
var b: String = "B"
swap(a: &a, b: &b)
```

## 2.2. 불투명한 타입(Opaque Types)

불투명한 타입이 역 제네릭 타입이라고 불리는 이유는 불투명한 타입의
경우 외부에서 함수의 반환 값 타입을 정확하게 알 수 없고, 함수 내부에서는
알고 있기 때문이다.

예를 들어, 과일 가게에서 사과와 체리를 팔고 있다고 가정하고 박스에
포장해준다고 할 때

```swift
struct Apple { ... }
struct Cherry { ... }
protocol FruitBox {
	associatedtype fruitType
  var fruit: fruitType { get }
}
```

위와 같이 assoicatedtype을 사용해 구현할 수 있다.

※ associatedtype은 Protocol 내의 Generic Type이라고 할 수 있다.

```swift
struct AppleBox: FruitBox {
	var fruit: Apple
}
struct CherryBox: FruitBox {
	var fruit: Cherry
}
```

위와 같이 사용할 수 있다.

```swift
func makeAppleFruitBox() -> FruitBox {
	return AppleBox.init(fruit: .init())
}
func makeCherryFruitBox() -> FruitBox {
	return CherryBox.init(fruit: .init())
}
```

사과와 체리를 반환하는 함수를 만들고 싶은데 위와 같이 정의하면 같은
코드가 중복으로 쓰이는 불상사가 발생함

그래서 아래와 같이 정의하면

```swift
func makeFruitBox() -> FruitBox {
	return AppleBox.init(fruit: .init())
}
```

에러가 발생한다.

에러가 발생한 이유는 fruit이라는 프로퍼티의 타입이 associatedtype이기
때문이다.

외부에선 fruitBox의 내용물이 사과인지 체리인지 알 수가 없다.

💡 따라서 함수의 반환타입이 확실하게 정해져 있지 않지만 항상 특정
타입만 반환할 거야라고 컴파일러에거 알릴 때 사용하는 것이
**some**이라는 키워드이다.

아래의 코드처럼 some이란 키워드를 추가하면 에러가 사라지면서 반환
타입인 FruitBox가 불투명 타입이 된다.

```swift
func makeFruitBox -> some FruitBox {
	return AppleBox.init(fruit: .init())
}
```

# 3. ContentView란

viewController 혹은 View에서 화면을 그리고 State의 변화로 UI로 화면을
업데이트 하던 작업들을 **ContentView**라는 구조체 안에서
한다고 생각하면 된다.

이때 View는 프로토콜로 구현되어 있고, body라는 프로퍼티를 갖고
있다.

따라서 View를 채택하고 있는 ContentView 구조체 안에 body라는
프로퍼티는 반드시 있어야 하고, 이 body가 ContentView의 최상위 View의
역할을 한다.

※ body는 연산 프로퍼티로 구현하면 된다.

body는 단 한개의 View만 반환해야 한다.

여러 개의 뷰를 배치하고 싶을 땐 stack 등을 사용해서 여러 개의 뷰를
하나의 뷰로 감싸서 하나의 View로 리턴해야 한다.

# 4. View의 생명주기

**Initalization**: 뷰가 처음 생성될 때 호출된다. 초기화
중에 필요한 속성들을 설정하고 초기 상태를 설정하는 등의 작업을
수행한다.

**onAppear / onDisAppear**: 뷰가 화면에 나타나거나
사라질 때 호출된다. 예를 들어, 사용자가 다른 화면으로 이동할 때 혹은
뷰가 화면에 나타날 때 특정 동작을 수행하도록 코드를 작성할 수 있다.

```swift
struct ContentView: View {
	var body: some View {
		Text("Hello, SwiftUI")
			.onAppear {
				// TODO: View appeared on screen
			}
			.onDisAppeear {
				// TODO: View disappeared from screen
			}
	}
}
```

**onChange**: 특정 바인딩의 값이 변경될 때 호출된다.
예를 들어, 특정 변수가 변경되면 뷰를 업데이트하거나 특정 작업을 수행하는
데 사용된다.

```swift
struct ContentView: View {
	@State private var someState: Int = 0
	var body: some View {
		Text("Hello, SwiftUI")
			.onChange(of: someState) { newValue in
				// TODO: State changed
				}
	}
}
```

**onReceive**: Combine 프레임워크의 Publisher가 값을
방출할 때 호출된다. Combine을 사용하여 비동기 작업을 수행하거나 데이터를
관찰하는 데 유용하다.

```swift
struct ContentView: View {
	@State private var someData: String = ""
	var body: some View {
		Text(someData)
			.onReceive(somePublisher) { newData in
				self.someData = newData
       }
	}
}
```

**Deinitialization:** 뷰가 메모리에서 해제될 때
호출됩니다. 메모리 누수를 방지하거나 리소스 정리 등을 수행하는 데
사용됩니다.

# 5. SwiftUI Components

- 기본 Components
    - **Text**: 정적 또는 동적으로 생성된 텍스트를 표시
    - **Image**: 에셋, URL 또는 시스템 제공 이미지에서 이미지를 표시
    - **Button**: 눌렸을 때 작업을 트리거하는 탭 가능한 UI요소
    - **TextField**: 사용자가 텍스트를 입력할 수 있게 함
    - **Toggle**: 두 상태 사이를 전환하는 스위치 모양의 UI 요소
    - **Slider**: 범위에서 값을 선택할 수 있도록 사용자가 슬라이더를 따라 이동할 수 있게 함
    - **Picker**: 선택 옵션 집합에서 선택할 수 있는 드롭다운 목록
    - **List**: 데이터의 스크롤 가능한 목록을 표시
    - **NavigationView**: 내비게이션 계층을 관리하기 위한 컨테이너 뷰
    - **NavigationLink**: 내비게이션을 위한 다른 뷰로의 링크를 생성
    - **NavigationStack**: 사용자 인터페이스 내에서 내비게이션을 관리하기 위한 컨테이너
    - **TabView**: 탭을 사용하여 여러 뷰 사이를 이동할 수 있게 함
    - **ScrollView**: 사용 가능한 공간을 초과하는 콘텐츠에 대한 스크롤 기능을 제공
    - **Spacer**: 레이아웃에서 사용 가능한 공간을 확장하는 유연한 공간
    - **VStack**, **HStack**, **ZStack**: 뷰를 세로, 가로 또는 레이어로 배열하는 레이아웃 컨테이너
    - **ForEach**: 데이터 컬렉션을 반복하고 여러 뷰를 생성
    - **Alert**: 사용자에게 알림 메시지를 표시
    - **Sheet**: 현재 컨텍스트 위에 모달 뷰를 표시
- 커스텀 Components

```swift
import SwiftUI

// 정의
struct CustomButton: View {
	var title: String
	var action: () -> Void

	var body: some View {
		Button(action: self.action) {
			Text(title)
		}
	}
}

// 사용
struct ContentView: View {
	var body: some View {
		CustomButton(title: "TEST") {
			// TODO: Action
		}
	}
}
```

# 6. SwiftUI와 디자인 패턴

## 6.1. MVVM(Model-View-ViewModel)

### 6.1.1. MVVM 역할

Model

- 데이터, 비지니스 로직, 서비스 클라이언트 등으로 구성
- 실제 데이터

View

- iOS는 ViewController까지 View가 된다.
- 사용자에게 보여지는 View를 생각하면 된다. 유저 인터랙션을 받고,
ViewModel과 상호작용합니다.

ViewModel

- View를 표현하기 위해 만들어진 View를 위한 Model
- View와는 Binding을 통해 연결 후 View에게 Action을 받고 View를
업데이트한다.

### 6.1.2. MVVM 장단점

장점

- View와 Model이 서로 알지 못하기 때문에 독립성을 유지할 수 있다.
- 독립성을 유지하기 때문에 효율적인 유닛테스트가 가능하다.
- View와 ViewModel을 바인딩하기 때문에 코드의 양이 줄어든다.
- View와 ViewModel의 관계는 N : 1이다.

단점

- 간단한 UI에서 오히려 ViewModel을 설계하는 어려움이 있을 수
있다.
- 데이터 바인딩이 필수적으로 요구된다.
- 복잡해질수록 Controller처럼 ViewModel이 비대해진다.
- 표준화된 틀이 존재하지 않아 사람마다 이해가 다르다.

### 6.1.3 SwiftUI와 MVVM

SwiftUI에서 ViewModel이 필요하지 않은 이유

- 실제 개발 시 SwiftUI로 개발하다보면 MVVM 구조를 지키기 위해 억지로
ViewModel을 만드는 상황이 종종 발생한다.
- SwiftUI에서 View는 자체적으로 Data Binding이 가능한
PropertyWrapper를 지원한다.
- 즉, SwiftUI에서의 View는 이미 View + ViewModel의 역할을 하고
있다.
- Apple Developer forum을 포함한 다양한 아티클에서 개발자들은
SwiftUI에서 MVVM을 사용하는 것이 불필요하다고 주장하고 있다.
- SwiftUI에서는 Model과 View가 결합된 MV면 충분할 수 있다.

## 6.2. TCA(The Composable
Architecture)

TCA는 SwiftUI 앱을 위한 간단하고 강력한 아키텍처를 제공한다. 또한
Combine과 함께 사용하면 리액티브 프로그래밍의 이점을 누릴 수 있다.

### 6.2.1. TCA 역할

State

- 앱의 상태를 나타낸다. 모든 데이터와 뷰 상태는 하나의 중앙 상태로
표현된다.

Action

- State를 변경하는 행동을 나타낸다. 사용자의 입력, 비동기 작업 완료
등이 Action으로 표현된다.

Reducer

- 현재 State와 Action을 받아서 새로운 상태를 반환하는 함수이다. 모든
상태 변경은 Reducer를 통해 이루어진다.

Effect

- 비동기 작업이나 부수 효과를 나타낸다. Effect는 Reducer에서 반환되어
비동기 작업이 완료되면 새로운 Action을 생성한다.

Store

- State, Reducer, Effect 등을 결합하여 전체 앱 상태를 관리하는
객체이다. 모든 State 변경은 Store를 통해 이루어진다.

View

- SwiftUI의 View는 TCA와 함께 사용된다. SwiftUI 뷰는 현재 상태를
표현하고, 사용자의 입력에 대한 Action을 생성하여 State 변경을
트리거한다.

이렇게 하나의 동작 단위를 나타내는 Action, Reducer, Effect, 그리고
상태를 담당하는 State가 서로 조홥돼 SwiftUI와 함께 동작한다.

### 6.2.2. SwiftUI와 TCA, Combine
예시

이미지를 비동기로 받아와 화면에 표시하는 예문

- 모델 및 상태 정의

```swift
import Combine
import Foundation
import SwiftUI

struct ImageModel: Cadable {
		let url: URL
}
struct AppState {
	var image: UIImage?
	var isLoading: Bool = false
}
```

- 액션 정의

```swift
enum AppAction {
	case loadImage
  case imageLoaded(UIImage?)
}
```

- 리듀서 구현

```swift
import ComposableArchitecturelet

appReducer = Reducer<AppState, AppAction, Void> { state, action, _ in
	switch action {
		case .loadImage:
			// 이미지 로딩 중인 경우 무시
			guard !state.isLoading else { return .none }
			state.isLoading = true
			// 비동기 작업(이미지 다운) 시작
			return URLSession.shared.dataTaskPublisher(for: URL(string: "{예시 이미지 URL}")!)
				.map { UIImage(data: $0.data) }
				.replaceError(with: nil)
				.receive(on: DispatchQueue.main)
				.map(AppAction.imageLoaded)
				.eraseToEffect()
		case let .imageLoaded(image):
			state.isLoading = false
			state.image = image
      return .none
  }
}
```

- 뷰 및 환경 설정

```swift
struct ContentView: View {
	let store: Store<AppState, AppAction>
	var body: some View {
		WithViewStore(store) { viewStore in
			VStack {
				if viewStore.isLoading {
					ProgressView("Loading...")
				} else if let image = viewStore.image {
					Image(uiImage: image)
						.resizable()
						.scaledToFit()
				} else {
					Text("Tap the button to load image")
				}
				Button("Load Image") {
					viewStore.send(.loadImage)
				}
				.padding()
			}
		}
	}
}
struct ContentView_Previews: PreviewProvider {
	static var previews: some View {
		ContentView(store: Store(
			initialState: AppState(),
			reducer: appReducer,
			environment: ()
		))
	}
}
```

- 앱 진입 지점 설정

```swift
import ComposableArchitecture
import SwiftUI

@mainstruct AsyncImageLoadingApp: App {
	var body: some Scene {
		WindowGroup {
			ContentView(store: Store(
				initialState: AppState(),
				reducer: appReducer,
				environment: ()
			))
		}
	}
}
```

## 6.3. VIP

View

- 사용자 인터페이스를 표시하고, 사용자의 입력을 받는 역할을 한다.
- UIKit에서는 UIViewController가 SwiftUI에서는 View에 해당한다.

Interactor

- 비즈니스 로직을 처리하는 부분이다.

Presenter

- Interactor로부터 전달받은 데이터를 가공하여 View에 표시할 데이터를
가공한다.
- View와 Interactor의 중개자 역할

Entity

- 데이터 모델을 나타낸다.
- 앱에서 사용되는 데이터 객체를 정의하는 부분

Router

- 화면 간의 전환을 관리한다.
- 다른 모듈로의 데이터 전달과 같은 네비게이션 로직을 처리한다.

## 6.4. Flux 아키텍처

View

- 사용자 인터페이스, SwiftUI의 View는 상태를 직접 변경하지 않고 액션을
디스패처에 보내 상태 변경을 유도

Store

- 앱의 상태를 보유하고, 상태 변경을 관리하는 부분

Action

- 사용자 이벤트, 기타 외부 이벤트를 나타내는 객체
- SwiftUI에서는 enum으로 정의가능

Dispatcher

- Action을 Store로 전달하는 역할

## 6.5. Repository 패턴

Entity

- 데이터 모델을 나타낸다.

Repository Interface

- 데이터 엑세스의 기본 메서드를 정의한 인터페이스이다.

Concrete Repository

- 실제 데이터 엑세스를 수행하는 클래스, 레파지토리 인터페이스의
메서드를 구현한다.

```swift
struct User {
	let id: Int
  let name: String
  ...
}
class UserRepository {
	func getUserByID(_ userID: Int) -> User?
  func saveUser(_ user: User)
}
class UserRepositoryImpl: UserRepository {
	func getUserByID(_ userID: Int) -> User? { /* TODO */ }
	func saveUser(_ user: User) { /* TODO */ }
}
```

# 7. Navigation

NavigationView

- SwiftUI에서 네비게이션을 시작하려면 NavigationView 를 사용해야 한다.
navigationView는 네비게이션 스택을 관리하고 화면 전환을 처리하는 데
사용된다.

```swift
struct ContentView: View {
	var body: some View {
		NavigationView { /* TODO */ }
	}
}
```

- 타이틀 설정: 네비게이션 바에 타이틀을 설정하려면
NavigationBarTitle을 사용한다.

```swift
struct ContentView: View {
	var body: some View {
		NavigationView {
			Text("첫 번째 화면")
				.navigationBarTitle("홈")
		}
	}
}
```

NavigationLink

- 사용자가 특정 뷰로 이동할 수 있게 해주는 링크 역할을 한다. 버튼,
텍스트 뷰를 탭했을 때 다른 뷰로 전환할 수 있다.

```swift
struct ContentView: View {
	var body: some View {
		NavigationView {
			NavigationLink("다음 화면으로", destination: Text("다음 화면"))
				.padding()
		}
	}
}
```

# 8. Annotation

## 8.1. Annotions

@State

- 상태를 관리하는 데 사용되는 프로퍼티 래퍼(property wrapper) 중
하나이다.
- Mutable한 로컬 상태 관리: @State로 선언된 변수는 뷰 내에서 변경 가능한
상태를 나타내며, 해당 변수가 변경되면 SwiftUI가 자동으로 뷰를
업데이트한다.
- 값 타입으로 사용: @State는 값 타입을 사용하며, 뷰의 소유하에
있다. 따라서 뷰 간에 상태를 전달하려면 다른 방법을 사용해야 한다.
- 상태가 전체 앱이나 여러 뷰에서 공유되어야 하는 경우에는 @State보다 @ObservedObject,
@EnvironmentObject, 또는 @Binding 등을 사용하는 것이
더 적절하다.

```swift
struct ContentView: View {
	@State private var count: Int = 0
	var body: some View {
		VStack {
			Text("Count: \(count)")
			Button("증가") {
				count += 1
			}
		}
	}
}
```

@Binding

- 부모 뷰에서 자식 뷰로 데이터를 전달하고, 그 데이터를 변경하면 부모
뷰에서도 변경된 값을 반영할 때 사용된다.

```swift
struct ContentView: View {
	@State private var text: String = "Initial Text"
	var body: some View {
		ChildView(text: $text)
	}
}
struct ChildView: View {
	@Binding var text: String
  var body: some View {
		TextField("Enter text", text: $text)
	}
}
```

@ObservedObject

- 클래스 기반의 ObservableObject를 사용할 때 사용된다.
- ObservableObject는 객체가 변경될 때 뷰를 감시하고 업데이트할 수
있다.

```swift
class MyModel: ObservableObject {
	@Published var data: String = "Initial Data"
}
struct ContentView: View {
	@ObservedObject var myModel = MyModel()
	var body: some View {
		Text(myModel.data)
	}
}
```

@EnvironmentObject

- 앱의 환경에서 전역적으로 사용 가능한 객체를 나타낸다.
- 해당 객체는 뷰 계층 구조 전체에서 공유되며, 필요한 뷰에서 @EnvironmentObject로 선언하여
접근할 수 있다.

```swift
class UserData: ObservableObject {
	@Published var username = "John Doe"}
}
struct ContentView: View {
	@EnvironmentObject var userData: UserData
  var body: some View {
		Text("Username: \(userData.username)")
	}
}
```

@GestureState

- 제스처의 상태를 추적하는 상태 변수를 생성하는데 사용한다.
- 제스처 수정자와 함께 사용되어 뷰에 상호작용성을 추가한다.

```swift
import SwiftUI

struct ContentView: View {
	@GestureState private var isDragging = false
	@GestureState private var dragOffset = CGSize.zero

	var body: some View {
		let dragGesture = DragGesture()
			.updating($isDragging) { value, state, _ in
				state = true
			}
			.updating($dragOffset) { value, state, _ in
				state = value.translation
			}
			.onEnded { value in
				// 드래그 종료 처
			}
			
		RoundedRectangle(cornerRadius: 10)
			.fill(isDragging ? Color.blue: Color.red)
			.offset(dragOffset)
			.gesture(dragGesture)
	}
}
```

@StateObject

- @ObserverObject와 유사하지만 뷰 내에서 관찰되는 객체를 초기화한다.
- 관찰 대상 객체가 뷰의 수명주기 동안 한번만 생성되도록 보장한다.

```swift
import SwiftUI

class ViewModel: ObservableObject {
	@Published var counter = 0

	func increment() {
		counter += 1
	}
}

struct ContentView: View {
	@StateObject var viewModel = ViewModel()

	var body: some View {
		VStack {
			Text("Counter: \(viewModel.counter)")
			Button("increment") {
				viewModel.increment()
			}
		}
	}
}
```

### 8.1.1. @ObservedObject VS @StateObject

- **@ObservedObject**
    - 현재 뷰 계층 구조 외부에 있는 객체를 선언하는 데 사용, 그러나 뷰 내에서 해당 객체의 변경 사항을 관찰해야하는 경우 사용된다.
    - 주로 외부에서 관찰 가능한 객체의 인스턴스를 뷰에 주입하는데 사용, 일반적으로 뷰 외부에서 초기화됨
    - 관찰 대상 객체는 여러 뷰에서 공유되며, 관찰 대상 객체의 변경 사항이 발생하면 관찰하는 뷰가 업데이트됨
    - 각 뷰는 관찰 대상 객체의 복사본을 받으며, 해당 복사본에 대한 변경 사항은 모든 관찰하는 뷰에 전파됨
- @StateObject
    - 외부 객체를 선언하는 데 사용, 하지만 특정 뷰 내에서 객체를 초기화하는 데 사용된다.
    - 뷰의 수명 동안 관찰 대상 객체가 한번만 생성되도록 보장, 뷰가 상태 변경으로 인해 다시 생성되더라도 뷰의 수명 동안 한번만 생성됨
    - 객체의 복사본을 받지 않음
    - 관찰 대상 객체가 뷰의 수명주기와 밀접하게 연결되어 있고 뷰가 다시 생성될 때마다 다시 생성되어야 하는 경우에 적