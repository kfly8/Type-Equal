use strict;
use warnings;
use Test::More;

use Types::Equal qw( Eq );

subtest 'Eq' => sub {
    subtest 'display_name' => sub {
        my $type = Eq[ 'foo' ];

        is($type->display_name, 'Eq[foo]', 'display_name is Eq[foo]');
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
        my $FooBar = Eq[ 'foo' ] | Eq[ 'bar' ];

        ok( $FooBar->check( 'foo' ), 'foo eq foo' );
        ok( $FooBar->check( 'bar' ), 'bar eq bar' );
        ok( !$FooBar->check( 'baz' ), 'baz not eq foo or bar' );
    };
};

done_testing;
