# -------------------------------------------------------------------------- #
# PROGRAM NAME	: form-generator.coffee
# COMPANY   		: Nemocommerce,Inc
# AUTHOR		    : vncodenavi@gmail.com
# DATE			    : 2014.07.21
# DESCRIPTION	  : ECTENCHO FORM GENERATOR LIBRARY
# VENDOR LIB    : jquery-validator http://jqueryvalidation.org/
# -------------------------------------------------------------------------- #

# Jquery Start
$ ->
  # console.log "DOM is ready!!!"
  settings = {} #체크폼 데이터 초기화

  # ------------------------------------------------------------ #
  # 1. 타입별 폼생성
  # ------------------------------------------------------------ #
  $ec_input_form = $("div.ec-auto-form")
  for form in $ec_input_form

    mkFactory = new MakeFormFactory(form)
    # MakeInputBox 그룹전체 폼생성
    mkFactory.makeRowForm("span")
    # MakeInputBox 각 행의 입력폼 생성
    mkFactory.makeItemForm("p")
    if add=mkFactory.getCheckRules()
      # 오브젝트 합치기
      settings = $.extend({}, settings,add)
      #console.log settings
    $(form).removeClass("ec-auto-form")

  # ------------------------------------------------------------ #
  # 2. 폼 체크 자동생성 : http://jqueryvalidation.org/
  # ------------------------------------------------------------ #
  $("#form1").validate
    rules : settings
    highlight: (element) ->
      $(element).closest(".form-check-item").addClass "has-error"
      if $(element).attr("class") is "bootstrap-drop hide"
        $(element).closest(".dropdown").find("button").attr("style","color:#933132")
    unhighlight: (element) ->
      $(element).closest(".form-check-item").removeClass "has-error"
      if $(element).attr("class") is "bootstrap-drop hide"
        $(element).closest(".dropdown").find("button").removeAttr "style"
    errorElement: "span"
    errorClass: "help-block"
    errorPlacement: (error, element) -> # 에러메세지 출력장소 지정
      # 복수 입력박스 그룹인경우
      if element.parents(".form-inline").length
        error.insertAfter element.parents(".form-inline")[0]
      # 입력박스 그룹인경우
      else if element.parent(".input-group").length
        error.insertAfter element.parent()
      # 입력박스 하나인경우
      else
        error.insertAfter element
    invalidHandler : (error,element) ->
      console.log "dsf"
      if element.numberOfInvalids() # 에러체크가 있는경우
        obj=element.errorList[0].element
        # Bootstrap3버튼일 경우
        if $(obj).attr("class") is "bootstrap-drop hide"
          # DROP 박스의 버튼을 포커스로 지정
          $(obj).closest(".dropdown").find("button").focus()

    submitHandler: (form) ->
      return form



  # ------------------------------------------------------------ #
  # 3. 폼 체크 룰 추가
  # ------------------------------------------------------------ #
  $.validator.addMethod "ec_code", ((value) ->
    if value.match /[^A-Za-z0-9_-]/g
      return false
    else
      return true
  ), "영숫자를 입력하세요.(_-포함가능)"

  # ------------------------------------------------------------ #
  # 4. Bootstrap3 DropdownBox(SelectBox) 이벤트룰 자동 설정
  # ------------------------------------------------------------ #
  $ec_input_form.on "click", ".dropdown-menu li", (event) ->
    $target = $(event.currentTarget)
    # 선택한 리스트를 버튼 텍스트로 설정후 토글
    $target.closest(".dropdown").find("[data-bind=\"label\"]")
      .text($target.text())
      .end()
      .children(".dropdown-toggle").dropdown "toggle"

    # 선택한 커스텀 셀렉트박스 키를 POST로 넘길 입력값으로 설정
    $target.closest(".dropdown").find("input").val $target.attr("key")
    $target.closest(".dropdown").find("input").focusout()




# ------------------------------------------------------------ #
# MakeInputBox 타입별 폼생성  (Bootstrap3정의)
# ------------------------------------------------------------ #
class MakeInputBox

  constructor: (obj)->
    item = obj
    @FormUtil = new FormUtil()
    @type=""
    @id=""
    @val=""
    @size=""
    @option=""
    @default=""
    @hint=""
    @target=""
    @mark=""
    @rows=""
    @src=""
    @alt=""
    @type=val if val=item.attr("type")
    @id=val if val=item.attr("id")
    @val=val if val=item.attr("val")
    @size=val if val=item.attr("size")
#    @val.replace /([\\"'])/g, "\\$1"
#    @val.replace /\0/g, "\\0"
    @default=val if val=item.attr("default")
    @hint=val if val=item.attr("hint")
    @target=val if val=item.attr("target")
    # JSON형식 또는 TEXT: option='{"1":"셀렉트아이템1","2":"셀렉트아이템1","3":"셀렉트아이템1"}'
    @option=val if val=item.attr("option")
    @mark=val if val=item.attr("mark")
    @rows=val if val=item.attr("rows")
    @src=val if val=item.attr("src")
    @alt=val if val=item.attr("alt")
    @_checkPram(item)

  # ------------------------------------------------------------ #
  # 파라미터 체크 : 인풋박스 생성을 위한 체크
  # ------------------------------------------------------------ #
  _checkPram:(pram) ->
    try
      tag = pram.context.outerHTML
      throw 'INPUTBOX를 생성할 TYPE이 지정되지 않았습니다.'+tag unless @type
      throw 'INPUTBOX를 생성할 ID가 지정되지 않았습니다.'+tag unless @id
      return false if @type is "validator" # 폼체크 타입은 무시한다.
      if @type is "select" or @type is "radio" or @type is "check"
        throw @type+' BOX를 생성할 OPTION이 지정되지 않았습니다.' unless @option
        @option = @FormUtil.convJSON(@option) # Json형태 오브젝트로 변환
        throw @type+' BOX OPTION의 JSON형식에 오브젝트배열이 있습니다. :' if typeof @selected is 'object'
      if @type is "check" #체크박스 복수선택시
        @checked = @FormUtil.convJSON(@default) if @default # Json형태 오브젝트로 변환
        @checked = @FormUtil.convJSON(@val) if @val # Json형태 오브젝트로 변환

    catch e
      throw '자동완성입력폼 TAG : '+e.toString()

  # ------------------------------------------------------------ #
  # TEXT박스 정의
  # ------------------------------------------------------------ #
  getTextBox:() ->

    tag = ''
    tag += '<input id="'+@id+'" name="'+@id+'" value="'+@val+'" type="text" '
    tag += ' size="'+@size+'"' if @size
    tag += ' class="form-control" placeholder="'+@hint+'" >'

    if @mark
      tag = '<span class="input-group-addon">'+@mark+'</span>'+tag
      tag = '<div class="input-group input-group-sm">'+tag+'</div>'
    else
      tag = '<div class="input-group-sm">'+tag+'</div>'
    return tag

  # ------------------------------------------------------------ #
  # 셀렉트박스 정의 (Bootstrap3 Dropbox정의)
  #  Bootstrap3에서는 셀렉트박스의 css가 각 브라우져호환성저하로 Dropdown추천
  #  데이터는 Input hidden으로 처리
  # ------------------------------------------------------------ #
  #<div class="dropdown">
  #  <button class="btn btn-default btn-sm dropdown-toggle" type="button" data-toggle="dropdown">
  #    二重価格文言を選択してください。<span class="caret"></span>
  #  </button>
  #  <ul class="dropdown-menu" >
  #    <li><a href="#">当店普通価格</a></li>
  #    <li><a href="#">メーカー希望小売価格</a></li>
  #    <li><a href="#">自動選択</a></li>
  #  </ul>
  #</div>
  getDropDownBox:() ->
    tag = ''
    opt = ''
    selected_key='' #옵션의 첫번째 키는 공백으로 간주한다.
    selected_text=@selected #옵션의 첫번째 배열 [초기설정 고정]

    if @val # 디비에 값이 있는 경우 :
      selected_key = @val
    else # 기본폼에 디폴트 값이 있는경우 :
      selected_key = @default
      selected_text = @option[selected_key]

    for key, val of @option
      opt += '<li key="'+key+'"><a href="#0">'+val+'</a></li>'
      # console.log key + ':'+val
    # 셀렉트박스 태그지정
    tag += '<div class="dropdown">'
    tag += '<button class="btn btn-default btn-sm dropdown-toggle " type="button" data-toggle="dropdown">'
    tag += '<span data-bind="label">'+selected_text+'</span><span class="caret"></span></button>'
    tag += '<ul class="dropdown-menu" role="menu">'+opt+'</ul>'
    tag += '<input type="text" id="'+@id+'" class="bootstrap-drop hide" name="'+@id+'" value="'+selected_key+'"/></div>'
    tag = '<div class="form-group"><div class="input-group input-group-sm" >'+tag+'</div></div>'

  # ------------------------------------------------------------ #
  # SELECT박스 정의 (bootstrap-select정의)
  # url : http://silviomoreto.github.io/bootstrap-select/3/
  # ------------------------------------------------------------ #
  getSelectBox:() ->
    opt = ''
    for key, val of @option
      opt += '<option value="'+key+'">'+val+'</option>'
    tag = '<select class="selectpicker" id="'+@id+'" name="'+@id+'">'+opt+'</select>'
    return tag

  # ------------------------------------------------------------ #
  # RADIO박스 정의 (Bootstrap3정의)
  # ------------------------------------------------------------ #
  getRadioBox:() ->
    tag = ''
    checked_key = ''
    checked_key = @default if @default # 기본폼에 디폴트 값이 있는경우
    checked_key = @val if @val # 디비에 값이 있는경우

    for key, val of @option
      checked = ''
      checked = 'checked' if key is checked_key
      key = @id+'-'+key if key
      tag +=' <div class="form-group"><div class="input-group input-group-sm">'
      tag +='  <span class="input-group-addon"><input type="radio" name="'+@id+'" '+checked+'></span>'
      tag +='  <span class="form-control" key="'+key+'">'+val+'</span>'
      tag +='</div></div>'
    tag = '<div class="form-inline">'+tag+'</div>'
    return tag

  # ------------------------------------------------------------ #
  # CHECK박스 정의 (Bootstrap3정의)
  # ------------------------------------------------------------ #
  getCheckBox:() ->
    tag = ''
    for key, val of @option
      # 체크된 값이 있는경우
      _checked = ''
      if @checked
        #findKeys = @checked.filter (x) -> x is key
        #_checked='checked' if findKeys[0]
        for row,item of @checked
          _checked='checked' if item is key

      tag +=' <div class="form-group"><div class="input-group input-group-sm">'
      tag +='  <span class="input-group-addon"><input type="checkbox" name="'+@id+'" '+_checked+'></span>'
      tag +='  <span class="form-control">'+val+'</span>'
      tag +='</div></div>'
    tag = '<div class="form-inline">'+tag+'</div>'
    return tag

  # ------------------------------------------------------------ #
  # TEXTAREA 박스 정의 (Bootstrap3정의)
  # ------------------------------------------------------------ #
  getTextarea:() ->
    tag = '<textarea class="form-control input-sm" rows="'+@rows+'" placeholder="'+@hint+'">'+@val+'</textarea>'
    return tag

  # ------------------------------------------------------------ #
  # 썸네일 박스 정의 (Bootstrap3정의)
  # ------------------------------------------------------------ #
  getThumbnail:() ->
    tag = ''
    tag +=' <a href="#" class="thumbnail">'
    tag +=' <img src="'+@src+'" alt="'+@alt+'" class="img-thumbnail"></a>'
    tag = '<div class="col-xs-2 col-md-2" style="margin-right: -20px; margin-bottom:-22px">'+tag+'</div>'
    return tag


  # ------------------------------------------------------------ #
  # 기본입력 박스 생성
  # ------------------------------------------------------------ #
  makeInput:() ->
    switch @type
      when "text" then return @getTextBox()
      when "select" then return @getDropDownBox()
      when "radio" then return @getRadioBox()
      when "check" then return @getCheckBox()
      when "thumbnail" then return @getThumbnail()
      when "textarea" then return @getTextarea()


class MakeFormFactory

  # ------------------------------------------------------------ #
  # 생성자 : Bootstrap3의 기본 입력폼 양식을 생성한다.
  # ------------------------------------------------------------ #
  constructor: (obj)->
    @FormUtil = new FormUtil()
    @form = $(obj)
    form_copy = @form.html()
    @form.html("")
    # EC입력폼의 전체 헤더의 패널설정
    @form.addClass("panel panel-default")
    # EC입력폼의 전체 헤더의 타이틀 설정
    @form.append('<div class="panel-heading">'+@form.attr("title")+'</div>')
    # EC입력폼을 전체 헤더로 감싼다.
    @form.append('<div class="list-group"><li class="list-group-item">'+form_copy+'</li></div>')
    # 체크룰 오브젝트 초기화
    @_validate_rules={}


  # ------------------------------------------------------------ #
  # 각행의 폼 생성 : 입력받은 구분자로 입풋아이템의 폼을 생성한다.
  # ------------------------------------------------------------ #
  makeRowForm: (parseTag) ->
    for row in $(parseTag,@form)
      row = $(row)
      # EC입력폼의 COL(가로)의 그룹을 생성
      # : 사용예) [ 표시가격셀렉트박스 | 표시가격 입력박스 | 가격선택 라디오박스 ]
      row.wrap('<div class="form-inline"><div class="form-check-item"></div></div>') if row.hasClass("ec-form-col")
      # EC입력폼의 ROW(세로)의 그룹을 생성 : 사용예) 이미지 URL/ALT의 폼크기 조절
      row.attr("class","col-xs-10") if row.hasClass("ec-form-row")
      # EC입력폼의 이미지 ROW(세로)의 그룹을 생성 : 사용예) 이미지 그룹
      row.wrap('<div class="row"></div>') if row.hasClass("ec-form-img")

  # ------------------------------------------------------------ #
  # 입력폼 생성 : 입력받은 구분자로 입풋아이템의 폼을 생성한다.
  # ------------------------------------------------------------ #
  makeItemForm: (parseTag) ->
    for row in $(parseTag,@form)
      try
        row = $(row)
        @_makeCheckRules(row)
        mk = new MakeInputBox(row)
        # 입력박스 아이템에 타겟지정이 있는경우 : 해당타겟으로 이동시킨다.
        if target=row.attr("target")
          target_row = $('[key="'+target+'"]')
          target_row.html(mk.makeInput())
          target_row.contents().unwrap()
          # 입력박스 아이템이 COL(세로)그룹지정인 경우 : 각 입력폼을 그룹으로 감싼다.
        else if row.parent().hasClass("ec-form-col")
          row.wrap('<div class="form-group"></div>')
          row.parent().append(mk.makeInput())
          # 일반 입력박스 아이템인 경우 : 입력박스만 생성한다.
        else
          row.wrap('<div class="form-check-item"></div>')
          row.parent().append(mk.makeInput())
#          row.wrap(mk.makeInput())
      # 생선전의 HTML커스텀 입력박스 태그를 삭제한다.
      catch e
        console.error ":"+e
      finally
        row.detach()


  # ------------------------------------------------------------ #
  # 체크데이터의 룰을 생성  : Jquery Validator Roules
  #  입력폼 생성시 받은 옵션데이터로 체크데이터 룰을 생성한다.
  # ------------------------------------------------------------ #
  _makeCheckRules: (obj) ->

    # 체크룰이 없는경우는 종료
    return unless text = obj.attr("rules")

    if check=@FormUtil.convJSON(text) # Json형태 오브젝트로 변환
      # console.log "체크데이터의 룰을 생성  : Jquery Validator Roules"
      rules = {}
      rules['required']=true if x=check.req
      rules['required']=true if x=check.required
      rules['minlength']=x if x=check.minlength
      rules['maxlength']=x if x=check.maxlength
      rules['equalTo']=x if x=check.equalTo
      rules['email']=x if x=check.email
      rules['url']=x if x=check.url
      rules['number']=true if check.type is 'number' or check.type is 'num'
      rules['date']=true if check.type is 'date'
      rules['url']=true if check.type is 'url'
      rules['ec_code']=true if check.type is 'code'
      if check.type is 'digits' or check.type is 'dig'
        rules['digits']=true
        rules['min']=Number x if x=check.min
        rules['max']=Number x if x=check.max
      else
        rules['maxlength']=x if x=check.max
        rules['minlength']=x if x=check.min

      id = obj.attr("id")
      @_validate_rules[id] = rules

  getCheckRules: () ->
    return @_validate_rules



class FormUtil

  # ------------------------------------------------------------ #
  # TEXT를 JSON형식 오브젝트로 변환
  #  1:정식 JSON오브젝트 문자열인 경우 jQuery.parseJSON로 처리
  #  2:TEXT (TEST:1,test:1) 의 경우 구분자(,)(:)로 json 오브젝트형식으로 변환
  #  3:TEXT (TEST1,TEST2) 의 경우 구분자(,)로  배열OBJECT 형식으로 변환
  # ------------------------------------------------------------ #
  convJSON: (text) ->
    return "" unless text # 값이 공백인 경우는 종료
    try
    # 1:정식 JSON오브젝트 문자열인 경우 jQuery.parseJSON로 처리
      obj = JSON.stringify(eval '(' + text + ')')
      return obj if obj=JSON.parse obj

    # 비지니스 로직 예외처리 : Json형식이 아닐경우
    catch e
      json_string = ''
      text = text.replace /[\[\]{}\"\']/g, "" # 특수문자 제거

      # 2:TEXT (TEST:1,test:1) 의 경우 구분자(,)(:)로 json 오브젝트형식으로 변환
      if text.match /:/
        for row, i in text.split ","
          temp = ''
          for item , j in row.split ":"
            temp += ':' if j > 0
            temp += '"'+item+'"'
          json_string += ',' if i > 0
          json_string += temp
        json_string = '{'+json_string+'}'
        obj = JSON.stringify(eval '(' + json_string + ')')
        return JSON.parse obj

      # 3:TEXT (TEST1,TEST2) 의 경우 구분자(,)로 json 배열형식으로 변환
      else
        return text.split ","













# -------------------------------------------------------------------------- #