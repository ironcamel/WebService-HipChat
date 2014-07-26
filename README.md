# NAME

WebService::HipChat

# VERSION

version 0.0201

# SYNOPSIS

    my $hc = WebService::HipChat->new(auth_token => 'abc');
    $hc->send_notification('Room42', { color => 'green', message => 'allo' });

    # get paged results:
    my $res = $hc->get_emoticons;
    my @emoticons = @{ $res->{items} };
    while (my $next_link = $res->{links}{next}) {
        $res = $hc->get($next_link);
        push @emoticons, @{ $res->{items} };
    }

# DESCRIPTION

This module provides bindings for the
[HipChat API v2](https://www.hipchat.com/docs/apiv2).
It also provides the command line utility [hipchat-send](http://search.cpan.org/perldoc?hipchat-send).

# METHODS

All methods return a hashref.
The `$room` param can be the id or name of the room.
The `$user` param can be the id, email address, or @mention name of the user.
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

## create\_room

    create_room({ name => 'monkeys' })

Example response:

    {
      id => 46,
      links => { self => "https://hipchat.com/v2/room/46" },
    }

## update\_room

    update_room($room, {
        is_archived         => JSON::false,
        is_guest_accessible => JSON::false,
        name                => "Jokes",
        owner               => { id => 17 },
        privacy             => "public",
        topic               => "funny jokes",
    });

## set\_topic

    set_topic($room, 'new topic');

## delete\_room

    delete_room($room)

## send\_notification

    send_notification($room, { color => 'green', message => 'allo' });

## get\_webhooks

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

## create\_webhook

    create_webhook($room, {
        url   => 'http://yourdomain.org/hipchat-webhook'
        event => 'room_message',
        name  => 'hook1',
    });

## send\_private\_msg

    send_private_msg($user, { message => 'allo' });

## get\_members

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

## add\_member

Adds a user to a room.

    add_member($room, $user);

## remove\_member

Removes a user from a room.

    remove_member($room, $user);

## get\_users

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

## get\_user

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

## get\_emoticons

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

## get\_emoticon

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

# AUTHOR

Naveed Massjouni <naveed@vt.edu>

# COPYRIGHT AND LICENSE

This software is copyright (c) 2014 by Naveed Massjouni.

This is free software; you can redistribute it and/or modify it under
the same terms as the Perl 5 programming language system itself.
