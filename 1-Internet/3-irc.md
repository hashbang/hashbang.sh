## Internet Relay Chat

The chat protocol known as IRC was originally developed in 1988 as a way to
establish real time synchronous communication on the internet, which previously
had only been home to asymmetric communication such as E-Mail and forums.

IRC has fallen out of favor with the advent of "walled garden" proprietary chat
systems like Apple iMessage, Google Hangouts, and Facebook Messenger. A little
known fact however is that IRC is still used heavily internally by some
engineering teams at all three companies because it is simple, reliable, and
will still be working when their own complex proprietary systems are offline.

Public IRC networks are not only alive and well, but still the de-facto place
to communicate in real time with many of the worlds best software engineers,
system administrators, security professionals, and maintainers of your favorite
open source projects. All of whom prefer a standard communication system not
controlled by any single entity or company, much like HTTP, email, and other
major internet protocols.

\#! provides IRC chat clients to all of our users to communicate with each
other and provide a bridge to other IRC networks, but here we will explore
how to do it by hand in telnet, which is the basis for making your own IRC
clients, bots, and connecting with hundreds of thousands of the smartest people
in the world.

1. Connect to the FreeNode IRC server

```
telnet irc.freenode.net 6667
```

It will respond trying to ask for your identity on the server:

```
Trying 71.11.84.232...
Connected to irc.freenode.net.
Escape character is '^]'.
:tolkien.freenode.net NOTICE * :*** Looking up your hostname...
:tolkien.freenode.net NOTICE * :*** Checking Ident
:tolkien.freenode.net NOTICE * :*** Found your hostname
```

2. Now tell the server who you are. 

```
PASS none
NICK jdoe
USER guest 0 * :John Doe 
```

The server should greet you with a long "message of the day" welcoming you.

3. Now verify you have communication to the server with a "PING"

```
PING :verne.freenode.net
```

It should reply with:

```
:verne.freenode.net PONG verne.freenode.net :verne.freenode.net
```

4. Now join a channel

```

JOIN ##linux
```

You should see a giant list of the hundreds of people in this room.

Stick around for a few minutes and you should see people talking

5. Send a message to the channel

```
PRIVMSG ##linux :hello! I am connected from telnet and have no idea what I am doing.
```

Everyone should see your message:

```
<jdoe> hello! I am connected from telnet and have no idea what I am doing.
```

6. Respond to server PING requests

After a bit the server will send you a PING request to see if you are still
there.

It will look like this:

```
PING :verne.freenode.net
```

Respond with a PONG.

```
PONG :verne.freenode.net
```

Congratulations, you are functionally using IRC by hand like it is the 80s!

Now go write some IRC bots, talk to industry experts, and take over the world.
