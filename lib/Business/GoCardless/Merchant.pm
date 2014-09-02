package Business::GoCardless::Merchant;

use Moo;

extends 'Business::GoCardless::Resource';

has [ qw/
    balance
    created_at
    description
    email
    eur_balance
    eur_pending_balance
    first_name
    gbp_balance
    gbp_pending_balance
    hide_variable_amount
    id
    last_name
    name
    next_payout_amount
    next_payout_date
    pending_balance
    sub_resource_uris
    uri
/ ] => (
    is => 'rw',
);

sub BUILD {
    my ( $self ) = @_;

    my $data = $self->client->api_get( sprintf( $self->endpoint,$self->id ) );

    foreach my $attr ( keys( %{ $data } ) ) {
        $self->$attr( $data->{$attr} );
    }

    return $self;
}

sub bills  {
    my ( $self ) = @_;

    my $data = $self->client->api_get(
        sprintf( $self->endpoint,$self->id ) . "/bills"
    );

    my @bills = map {
        Business::GoCardless::Bill->new( client => $self->client,%{ $_ } );
    } @{ $data };

    return @bills;
}

sub payouts {
    my ( $self ) = @_;

    my $data = $self->client->api_get(
        sprintf( $self->endpoint,$self->id ) . "/payouts"
    );

    my @payouts = map {
        Business::GoCardless::Payout->new( client => $self->client,%{ $_ } );
    } @{ $data };

    return @payouts;
}

1;

# vim: ts=4:sw=4:et