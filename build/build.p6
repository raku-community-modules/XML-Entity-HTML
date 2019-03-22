#!/usr/bin/env perl6
use JSON::Tiny;

sub MAIN (
  Str :$outfile='./lib/XML/Entity/HTML.pm6',
  Str :$infile='./build/entities.json',
  Bool :$debug
)
{
  my $rules = from-json slurp $infile;
  
  my $blacklist = set <&zwnj; &DownBreve; &TripleDot; &DotDot; &tdot; &zwj;>;
  my $usequotes = set <&quot; &quot &QUOT; &QUOT &apos;>;
  my $useescape = set <&bsol;>;
  
  my $outkeys = '';
  my $outvals = '';
  
  my $output = q:to/END/;
  use XML::Entity;
  
  class XML::Entity::HTML is XML::Entity
  {
    sub decode-html-entities (Str $in, Bool :$numeric=True) is export
    {
      XML::Entity::HTML.new.decode($in, :$numeric);
    }

    has @.entityNames is rw = [
  END
  
  my @kv = $rules.pairs.sort.reverse;
 
  for @kv -> $pair
  {
    my $key = $pair.key;
    if $blacklist{$key} || !$key.match(/^'&' \w+ ';'$/)
    { ## Skip blacklisted, or non-XML-compatible keys.
      next;
    }
    $outkeys ~= "    '$key',\n";
    my $char = $pair.value<characters>;
    if ($usequotes{$pair.key})
    {
      $outvals ~= "    q\{$char\},\n";
    }
    elsif ($useescape{$pair.key})
    {
      $outvals ~= "    '\\$char',\n";
    }
    else
    {
      $outvals ~= "    '$char',\n";
    }
  }
 
  $output ~= "$outkeys  ];\n  has \@.entityValues is rw = [\n$outvals  ];\n}\n";
  
  spurt $outfile, $output;
  if $debug
  {
    spurt 'keys.p6', "my \$keys = [\n$outkeys]\n;";
    spurt 'vals.p6', "my \$vals = [\n$outvals]\n;";
  }
}
