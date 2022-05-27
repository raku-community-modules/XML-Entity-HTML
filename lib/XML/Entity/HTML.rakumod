use XML::Entity;

#- start of generated part of entities
my str @entityNames;
my str @entityValues;
#- end of generated part of entities

class XML::Entity::HTML is XML::Entity {
    method entityNames()  { @entityNames  }
    method entityValues() { @entityValues }
}

my constant $xeh = XML::Entity::HTML.new;

sub decode-html-entities(
  Str:D   $in,
  Bool:D :$numeric = True,
--> Str:D) is export {
    $xeh.decode($in, :$numeric)
}

sub encode-html-entities(
  Str:D   $in,
          *@numeric,
  Bool:D :$hex = False,
--> Str:D) is export {
    $xeh.encode($in, :$hex, |@numeric);
}

=begin pod

=head1 NAME

XML::Entity::HTML - Extension of XML::Entity for (X)HTML 5 entities.

=head1 SYNOPSIS

=begin code :lang<raku>

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

=end code

=head1 DESCRIPTION

It's simply an extension class of XML::Entity, but with a lot more
entities taken from the
L<official JSON list|https://www.w3.org/TR/html5/entities.json>.

Any entities that wouldn't compile properly have been blacklisted
and aren't supported. See the C<build.raku> script in the C<build>
directory on how this module is built.

=head1 METHODS

=head2 decode

Overrides the C<XML::Entity.decode> method.  Expects a string and an
optional named argument C<:numeric>.

=head2 encode

Overrides the C<XML::Entity.encode> method.  Expects a string and an
optional named argument C<:hex>.

=head1 EXPORTED SUBROUTINES

=head2 decode-html-entities

Provides procedural access to the C<decode> method on a singleton
C<XML::Entity::HTML> object.  Takes the same parameters.

=head2 encode-html-entities

Provides procedural access to the C<encode> method on a singleton
C<XML::Entity::HTML> object.  Takes the same parameters.

=head1 AUTHOR

Timothy Totten

=head1 COPYRIGHT AND LICENSE

Copyright 2019 Timothy Totten

Copyright 2020 - 2022 Raku Community

This library is free software; you can redistribute it and/or modify it under the Artistic License 2.0.

=end pod

# vim: expandtab shiftwidth=4
