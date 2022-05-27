[![Actions Status](https://github.com/raku-community-modules/XML-Entity-HTML/actions/workflows/test.yml/badge.svg)](https://github.com/raku-community-modules/XML-Entity-HTML/actions)

NAME
====

XML::Entity::HTML - Extension of XML::Entity for (X)HTML 5 entities.

SYNOPSIS
========

```raku
use XML::Entity::HTML;

my $xeh = XML::Entity::HTML.new;
say $xeh.decode: 'Text with &lt;entities&gt; &amp; &laquo;more&raquo;';
# Text with <entities> & «more»

say $xeh.encode: 'Text with <entities> & «more»';
# Text with &lt;entities&gt; &amp; &laquo;more&raquo;

say decode-html-entities 'Text with &lt;entities&gt; &amp; &laquo;more&raquo;';
# Text with <entities> & «more»

say encode-html-entities 'Text with <entities> & «more»';
# Text with &lt;entities&gt; &amp; &laquo;more&raquo;
```

DESCRIPTION
===========

It's simply an extension class of XML::Entity, but with a lot more entities taken from the [official JSON list](https://www.w3.org/TR/html5/entities.json).

Any entities that wouldn't compile properly have been blacklisted and aren't supported. See the `build.raku` script in the `build` directory on how this module is built.

METHODS
=======

decode
------

Overrides the `XML::Entity.decode` method. Expects a string and an optional named argument `:numeric`.

encode
------

Overrides the `XML::Entity.encode` method. Expects a string and an optional named argument `:hex`.

EXPORTED SUBROUTINES
====================

decode-html-entities
--------------------

Provides procedural access to the `decode` method on a singleton `XML::Entity::HTML` object. Takes the same parameters.

encode-html-entities
--------------------

Provides procedural access to the `encode` method on a singleton `XML::Entity::HTML` object. Takes the same parameters.

AUTHOR
======

Timothy Totten

COPYRIGHT AND LICENSE
=====================

Copyright 2019 Timothy Totten

Copyright 2020 - 2022 Raku Community

This library is free software; you can redistribute it and/or modify it under the Artistic License 2.0.

