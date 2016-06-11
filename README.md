# hashbang.sh #

  <http://github.com/hashbang/hashbang.sh>

## About ##

This is the source for the http://hashbang.sh website including any static
files we wish to make available on it.

## Deployment

1. Push latest code to master branch

    ```
    git push origin master
    ```

2. Restart systemd service on production machine

    ```
    ssh core@hashbang.sh sudo systemctl restart hashbangs-http
    ```
