use strict;
use warnings;
use Test::More;

use Types::Equal qw( Eq Equ);

subtest 'Eq' => sub {
    subtest 'display_name' => sub {
        my $type = Eq[ 'foo' ];

        is($type->display_name, "Eq['foo']", "display_name is Eq['foo']");
    };

    subtest 'check' => sub {
        my $type = Eq[ 'foo' ];

        ok( $type->check( 'foo' ), 'foo eq foo' );
        ok( !$type->check( 'bar' ), 'bar not eq foo' );
        ok( !$type->check( 'fo' ), 'fo is not eq foo' );
        ok( !$type->check( 'foo ' ), '"foo " not eq foo' );
        ok( !$type->check( ' foo' ), '" foo" not eq foo' );
        ok( !$type->check( undef ), 'undef not eq foo' );
        ok( !$type->check( {} ), '{} not eq foo' );
        ok( !$type->check( [] ), '[] not eq foo' );
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

            ok( $type->check( 'foo' ), 'foo eq foo' );
            ok( !$type->check( 'bar' ), 'bar not eq foo' );
            ok( !$type->check( 'fo' ), 'fo is not eq foo' );
            ok( !$type->check( 'foo ' ), '"foo " not eq foo' );
            ok( !$type->check( ' foo' ), '" foo" not eq foo' );
            ok( !$type->check( undef ), 'undef not eq foo' );
            ok( !$type->check( {} ), '{} not eq foo' );
            ok( !$type->check( [] ), '[] not eq foo' );
        };

        subtest 'value is undef' => sub {
            my $type = Equ[ undef ];

            ok( $type->check( undef ), 'undef equal undef' );
            ok( !$type->check( '' ), 'empty string not equal undef' );
            ok( !$type->check( 'foo' ), 'foo not equal foo' );
            ok( !$type->check( {} ), '{} not eq foo' );
            ok( !$type->check( [] ), '[] not eq foo' );
        };

        subtest 'value is number' => sub {
            my $type = Equ[ 123 ];

            ok( $type->check( 123 ), '123 equal 123' );
            ok( $type->check( '123' ), '123 equal 123' );
            ok( $type->check( 123.0 ), '123.0 not equal 123' );
            ok( !$type->check( 'foo' ), 'foo not equal 123' );
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
