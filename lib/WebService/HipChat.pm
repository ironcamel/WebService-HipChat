package WebService::HipChat;
use Moo;
with 'WebService::BaseClientRole';

# VERSION

use Carp qw(croak);

has auth_token => ( is => 'ro', required => 1 );

has '+base_url' => ( default => 'https://api.hipchat.com/v2' );

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

sub create_room {
    my ($self, $data) = @_;
    croak '$data is required' unless 'HASH' eq ref $data;
    return $self->post("/room", $data);
}

sub update_room {
    my ($self, $room, $data) = @_;
    croak '$room is required' unless $room;
    croak '$data is required' unless 'HASH' eq ref $data;
    return $self->put("/room/$room", $data);
}

sub delete_room {
    my ($self, $room) = @_;
    croak '$room is required' unless $room;
    return $self->delete("/room/$room");
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

sub get_members {
    my ($self, $room) = @_;
    croak '$room is required' unless $room;
    return $self->get("/room/$room/member");
}

sub add_member {
    my ($self, $room, $user) = @_;
    croak '$room is required' unless $room;
    croak '$user is required' unless $user;
    return $self->put("/room/$room/member/$user", {});
}

sub remove_member {
    my ($self, $room, $user) = @_;
    croak '$room is required' unless $room;
    croak '$user is required' unless $user;
    return $self->delete("/room/$room/member/$user");
}

sub get_users {
    my ($self) = @_;
    return $self->get("/user");
}

sub get_user {
    my ($self, $user) = @_;
    croak '$user is required' unless $user;
    return $self->get("/user/$user");
}

sub send_private_msg {
    my ($self, $user, $data) = @_;
    croak '$user is required' unless $user;
    croak '$data is required' unless 'HASH' eq ref $data;
    return $self->post("/user/$user/message", $data);
}

sub get_emoticons {
    my ($self) = @_;
    return $self->get("/emoticon");
}

sub get_emoticon {
    my ($self, $emoticon) = @_;
    croak '$emoticon is required' unless $emoticon;
    return $self->get("/emoticon/$emoticon");
}

=head1 SYNOPSIS

    my $hc = WebService::HipChat->new(auth_token => 'abc');
    $hc->send_notification('Room42', { color => 'green', message => 'allo' });

    # get paged results:
    my $res = $hc->get_emoticons;
    my @emoticons = @{ $res->{items} };
    while (my $next_link = $res->{links}{next}) {
        $res = $hc->get($next_link);
        push @emoticons, @{ $res->{items} };
    }

=head1 DESCRIPTION

This module provides bindings for the
L<HipChat|https://www.hipchat.com/docs/apiv2> API v2.

=head1 METHODS

All methods return a hashref.
The C<$room> param can be the id or name of the room.
The C<$user> param can be the id, email address, or @mention name of the user.
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

=head2 create_room

    create_room({ name => 'monkeys' })

Example response:

    {
      id => 46,
      links => { self => "https://hipchat.com/v2/room/46" },
    }

=head2 update_room

    update_room($room, {
        is_archived         => JSON::false,
        is_guest_accessible => JSON::false,
        name                => "Jokes",
        owner               => { id => 17 },
        privacy             => "public",
        topic               => "funny jokes",
    });

=head2 delete_room

    delete_room($room)

=head2 send_notification

    send_notification($room, { color => 'green', message => 'allo' });

=head2 get_webhooks

    get_webhooks($room)

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

=head2 send_private_msg

    send_private_msg($user, { message => 'allo' });

=head2 get_members

    get_members($room);

Example response:

    {
      items => [
        {
          id => 73,
          links => { self => "https://hipchat.com/v2/user/73" },
          mention_name => "momma",
          name => "Yo Momma",
        },
        {
          id => 23,
          links => { self => "https://hipchat.com/v2/user/23" },
          mention_name => "jackie",
          name => "Jackie Chan",
        },
      ],
      links => { self => "https://hipchat.com/v2/room/Test/member" },
      maxResults => 100,
      startIndex => 0,
    }

=head2 add_member

Adds a user to a room.

    add_member($room, $user);

=head2 remove_member

Removes a user from a room.

    remove_member($room, $user);

=head2 get_users

    get_users()

Example response:

    {
      items => [
        {
          id => 1,
          links => { self => "https://hipchat.com/v2/user/1" },
          mention_name => "magoo",
          name => "Matt Wondercookie",
        },
        {
          id => 3,
          links => { self => "https://hipchat.com/v2/user/3" },
          mention_name => "racer",
          name => "Brian Wilson",
        },
      ],
      links => { self => "https://hipchat.com/v2/user" },
      maxResults => 100,
      startIndex => 0,
    }

=head2 get_user

    get_user($user)

Example response:

    {
      created        => "2014-06-20T03:00:28",
      email          => 'matt@foo.com',
      group          => {
                          id => 1,
                          links => { self => "https://hipchat.com/v2/group/1" },
                          name => "Everyone",
                        },
      id             => 1,
      is_deleted     => 0,
      is_group_admin => 1,
      is_guest       => 0,
      last_active    => 1405718128,
      links          => { self => "https://hipchat.com/v2/user/1" },
      mention_name   => "magoo",
      name           => "Matt Wondercookie",
      photo_url      => "https://hipchat.com/files/photos/1/abc.jpg",
      presence       => {
                          client => {
                            type => "http://hipchat.com/client/linux",
                            version => 98,
                          },
                          idle => 3853,
                          is_online => 1,
                          show => "away",
                        },
      timezone       => "America/New_York",
      title          => "Hacker",
      xmpp_jid       => '1_1@chat.hipchat.com',
    }

=head2 get_emoticons

    get_emoticons()

Example response:

    {
      items => [
        {
          id => 166,
          links => { self => "https://hipchat.com/v2/emoticon/166" },
          shortcut => "dog",
          url => "https://hipchat.com/files/img/emoticons/1/dog.png",
        },
      ],
      links => { self => "https://hipchat.com/v2/emoticon" },
      maxResults => 100,
      startIndex => 0,
    }

=head2 get_emoticon

    get_emoticon()

Example response:

    {
      creator => {
        id => 11,
        links => { self => "https://hipchat.com/v2/user/11" },
        mention_name => "bob",
        name => "Bob Ray",
      },
      height => 30,
      id => 203,
      links => { self => "https://hipchat.com/v2/emoticon/203" },
      shortcut => "dog",
      url => "https://hipchat.com/files/img/emoticons/1/dog.png",
      width => 30,
    }

=cut

1;
