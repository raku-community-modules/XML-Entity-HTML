use JSON::Fast;

my $base := $?FILE.IO.parent.parent;

unit sub MAIN(
  IO()   :$module   = $base.add('lib').add('XML').add('Entity').add('HTML.rakumod'),
  IO()   :$entities = $base.add('build').add('entities.json'),
  Bool:D :$debug    = False,
);

my %blacklist is Set = <&zwnj; &DownBreve; &TripleDot; &DotDot; &tdot; &zwj;>;
my %usequotes is Set = <&quot; &QUOT; &apos;>;
my %useescape is Set = ('&bsol;',);

my $generator = $*PROGRAM-NAME;
my $generated = DateTime.now.gist.subst(/\.\d+/,'');
my $start     = '#- start of generated part of entities';
my $end       = '#- end of generated part of entities';

my %rules := from-json $entities.slurp;

my str @outkeys;
my str @outvalues;

# Set up entity information in reverse order, so that the UPPERcase
# versions will be overwritten by the lowercase ones.
for %rules.keys.sort.reverse -> str $key {
    # Skip blacklisted, or non-XML-compatible keys.
    next if %blacklist{$key} || !$key.match(/^'&' \w+ ';'$/);

    @outkeys.push: $key;
    my str $char = %rules{$key}<characters>;
    @outvalues.push: %usequotes{$key}
      ?? "q\{$char\}, "
      !! %useescape{$key}
        ?? "'\\$char', "
        !! "'$char', ";
}

if $debug {
    'keys.raku'.IO.spurt: "my \$keys = [\n@outkeys[]]\n;";
    'vals.raku'.IO.spurt: "my \$vals = [\n@outvalues[]]\n;";
}

my $old := $module.slurp;
my str @lines = $old.lines;
$*OUT = $module.open(:w);

# for all the lines in the source that don't need special handling
while @lines {
    my $line := @lines.shift;

    # nothing to do yet
    unless $line.starts-with($start) {
        say $line;
        next;
    }

    # found header
    say $start ~ " " ~ "-" x 79 - $start.chars;
    say "#- Generated on $generated by $generator";
    say "#- PLEASE DON'T CHANGE ANYTHING BELOW THIS LINE";

    # skip the old version of the code
    while @lines {
        last if @lines.shift.starts-with($end);
    }

    my str $out = 'BEGIN my str @entityNames = ';
    while @outkeys {
        my str $next = "'@outkeys.shift()', ";
        if $out.chars + $next.chars > 75 {
            say $out;
            $out = "  $next";
        }
        else {
            $out ~= $next;
        }
    }
    say $out.chars > 2
      ?? "$out.chop(2);"
      !! ';';

    $out = 'BEGIN my str @entityValues = ';
    while @outvalues {
        my str $next = @outvalues.shift;
        if $out.chars + $next.chars > 75 {
            say $out;
            $out = "  $next";
        }
        else {
            $out ~= $next;
        }
    }
    say $out.chars > 2
      ?? "$out.chop(2);"
      !! ';';

    # we're done
    say "";
    say "#- PLEASE DON'T CHANGE ANYTHING ABOVE THIS LINE";
    say $end ~ " " ~ "-" x 79 - $end.chars;
}

# Close the file properly
$*OUT.close;

# Restore if something went wrong
my $all-ok = True;
END {
    unless $all-ok {
        .spurt($old) with $module;
    }
}

# vim: expandtab shiftwidth=4
