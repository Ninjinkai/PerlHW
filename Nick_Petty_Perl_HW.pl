# Nick Petty
# COT5930 Programming Languages
# Perl Homework Assignment

use strict;

while( <> )                         # <> one line at a time into $_
{
    chomp;                          # same a chomp( $_ ); remove \n
    print "input line:\t$_\n";      # print current line

    my ( @a ) = tokens( $_ );       # break current line into tokens

    pstack( "tokens:", \@a );       # title and address of array a

    postfix( @a );

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

# Convert an infix expression, as a tokenized array, into a postfix epression in the same format.
sub postfix
{
    # Tokens from input parameter.
    my @tok = @_;

    # Iterator for tokens, stack for operators, stack for output.
    my ( $i, @stack, @output );

    # Valid operators.
    my ( $operators ) =  "+-*/\(\)";

    # Iterate over the input array and place elements according to postfix notation.
    # Parenthesis are effectively dropped.
    for( $i = 0; $i < @tok; ++$i )
    {
        # Operator found.
        if( index( $operators, $tok[ $i ] ) != -1 )
        {
            # Opening parenthesis pushed to stack.
            if( $tok[ $i ] eq "(" )
            {
                push( @stack, $tok[ $i ] );
            }
            # Closing parenthesis pop stack to output until opening parenthesis is found.
            elsif( $tok[ $i ] eq ")" )
            {
                while( $stack[ -1 ] ne "(")
                {
                    push( @output, pop( @stack ));
                }
                pop( @stack );
            }
            # Handle +-*/
            else
            {
                # Operators always go onto the empty stack.
                if( @stack <= 0 )
                {
                    push( @stack, $tok[ $i ] );
                }
                else
                {
                    # Input has higher precedence than top of stack, push it.
                    if( precedence( $tok[ $i ] ) > precedence( $stack[ -1 ] ))
                    {
                        push( @stack, $tok[ $i ] );
                    }
                    # Input has equal or lower precedence than top of stack.
                    else
                    {
                        # Input goes onto the stack if there is already a parenthesis on top.
                        if( $stack[ -1 ] eq "(" )
                        {
                            push( @stack, $tok[ $i ] );
                        }
                        else
                        {
                            # Pop stack to output until input has higher precedence, there
                            # is a parenthesis, or the stack is empty.
                            while( precedence( $tok[ $i ] ) <= precedence( $stack[ -1 ] ))
                            {
                                push( @output, pop( @stack ));
                                if( $stack[ -1 ] eq "(" )
                                {
                                    last;
                                }
                                if( @stack <= 0 )
                                {
                                    last;
                                }
                            }
                            # Push the input onto the stack once above conditions are met.
                            push( @stack, $tok[ $i ] );
                        }                        
                    }
                }
            }
        }
        # Operand found, goes to output.
        else
        {
            push( @output, $tok[ $i ] );
        }
    }

    # Push any operators on stack to output.
    while( @stack > 0)
    {
        push( @output, pop( @stack ));
    }

    # Output postfix expression.
    print "\nPostfix: @output\n";

}

# Returns the precedence of an operator.
sub precedence
{
    my $oper = $_[ 0 ];

    if( $oper eq "+" || $oper eq "-" )
    {
        return 0;
    }
    elsif( $oper eq "*" || $oper eq "/" )
    {
        return 1;
    }
    # For parenthesis, but probably unnecessary.
    else
    {
        return 2;
    }
}