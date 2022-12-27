# Enhanced ZSH Modular System

## What is this?

**ezsh** (Enhanced ZSH or EZ SH), started as EBv1 (Enhanced BASH), then EBv2, and finally EBv3 (which is still available) was a theoretical utility to help with complex command line arguments which became several mini scripts cluttered throughout my home directory for quick and easy commands to run routine tasks as a system administrator; whereas now **ezsh** has evolved over a long period of time for ease of use, manipulation, and portability. Although this particular version is still fairly new, over the past decade I have been collecting, building, customizing and designing scripts to make the terminal experience easier to use by reducing mundane commands with long arguments as well as make it universal between different distributions of Linux as possible.

Previous versions started with scripting on [Oracle Linux](https://www.oracle.com/linux/) (RHEL distro), which later switched to [Red Hat](https://www.redhat.com/) 6. At home my primary distro to use was [Debian](https://www.debian.org/) Linux, and finally experimented with [Gentoo](https://www.gentoo.org/) and [Slackware](https://www.slackware.com/). Now I primarily use Red Hat with ZSH installed [ZSH](https://zsh.sourceforge.net/) on my home lab.

Because the majority of the development of this script has been from home (since it seems out of 1200 people at work there is always a fire to put out), much of my testing has been done on a [custom made](https://www.linuxfromscratch.org/) Debian distro and Red Hat. I have researched other systems by using [Google](https://www.google.com/), and [Stack Overflow](https://www.stackoverflow.com/), as well as talked with other admins about compatibility, including fetching a new version on my work PC once a week.

Something very important to say here, although I have came up with the concept of this modular approach, I have not 100% created each of these scripts many have come from [Awesome Shell](https://github.com/alebcay/awesome-shell), [DylanRaps](https://github.com/dylanaraps), and many contributors from [Stack Overflow](https://www.stackoverflow.com/). I have created many of them myself, and I will continue to build this script, I will be going through and giving credit to each of those people for their scripts. This was once in mind just a way to keep some of the scripts I found throughout the internet and use them for my personal use. I believe this concept is too good of an idea to let it not be shared. If you are someone who has created one of the scripts in this, please let me know if you approve of me using and so I can give you credit where it is due.

## Installation

Because I started scripting this on Dec. 22, 2022 there is not install method at the moment. Using it is pretty simple. There are some things I have installed, such
as Oh-My-ZSH, and these other programs:

* unzip
* zip
* tar
* p7zip
* unrar
* gzip
* wget
* curl
* bc
* git

```sh
# This is for RHEL 9, if you are using Debian, or any other you may need to include those optional repos
sudo subscription-manager repos --enable codeready-builder-for-rhel-9-$(arch)-rpms
sudo yum install https://dl.fedoraproject.org/pub/epel/epel-release-latest-9.noarch.rpm -yq

# This is for Debian
sudo add-apt-repository universe

# This is for RHEL versions
sudo yum install zip unzip p7zip p7zip-plugins unrar gzip wget curl bc git

# This is for Debian versions
sudo apt install zip unzip p7zip-full p7zip-rar unrar gzip wget curl bc git

git clone https://github.com/girls-whocode/ezsh.git
cd ezsh
source ezsh
```

## Usage

So far, I have completed:

* backup - quickly makes a centralized backup of a file or folder with a timestamp attached
* dir jump - quickly jump to one of the last 15 directories you've visited
* log viewer - Colorize many common elements in a log file
* empty - Zeros out a file without changing permissions or creates a new file if it doesn't exist
* extract - Extracts several different types of archives
