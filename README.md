## Motivate

Automate configure CentOS7.x or Fedora OS environment using Shell script to deploy.

## How to use it

Here, we support `apps | config | tools` related subcommands.

* `apps` means it will install all softwares or RPM package after modifying file in `config/pkgs/`.
* `config` means it will configure user's option files, such as: vimrc, bashrc, etc.
* `tools` means it will install all **Shell** script as useful tools to use.

Use below following code to deploy:
```
# Install all softwares or RPM package after modifying file in `config/pkgs/`
[yancy@asus os-env-config]$ ./deploy apps

# Configure user's option files for root user, use ./deploy config normal for normal user.
[yancy@asus os-env-config]$ ./deploy config root

... ...
```
