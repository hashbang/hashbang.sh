#!/bin/sh
# This script first and foremost attempts to be POSIX compliant.
# Secondly, it attempts to be compatible with as many shell implementations as
# possible to provide an easy gateway for new users.

# If we're using bash, we do this
if [ "x$BASH" != "x" ]; then
	shopt -s extglob
	set -o posix
fi

bail() {
    echo " If you think this is a bug, please report it to ";
    echo " -> https://github.com/hashbang/hashbang.sh/issues/";
    echo " ";
    echo " The installer will not continue from here...";
    echo " ";
    exit 1
}
checkutil() {
	printf " * Checking for $1..."
	which $1 >/dev/null
	if [ $? -eq 0 ]; then
		printf "ok!\n";
		return 0;
	else
		printf "not found!"
		return 1
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
}

clear;
echo "   _  _    __  ";
echo " _| || |_ |  |  Welcome to #!. This network has three rules:";
echo "|_  __  _||  | ";
echo " _| || |_ |  |  1. When people need help, teach. Don't do it for them";
echo "|_  __  _||__|  2. Don't use our resources for closed source projects";
echo "  |_||_|  (__)  3. Be excellent to each other";
echo "               ";
echo " We are a diverse community of people who love teaching, and learning.";
echo " Putting a #! at the beginning of a \"script\" style program tells a ";
echo " computer that it needs to \"do something\" or \"execute\" this file.";
echo " Likewise, we are a community of people that like to \"do stuff\".";
echo " ";
echo " If you like technology, and you want to learn to write your first";
echo " program, learn to use Linux, or even take on interesting challenges";
echo " with some of the best in the industry, you are in the right place.";
echo "";
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
echo " -------------------------------------------------------------------- ";
echo " ";

echo " First, your system must be properly configured with the required";
echo " utilities and executables.";
echo " We will perform a short check for those now.";
echo " NOTE: If you see this message, it is likely because something is";
echo " not installed. Check the list below, and install any";
echo " missing applications.";

checkutil expr || exit 1
checkutil gpg || exit 1
( checkutil ssh-keygen && checkutil ssh ) || exit 1
( checkutil curl || checkutil busybox ) || exit 1

clear;

echo " ";
echo " ";
echo " -------------------------------------------------------------------- ";
echo " ";


echo " To create your account we first need a username.";
echo " ";
echo " A valid username must:";
echo "  * be between between 1-31 characters long";
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
    if echo "$input" | grep -E "^[a-z][a-z0-9]{0,30}$" >/dev/null; then
        username=$input
    else
        echo " ";
        echo " \"$input\" is not a valid username."
        echo " Please read the instructions and try again"
        echo " ";
    fi
done

echo " ";
echo " -------------------------------------------------------------------- ";
echo " ";
echo " Now we will need an SSH Public Key."
echo " ";
echo " SSH Keys are a type of public/private key system that let you identify ";
echo " yourself to systems like this one without ever sending your password ";
echo " over the internet, and thus by nature we won't even know what it is";
echo " ";

for keytype in id_rsa id_dsa id_ecdsa id_ed25519; do
    if [ -e ~/.ssh/$keytype.pub  ]; then
        if ask " We found a public key in [ ~/.ssh/$keytype.pub ]. Use this key?" Y; then
            keyfile="~/.ssh/$keytype.pub"
            key=$(cat ~/.ssh/$keytype.pub)
            break
        fi
    fi
done

if [ "x$key" = "x" ]; then
    if ask " Do you want us to generate a key for you?" Y; then
        ssh-keygen -t rsa -C "#! $username"
        keyfile="~/.ssh/id_rsa.pub"
        key=$(cat ~/.ssh/id_rsa.pub)
    fi
fi



while [ "x$key" = "x" ]; do
    echo " ";
    echo " Please enter path to SSH Public Key: ";
    read keyfile
    if [ -f $keyfile ] ; then
        ssh-keygen -l -f $keyfile > /dev/null 2>&1
        if [ $? -eq 0 ]; then
            key=$(cat $keyfile)
        else
            echo " ";
            echo " \"$keyfile\" is not a valid SSH Public Key";
        fi
    else
       echo " ";
       echo " \"$keyfile\" does not exist";
    fi
done

# Insert functions to allow user to select from multiple hosts here
# hardcoding all users to va1 for now
host="va1"

if [ "x$key" != "x" -a "x$username" != "x" ]; then
    echo " ";
    echo " -------------------------------------------------------------------- ";
    echo " ";
    echo " We are going to create an account with the following information";
    echo " ";
    echo " Username: $username";
    echo " Public Key: $keyfile";
    echo " Host: $host";
    echo " ";
    if ask " Does this look correct?" Y ; then
        echo " ";
        echo " Creating your account...";
        echo " ";

	if curl -f -H "Content-Type: application/json" \
        -d "{\"user\":\"$username\",\"key\":\"$key\",\"host\":\"$host\"}" \
        https://hashbang.sh/user/create; then
            echo " ";
            echo " Account Created!"
            echo " ";
        else
            echo " ";
            echo " Account creation failed.";
            echo " Something went awfully wrong and we couldn't create an account for you.";
            bail
        fi
        if ask " Would you like to add trusted/signed keys for our servers to your .ssh/known_hosts?" Y ; then
            echo " "
            echo " Downloading GPG keys"
            echo " "
            gpg --recv-keys 0xD2C4C74D8FAA96F5
            echo " "
            echo " Downloading key list"
            echo " "
            data="$(curl -s https://hashbang.sh/static/known_hosts.asc)"
            printf %s "$data" | gpg --verify
            if [ ! $? -eq 0 ]; then
                echo " "
                echo " Unable to verify keys"
                echo " The installer will not continue from here..."
                echo " "
                exit 1
            fi
            printf %s "$data" | grep "hashbang.sh" >> ~/.ssh/known_hosts
            echo " "
            echo " Key scanned and saved"
            echo " "
        fi

        if ask " Would you like an alias (shortcut) added to your .ssh/config?" Y ; then
            printf "\nHost hashbang\n  HostName ${host}.hashbang.sh\n  User %s\n  IdentityFile %s\n" \
							"$username" "$keyfile" \
            >> ~/.ssh/config
            echo " You can now connect any time by entering the command:";
            echo " ";
            echo " > ssh hashbang";
        else
            echo " You can now connect any time by entering the command:";
            echo " ";
            echo " > ssh ${username}@${host}.hashbang.sh";
        fi

        echo " ";
    fi

    if ask " Do you want us to log you in now?" Y; then
        ssh ${username}@${host}.hashbang.sh
    fi
fi
# exit [n]. if [n] is not specified, then exit shall use the return code of the
# last command.
exit 0
