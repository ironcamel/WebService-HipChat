package WebService::HipChat;
use Moo;
with 'WebService::HipChat::HTTP';

# VERSION

use Carp qw(croak);

has auth_token => ( is => 'ro', required => 1 );

sub BUILD {
    my ($self) = @_;
    $self->ua->default_header(Authorization => "Bearer " . $self->auth_token);
}

sub get_rooms {
    my ($self) = @_;
    return $self->get("/room");
}

sub get_room {
    my ($self, $room) = @_;
    croak '$room is required' unless $room;
    return $self->get("/room/$room");
}

sub send_notification {
    my ($self, $room, $data) = @_;
    croak '$room is required' unless $room;
    croak '$data is required' unless 'HASH' eq ref $data;
    return $self->post("/room/$room/notification", $data);
}

sub get_webhooks {
    my ($self, $room) = @_;
    croak '$room is required' unless $room;
    return $self->get("/room/$room/webhook");
}

sub create_webhook {
    my ($self, $room, $data) = @_;
    croak '$room is required' unless $room;
    croak '$data is required' unless 'HASH' eq ref $data;
    return $self->post("/room/$room/webhook", $data);
}

=head1 SYNOPSIS

    my $hc = WebService::HipChat->new( auth_token => 'abc' );
    $hc->send_notification('Room42', { color => 'green', message => 'allo' });

=head1 DESCRIPTION

This module provides bindings for the
L<HipChat|https://www.hipchat.com/docs/apiv2> API v2.

=head1 METHODS

All methods return a hashref.
The C<$room> param can be a room id or name.
If a resource does not exist for the given parameters, undef is returned.

=head2 get_rooms

    get_rooms()

Example response:

    {
      items => [
        {
          id => 2,
          links => {
            self => "https://hipchat.com/v2/room/2",
            webhooks => "https://hipchat.com/v2/room/2/webhook",
          },
          name => "General Discussion",
        },
        {
          id => 3,
          links => {
            self => "https://hipchat.com/v2/room/3",
            webhooks => "https://hipchat.com/v2/room/3/webhook",
          },
          name => "Important Stuff",
        },
      links => { self => "https://hipchat.com/v2/room" },
      maxResults => 100,
      startIndex => 0,
    }

=head2 get_room

    get_room($room)

Returns the room for the given $room name.

Example response:

    {
      created => "2014-06-25T02:28:04",
      guest_access_url => undef,
      id => 2,
      is_archived => 0,
      is_guest_accessible 0,
      last_active => "2014-07-19T02:40:55+00:00",
      links => {
        self => "https://hipchat.com/v2/room/2",
        webhooks => "https://hipchat.com/v2/room/2/webhook",
      },
      name => "General Discussion",
      owner => {
        id => 1,
        links => { self => "https://hipchat.com/v2/user/1" },
        mention_name => "bob",
        name => "Bob Williams",
      },
      participants => [],
      privacy => "public",
      statistics => {
        links => { self => "https://hipchat.com/v2/room/2/statistics" },
      },
      topic => "hipchat commands",
      xmpp_jid => "1_general_discussion\@conf.btf.hipchat.com",
    }

=head2 send_notification

    send_notification($room, { color => 'green', message => 'allo' });

=head2 get_webhooks

    get_webhooks()

Example response:

    {
      items => [
        {
          event => "room_message",
          id => 1,
          links => { self => "https://hipchat.com/v2/room/API/webhook/1" },
          name => "hook1",
          pattern => undef,
          url => "http://yourdomain.org/hipchat-webhook",
        },
      ],
      links => { self => "https://hipchat.com/v2/room/API/webhook" },
      maxResults => 100,
      startIndex => 0,
    }

=head2 create_webhook

    create_webhook($room, {
        url   => 'http://yourdomain.org/hipchat-webhook'
        event => 'room_message',
        name  => 'hook1',
    });

=cut

1;
