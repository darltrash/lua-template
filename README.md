lua-template
============

The simplest Lua HTML template engine in just a few lines of code, now for Luvit!

Installation
------------

`lit install darltrash/template`

Compiling templates
-------------------
Templates can be compiled by either running

`template template.tpl -o template.lua`

nor by passing a string to  `template.compile`.

Syntax
------
In short, Lua expressions must be included between percent signs and Lua statements must be placed beetween question marks.

### Variables and expressions
```html
<a href="page-<%page + 2%>"><%next%></a>
```

### Variables and expressions without HTML escaping
```html
<body><%= content%></body>
```

### Loops
```html
<ul>
<? for i = 1, 3 do ?>
  <li>item #<%i%></li>
<? end ?>
</ul>
```

### Conditional
```html
<? if 1 > 2 then ?>
Impossible!
<? else ?>
That's right!
<? end ?>
```

### Template inclusion
Templates are compiled to a general Lua file and hence can be loaded by `require` statement:
```html
<html>
  <script><%= require "scripts" %></script>
  <style><%= require "styles" %></style>
</html>
```

Evaluating templates
--------------------
`template.print` takes three arguments: template function, a table with variables passed to the template and optionally a callback function, which handles string printing (`print` is used by default).

Compressing templates
---------------------
`template.compile` has an optional `minify` argument and `template` has `-m` option.

### Credits
Original by Danila Poyarkov! [Thank you!](https://github.com/dannote/lua-template)
