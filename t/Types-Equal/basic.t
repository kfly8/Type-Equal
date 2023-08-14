use strict;
use warnings;
use Test::More;

use Types::Equal qw( Eq Equ );

{
    package StringableFoo;
    use overload '""' => sub { 'foo' };
    sub new { bless {}, shift }
}

subtest 'Eq' => sub {
    subtest 'display_name' => sub {
        my $type = Eq[ 'foo' ];

        is($type->display_name, "Eq['foo']", "display_name is Eq['foo']");
    };

    subtest 'check' => sub {

        subtest 'value is defined' => sub {
            my $type = Eq[ 'foo' ];

            ok( $type->check( 'foo' ), '`foo` is equal' );
            ok( !$type->check( 'bar' ), '`bar` is not equal' );
            ok( !$type->check( 'fo' ), '`fo` is not equal' );
            ok( !$type->check( 'foo ' ), '`foo ` is not equal' );
            ok( !$type->check( ' foo' ), '` foo` is not equal' );
            ok( !$type->check( undef ), 'undefined value is not equal' );
            ok( !$type->check( {} ), '{} is not equal' );
            ok( !$type->check( [] ), '[] is not equal' );
            ok( !$type->check( sub {} ), 'sub {} is not equal' );
        };

        subtest 'value is number' => sub {
            my $type = Eq[ 123 ];

            ok( $type->check( 123 ), 'number 123 is equal' );
            ok( $type->check( '123' ), "string 123 is equal" );
            ok( $type->check( 123.0 ), 'number 123.0 is equal' );
            ok( !$type->check( '123.0' ), 'string 123.0 is not equal' );
            ok( !$type->check( 'foo' ), 'foo is not equal' );
        };

        subtest 'value is strinable object' => sub {
            my $foo = StringableFoo->new;
            my $type = Eq[ $foo ];

            ok( $type->check( 'foo' ), '`foo` is equal' );
            ok( !$type->check( 'bar' ), '`bar` is not equal' );
            ok( !$type->check( 'fo' ), '`fo` is not equal' );
            ok( !$type->check( 'foo ' ), '`foo ` is not equal' );
            ok( !$type->check( ' foo' ), '` foo` is not equal' );
            ok( !$type->check( undef ), 'undefined value is not equal' );
            ok( !$type->check( {} ), '{} is not equal' );
            ok( !$type->check( [] ), '[] is not equal' );
            ok( !$type->check( sub {} ), 'sub {} is not equal' );
        };
    };

    subtest 'value' => sub {
        my $type = Eq[ 'foo' ];
        is($type->value, 'foo', 'value is foo');
    };

    subtest 'value cannot be undef' => sub {
        eval { Eq[ undef ] };
        like( $@, qr/Eq value must be defined/ );
    };

    subtest 'union' => sub {
        my $FooOrBar = Eq[ 'foo' ] | Eq[ 'bar' ];

        ok( $FooOrBar->check( 'foo' ), 'foo is valid' );
        ok( $FooOrBar->check( 'bar' ), 'bar is valid' );
        ok( !$FooOrBar->check( 'baz' ), 'baz is invalid' );
    };
};


subtest 'Equ' => sub {
    subtest 'display_name' => sub {
        is( (Equ[ 'foo' ])->display_name, "Equ['foo']", "display_name is Equ['foo']");
        is( (Equ[ undef ])->display_name, "Equ[Undef]", "display_name is Equ[Undef]");
    };

    subtest 'check' => sub {
        subtest 'value is defined' => sub {
            my $type = Equ[ 'foo' ];

            ok( $type->check( 'foo' ), '`foo` is equal' );
            ok( !$type->check( 'bar' ), '`bar` is not equal' );
            ok( !$type->check( 'fo' ), '`fo` is not equal' );
            ok( !$type->check( 'foo ' ), '`foo ` is not equal' );
            ok( !$type->check( ' foo' ), '` foo` is not equal' );
            ok( !$type->check( undef ), 'undefined value is  not equal' );
            ok( !$type->check( {} ), '{} is not equal' );
            ok( !$type->check( [] ), '[] is not equal' );
            ok( !$type->check( sub {} ), 'sub {} is not equal' );
        };

        subtest 'value is undefined' => sub {
            my $type = Equ[ undef ];

            ok( $type->check( undef ), 'undefined value is valid' );
            ok( !$type->check( '' ), 'empty string is not equal' );
            ok( !$type->check( 'foo' ), '`foo` is not equal' );
            ok( !$type->check( {} ), '{} is not equal' );
            ok( !$type->check( [] ), '[] is not equal' );
            ok( !$type->check( sub {} ), 'sub {} is not equal' );
        };

        subtest 'value is number' => sub {
            my $type = Equ[ 123 ];

            ok( $type->check( 123 ), 'number 123 is equal' );
            ok( $type->check( '123' ), "string 123 is equal" );
            ok( $type->check( 123.0 ), 'number 123.0 is equal' );
            ok( !$type->check( '123.0' ), 'string 123.0 is not equal' );
            ok( !$type->check( 'foo' ), 'foo is not equal' );
        };

        subtest 'value is strinable object' => sub {
            my $foo = StringableFoo->new;
            my $type = Equ[ $foo ];

            ok( $type->check( 'foo' ), '`foo` is equal' );
            ok( !$type->check( 'bar' ), '`bar` is not equal' );
            ok( !$type->check( 'fo' ), '`fo` is not equal' );
            ok( !$type->check( 'foo ' ), '`foo ` is not equal' );
            ok( !$type->check( ' foo' ), '` foo` is not equal' );
            ok( !$type->check( undef ), 'undefined value is not equal' );
            ok( !$type->check( {} ), '{} is not equal' );
            ok( !$type->check( [] ), '[] is not equal' );
            ok( !$type->check( sub {} ), 'sub {} is not equal' );
        };
    };

    subtest 'value' => sub {
        is( (Equ['foo'])->value, 'foo', 'value is foo' );
        is( (Equ[undef])->value, undef, 'value is undef' );
    };

    subtest 'union' => sub {
        my $FooOrBar = Equ[ 'foo' ] | Equ[ 'bar' ];

        ok( $FooOrBar->check( 'foo' ), 'foo eq foo' );
        ok( $FooOrBar->check( 'bar' ), 'bar eq bar' );
        ok( !$FooOrBar->check( 'baz' ), 'baz not eq foo or bar' );

        my $FooOrUndef = Equ[ 'foo' ] | Equ[ undef ];
        ok( $FooOrUndef->check( 'foo' ), 'foo is valid' );
        ok( $FooOrUndef->check( undef ), 'undef is valid' );
        ok( !$FooOrBar->check( 'baz' ), 'baz is invalid' );
    };
};

done_testing;
