#!/usr/bin/env perl6

use XML;
use XML::Entity::HTML;
use Test;

plan 4;

my $raw = 'A text node with &lt;entities&gt; &amp; &laquo;more&raquo; &copy;';
my $decoded = 'A text node with <entities> & «more» ©';

my $out = decode-html-entities($raw);
is $out, $decoded, 'decode-html-entities works';

my $he = XML::Entity::HTML.new;

my $xml = from-xml-file('./t/html-entities.xml');
my $textNode = $xml.root[0];
is $textNode.text, $raw, 'Text.text is correct';

my $out2 = $textNode.string($he);
is $out2, $decoded, 'Text.string() with XML::Entity::HTML is correct.';

my $out3 = $he.encode($out2);
is $out3, $raw, 'Re-encoded HTML entities correctly.';
