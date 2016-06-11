# hashbang.sh #

  <http://github.com/hashbang/hashbang.sh>

## About ##

This is the source for the public facing shell request process for hashbang.sh

It consists of:

 - A simple static html landing page ( https://hashbang.sh )
 - A ssh server that accept invite codes and sets up accounts (ssh hashbang.sh)

The sign-up flow is as follows:

1. User visits https://hashbang.sh which instructs them to `ssh hashbang.sh`
2. User opens a terminal and types `ssh hashbang.sh`
3. User verifies server/sshkey/username, edits if needed, and submits
4. Server creates account, and informs user of command to connect
5. User connects to their shell via command like `ssh user@ny1.hashbang.sh`

## Current Features ##

 - None! The above is currently all lies, and WIP.
 - The below is also all lies, but how it should work when complete

## Deployment

1. Push latest code to master branch

    ```
    git push origin master
    ```

2. Restart systemd service on production machine

    ```
    ssh core@hashbang.sh sudo systemctl restart hashbangsh
    ```
