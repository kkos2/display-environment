# KK OS2 Display Runtime environments

This repository acts as the [repository](https://docs.platform.sh/overview/structure.html)
for the platform.sh project used to host a os2display environment.

A running os2display installation consists of a number of components that are
sourced from individual repositories. In order to deploy os2display we need
to pick a revision from each of these repositories to deploy. This is done
via git submodules.

Platform.sh handles the checkout of the individual submodules, so all we have
to do is to make sure the submodule is set to the correct revision, and then
push the updated module to github.

## Directory Layout

`/apps` contains a sub-directory pr os2display component. Each of these directories
contains

* platform.sh configuration for the platform.sh "Application" in a `.platform.app.yaml`
  file
* a submodule for the component
* various configuration-files that needs to be rendered into the application at
  build/deploy time.
acts as the root folder for a platform.sh "Application" and as such contains
a  configuration-file that describes how the component is to
built and deployed.

The following submodules

* apps/admin/display-admin-client
* apps/api/display-api-service
* apps/client/display-client

## Platform.sh configuration

As mentioned above the deployment is split up into three individual platform.sh
"apps".

### Admin and Client

Both of these apps are React apps, and as such are static and does not require
any dynamic server-side scripting.

## Updating submodules

A submodule is updated via the `revision:set` and `revision:set:all` tasks.
Both takes a revision as an argument. The revision can be any valid refspec
such as a tag, branch or a sha.

### Update admin, api and client to git tag 1.2.3

```shell
# Update all submodules.
$ task revision:set:all REVISION=1.2.3

# Push the result to github, triggering a platform.sh deploy.
$ git push
```

### Updating admin, api and client to the latest version of their develop branch

```shell
# Update all submodules.
$ task revision:set:all REVISION=develop

# Push the result to github, triggering a platform.sh deploy
$ git push
```

### Update a single component

We're using admin as an example here, but any of admin, api and client would do.

We're updating to the latest version of the develop branch, but any refspec (
  sha, tag, branch) can be used.

```shell
# Update the admin submodule.
$ task revision:set APP=admin REVISION=develop

# Push the result to github, triggering a platform.sh deploy
$ git push

```
