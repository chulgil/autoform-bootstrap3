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
  
   