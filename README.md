AutoForm for Bootstrap3
=========================


간단한 HTML TAG 만으로 부트스트랩3 의 입력폼을 자동생성합니다.

셈플페이지 : http://vncodenavi.kissr.com/

 1.폼 디자인을 수정해야 하는 수고를 덜어줍니다.

 2.복수의 입력박스를 작성해야 하는 수고를 덜어줍니다.

   예) SELECT , CHECK, RADIO의 옵션등

 3.Javascript로 이벤트를 제어해야 하는 수고를 덜어줍니다.

   예) SELECT BOX 디폴트 값, 옵션 선택시 이벤트

 4.폼체크 기능을 자동으로 생성합니다.

   Jquery-validate의 체크사양참조 http://jqueryvalidation.org/




## Table of Contents
<!-- START doctoc generated TOC please keep comment here to allow auto update -->
<!-- DON'T EDIT THIS SECTION, INSTEAD RE-RUN doctoc TO UPDATE -->
**Table of Contents**  *generated with [DocToc](http://doctoc.herokuapp.com/)*

- [사용 방법](#사용방법)
- [주의 사항](#주의사항)
- [기본폼 정의](#기본폼정의)
- [TYPE의 종류](#Type의종류)
- [폼체크 종류](#폼체크종류)
- [셈플](#셈플)


<!-- END doctoc generated TOC please keep comment here to allow auto update -->


## 사용방법
  1. autoform-bootstrap3를 다운로드 받습니다.
  2. html파일에 /lib/form_generator.js를 include합니다.
  3. html파일에 자동생성할 폼태그를 입력합니다.
```html
<script src="lib/form_generator.js"></script>
<form>
    <div class="ec-auto-form" title="기본정보">
    <h6>입력항목1</h6>
    <p type="text" id="pid" val="" rules="req:true" hint="필수정보를 입력하세요."></p>
    </div>
</form>
```

## 주의사항
  1. Jquery가 import되어 있어야 합니다.
  2. bootstrap3 css/js가 import되어 있어야 합니다.
  3. Jquery Validator가 import되어 있어야 합니다.

```html
    <script src="https://ajax.googleapis.com/ajax/libs/jquery/1.11.1/jquery.min.js"></script>
    <script src="https://cdnjs.cloudflare.com/ajax/libs/bootstrap-select/1.3.5/bootstrap-select.min.js"></script>
    <script src="http://ajax.aspnetcdn.com/ajax/jquery.validate/1.13.0/jquery.validate.min.js"></script>
```


## 기본폼정의
  1.기본적으로 form태그 안에 정의합니다.
  2.기본 폼 클래스인 ec-auto-form와 폼 타이틀을 정의합니다.
  3.항목생성 태그를 정의함으로서 폼이 생성됩니다.<p type=""></p>
```html
    <form>
        <div class="ec-auto-form" title="기본정보">
        <h6>입력항목1</h6>
        <p type="text" id="pid" val="" rules="req:true" hint="필수정보를 입력하세요."></p>
        </div>
    </form>
```

## Type의종류
  
  각 OPTION은 JSON형식으로 지정합니다.
  일반텍스트의 경우는 "키:값,키:값" 으로도 설정가능합니다.
  
  1.INPUT TEXT :
```html
    <p type="text" id="" val="" hint="필수정보를 입력하세요."></p>
```

  2.SELECT BOX :
    
```html
    <p type="select" id="" val="" option='{"":"선택해주세요","01":"아이템1","02":"아이템2","03":"아이템3"}'></p>
```

  3.CHECK BOX :
```html
    <p type="check" id="" val="" option='{"":"선택해주세요","01":"아이템1","02":"아이템2","03":"아이템3"}'></p>
```

  4.RADIO BOX :
```html
    <p type="radio" id="" val="" option='{"":"선택해주세요","01":"아이템1","02":"아이템2","03":"아이템3"}'></p>
```

## 폼체크종류

  ※Jquery-validate의 체크사양참조 http://jqueryvalidation.org/
```html
    <!-- 필수체크 -->
    <p type="text" id="" val="" rules="req:true"'></p>
    <!-- url체크 -->
    <p type="text" id="" val="" rules="type:url"'></p>    
    <!-- 10자 이하 -->
    <p type="text" id="" val="" rules="max:10"'></p>
    <!-- 2자 이상 -->
    <p type="text" id="" val="" rules="max:2"'></p>            
```
  
## 셈플
```html
<div class="ec-auto-form" title="기본정보">
    <h6>필수 타입 <span class="red">【필수】</span></h6>
    <p type="text" id="pid" val="" rules="req:true" hint="필수정보를 입력하세요."></p>
    <h6>코드 타입 <span class="red">【필수】</span> (영숫자 32자 이내)</h6>
    <p type="text" id="pid1" val="" rules="type:code,req:true,max:32" hint="(예) 001-123、apple_01-b"></p>
    <h6>문자열 타입 (문자 100자 이내) </h6>
    <p type="text" id="pid2" val="\" rules="max:100" hint="상품명을 입력해주세요."></p>
    <h6>가격 타입 <span class="red">【필수】</span> (숫자 9자 이내) </h6>
    <p type="text" id="pid3" val="" mark="₩" rules="type:num,req:true,max:9" hint=""></p>
    <h6>날짜 타입</h6><p type="text" id="pid4" val="" rules="type:date"></p>
    <h6>숫자 타입 (10이상 100이하)</h6><p type="text" id="pid5" val="" rules="type:dig,min:10,max:100"></p>
    <h6>셀렉트 박스</h6>
    <p id="pid6" type="select" val="" rules="req:true"
        option='{"":"선택해주세요","001":"셀렉트아이템1","002":"셀렉트아이템2","003":"셀렉트아이템3"}'></p>
    <h6>셀렉트 박스 디폴트지정</h6><p id="pid6_1" type="select" val="" default="001"
        option='{"":"선택해주세요","001":"셀렉트아이템1 디폴트","002":"셀렉트아이템2","003":"셀렉트아이템3"}'></p>
    <h6>라디오 박스 </h6><p id="pid7" type="radio" val=""
        option='{"001":"라디오아이템1","002":"라디오아이템2","003":"라디오아이템3","004":"라디오아이템4"}'></p>
    <h6>라디오 박스 디폴트지정</h6><p id="pid7_1" type="radio" val="" default="002"
        option='{"001":"라디오아이템1","002":"라디오아이템2 디폴트","003":"라디오아이템3","004":"라디오아이템4"}'></p>
    <h6>라디오 박스 <span class="red">【필수】</span></h6><p id="pid7_2" type="radio" val="" rules="req:true"
        option='{"001":"라디오아이템1","002":"라디오아이템2","003":"라디오아이템3"}'></p>
    <h6>체크 박스</h6><p id="pid8" type="check"  val="" default="001"
        option='{"001":"체크아이템1","002":"체크아이템2","003":"체크아이템3","004":"체크아이템4"}'></p>
    <h6>체크 박스 디폴트지정</h6><p id="pid8_1" type="check"  val="" default="003,001"
        option='{"001":"체크아이템1 디폴트","002":"체크아이템2","003":"체크아이템3 디폴트","004":"체크아이템4"}'></p>
    <h6>체크 박스  <span class="red">【필수】</span></h6><p id="pid8_2" type="check"  val="" rules="req:true"
        option='{"001":"체크아이템1","002":"체크아이템2","003":"체크아이템3 디폴트"}'></p>
</div>
```
