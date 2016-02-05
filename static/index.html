-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA512

#!/bin/sh
<<\EOF
<!--
  Hey, you found the source code!

  That is a sign you hopefully know better than to blindly run unknown commands
  from the internet and/or are a curious person. We like you already.

  What this command will actually do, is set you up with a free "shell" account
  on one of our servers, that you can use as you see fit. It will also set you
  up with email, IRC, and other things on your shell, so you can keep in touch
  and learn/make awesome things with us.

  Don't trust us? Good! You probably don't know us (yet) so you shouldn't.

  To help address this we GPG sign this shell-setup script so you can verify
  it has not been changed by a third party before you run it by doing:

  > gpg --verify <(curl https://hashbang.sh)

  The safest method of running a script from a source you don't trust is to:


  Download and verify integrity with GnuPG
  > gpg --recv-keys 0xD2C4C74D8FAA96F5
  > curl https://hashbang.sh | gpg -o hashbang.sh

  Inspect source code
  > less hashbang.sh

  Run
  > chmod +x hashbang.sh
  > ./hashbang.sh

  As an advanced alternative you can bypass using this script and hit our user
  provisioning API directly with an SSH Public Key and desired username:

  > curl https://hashbang.sh/server/stats
  { "server.hashbang.sh": { infos ...}, ... }
  > curl -d '{"user":"someuser","key":"'"$(cat ~/.ssh/id_rsa.pub)"'","host":"someHost.hashbang.sh"}' -H 'Content-Type: application/json' https://hashbang.sh/user/create

  We look forward to seeing you on the other side.

  Note: #! has never provided user data to any government agency.
        Pay close attention to the removal of this notice.

- -->
<!DOCTYPE html>
<html lang="en">
  <head>
    <title>&lrm;</title>
    <meta name="viewport" content="initial-scale = 1, maximum-scale=1, user-scalable = 0"/>
    <meta name="apple-mobile-web-app-capable" content="yes"/>
    <meta name="apple-mobile-web-app-status-bar-style" content="black"/>
    <meta name="HandheldFriendly" content="true"/>
    <meta name="MobileOptimized" content="320"/>
    <link href='https://fonts.googleapis.com/css?family=Montserrat' rel='stylesheet' type='text/css'>
    <style type="text/css">
        * {
        text-indent:-9999px;
        -webkit-touch-callout: none;
        -webkit-user-select: none;
        -khtml-user-select: none;
        -moz-user-select: none;
        -ms-user-select: none;
        user-select: none;
      }
      html {
        background:black;
        color:black;
      }
      body {
        display:block;
        position:fixed;
        top:50%;
        left:50%;
        margin-top:-160px;
        margin-left:-160px;
        width:320px;
        height:320px;
        color:#DDD;
        overflow:hidden;
      }
      h1 {
        text-indent:0px;
        font-family: 'Montserrat', cursive;
        position:absolute;
        top:-50px;
        left:10px;
        right:0px;
        line-height:0px;
        font-size:280px;
      }
      a {
        color:white;
        text-decoration:none;
      }
      code {
        text-indent:0px;
        display:block;
        position:absolute;
        bottom:0px;
        left:0px;
        right:0px;
        text-align:center;
        font-size:20px;
      }
    </style>
  </head>
  <body>
    <script>
      window.location="#!"
      var link = document.createElement("link");
      link.type = "image/png";
      link.rel = "icon";
      link.href = "data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAABAAAAAQAQAAAAA3iMLMAAAABGdBTUEAALGPC/xhBQAAACBjSFJNAAB6JgAAgIQAAPoAAACA6AAAdTAAAOpgAAA6mAAAF3CculE8AAAAAmJLR0QAAd2KE6QAAAAYSURBVAjXY2CAAck+EKp/B0II9gMoGwYA4+MJkeae/NUAAAAldEVYdGRhdGU6Y3JlYXRlADIwMTQtMDUtMTdUMTM6MzI6MTMtMDQ6MDB7pieOAAAAJXRFWHRkYXRlOm1vZGlmeQAyMDE0LTA1LTE3VDEzOjMxOjQ4LTA0OjAwqyt+rwAAAABJRU5ErkJggg==";
      document.getElementsByTagName("head")[0].appendChild(link);
    </script>
    <h1>#!</h1>
    <a href="view-source:https://hashbang.sh">
      <code>curl hashbang.sh | gpg > hashbang.sh</code>
    </a>
  </body>
</html>
<!--
EOF
#!/bin/sh
# This script first and foremost attempts to be POSIX compliant.
# Secondly, it attempts to be compatible with as many shell implementations as
# possible to provide an easy gateway for new users.

# If we're using bash, we do this
if [ "x$BASH" != "x" ]; then
	shopt -s extglob
	set -o posix
	# Bail out if any curl fails
	set -o pipefail
fi

# POSIX doesn't specify mktemp(1).
# This was checked against manpages for:
#  - OpenBSD: http://www.openbsd.org/cgi-bin/man.cgi/OpenBSD-current/man1/mktemp.1?query=mktemp&sec=1
#  - FreeBSD: https://www.freebsd.org/cgi/man.cgi?query=mktemp&sektion=1
#  - OS X 10.9: https://developer.apple.com/library/mac/documentation/Darwin/Reference/ManPages/man1/mktemp.1.html
#  - Todd Miller's mktemp: http://www.mktemp.org/manual.html
#  - Solaris 10: https://docs.oracle.com/cd/E23823_01/html/816-5165/mktemp-1.html
#  - HP Tru64 UNIX: https://web.archive.org/web/20120117215524/http://h30097.www3.hp.com/docs/base_doc/DOCUMENTATION/V51B_HTML/MAN/MAN1/0251____.HTM
#  - GNU coreutils: https://www.gnu.org/software/coreutils/manual/html_node/mktemp-invocation.html#mktemp-invocation
tmp_hb_dir="$(mktemp -d -t hashbang.XXXXXX)"
trap 'rm -rf -- "${tmp_hb_dir}"' EXIT

# Fetch host data for later.
# If this fails there is no point in proceeding
host_data="${tmp_hb_dir}/server_stats"
curl -sfH 'Accept:text/plain' https://hashbang.sh/server/stats > "$host_data"
err=$?
echo >> "$host_data"

bail() {
	echo " "
	echo " If you think this is a bug, please report it to ";
	echo " -> https://github.com/hashbang/hashbang.sh/issues/";
	echo " ";
	echo " The installer will not continue from here...";
	echo " ";
	exit 1
}
[ ! $err -eq 0 ] && bail

# check if can write to file
checkutil() {
	printf '%s' " * Checking for $1..."
	if which "$1"; then
		printf "ok!\n";
		return 0;
	else
		printf "not found!\n";
		return 1;
	fi
}

# This function can be called with two parameters:
#
# First is obligatory, and is the "question posed".
# For instance, one may ask "is pizza your favorite meal?", to which the
# responder may answer Y (yes) or N (no).
#
# Second parameter is optional, and can be either Y or N.
# The reasoning behind this is to have a default answer to the question,
# resulting in the responder being able to simple press [enter] and skip
# pressing Y or N, giving the default answer instead.
ask() {
	while true; do
		prompt=""
		default=""

		if [ "${2}" = "Y" ]; then
			prompt="Y/n"
			default=Y
		elif [ "${2}" = "N" ]; then
			prompt="y/N"
			default=N
		else
			prompt="y/n"
			default=
		fi

		# Ask the question
		echo " "
		printf "%s [%s] " "$1" "$prompt"
		read REPLY

		# Default?
		if [ -z "$REPLY" ]; then
			REPLY=$default
		fi

		# Check if the reply is valid
		case "$REPLY" in
			Y*|y*) return 0 ;;
			N*|n*) return 1 ;;
		esac

	done
	echo " "
}

# generate ssh kypair
makekey() {
	( checkutil ssh-keygen && checkutil ssh ) || bail
	if [ ! -e "$1" ]; then
		ssh-keygen -t rsa -C "#! $username" -f "$1"
		if [ ! $? ]; then
			echo " Unable to make key with that location"
		else
			chmod 600 "$1"
			echo " Successfully generated key"
			return
		fi
	else
		if ask " Unable to generate key, do you want to delete the file?" N; then
			rm -f "$1"
			if [ ! $? ]; then
				echo " Unable to delete file, resetting"
			else
				echo " File deleted"
				ssh-keygen -t rsa -C "#! $username" -f "$1"
				if [ ! $? ]; then
					echo " Unable to generate key, resetting"
				fi
			fi
		else
			echo " Unable to make key with that path, resetting"
		fi
	fi
}

clear;
echo "   _  _    __ ";
echo " _| || |_ |  |  Welcome to #!. This network has three rules:";
echo "|_  __  _||  | ";
echo " _| || |_ |  |  1. When people need help, teach. Don't do it for them";
echo "|_  __  _||__|  2. Don't use our resources for closed source projects";
echo "  |_||_|  (__)  3. Be excellent to each other";
echo " ";
echo " We are a diverse community of people who love teaching and learning.";
echo " Putting a #! at the beginning of a \"script\" style program tells a ";
echo " computer that it needs to \"do something\" or \"execute\" this file.";
echo " Likewise, we are a community of people that like to \"do stuff\".";
echo " ";
echo " If you like technology, and you want to learn to write your first";
echo " program, learn to use Linux, or even take on interesting challenges";
echo " with some of the best in the industry, you are in the right place.";
echo " ";
echo " The following will set you up with a \"shell\" account on one of our";
echo " shared systems. From here you can run IRC chat clients to talk to us,";
echo " access to personal file storage and web hosting, and a wide range of";
echo " development tools. ";
echo " ";
echo " Everything should work perfectly, unless it doesn't";
echo " ";
echo " Please report any issues here: ";
echo "   -> https://github.com/hashbang/hashbang.sh/issues/";
echo " ";
printf " If you agree with the above and wish to continue, hit [Enter] ";
read _
clear

echo " ";
echo " ";
printf -- ' %72s\n' | tr ' ' -;
echo " ";

echo " First, your system must be properly configured with the required";
echo " utilities and executables.";
echo " We will perform a short check for those now.";
echo " NOTE: If you see this message, it is likely because something is";
echo " not installed. Check the list below, and install any";
echo " missing applications.";

checkutil expr || bail
checkutil gpg || bail
( checkutil ssh-keygen && checkutil ssh ) || bail
checkutil curl || bail
clear;

echo " ";
echo " ";
printf -- ' %72s\n' | tr ' ' -;
echo " ";


echo " To create your account we first need a username.";
echo " ";
echo " A valid username must:";
echo "  * be between between 1 and 31 characters long";
echo "  * consist of only 0-9 and a-z (lowercase only)";
echo "  * begin with a letter";
echo " ";
echo " Traditional unix usernames are first initial, optional middle initial,";
echo " and the first 6 characters of the last name, but feel free to use ";
echo " whatever you want";
echo " ";

while [ "x$username" = "x" ]; do
	printf " Username: ";
	read input;

	# Keep in sync with the description and
	#  https://github.com/hashbang/provisor/blob/master/provisor/utils.py#L77
	if echo "$input" | grep -E "^[a-z][a-z0-9]{0,30}$" >/dev/null; then
		username="$input"
	else
		echo " ";
		echo " \"$input\" is not a valid username."
		echo " Please read the instructions and try again"
		echo " ";
	fi
done

echo " ";
printf -- ' %72s\n' | tr ' ' -;
echo " ";
echo " Now we will need an SSH Public Key."
echo " ";
echo " SSH Keys are a type of public/private key system that let you identify";
echo " yourself to systems like this one without ever sending your password ";
echo " over the internet, and thus by nature we won't even know what it is";

for keytype in id_ed25519 id_ecdsa id_rsa id_dsa; do
	if [ -e ~/.ssh/${keytype}.pub ] && [ -e ~/.ssh/${keytype} ]; then
		if ask " We found a public key in [ ~/.ssh/${keytype}.pub ]. Use this key?" Y; then
			private_keyfile="${HOME}/.ssh/${keytype}"
			public_key="$(cat ~/.ssh/${keytype}.pub)"
			break
		fi
	fi
done

if [ "x$public_key" = "x" ]; then
	echo " No SSH key for login to server found, attempting to generate one"
	while true; do
		echo " "
		printf " Path to new or existing connection key (~/.ssh/id_rsa): "
		read private_keyfile
		if [ "x$private_keyfile" = "x" ]; then
			private_keyfile="$HOME/.ssh/id_rsa"
		fi
		private_keyfile=$(echo "$private_keyfile" | sed "s@~@$HOME@")
		echo " "
		if [ ! -e "$private_keyfile" ] && [ ! -e "$private_keyfile.pub" ]; then
			if ask " Do you want us to generate a key for you?" Y; then
				if [ -e "$private_keyfile" ]; then
					if ask " File exists: $private_keyfile - delete?" Y; then
						rm "$private_keyfile"
						if [ -e "${private_keyfile}.pub" ]; then
							rm "${private_keyfile}.pub"
						fi
						makekey "$private_keyfile"
					fi
				else
					makekey "$private_keyfile"
				fi
				public_key=$(cat "${privat_keyfile}.pub")
			fi
		elif [ ! -e "$private_keyfile" ] && [ -e "${private_keyfile}.pub" ]; then
			if ask " Found public keyfile, missing private. Do you wish to continue?" N; then
				echo " Using public key ${private_keyfile}.pub"
				break
			else
				echo " Resetting"
			fi
		elif [ ! -e "${private_keyfile}.pub" ]; then
			echo " Unable to find public key ${private_keyfile}.pub"
		else
			echo " Using public key ${private_keyfile}.pub"
			break
		fi
	done
	public_key=$(cat "${private_keyfile}.pub")
fi

n=0
echo
printf -- ' %72s\n' | tr ' ' -;
echo
echo " Please choose a server to create your account on."
echo
printf -- ' %72s\n' | tr ' ' -;
printf -- '  %-1s | %-4s | %-36s | %-8s | %-8s\n' \
	"#" "Host" "Location" "Users" "Latency"
printf -- ' %72s\n' | tr ' ' -;
while IFS="|" read host _ location current_users max_users; do
	host=$(echo "$host" | sed 's/\([a-z0-9]\+\)\..*/\1/g')
	latency=$(ping -c 1 "${host}.hashbang.sh" | head -n2 | tail -n1 | sed 's/.*=//g')
	n=$((n+1))
	printf -- '  %-1s | %-4s | %-36s | %8s | %-8s\n' \
		"$n" \
		"$host" \
		"$location" \
		"$current_users/$max_users" \
		"$latency"
done < "$host_data"
printf -- ' %72s\n' | tr ' ' -;

echo
while true; do
	printf ' Enter Number 1-%i : ' "$n"
	read choice
	number=$(echo "$choice" | awk '$0 ~/[^0-9]/ { print "no" }')
	if [ "$number" != "no" ] && \
	   [ "$choice" -ge 1 ] && \
	   [ "$choice" -le $n ]; then
		break;
	fi
done
host=$(head -n "$choice" "$host_data" | tail -n1 | cut -d \| -f1)

if [ "x$public_key" != "x" -a "x$username" != "x" ]; then
	echo " ";
	printf -- ' %72s\n' | tr ' ' -;
	echo " ";
	echo " We are going to create an account with the following information";
	echo
	echo " Username: $username";
	echo " Public Key: ${private_keyfile}.pub";
	echo " Host: $host";
	echo
	if ask " Does this look correct?" Y ; then
		echo
		printf ' Creating your account... '
		format="{\"user\":\"$username\",\"key\":\"$public_key\",\"host\":\"$host\"}"
		headers="${tmp_hb_dir}/create_headers"
		output=$(curl -H "Content-Type: application/json" -d "$format" https://hashbang.sh/user/create -D "$headers" 2>&-)
		status=$(head -n 1 "$headers" | awk '{print $2}')
		if [ "$status" -eq 200 ]; then
			echo " Account Created!"
		else
			echo " Account creation failed: $(echo "$output" | sed -e 's/.*\"message\": \?\"\([^\"]\+\)\".*/\1/')";
			bail
		fi

		if ask " Would you like to add trusted/signed keys for our servers to your .ssh/known_hosts?" Y ; then
			echo " Downloading GPG keys"
			echo " "
			gpg --keyserver keys.gnupg.net \
			    --recv-keys 0xD2C4C74D8FAA96F5
			echo " "
			echo " Downloading key list"
			echo " "
			curl -s 'https://hashbang.sh/static/known_hosts.asc' |
			    gpg --decrypt --output "${tmp_hb_dir}/known_hosts"

			if [ ! $? -eq 0 ]; then
				echo " "
				echo " Unable to verify keys"
				bail
			fi
			cat "${tmp_hb_dir}/known_hosts" >> ~/.ssh/known_hosts
			echo " "
			echo " Keys downloaded and saved"
		fi

		if ask " Would you like an alias (shortcut) added to your .ssh/config?" Y ; then
			printf '\nHost hashbang\n  HostName %s\n  IdentitiesOnly yes\n  User %s\n  IdentityFile %s\n' \
			       "${host}" "$username" "$private_keyfile" \
			>> ~/.ssh/config
			echo " You can now connect any time by entering the command:";
			echo " ";
			echo " > ssh hashbang";
		else
			echo " You can now connect any time by entering the command:";
			echo " ";
			echo " > ssh ${username}@${host}";
		fi

	else
		echo " Please re-run script to make corrections.";
		bail
	fi

	if ask " Do you want us to log you in now?" Y; then
		if [ -e "$private_keyfile" ]; then
			ssh -i "$private_keyfile" "${username}@${host}"
		else
			ssh "${username}@${host}"
		fi
	fi
fi

# exit [n]. if [n] is not specified, then exit shall use the return code of the
# last command.
exit 0
-----BEGIN PGP SIGNATURE-----

iQIcBAEBCgAGBQJWwKiIAAoJENLEx02Pqpb1TS0P/27soX4cddnAKv4RxYquceW2
WRCJbQkEfjJTHBMn0K0YEYYOEPK8kXZxMX/J0i01+yojDUiPVFLIjqkxamnSMDun
ITkdFB482TGDEq06J2PPNhb7ZwAzWrqL6iRDg2xm4KXFduDjBDnSnzqyY3SLhPVX
1Xu55RLe2p3AKHMXDdYjE9BZ7DXnsLg38GdWG4N7QBA0WR/Og5g5IQfR8iHQRn7r
rjk++YcPPE7qw3TUNGwwxbIt1KnS9aNWlTmCfVsYu3krHZPfdBt84+bJhDdImdxY
v32qg3oBCrG5hsEjzwt/pZSsF8qwh3E/VyUEUPEWTJagqwHGbppHviSd/pH904nU
my/qGBnUac0ytp36q3dB7p5TQXmET9n/U4D6/YkE8Et0GRrxHGY+FtCdYN/KZdMr
cAZienrQhN6bzu8W9y4uooTnFD89PvFu590yVHJEV4LahfK31CmyOYOUioYLBhzT
yymUjmdmhrX+KJr4IYwzl2Og2IFQhP3a5WZlwDuoWdbuQpqr4eKIzddqt2/eVSlR
PcTCvbAXksM6nutQQMDXIMJ7Y1gh0Tyk+JeaPgSilUNT7HhTvI7ZnowqhTbLJprh
N+GVL3U9XRBPSIshHIE4N5+m/zlhhq+3oe7ZdXYhiLBHJ9fyowWl6bOTJOjrur7n
3okGVR2s0Ro6LR5HPSKa
=LA82
-----END PGP SIGNATURE-----
