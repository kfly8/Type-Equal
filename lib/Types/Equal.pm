package Types::Equal;
use 5.008001;
use strict;
use warnings;

our $VERSION = "0.01";

use Type::Library -base, -declare => qw( Eq Equ );
use Type::Tiny::Eq;
use Type::Tiny::Equ;

my $meta = __PACKAGE__->meta;

$meta->add_type(
    {
        name => 'Eq',
        constraint_generator => sub {
            Type::Tiny::Eq->new(
                value => $_[0],
            )
        }
    }
);

$meta->add_type(
    {
        name => 'Equ',
        constraint_generator => sub {
            Type::Tiny::Equ->new(
                value => $_[0],
            )
        }
    }
);

1;
__END__

=encoding utf-8

=head1 NAME

Types::Equal - It's new $module

=head1 SYNOPSIS

    use Types::Equal;

=head1 DESCRIPTION

Types::Equal is ...

=head1 LICENSE

Copyright (C) kobaken.

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.

=head1 AUTHOR

kobaken E<lt>kentafly88@gmail.comE<gt>

=cut

