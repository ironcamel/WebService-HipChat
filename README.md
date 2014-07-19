# NAME

WebService::HipChat

# VERSION

version 0.0001

# SYNOPSIS

    my $hc = WebService::HipChat->new( auth_token => 'abc' );
    my $rooms = $hc->get_rooms->{items};

# DESCRIPTION

This module provides bindings for the
[HipChat](https://www.hipchat.com/docs/apiv2) API v2.

# METHODS

All methods return a hashref.
If a resource does not exist for the given parameters, undef is returned.

## get\_rooms

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

## get\_room

    get_room($room_id)

Returns the room for the given $room\_id

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

## get\_room\_webhooks

    get_room_webhooks()

## create\_room\_webhook

    create_room_webhook($room_id, {
        url   => 'http://yourdomain.org/hipchat-webhook'
        event => 'room_message',
        name  => 'hook1',
    });

# AUTHOR

Naveed Massjouni <naveed@vt.edu>

# COPYRIGHT AND LICENSE

This software is copyright (c) 2014 by Naveed Massjouni.

This is free software; you can redistribute it and/or modify it under
the same terms as the Perl 5 programming language system itself.
