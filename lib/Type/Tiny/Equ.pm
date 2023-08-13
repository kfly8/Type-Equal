package Type::Tiny::Equ;
use 5.008001;
use strict;
use warnings;

our $VERSION = "0.01";

use parent qw( Type::Tiny );

sub _croak ($;@) { require Error::TypeTiny; goto \&Error::TypeTiny::croak }

sub new {
    my $class = shift;

    my %opts = ( @_ == 1 ) ? %{ $_[0] } : @_;

    _croak "Equ type constraints cannot have a parent constraint passed to the constructor"
        if exists $opts{parent};

    _croak "Equ type constraints cannot have a constraint coderef passed to the constructor"
        if exists $opts{constraint};

    _croak "Equ type constraints cannot have a inlining coderef passed to the constructor"
        if exists $opts{inlined};

    _croak "Need to supply value" unless exists $opts{value};

    # stringify
    $opts{value} = defined $opts{value} ? "$opts{value}" : undef;

    return $class->SUPER::new( %opts );
}

sub value { $_[0]{value} }

sub _build_display_name {
    my $self = shift;
    defined $self->value
        ? sprintf( "Equ['%s']", $self->value )
        : "Equ[Undef]";
}

sub has_parent {
    !!0;
}

sub constraint { $_[0]{constraint} ||= $_[0]->_build_constraint }

sub _build_constraint {
    my $self = shift;

    if (defined $self->value) {
        return sub {
            defined $_ && $_ eq $self->value;
        };
    }
    else {
        return sub {
            !defined $_;
        };
    }
}

sub can_be_inlined {
    !!1;
}
#
sub inline_check {
    my $self = shift;

    my $value = $self->value;
    my $code;
    if (defined $value) {
        $code = "(defined($_[0]) && $_[0] eq '$value')";
    }
    else {
        $code = "!defined($_[0])";
    }

    return "do { $Type::Tiny::SafePackage $code }"
        if $Type::Tiny::AvoidCallbacks; ## no critic (Variables::ProhibitPackageVars)
    return $code;
}

1;
