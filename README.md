![Wiris](assets/logo-wiris.png)![Moodle](assets/logo-moodle.png)&nbsp;&nbsp;&nbsp;![Docker](assets/logo-docker.png) 

# wmd: a local development environment tool for the Wiris Moodle plugins suite

**wiris-moodle-docker**, `wmd` for short, is the perfect tool to try the whole set of Wiris math & science plugins. It helps you install on your computer a Moodle instance with the WIRIS plugins suite installed and some dummy content.

_This project has been created by the Wiris Engineering Team and is aimed at Moodle plugins developers and Moodle users interested to try the WIRIS Moodle Math & Science set._

**Index of contents**

- [Purpose](#purpose)
- [Features](#features)
- [User's guide](#users-guide)
    - [Before you begin](#before-you-begin)
    - [Quick start](#quick-start)
    - [How it works](#how-it-works)
    - [Scripts in action](#scripts-in-action)
    - [Update the PHP integration](#update-the-php-integration)
    - [Update the DB](#update-the-db)
- [FAQ](#faq)
- [Wiris Moodle math & science set](#wiris-moodle-math--science-plugins-set)
- [Technical Support or Questions](#technical-support-or-questions)
- [Privacy policy](#privacy-policy)
- [License](#license)

## Purpose

**wmd** is a collection of scripts aimed at Moodle Plugin developers to setup automatically a testing environment for Moodle that includes the Wiris math & science plugin set.

This tool depends heavily on [moodle-docker: Docker Containers for Moodle Developers](https://github.com/moodlehq/moodle-docker/), that does all the heavy-lifting to manage the Docker images.

## Features

* Zero-configuration approach.
* Zero-maintenance.
* Supports all [Moodle versions](https://github.com/moodle/moodle/branches/all).
* Supports all PHP versions.
* Supports all [MathType and Quizzes Moodle plugins](https://moodle.org/plugins/browse.php?list=set&id=66) versions.
* Behat/Selenium configuration for Firefox and Chrome.
* Catch-all smtp server and web interface to messages using MailHog.
* All PHP Extensions enabled configured for external services (e.g. solr, ldap)
* Downloads code from github with both `ssh` or `https`.
* Uses the branch name as source to download Moodle and WIRIS plugins.
* Support both Linux and MacOS; (Windows, coming soon).

## User's guide

Follow these instructions to set up your computer. 

### Before you begin

Install these on your computer:

* Git
* [Docker](https://docs.docker.com) and [Docker Compose](https://docs.docker.com/compose/) installed

> **Tip**: Check the excellent [tutorial on how to install Docker on Ubuntu](https://www.digitalocean.com/community/tutorials/how-to-install-and-use-docker-on-ubuntu-20-04) from the folks at Digital Ocean.

### Quick start

Firs step, will be to set up a path on your computer where the Moodle code will be downloaded to.

**A. Default settings**

We recommend you to add these values to your `.bashrc` file, so you don't need to set them again every time you use the tool.

```bash
# Recommended default values for 'wiris-moodle-docker'.
# Add this to your .bashrc file.
# More information at https://github.com/moodlehq/moodle-docker.

# 01. Set up path to all Moodles releases code, like '/var/www'.
# Required. 
export WEB_DOCUMENTROOT=/path/to/source/code

# 02. Set the Moodle branch to downlowad code from on the next install.
# Defaults to Moodle_39 if not set as environment variable.
# Recommended.
export WIRIS_MOODLE_BRANCH="MOODLE_310_STABLE"
# Recommended.
export MOODLE_DOCKER_WWWROOT=${WEB_DOCUMENTROOT}/${WIRIS_MOODLE_BRANCH}

# 03. Set whether you want to download the code from github using ssh (authenticated) or https. 
# Defaults to 'off' (https). Set to 'on' for 'ssh'.
# Note: you will need to set up your default ssh credentials on your profile at GitHub.
# For developers.
export WIRIS_MOODLE_MATHTYPE_DEV_MODE="on" 

# 04. Selenium will expose a VNC session on this port.
# Recommended.
export MOODLE_DOCKER_SELENIUM_VNC_PORT=5900
```

**B. Advanced settings**

There are some configuration settings that you may need to set from the Terminal, for the current session. 

```bash
# 01. Set the MathType plugins branch to downlowad code from on the next install.
# Defaults to 'main' if not set as environment variable.
# Optional, not needed.
export WIRIS_MOODLE_MATHTYPE_BRANCH="main" 

# 02. Set the Quizzes plugins branch to downlowad code from on the next install.
# Defaults to 'main' if not set as environment variable.
# Optional, not needed.
export WIRIS_MOODLE_QUIZZES_BRANCH="main"

# 03. Set the PHP version to install on the next build. 
# Defaults to PHP7_4 if not set as environment variable.
export MOODLE_DOCKER_PHP_VERSION="7.4"

# 04. To change the default browser for behat tests. 
# Defaults to 'chrome'. Set to 'firefox' for Firefox.
export MOODLE_DOCKER_BROWSER="chrome"
```

> **Note**: For more information about all these configuration settings, and a few more available, visit the [moodle-docker](https://github.com/moodlehq/moodle-docker/) documentation.

### How it works

There are three groups of commands, depending on which step on the installation you are: 

- `install` => `start` => `test`.

> **Note**: You'll need to execute them sequentially in order to work. Example: you can't `start` the Moodle instance if you don't run the `install` command, first.

**Command list**

| Command   | Description                                             | Subcommands       |
| --------- | ------------------------------------------------------- | ----------------- |
| `install` | Downloads the Moodle code to your computer              | `clean`, `delete` |
| `start`   | Starts a ready-to-use Moodle instance on your computer  | `restart`, `stop` |
| `test`    | Runs all available automated tests on behat and phpunit | `test-init` `test-behat` `test-phpunit` |

**01. Install**

Install downloads all the necessary files and dependencies to your local computer using `git`; including the last version of [moodle-docker](https://github.com/moodlehq/moodle-docker/) project.

```bash
# Set a Moodle version of your choice for this session.
export WIRIS_MOODLE_BRANCH="MOODLE_39_STABLE"

# Let's download everything from git.
$ ./bin/wiris-moodle-docker-install

# Subcommands: clean, delete.
# Deletes all WIRIS plugins both MathType and Quizzes; eventually, you could change the WIRIS_MOODLE_*_BRANCH values.
$ ./bin/wiris-moodle-docker-clean

# Removes the whole Moodle branch directory on the $WEB_DOCUMENTROOT folder.
$ ./bin/wiris-moodle-docker-delete
```

**02. Start**

It configures and starts the docker containers that will serve the Moodle instances as defined on the install step.

```bash
# Set a PHP version of your choice for this session.
export MOODLE_DOCKER_PHP_VERSION="7.2"

# Let's start the Moodle instance.
$ ./bin/wiris-moodle-docker-start

# Open http://localhost:8000 to access the Moodle instance.

# Subcommands: restart, stop.
# Restart containers.
$ ./bin/wiris-moodle-docker-restart
# Shut down containers.
$ ./bin/wiris-moodle-docker-stop
```

> **Notes:**
> - The Moodle intance is configured to listen on http://localhost:8000/.
> - Mailhog is listening on http://localhost:8000/_/mail to view emails which Moodle has sent out.
> - The admin username you need to use for logging in is admin by default. [Check the FAQ](#faq) section.

**03. Test**

Initializes behat and/or phpunits test environments and allows you to run all available tests for the WIRIS suite of Moodle plugins.

```bash
$ ./bin/wiris-moodle-docker-test

# Subcommands: init.
# Initializa the tests environments for both behat and phpunit testing: behat and phpunit.
$ ./bin/wiris-moodle-docker-test-init

# Then, you'll be able to run phpunit and behat tests of any plugin:
# Example: Run some behat tests by tag.
$ ./bin/wiris-moodle-docker-test-behat --tag filter_wiris

# Example: Run a phpunit tests.
$ ./bin/wiris-moodle-docker-test-phpunit --test auth/manual/tests/manual_test.php

# Or you can use these commands as moodle-docker
# See: https://github.com/moodlehq/moodle-docker#use-containers-for-running-phpunit-tests 
$ ./moodle-docker/bin/moodle-docker-compose exec -u www-data webserver php admin/tool/behat/cli/run.php -vvv --colors --tags=@filter_wiris

$ ./moodle-docker/bin/moodle-docker-compose exec webserver vendor/bin/phpunit auth/manual/tests/manual_test.php
```

**Using VNC to view running tests**

If `MOODLE_DOCKER_SELENIUM_VNC_PORT` is defined, selenium will expose a VNC session on the port specified so behat tests can be viewed in progress.

For example, if you set `MOODLE_DOCKER_SELENIUM_VNC_PORT` to 5900.

1. Download a VNC client: https://www.realvnc.com/en/connect/download/viewer/
2. With the containers running, enter 0.0.0.0:5900 as the port in VNC Viewer. You will be prompted for a password. The password is `'secret'`.
3. You should be able to see an empty Desktop. When you run any Behat tests a browser will popup and you will see the tests execute.


> **Notes:**
> 
> - The behat faildump directory is exposed at http://localhost:8000/_/faildumps/.
> - If you want to run phpunit tests with coverage report, use command: `./moodle-docker/bin/moodle-docker-compose exec webserver phpdbg -qrr vendor/bin/phpunit --coverage-text auth/manual/tests/manual_test.php`
> - If `MOODLE_DOCKER_SELENIUM_VNC_PORT` is defined, selenium will expose a VNC session on the port specified so behat tests can be viewed in progress; [more information](https://github.com/moodlehq/moodle-docker#using-vnc-to-view-behat-tests).

#### Run several Moodle instances simultaneously

By default, the script will load a single instance. If you want to run two
or more different versions of Moodle at the same time, you have to activate the environment variable `WIRIS_MOODLE_MULTIPLE` to `"on"`:

```bash
# Set to "on" if you want to run more than one container at the same time.
export WIRIS_MOODLE_MULTIPLE="on"
```

**Run another instances:**

If you want to run a new instance with a different Moodle or PHP version you must set new `WIRIS_MOODLE_BRANCH` and `MOODLE_DOCKER_PHP_VERSION` values, then follow the install and start commands, again.

**Stop and test an instance:**

If you want to stop an instance or run a test on an already started instance, change the value of the `WIRIS_MOODLE_BRANCH` variable to the corresponding instance, first.

```bash
export WIRIS_MOODLE_BRANCH="MOODLE_311_STABLE"

# [..] run the stop or test commands.
```

**How the instance port is calculated:**

The port exposed by each instance of Moodle is automatically configured following the next format:

- The first digit is 1.
- The next 4 digits will be based on the Moodle version.

 e.g for Moodle 3.9 the exposed port will be 10039. For Moodle 3.10 the exposed port will be 10310.

 VNC port follows a similar format:

- The first digit is 2.
- The next 4 digits will be based on the Moodle version.

 e.g for Moodle 3.9 the exposed port will be 20039. For Moodle 3.10 the exposed port will be 20310.

> **Notes:**
> 
> - Each version of Moodle can be instantiated only once.
> - If you reinstantiate the same Moodle version with a different PHP, the previous Moodle instance will be deleted.

**04. Connect to Data Base**

> Requirements: MySQL Workbench app.

Connect to the Moodle Docker Data Base on the localhost:

1. Create a TCP connection with the Data Base port to make it easier to access.

    Add the following code on the last line of the `db.mysql.yml` file:

    ```yml
    ports:
      - "127.0.0.1:3306:3306"
    ```

2. Open MySQL Workbench and create a new connection with the following parameters:

    * **Connection Method**: Standard(TCP/IP)
    * **Hostname**: localhost
    * **Port**: 3306
    * **Username**: moodle
    * **Password**: $MYSQL_PASSWORD environment variable
    * **Default Schema**: moodle

3. Test connection and, if the test results are positive, close the configuration.

4. Re-install and re-start the Wiris Moodle Docker instance. When ready open the Data Base connection.


### Scripts in action

```bash
# Set a Moodle version of your choice for this session.
export WIRIS_MOODLE_BRANCH="MOODLE_35_STABLE"
# Set a PHP version of your choice for this session.
export MOODLE_DOCKER_PHP_VERSION="7.1"

# Install: 
# Downloads Moodle, Moodle-docker and WIRIS plugins source code to $WEB_DOCUMENTROOT.
./bin/wiris-moodle-docker-install

# Starts the Moodle instance's containers, loads a dummy content db and serve it on http://localhost:8000.
./bin/wiris-moodle-docker-start

# Work with the Moodle instance's containers (see below).
# [..]

# Shut down containers.
./bin/wiris-moodle-docker-stop

# Restart containers; eventually, you could change the MOODLE_DOCKER_PHP_VERSION value.
./bin/wiris-moodle-docker-restart

# Initialize all test environments.
./bin/wiris-moodle-docker-test-init

# Examples: Run behat tests
./bin/wiris-moodle-docker-test-behat --tag filter_wiris
./bin/wiris-moodle-docker-test-behat --tag wiris_mathtype

# Example: Run phpunit tests
./bin/wiris-moodle-docker-test-phpunit --test auth/manual/tests/manual_test.php

# All-in-one: Initialize all environments and execute all available tests.
./bin/wiris-moodle-docker-test

# Install clean:
# Deletes all WIRIS plugins both MathType and Quizzes; eventually, you could change the WIRIS_MOODLE_*_BRANCH values.
./bin/wiris-moodle-docker-clean

# Install delete:
# Removes the whole Moodle branch directory on the $WEB_DOCUMENTROOT folder.
./bin/wiris-moodle-docker-delete

```

### Update the PHP integration

The [MathType Moodle filter plugin][filter] has a folder in the root called [`integration`](https://github.com/wiris/moodle-filter_wiris/tree/stable/integration) that contains a whole copy of the PHP backend of the MathType Web plugin.
Ideally, whenever that backend is updated, it should be updated in the filter plugin repository as well.
This section explains how to do that.

1. Create a branch off the `main` branch of [filter].

2. Replace the `integration` folder with the contents of the PHP backend.
    The backend can be found, for instance, within any of the compiled plugins with PHP backend found in the GitHub [releases](https://github.com/wiris/plugins/releases) of the [plugins] repository.
    Extract the plugin and look for the integration folder.
    For instance, in the case of the `php-ckeditor4` plugin, the integration is the folder `php-ckeditor4-.../ckeditor_wiris/integration`.
    Replace the `integration` folder in the filter repository with that one.
    Commit and push.

3. Let the automated Moodle tests pass on the new branch.
    When they pass correctly, continue.

4. Look for the the `thirdpartylibs.xml` file.
    Update the `<version>` entry for the `integration` library to be the same as the version of the backend.

5. Open a PR or merge directly to `main`, as appropriate.

### Update the DB

For each new Moodle version, the database is likely to change. Some times, when we are using an old database, moodle will throw an error and we will have to update it.

1. Open the latest Moodle you cna with the current databases there are on Moodle Docker project.

2. Once the containers are up and the moodle running, execute the following command on the Docker container of the DB:
    `docker exec -it CONTAINER_ID mysqldump --default-character-set=utf8mb4 --no-tablespaces -u moodle --password=m@0dl3ing -C -Q -e --create-options moodle > moodle-database.sql`

3. This will create a copy of the current DB with the name `moodle-database.db`.

4. You have the neew DB ready to use. In case you want to update the Moodle Docker DataBase set, move it to the database folder and rename it to the Moodle stable verions you where using when creating the dump.


## FAQ

### What `wmd` stands for?

[Wiris](https://www.wiris.com) + [Moodle](https://moodle.org/) + [Docker](https://www.docker.com/).

### Which versions of Moodle can I install?

Check the Moodle's project at GitHub for [a full list of Moodle versions available](https://github.com/moodle/moodle/branches/all) using the Git branch name to set the environment variable, like `export WIRIS_MOODLE_BRANCH="MOODLE_311_STABLE"`. 

### Can I run two different Moodle instances simultaneously with this tool?

Yes.

Follow the instructions on the [Run several Moodle instances simultaneously](#run-several-moodle-instances-simultaneously) section.

### What is the complete list of WIRIS MathType Moodle plugins?

- [MathType Filter](https://github.com/wiris/moodle-filter_wiris/)
- [MathType for Atto Editor](https://github.com/wiris/moodle-atto_wiris/)
- [MathType for TinyMCE Editor](https://github.com/wiris/moodle-tinymce_tiny_mce_wiris)

### What is the complete list of WIRIS Quizzes Moodle plugins?

- [moodle-qtype_essaywiris](https://github.com/wiris/moodle-qtype_essaywiris)
- [moodle-qtype_shortanswerwiris](https://github.com/wiris/moodle-qtype_shortanswerwiris) 
- [moodle-qtype_wq](https://github.com/wiris/moodle-qtype_wq)
- [moodle-local_wirisquizzes](https://github.com/wiris/moodle-local_wirisquizzes)
- [moodle-qtype_matchwiris](https://github.com/wiris/moodle-qtype_matchwiris)
- [moodle-qtype_multianswerwiris](https://github.com/wiris/moodle-qtype_multianswerwiris)
- [moodle-qtype_multichoicewiris](https://github.com/wiris/moodle-qtype_multichoicewiris)
- [moodle-qtype_truefalsewiris](https://github.com/wiris/moodle-qtype_truefalsewiris)

### How can I login to Moodle?

There are these three users for you to try the Moodle instance:

| Role              | User    | Password   |
| ----------------- | ------- | ---------- |
| **Administrator** | admin   | admin@A1   |
| **Teacher**       | teacher | teacher@A1 |
| **Student**       | student | student@A1 |

### What behat tests tags are available for the MathType suite of Moodle plugins ?

This is the current list of available tags to help you filter which test files to execute using the `run.php` behat script, manually.

- `@filter`
- `@filter_wiris`
- `@filter_wiris_render`
- `@filter_wiris_render_server`
- `@filter_wiris_render_image`
- `@filter_wiris_settings`
- `@editor`
- `@editor_atto`
- `@atto`
- `@atto_wiris`
- `@tinymce`
- `@tinymce_tiny_mce_wiris`

### How can I run a behat test manually using the tags above?

```bash

# Make sure the test environment is initialized.
./bin/wiris-moodle-docker-test-init

# Examples: Run behat tests.
./bin/wiris-moodle-docker-test-behat --tag filter_wiris

```

Check the [User's guide](#users-guide) above for more useful commands. 

### How to update/export the database of a new Moodle version?

You may have changes to the database that you would like to install by default everytime you use the `start` command.
Or maybe, there's a new Moodle version available and you'd like to generate a sql dump file for this new version. 

```bash
# (parameter) Set up the Moodle version to download using the branch name convention.
export WIRIS_MOODLE_BRANCH="MOODLE_38_STABLE" 

./bin/wiris-moodle-docker-install
./bin/wiris-moodle-docker-start

./moodle-docker/bin/moodle-docker-compose exec -T db mysqldump -u moodle -pm@0dl3ing moodle > databases/${WIRIS_MOODLE_BRANCH}.sql

```

### How can I import my own Moodle database dump?

```bash
# Import: you may want to load a database from another source...?
./moodle-docker/bin/moodle-docker-compose exec -T db mysql -u moodle -pm@0dl3ing moodle < [YOUR-DIRECTORY]/databases/${WIRIS_MOODLE_BRANCH}.sql

```

### How can change the browser for behat tests?

```bash
export MOODLE_DOCKER_BROWSER="chrome"

export MOODLE_DOCKER_BROWSER="firefox"
````
Also, please reinstall the Moodle instance to apply the changes.

## Wiris Moodle math & science plugins set

<img src="assets/MT_logo.svg" height="36" alt="Wiris MathType">

_Type and handwrite mathematical notation in Moodle with MathType. The popular equation editor for MS Word is now seamlessly integrated into Moodle._

![MathType on Moodle](assets/MT_header.svg)

<img src="assets/CT_logo.svg" height="36" alt="Wiris ChemType">

_A flavor of MathType designed to help you work with chemical notation. It includes common chemical symbols and a user experience adapted to chemistry authors._

![ChemType on Moodle](assets/CT_header.svg)

<img src="assets/WQ_logo.svg" height="48" alt="Wiris Quizzes, assessment for STEM" style="display:inline; margin-left:-10px;">

_Wiris Quizzes takes Moodle Quizzes one step further: computer based grading of math and science questions, random parameters or graphics in your STEM quizzes._

![Wiris Quizzes on Moodle](assets/WQ_header.png)

## Technical Support or Questions

If you have questions about MathType, Quizzes or need help integrating MathType, please contact us (support@wiris.com) instead of opening an issue.

## Privacy policy

The [MathType Privacy Policy](http://www.wiris.com/mathtype/privacy-policy) covers the data processing operations for the MathType users. It is an addendum of the company’s general Privacy Policy and the [general Privacy Policy](https://wiris.com/en/privacy-policy) still applies to MathType users.

## License

MathType filter by [WIRIS](http://www.wiris.com) is licensed under the [GNU General Public, License Version 3](https://www.gnu.org/licenses/gpl-3.0.en.html).

![Wiris](assets/logo-wiris.svg)