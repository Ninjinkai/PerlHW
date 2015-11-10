
use strict;

while( <> )                         # <> one line at a time into $_
{
    chomp;                          # same a chomp( $_ ); remove \n
    print "input line:\t$_\n";      # print current line

    my ( @a ) = tokens( $_ );       # break current line into tokens

    pstack( "tokens:", \@a );       # title and address of array a

#   postfix( @a );

    print "\n";
}


sub pstack
{
    my $title = $_[ 0 ];            # first  parameter: a scalar
    my $stack = $_[ 1 ];            # second parameter: addr. of a stack
    my ( $i );

    print "\n$title\n";

    if( @$stack <= 0 )              # is the stack empty?
    {
        print "\tnone\n";
    }
    else
    {                               # treat $stack as an array
        for( $i = 0; $i < @$stack; ++$i )
        {
            print "$i\t$$stack[ $i ]\n";
        }
    }
}


sub tokens
{
    local $_ = $_[ 0 ];             # first parameter in @_

    my ( @tok ) = split( /\s+/ );   # split $_ on white spaces

    return @tok;
}

