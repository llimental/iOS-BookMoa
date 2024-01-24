# BookMoa README

* [💫 Introduce 💫](https://github.com/llimental/iOS-BookMoa#-introduce-)
* [📱 구현 화면](#-구현-화면)
* [🏛️ 프로젝트 구조](https://github.com/llimental/iOS-BookMoa#%EF%B8%8F-프로젝트-구조)
* [🔨 STEP별 구현 내용](#-step별-구현-내용)
* [🚀 트러블 슈팅](#-트러블-슈팅)
  + [1. 네트워크 모델 구성](#1-네트워크-모델-구성)
  + [2. Modern CollectionView 구성](#2-modern-collectionview-구성)
  + [3. DiffableDataSource - snapshot expensive cost 문제](#3-diffabledatasource---snapshot-expensive-cost-문제)
  + [4. UITextView Placeholder 만들기](#4-uitextview-placeholder-만들기)
  + [5. 키보드가 화면을 가리는 현상](#5-키보드가-화면을-가리는-현상)
  + [6. 더보기 기능 구현](#6-더보기-기능-구현)
  + [7. Preview 기능 구현](#7-preview-기능-구현)
  + [8. Gesture의 사용법](#8-gesture의-사용법)
  + [9. addArrangedSubview란?](#9-addarrangedsubview란)
  + [10. 큰 화면을 가진 기기 대응](#10-큰-화면을-가진-기기-대응)
* [🙋🏻 추후 계획](#-추후-계획)

<br>

## 💫 Introduce 💫
🏃🏻🏃🏻‍♂️💨 **프로젝트 기간:** `23. 05. 17` ~ `23. 06. 14`

|<img src="https://avatars.githubusercontent.com/u/45708630?v=4" width=200>|
|:---:|
|[Lust3r](https://github.com/llimental)|

- **서비스 :** 시중의 다양한 책에 대한 정보를 제공
  - 베스트 셀러 목록
  - 장르별 도서 목록
  - 개별 도서 상세 정보
  - 개별 도서 메모 기능
  - 개별 도서 미리보기 기능
  - 키워드 검색(서명, 저자)
  - 즐겨찾기 기능
- **기술 스택 :** `Swift(UIKit)`, `Figma(Design)`
- **프로젝트 회고 :**
  - 오롯이 혼자 공부하여 구현한 **첫 개인 프로젝트**
  - 짧은 기간 동안 **몰입**하여 프로젝트를 수행
  - 개발 전 **구현해야 하는 기능**과 **추후 개발할 기능**을 고려하여  Figma 페이지 분리 및 **기능별 Step 분리로 우선순위 확립**
  - 하나의 Open API이지만 기능별로 사용해야 하는 API가 달라  **재사용 가능한 EndPoint 및 네트워크 구조 설계**를 위해 노력
  - 미숙했던 기능의 구현을 위해 많은 **학습** 진행
    - Compositional CollectionView + Diffable Data Source
    - URLSession
    - Async/Await
  - 유지보수를 위해 최대한의 **파일, 객체, 메서드 분리 노력**
  - Notion을 통해 문서화를 진행하였지만, 정리 미흡
    - 미흡한 내용은 **보완 예정**

<br>

## 📱 구현 화면
![Simulator Screen Recording - iPhone 14 Pro - 2023-06-19 at 13 46 31](https://github.com/llimental/iOS-BookMoa/assets/45708630/0776adf0-6a04-4a02-b1d0-275f31c7a5e8)

<br>

## 🏛️ 프로젝트 구조
![Group 3](https://github.com/llimental/iOS-BookMoa/assets/45708630/0149c4e4-0451-435e-b328-79aee6bf8ca3)
![Group 4](https://github.com/llimental/iOS-BookMoa/assets/45708630/6db5c729-2abb-43a0-b5da-8fba907271c9)
![Group 5](https://github.com/llimental/iOS-BookMoa/assets/45708630/6e5d5a85-b802-4815-a069-d80991aa03fc)

<br>

## 🔨 STEP별 구현 내용

### STEP 1 모델 타입 구현
- Open API 데이터 형식을 고려하여 모델 타입을 구현
- 구현한 모델 타입으로 Parsing할 수 있는지에 대한 `단위 테스트(Unit Test)`를 진행

### STEP 2 네트워킹 타입 구현
- 네트워크 통신을 담당할 타입을 설계하고 구현
- Open API 데이터 형식을 고려하여 서버와 실제로 데이터를 주고 받도록 구현
- 🗝️ **keyword**: URLSession, Network, Decode, JSON Parsing

### STEP 3 메인 목록 화면 구현
- STEP 2에서 구현한 네트워킹 기능을 통해 실제로 책 목록을 API 서버에 요청하여 불러오기
- 리스트를 아래로 잡아끌어서 놓으면 리스트를 `새로고침` 하기
- 처음 목록을 불러올 때, 사용자에게 빈 화면만 보여주는 대신 `로딩 중`임을 알 수 있게 하기
- `좌우 스크롤`이 가능한 layout 구현
- 리스트에 표기할 정보
    - 인기 도서(이미지, 서명 저자) - 최대 10개까지 출력
    - 장르
- 메인 목록 화면 하단에 '홈' 화면과 '즐겨찾기' 화면으로 갈 수 있는 `툴바` 구현
- 🗝️ **keyword**: UIRefreshControl, UIActivityIndicatorView, Compositional Layout, UIToolbar

### STEP 4 상세 화면 구현(개별 도서)
- 메인 목록 화면에서 책의 이미지를 누르면 도서 세부화면으로 이동하도록 구현
- 책의 대표 이미지를 노출
    - 이미지를 탭하면 이미지를 확대해서 확인 가능
- 미리보기 버튼 제공
    - 탭하면 `미리보기`를 팝업으로 제공
- 도서의 줄거리를 제공합니다
    - 최대 100자를 노출합니다. 그 이상의 글자는 `더보기 버튼`을 통해서 제공합니다.
    - `더보기 버튼`을 누르면 전문이 노출됩니다.
- 저자 소개를 제공합니다.
    - 최대 100자를 노출합니다. 그 이상의 글자는 `더보기 버튼`을 통해서 제공합니다.
    - `더보기 버튼`을 누르면 전문이 노출됩니다.
- 해당 책에 대한 메모를 사용자가 직접 추가할 수 있습니다.
- 🗝️ **keyword**: Presentation, gesture, UILabel

### STEP 5 상세 화면 구현(장르별)
- 메인 목록 화면에서 장르 버튼을 누르면 장르 세부화면으로 이동하도록 구현
- `검색` 기능을 제공합니다
    - 검색가능 키워드: 책 제목, 저자명
    - 한 페이지에 최소 `9건` 이상의 도서 검색결과를 노출합니다.
        - 상하로 페이지 스크롤이 가능합니다. 최하단으로 스크롤할 경우 `추가적인` 검색결과를 불러옵니다.
        - 책 우측 상단에는 즐겨찾기 여부를 확인할 수 있는 이미지를 표시합니다.
    - 각 책을 누르면 STEP 4의 `개별 도서 상세 화면`으로 갈 수 있도록 합니다.
- 🗝️ **keyword**: SearchController, lazy loading

### STEP 6 즐겨찾기 페이지 구현
- 즐겨찾기 페이지는 검색 결과 화면과 `동일한` 화면을 사용합니다. 다만 즐겨찾기된 도서들만 표시합니다.
- STEP 6의 각 책의 우측 상단에는 `하트`가 표시됩니다.
    - 하트를 누르면 빨간색으로 하트가 변하고, `즐겨찾기 리스트`에 들어가게 됩니다.
    - 하트를 누른 책들의 목록을 `디바이스에 저장`하여 앱을 종료했다 켜더라도 유지되도록 합니다.
- 🗝️ **keyword**: UserDefaults, reuseCustomCell, viewLifeCycle

<br>

## 🚀 트러블 슈팅

### 1. 네트워크 모델 구성
**고민한 점 :** URL 요소를 어떻게 분리하는 것이 좋을까?

**참고자료 :** [Apple 공식문서(URLComponents)](https://developer.apple.com/documentation/foundation/urlcomponents)

**해결 :** 기존에는 firstComponent, secondComponent 등으로 나누어 구성하였기에 Component의 숫자가 **일정한 상황**에서는 유용하였지만, 숫자가 **다른 상황**에서는 Component를 제거하거나 추가해야 하는 등 **유연하게 사용하기가 어려웠다.**
공식문서의 내용을 따라 **scheme, host, path, queryItems**를 사용하여 문제를 해결할 수 있었다.

- **scheme**
    - 리소스를 접근하는데 사용할 **프로토콜을 식별**
    - 스키마 다음에는 :// 를 붙여주어야 한다.
- **host**
    - 리소스를 보유한 **호스트를 식별**
    - 호스트 이름 다음으로 **port number**가 올 수도 있다.
    - **포트 번호가 있는 경우** 호스트 이름 다음으로 **:과 함께 포트 번호**를 붙여 주어야 한다.
- **path**
    - 접근하려는 **특정 리소스를 식별**
    - 경로 이름은 **/** 로 시작한다.
- **query**
    - 특정 목적에 사용할 **정보에 대한 문자열을 제공**
    - 쿼리 문자열이 지정되면 **앞에 ?** 가 오며, **각 쿼리는 &로 연결된다.**

<br>
<img src = https://github.com/llimental/iOS-BookMoa/assets/45708630/8dbec68a-12b6-4785-a238-35b0942da42e width = 50%>
<br>

### 2. Modern CollectionView 구성
**고민한 점 :** 지금까지 TableView와 기본 CollectionView만 써봤는데, 저렇게 **다채로운** 레이아웃을 어떻게 하면 구성할 수 있을까?
찾아보니 Compositional이라는 것도 있고, diffable이라는게 있는데 이건 무엇일까?

**참고자료 :**
    - [Apple 공식문서(UICollectionViewCompositionalLayout)](https://developer.apple.com/documentation/uikit/uicollectionviewcompositionallayout)
    - [Apple 공식문서(UICollectionViewDiffableDataSource)](https://developer.apple.com/documentation/uikit/uicollectionviewdiffabledatasource)
    - [Apple 공식문서(UICollectionLayoutSectionOrthogonalScrollingBehavior)](https://developer.apple.com/documentation/uikit/uicollectionviewdiffabledatasource)
    - [Apple 공식문서(Implementing Modern Collection Views)](https://developer.apple.com/documentation/uikit/views_and_controls/collection_views/implementing_modern_collection_views)
    
**해결 :** Compositional Layout은 기존의 CollectionView로 다양한 레이아웃을 만들 때 어려울 수 있는 부분을 해결하기 위한 유형이라고 생각한다. 각 요소를 **item, group, section**으로 만들어 쪼개고, 각 section은 또 **다른 레이아웃을 가질 수 있기** 때문이다.
DiffableDataSource는 WWDC에 따르면 기존에는 데이터를 반영함에 있어 IndexPath도 중요하고, ReloadData를 해야 하는 소요가 있는데, Snapshot을 통해 이를 해결했다고 한다. **Snapshot을 비교함으로써 어떤 부분이 달라졌는지 파악**하여 View에 반영을 해주는 것이다. 덕분에 IndexPath 오류며 ReloadData의 필요 없이 snapshot.**apply() 로 해결**할 수 있게 되었다.

메인화면에서 베스트 셀러 목록은 가로로 스크롤을 해야 하고, 장르별 이름 리스트는 세로로 스크롤을 해야 했기에 위에서 언급한 각 **section별 별도의 레이아웃**이 필요했다.
이를 위해 **OrthogonalScrollingBehavior를 통해 베스트 셀러 섹션을 가로로 스크롤링** 하게 만들어주어 해결할 수 있었다.

<br>
<img src = https://github.com/llimental/iOS-BookMoa/assets/45708630/899a3854-f0b8-4902-aa01-eb4e83518e53>
<br>

### 3. DiffableDataSource - snapshot expensive cost 문제
**고민한 점 :** CollectionView가 로딩될 때 데이터를 넣는 과정에서 비용 문제가 발생하는데 어떤 것이 문제일까?

**문제 로그:** **Diffable data source detected an attempt to insert or append 10 item identifiers that already exist in the snapshot.**
    
**해결 :** 공식문서를 통해 Diffable Data Source, snapshot을 보고, WWDC를 다시 봐도 문제가 보이지 않았다.
같이 공부하는 동료에게 물어보니 지금까지 snapshot에 대해 잘못 이해하고 있었음을 깨달았다.
snapshot을 처음 만들 때에만 새로 만들어주고, 이후 스냅샷부터는 같은 스냅샷에 아이템만 새로 넣어주면 되는 것이라고 생각했었다. 하지만 snapshot ‘내’의 아이템 비교가 아닌 **snapshot ‘간’의 비교**이기 때문에 새로운 아이템이 담긴 snapshot을 만들어줘야 했던 것이다.

때문에 Diffable Data Source는 이미 스냅샷에 아이템이 들어있는데 왜 또 그 아이템을 넣으려고 하냐며 일단 들어는 주는데 이건 expensive cost다 하고 알려준 것이었다.
**새로운 snapshot을 만들어서 apply**해주자 문제를 해결할 수 있었다.

<br>
<img src = https://github.com/llimental/iOS-BookMoa/assets/45708630/43872a7f-4163-4912-a540-999e21711f57>
<br>

### 4. UITextView Placeholder 만들기
**고민한 점 :** 책 상세정보 View에서 메모를 위한 TextView를 만들었는데, 여기에 TextField처럼 placeholder를 넣어주고 싶다.
메모가 없다면 placeholder를 보여주고, 메모를 시작할 때 지우는 방식으로 하고자 한다.
찾아보니 Compositional이라는 것도 있고, diffable이라는게 있는데 이건 무엇일까?

**참고자료 :**
    - [블로그(김종권의 iOS 앱 개발 알아가기 - TextView placeholder 적용 방법)](https://ios-development.tistory.com/693)
    
**해결 :** **TextView Delegate를 활용하여 TextView가 편집중인지 아닌지**를 바탕으로 textView.text를 설정하는 방식으로 해결할 수 있었다.
가령 편집중인데 현재 text가 설정해놓은 placeholder text와 같다면 text를 nil로 만들고 글자 색을 .black으로 바꾸고, 편집이 끝났는데 text가 아무것도 없다면 placeholder text로 다시 돌려놓는 것이다.

<br>
<img src = https://github.com/llimental/iOS-BookMoa/assets/45708630/aa75851a-e74f-44f9-a143-9af7c98ec0ec>
<br>

### 5. 키보드가 화면을 가리는 현상
**고민한 점 :** 책 상세정보 View에서 메모를 하기 위해 TextView를 터치하면 키보드가 올라오는데, 키보드에 맞춰 뷰가 움직이는 것이 아니라 가려버리는 문제가 발생해서 뷰의 위치를 조정할 필요가 있었다.

**참고자료 :**
    - [블로그(김종권의 iOS 앱 개발 알아가기 - TextView placeholder 적용 방법)](https://ios-development.tistory.com/693)
    
**해결 :** **Notification Center Observer를 활용하여 해결**할 수 있었다. keyboardWillShowNotification,
keyboardWillHideNotification으로 옵저버를 추가하고,  selector 메서드에서 **키보드의 height와 tabBar의 height 만큼
View의 위치를 옮겨주는 방식**으로 화면을 구성하게 되었다.

하지만 처음에는 잘 작동하였으나 나중에 다시 테스트 했을 때, 키보드 자판을 터치하면 **키보드 위쪽으로 옮겨진 만큼의 빈 공간이 또 생기는 문제**가 발생했다.
실기기에서는 괜찮았으나 시뮬레이터에서만 중복으로 처리가 되고, 코드에서는 두 번 작동할만한 부분이 보이지 않아 난항을 겪었으나 **view의 y위치를 체크하는 조건문을 달아줌으로써 해결**할 수 있었다.
더불어 조건문을 통해 해결하면서 각 selector 메서드에서 각각 높이를 구하고 빼고 더해주는 작업 대신 hide에서는 view의 위치를 원래대로 돌리는 식으로 코드도 간결하게 처리할 수 있었다.

<br>
<img src = https://github.com/llimental/iOS-BookMoa/assets/45708630/39b9d5a0-f49a-47b4-a6cd-d352e53ea0b8>
<br>

### 6. 더보기 기능 구현
**고민한 점 :** UILabel에 어떻게 더보기를 구현할 수 있을까? 하는 생각으로 버튼을 만들어 numberOfLines 값을 바꿔주는 것을 생각했었다. 하지만 이는 글자수로 체크하는 것이 아니라 줄 수로 구분을 하는 문제가 있었고, 버튼을 마지막 글자 옆에 유동적으로 위치하게 할 수 없어 Label의 아래쪽에 레이아웃을 주게 되었는데 버튼을 눌렀을 때 hide를 시키면 해당 위치가 붕 뜨는 문제도 있었다.

**참고자료 :**
    - [stackoverflow(Add "...Read More" to the end of UILabel)](https://stackoverflow.com/questions/32309247/add-read-more-to-the-end-of-uilabel)
    
**해결 :** 수많은 답변이 있었으나 복잡하고 이해가 안가는 코드가 많이 있었다.
그 중 UILabel을 따로 커스텀하여 정해진 글자 수만큼 인덱스로 잘라서 보여주거나 전문을 보여주는 방식을 사용할 수 있었다.

<br>
<img src = https://github.com/llimental/iOS-BookMoa/assets/45708630/11576c6c-03a9-4df0-abc9-646ae160132c>
<br>
<img src = https://github.com/llimental/iOS-BookMoa/assets/45708630/ade1be63-72d6-4a82-a2be-88580d6bf33c width = 50%><img src = https://github.com/llimental/iOS-BookMoa/assets/45708630/bcea0dd6-f812-421c-8463-d98bf2ae20f2 width = 50%>
<br>

### 7. Preview 기능 구현
**고민한 점 :** 미리보기 이미지를 어떻게 보여주는 것이 좋을까?

**참고자료 :**
    - [Apple Human Interface Guidelines(Materials)](https://developer.apple.com/design/human-interface-guidelines/materials)
    
**해결 :** 기존에는 이미지와 이전, 닫기, 다음 3개의 버튼이 있는 뷰를 작게 팝업처럼 띄워서 미리보기를 할 수 있게 했었다.
하지만 프로젝트 피드백으로 HIG의 내용과 사용성에 대한 것이 들어왔다.

먼저, 기존의 방식을 사용하면 위에 뷰를 띄우기는 했지만 뒤에 있는 뷰도 터치가 가능한 이상한 방식으로 구동되고 있었다.
그렇다면 이것을 뒷부분 터치를 막을 것인가, 아니면 전체화면으로 만들어야 하는가 고민을 먼저 했다. 작은 팝업으로 띄운 이유는 이용자가 이 책의 미리보기를 보고 있다는 맥락 유지뿐만 아니라 전체 내용 보기가 아닌 미리보기라 잠깐 훑어보는 용도로 생각해서 큰 창으로 보여줄 필요가 없을 것 같다는 생각이었다. 하지만 피드백을 받은 이후 이러한 기능을 제공하는 몇 앱을 살펴보게 되었고 전체화면을 통해 크게 보여줌을 알 수 있었다.
그렇다면 전체화면으로 한다면, 레이아웃은 어떻게 구성하는 것이 좋을까에 대한 고민을 하던 중, 피드백중 하나였던 HIG가 떠올랐다.

HIG Materials에 따르면
**’Translucency can help people retain their context by providing a visible reminder of the content that’s in the background’
‘반투명도는 배경에 있는 콘텐츠를 시각적으로 상기시켜 사람들이 맥락을 유지하는 데 도움이 될 수 있습니다’**

라는 멘트가 있었다. ‘아, 그러면 뷰의 배경에 반투명도를 줘서 이전에 어떤 창에서 넘어온건지 알 수 있게 해주면 되겠다’하는 생각을 하게 되었고, HIG에서 알려준 UIBlurEffect를 적용해보게 되었다.

<br>
<img src = https://github.com/llimental/iOS-BookMoa/assets/45708630/056f5ea8-6c88-428a-b4f6-aa5589a0b2be width = 50%><img src = https://github.com/llimental/iOS-BookMoa/assets/45708630/259c35d0-5a46-4297-87bd-21e5de271918 width = 50%>
<br>

### 8. Gesture의 사용법
**고민한 점 :** 버튼을 통해 이미지를 넘기는 것이 아니라 사진앱에서 하듯이 스와이프 제스처로 이미지를 넘기고 싶은데 제스처는 어떻게 사용해야 하는 것일까?

**참고자료 :**
    - [Apple 공식문서(UIGestureRecognizer)](https://developer.apple.com/documentation/uikit/uigesturerecognizer)
    
**해결 :** 이전에 학습했던 touch Event, Responder Chain이 떠올라 UIGestureRecognizer를 찾아보았다.
UIGestureRecognizer의 서브 클래스는 중에서 스와이프 동작을 사용하기에 적합한 것은 이름 그대로 나타나 있는 UISwipeGestureRecognizer라고 생각하였고 이에 대해 학습해보았다. 공식문서에 따르면, GestureRecognizer는 특정 view 및 모든 subview에 대해 hit test를 거친 touch에서 작동한다고 한다. 따라서 해당 view와 연결을 해야 하고, 그러기 위해서는 UIView의 메서드인 addGestureRecognizer(_:)를 호출해야 한다고 한다. 또한 이는 **view의 responder chain에 참여하지 않는다**고 한다.

왜 Gesture Recognizer는 포함되지 않을까? 공식문서에 아래와 같은 내용이 있다.
**Gesture recognizers는 view보다 먼저 터치 및 누르기 이벤트를 수신**한다. view의 Gesture recognizers가 일련의 터치를 인식하지 못하면 UIKit이 터치를 View로 보낸다. **view가 터치를 처리하지 않으면 UIKit은 Responder chain 위로 터치를 전달**한다.
즉 **Gesture recognizer는 view보다 앞서 터치 이벤트를 수신하기 때문에 Responder Chain에 포함되지 않는 것**이고, 여기서 터치 이벤트를 처리하지 못하면 view로 전달, view도 안되면 위의 그림과 같이 chain에 따라 처리할 객체를 찾게 되는 것이다.

그러면, SwipeGestureRecognizer란 무엇일까? **하나 이상의 방향으로 밀기 제스처를 해석하는 불연속 제스처 인식기**로 사용자가 허용 가능한 방향으로 지정된 터치를 이동할 때 스와이프를 인식한다. **스와이프는 별개의 제스처이므로 시스템은 제스처당 한 번만 연결된 작업 메시지**를 보낸다. UISwipeGestureRecognizer 클래스를 사용하여 스와이프 제스처를 감지하고 view의 addGestureRecognizer(_:) 메서드를 호출한다. 이는 화면에서 가로 또는 세로로 사람의 손가락 동작을 추적한다. 이 제스처는 별개이므로 **동작 메서드는 제스처가 성공적으로 종료된 후에만 호출**되고 결과적으로 **스와이프는 사람의 손가락 움직임을 추적하지 않고 제스처의 결과에만 신경을 쓸 때 가장 적합**하다고 한다.

즉, 이 프로젝트에서 터치를 어떤 식으로 하든 그 과정보다 왼쪽으로 했는지, 오른쪽으로 했는지 여부가 중요하기 때문에 적합하다고 볼 수 있다.

<br>
<img src = https://github.com/llimental/iOS-BookMoa/assets/45708630/f640c326-5b51-4841-ada3-e513fb5b7fa4>
<img src = https://github.com/llimental/iOS-BookMoa/assets/45708630/8a13b686-fe5b-4610-ac0e-495a0a9425bb>
<img src = https://github.com/llimental/iOS-BookMoa/assets/45708630/a7073953-5234-48c5-b7a0-e25d478cb761>
<br>

### 9. addArrangedSubview란?
**고민한 점 :** addArrangedSubview를 했을 때 레이아웃을 어떻게 addSubview했을 때처럼 할 수 있을까?

**참고자료 :** **Xcode lldb**
    
**해결 :** 처음에는 UIView에는 addSubview, StackView에는 addArrangedSubview를 쓰며, 전자는 translatesAutoresizingMaskIntoConstraints를 false를 주어 레이아웃 제약을 직접 주는 반면, 후자는 arranged 방식을(axis, alignment, distribution) 줌으로써 제약을 따로 주지 않는 방식이라고 생각했다.

**addArrangedSubview도 제약을 줄 수 있다**는 것을 부트 캠프 학습 도우미 덕분에 알게 되었지만, 그래도 이해가 가지 않는 점이 있었다. 둘 다 제약을 직접 줄 수 있으면 arrangedSubview도 translates를 false처리 해줘야 할거고, 그렇다면 똑같이 코드가 많아지고 지저분해질텐데 **굳이 이걸 쓰는 장점이 있을까?** 하는 것이었다.

하지만 공식문서와 블로그에는 관련한 정보가 없었고, stackoverflow에도 예전 자료로 **addArrangedSubview는 기본으로 해당 속성이 false 처리된다**는 말이 **근거가 달리지 않은 채** 있었다.

해답을 얻기 위해 **lldb를 통해 addSubview 할 때와 addArrangedSubview를 할 때 프로퍼티의 해당 속성을 찍어**보았고, stackoverflow에서의 말이 맞음을 알 수 있었다.
이를 통해 addArrangedSubview는 물론 lldb의 사용법에 대해서도 좀 더 알게 되었다.

<br>
<img src = https://github.com/llimental/iOS-BookMoa/assets/45708630/55246456-8ab0-4e60-afc8-24cf4e5d73cc>
<br>

### 10. 큰 화면을 가진 기기 대응
**고민한 점 :** 타겟 시뮬레이터 말고 더 작거나 큰 기기에서의 레이아웃 대응을 하기 위해서는 어떻게 해야할까?

**참고자료 :** [Apple 공식문서(NSCollectionLayoutEnvironment)](https://developer.apple.com/documentation/uikit/nscollectionlayoutenvironment)
    
**해결 :** 기존에는 CollectionView의 Layout을 구성할 때 groupSize를 absolute나 estimated로 직접 값을 할당하였는데, **기기 사이즈에 맞게 동적**으로 주고 싶었다.
관련하여 검색하다 보니 공통적으로 layoutEnvironment라는 키워드가 나왔고, collectionViewLayout을 만들 때 사용하는 layoutEnvironment를 활용할 수 있는 방법을 애플 문서에서 찾게 되었다.

**NSCollectionLayoutEnvironment는 레이아웃의 컨테이너 및 환경 특성**(예: 크기 클래스 및 디스플레이 배율 인수)에 대한 정보를 제공하는 데 사용되는 프로토콜이다.

하위 속성에 있는 **traitCollection에 보면 horizontalSizeClass, verticalSizeClass를 통해 사이즈 정보**를 얻을 수 있고, 그 속성으로 **compact**와 **regular**를 사용할 수 있었다. 그러나 이 둘의 기준이 무엇인지는 알 수 없었다.

**공식문서 UITraitCollection에서 답을 얻을 수 있었다. 아이폰이 세워져 있을 때 가로 사이즈, 눕혀져 있을 때 가로/세로 사이즈는 Compact, 아이패드에서는 세로/가로 사이즈가 모두 Regular**였다. 하지만 아이폰도 SE부터 Max까지 다양하기에 **lldb를 활용**해보기로 했다. 실제 결과는 **iPhone Pro Max의 경우 눕혔을 때 가로 사이즈가 Regular**로 들어가는 것을 확인할 수 있었다.

<br>

**[공식문서 제공 이미지]**
<img src = https://github.com/llimental/iOS-BookMoa/assets/45708630/6586e68b-ef3b-4222-bb8e-3a437764dfe2>
<br>
**[iPhone 14 Pro lldb]**
<img src = https://github.com/llimental/iOS-BookMoa/assets/45708630/1bbf8fd0-e697-47d4-be86-a90a2ac107f0>
<img src = https://github.com/llimental/iOS-BookMoa/assets/45708630/531f526e-bcb9-46bd-bb6d-5787407f9e3d>
<br><br>
**[iPhone 14 Pro Max lldb]**
<img src = https://github.com/llimental/iOS-BookMoa/assets/45708630/3384601e-cdfd-41e2-b655-dc5a2b930cb1>
<img src = https://github.com/llimental/iOS-BookMoa/assets/45708630/af4cba4d-8c9c-4b21-956c-184dbd65920f>
<br>

## 🙋🏻 추후 계획

- 코드 리팩터링을 통한 컨벤션 실수 교정
- 동일한 구성을 가진 ViewController의 객체명 분리
- AutoLayout 정리
- UserDefaults 대신 CoreData 사용
- 검색창 로직 변경
- README 추가 정리
