---
$title: Join Us!
$titles:
  nav: Docs
  side: Welcome
$path: /
$category: Get started
$order: 0
---
## Create an Account

Create an account on #! and get instant access to our IRC Network, a shell to
play around with and a great community of people.

##### Dependencies

- curl
- jq

##### Command
```bash
key=$(cat ~/.ssh/id_rsa.pub)
curl https://userdb.hashbang.sh/passwd -H Content-Type:application/json -d '{"name": "'"$USER"'", "host": "de1.hashbang.sh", "data": {"shell": "/bin/bash", "ssh_keys": ["'"$key"'"]}}' | jq
```

### What's going on here?

This curl script will create a user on our servers using your current username.
If it's not already taken, it's yours! We are pulling your key from your public
key and making it so that you can immediately drop in. Once your account has
been created, just `ssh $USER@de1.hashbang.sh` and your in!
