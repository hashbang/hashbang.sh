#!/bin/bash
shopt -s extglob

function ask {
    while true; do

        if [ "${2:-}" = "Y" ]; then
            prompt="Y/n"
            default=Y
        elif [ "${2:-}" = "N" ]; then
            prompt="y/N"
            default=N
        else
            prompt="y/n"
            default=
        fi

        # Ask the question
        read -p "$1 [$prompt] " REPLY

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
echo "   -> https://github.com/lrvick/hashbang.sh/issues/";
echo " ";
read -n1 -s -p " If you agree with the above and wish to continue, hit [Enter] ";

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

until [[ -n $username ]]; do
    printf " Username: ";
    read input;
    if [[ $input = [[:lower:]]+([[:alnum:]]) && $input -le 31 ]]; then
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

if [[ -z $key ]]; then
    if ask " Do you want us to generate a key for you?" Y; then
        ssh-keygen -t rsa -C "#! $username"
        keyfile="~/.ssh/id_rsa.pub"
        key=$(cat ~/.ssh/id_rsa.pub)
    fi
fi



until [[ -n $key ]]; do
    echo " ";
    echo -n " Please enter path to SSH Public Key: ";
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

if [[ -n $key && -n $username ]]; then
    echo " ";
    echo " -------------------------------------------------------------------- ";
    echo " ";
    echo " We are going to create an account with the following information";
    echo " ";
    echo " Username: $username";
    echo " Public Key: $keyfile";
    echo " ";
    if ask " Does this look correct?" Y ; then
        echo " ";
        echo " Creating your account...";
        echo " ";
        curl -H "Content-Type: application/json" \
        -d "{\"username\":\"$username\",\"key\":\"$key\"}" \
        http://new.hashbang.sh/
        echo -e "\nHost hashbang\nHostName hashbang.sh\nUser $username\n ForwardAgent yes" \
        >> ~/.ssh/config
        echo " ";
        echo " Account Created!";
        echo " ";
        echo " You can now connect any time by entering the command:";
        echo " ";
        echo " > ssh $username@hashbang";
        echo " ";
    fi

    if ask " Do you want us to log you in now?" Y; then
        ssh $username@hashbang.sh
    fi
fi
