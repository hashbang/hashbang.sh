## Email

You probably have sent email. Or have you?

If you use a major mail provider like GMail, Yahoo, or Hotmail, they do all the
work of taking the information you want to send and who you want to send it to,
and then communicate that to an "SMTP" mail server on your behalf in a special
protocol. SMTP is easy to remember as it stands for "Send Mail To People".

At #! you get a free email account and a "Mutt" email client for interacting
with email on the terminal, but here we will dive a bit deeper and use
telnet to interact directly with our SMTP mail server to send an email in raw
form like your mail client would normally do for you.

1. Connect to the hashbang mail server with telnet
    ```
    > ssh yourusername@sf1.hashbang.sh telnet localhost 25
    Trying ::1...
    Connected to localhost.
    Escape character is '^]'.
    220 sf1.hashbang.sh ESMTP Postfix (Debian/GNU)
    ```

2. Announce yourself to the mail sever

    ```
    EHLO hashbang.sh
    ```

    The server will respond with a list of protocals it supports:

    ```
    250-sf1.hashbang.sh
    250-PIPELINING
    250-SIZE 52428800
    250-VRFY
    250-ETRN
    250-STARTTLS
    250-ENHANCEDSTATUSCODES
    250-8BITMIME
    250 DSN
    ```

2. Tell the server who you want to send mail as

    ```
    MAIL FROM:foo@derp.com
    ```
    Note: you can put literally any email you want here. This is like a return
    address on an envelope. Most email servers will blindly let you impersonate
    anyone. We call this email "spoofing".

3. Tell the server who you want to receive the mail

    ```
    RCPT TO: your@emailhere.com
    ```

4. Tell the server the body of the message you want to send

    Note: end with a period on a line by itself

    ```
    DATA
    Subject: some subject

    My really awesome message here
    ```

5. Send message

    ```
    .
    ```

    Just a single period on a line by itself lets the server know you are done.

    Go check your inbox!

    Depending on who you spoofed, it may or may not be in spam.

    Please don't abuse this, and be mindful of the laws in your local area ;)
