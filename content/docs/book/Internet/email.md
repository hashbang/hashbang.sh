---
$title: Email
$titles:
  nav: Docs
  side: Welcome
$path: /internet/email/
$category: Book/Internet
$order: 1
---



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

### The hard way

1. Install a local smtpd server

```
apt install opensmtpd
```

2. Start local mail server

```
sudo systemctl start opensmtpd
```

3. Connect to your local mail server
    ```
    > telnet localhost 25
    Trying ::1...
    Connected to localhost.
    Escape character is '^]'.
    220 sf1.hashbang.sh ESMTP Postfix (Debian/GNU)
    ```

4. Announce yourself to the mail sever

    ```
    EHLO localhost
    ```

    The server will respond with a list of protocals it supports:

    ```
    250-localhost
    250-PIPELINING
    250-SIZE 52428800
    250-VRFY
    250-ETRN
    250-STARTTLS
    250-ENHANCEDSTATUSCODES
    250-8BITMIME
    250 DSN
    ```

4. Tell the server who you want to send mail as

    ```
    MAIL FROM: <jdoe@derp.com>
    ```
    Note: you can put literally any email you want here. This is like a return
    address on an envelope. Most email servers will blindly let you impersonate
    anyone. We call this email "spoofing".

5. Tell the server who you want to receive the mail

    ```
    RCPT TO: <your@emailhere.com>
    ```

6. Tell the server the body of the message you want to send

    Note: end with a period on a line by itself

    You need to type everything below in order for the message to be accepted.

    "DATA" announces that you want to send a message, followed by From, to and
    subject followed by the body of your message.

    ```
    DATA
    From: John Doe <jdoe@derp.com>
    To: Your Name <your@emailhere.com>
    Subject: some subject

    My really awesome message here
    ```

7. Send message

    ```
    .
    ```

    Just a single period on a line by itself lets the server know you are done.

    Go check your inbox!

### The Easy Way

A bash one liner using the "sendmail" command:

```
echo "Subject: yeah cool\n\n my super rad message" | \
  sendmail \
    -F "John Doe <jdoe@somesite.com>" \
    -f jdoe@somesite.com \
    youremail@example.com.com
```

### Notes

    Depending on who you spoofed, it may or may not be in spam.

    In practice many mail providers will refuse mail from home IP addresses.

    You will generally have more success from an office or university. You
    also will only be able to spoof domains that don't have special settings
    on their domain.

    If spoofing actually works for a real domain like this, it is a sign
    they have a significant security hole. Point it out to them and collect
    your first bug bounty as a security researcher!

    Please don't abuse this, and be mindful of the laws in your local area ;)

