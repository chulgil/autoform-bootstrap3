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



사용방법 :
  1. autoform-bootstrap3를 다운로드 받습니다.
  2. html파일에 /lib/form_generator.js를 include합니다.
  3. html파일에 자동생성할 폼태그를 입력합니다.



주의사항 :
  1. Jquery가 import되어 있어야 합니다.
    <script src="https://ajax.googleapis.com/ajax/libs/jquery/1.11.1/jquery.min.js"></script>
  2. bootstrap3 css/js가 import되어 있어야 합니다.
    <script src="https://cdnjs.cloudflare.com/ajax/libs/bootstrap-select/1.3.5/bootstrap-select.min.js"></script>
    <script src="http://ajax.aspnetcdn.com/ajax/jquery.validate/1.13.0/jquery.validate.min.js"></script>
  3. Jquery Validator가 import되어 있어야 합니다.
    <script src="http://ajax.aspnetcdn.com/ajax/jquery.validate/1.13.0/jquery.validate.min.js"></script>



## Table of Contents
<!-- START doctoc generated TOC please keep comment here to allow auto update -->
<!-- DON'T EDIT THIS SECTION, INSTEAD RE-RUN doctoc TO UPDATE -->
**Table of Contents**  *generated with [DocToc](http://doctoc.herokuapp.com/)*

- [기본폼정의](#기본폼정의)
- [Installation](#installation)
- [Example](#example)
  - [A Basic Insert Form](#a-basic-insert-form)
  - [A Basic Update Form](#a-basic-update-form)
  - [A Basic Remove Form](#a-basic-remove-form)
  - [A Custom Insert Form](#a-custom-insert-form)
  - [Another Custom Insert Form](#another-custom-insert-form)
- [Component and Helper Reference](#component-and-helper-reference)
  - [autoForm](#autoform)
  - [quickForm](#quickform)
  - [afFieldInput](#affieldinput)
  - [afFieldSelect](#affieldselect)
  - [afFieldLabel](#affieldlabel)


<!-- END doctoc generated TOC please keep comment here to allow auto update -->




## 기본폼정의

If you've been using AutoForm and are now switching to the Blaze rendering engine, here's what you need to know to transition your app:

* Add "> " before every afQuickField, afFieldInput, afFieldLabel, and quickForm.
* Use `..` whereever you formerly used `../this`.
* When specifying the field name for any component or helper, add `name=`. For example, `{{afFieldMessage name="name"}}` rather than `{{afFieldMessage "name"}}`.
* Instead of using a submit button class to determine form behavior, use a `type` attribute on the `autoForm` component.
* Instead of using a submit button `data-meteor-method` attribute to identify the method name, use a `meteormethod` attribute on the `autoForm` or `quickForm` component.
* The components (any that you use `>` before) no longer require an `autoform` attribute when used within an `#each` or `#with` block. The helpers *do* still require the `autoform` attribute that references the `autoForm` context.
* There is no `AutoForm` instance. [How to add hooks.](#callbackshooks) There is also now support for global hooks and multiple hooks of the same type per form. (Adding hooks multiple times will extend the list of hooks rather than overwriting the previous hook.)
* Again, there is no `AutoForm` instance. The `autoForm` component can take a `schema` attribute that supplies a `SimpleSchema` instance or a `collection` attribute that supplies a `Meteor.Collection` instance with an attached schema. You can also specify both attributes, in which case form generation and validation will be based on the schema, but insert/update (and final validation) will happen on the collection. In this way, you can use slightly different validation logic or add additional constraints to a form that are not actual constraints on the collection's schema.
* New `afFieldSelect` block component that supports optgroups. [Read about it.](#affieldselect)
* Read about [choosing and customizing templates](#templates).
* Experimental support for array fields, including arrays of objects with add/remove buttons. Documentation coming soon.
* You may find the new [Common Questions](#common-questions) section helpful.

## Installation

Install using Meteorite. When in a Meteorite-managed app directory, enter:

```
$ mrt add autoform
```

## Example

Let's say you have the following Meteor.Collection instance, with schema support
provided by the collection2 package. (Adding `autoform` to your app does not add
`collection2` by default so you need to run `mrt add collection2` for this example
to work.)

```js
Books = new Meteor.Collection("books", {
    schema: {
        title: {
            type: String,
            label: "Title",
            max: 200
        },
        author: {
            type: String,
            label: "Author"
        },
        copies: {
            type: Number,
            label: "Number of copies",
            min: 0
        },
        lastCheckedOut: {
            type: Date,
            label: "Last date this book was checked out",
            optional: true
        },
        summary: {
            type: String,
            label: "Brief summary",
            optional: true,
            max: 1000
        }
    }
});
```

### A Basic Insert Form

```html
<template name="insertBookForm">
  {{> quickForm collection="Books" id="insertBookForm" type="insert"}}
</template>
```

That's it! This gives you:

* An autogenerated form that uses bootstrap3 classes.
* Appropriate HTML5 fields for all keys in the "Books" collection schema.
* A submit button that gathers the entered values and inserts them into
the "Books" collection.
* Form validation based on the "Books" collection schema. By default the form
is validated when the user submits. If anything is invalid, the form is
continually re-validated on keyup (throttled) as the user fixes the issues.
* Default validation error messages that appear under the fields, and can be
customized and translated.

### A Basic Update Form

An update form is similar to an insert form, except you need to provide the
document with the original values to be updated:

```html
<template name="updateBookForm">
  {{> quickForm collection="Books" doc=editingDoc id="updateBookForm" type="update"}}
</template>
```

And the helper:

```js
Template.updateBookForm.editingDoc = function () {
  return Books.findOne({_id: Session.get("selectedDocId")});
};
```

### A Basic Remove Form

It's possible to use a "remove" type, too, but usually you just want a single button
for removing, so there is a special template you can use to get that:

```html
{{> afDeleteButton collection="Books" doc=editingDoc}}
```

Where the `editingDoc` helper is the same as in the update form example.

When used this way, the content of the delete button will be the word "Delete". If you want to
get fancy, you can instead use `afDeleteButton` as a block helper and provide your own button
content:

```html
{{#afDeleteButton collection="Books" doc=editingDoc}}
<span style="color: yellow">DELETE ME!!</span>
{{/afDeleteButton}}
```

To show a confirmation dialog before deleting, add an `id` attribute to the `afDeleteButton` and define a "before remove" hook for that form ID.

### A Custom Insert Form

If you want to customize autogenerated forms for *all* forms, you can easily
do so by writing your own templates. Refer to the templates section. However,
sometimes a certain form has a complex schema or unique UI requirements, in
which case you can use `autoForm` rather than `quickForm`, allowing you to
define fields individually.

Here's an example:

```html
<template name="insertBookForm">
    {{#autoForm collection="Books" id="insertBookForm" type="insert"}}
    <fieldset>
        <legend>Add a Book</legend>
        {{> afQuickField name='title'}}
        {{> afQuickField name='author'}}
        {{> afQuickField name='summary' rows=6}}
        {{> afQuickField name='copies'}}
        {{> afQuickField name='lastCheckedOut'}}
    </fieldset>
    <button type="submit" class="btn btn-primary">Insert</button>
    {{/autoForm}}
</template>
```

In this example, we added `rows=6` to the "summary" field, which will cause it
to be rendered as a `textarea` instead of a normal text input field.

### Another Custom Insert Form

In the previous example of a custom insert form, we saw how `afQuickField` can
be used to render a field with simple customizations. Now let's say we need to
fully customize one of the fields. To do this, you can use the following more
specific templates and helpers:

* afFieldIsInvalid
* afFieldLabel
* afFieldInput
* afFieldSelect
* afFieldMessage

Here's an example:

```html
<template name="insertBookForm">
  {{#autoForm collection="Books" id="insertBookForm" type="insert"}}
  <fieldset>
    <legend>Add a Book</legend>
    {{> afQuickField name='title'}}
    {{> afQuickField name='author'}}
    {{> afQuickField name='summary' rows=6}}
    {{> afQuickField name='copies'}}
    {{> afQuickField name='lastCheckedOut'}}
    <div class="form-group {{#if afFieldIsInvalid name='cost'}}has-error{{/if}}">
      <div class="input-group">
        <span class="input-group-addon">$</span>
        {{> afFieldInput name='cost'}}
        <span class="input-group-addon">/each</span>
      </div>
      {{#if afFieldIsInvalid 'cost'}}
      <span class="help-block">{{afFieldMessage 'cost'}}</span>
      {{/if}}
    </div>
  </fieldset>
  <button type="submit" class="btn btn-primary">Insert</button>
  {{/autoForm}}
</template>
```
