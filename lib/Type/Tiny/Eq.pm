package Type::Tiny::Eq;
use 5.008001;
use strict;
use warnings;

our $VERSION = "0.01";

use parent qw( Type::Tiny );

sub _croak ($;@) { require Error::TypeTiny; goto \&Error::TypeTiny::croak }

sub new {
    my $class = shift;

    my %opts = ( @_ == 1 ) ? %{ $_[0] } : @_;

    _croak "Eq type constraints cannot have a parent constraint passed to the constructor"
        if exists $opts{parent};

    _croak "Eq type constraints cannot have a constraint coderef passed to the constructor"
        if exists $opts{constraint};

    _croak "Eq type constraints cannot have a inlining coderef passed to the constructor"
        if exists $opts{inlined};

    _croak "Need to supply value" unless exists $opts{value};

    _croak "Eq value must be defined" unless defined $opts{value};

    $opts{value} = "$opts{value}"; # stringify

    return $class->SUPER::new( %opts );
}

sub value { $_[0]{value} }

sub _build_display_name {
    my $self = shift;
    sprintf( "Eq[%s]", $self->value );
}

sub parent {
    require Types::Standard;
    Types::Standard::Str();
}

sub has_parent {
    !!1;
}

sub constraint { $_[0]{constraint} ||= $_[0]->_build_constraint }

sub _build_constraint {
    my $self = shift;
    return sub {
        defined && $_ eq $self->value;
    };
}

sub can_be_inlined {
    !!1;
}

sub inline_check {
    my $self = shift;

    my $value = $self->value;
    my $code = "(defined($_[0]) && $_[0] eq '$value')";

    return "do { $Type::Tiny::SafePackage $code }"
        if $Type::Tiny::AvoidCallbacks; ## no critic (Variables::ProhibitPackageVars)
    return $code;
}

1;
