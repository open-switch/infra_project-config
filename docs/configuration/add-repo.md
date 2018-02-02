# Adding a Repository to OpenSwitch

General documentation is found on the
[OpenSwitch site](http://egats.openswitch.net/documents/dev/contribute-code).

A more thorough explanation of our CI system can be found
[here](http://abregman.com/2016/03/05/openstack-infra-jenkins-jobs/).

Let's set some variables.
- project: **opx**
- repository: **new-repo**

> Before starting any code changes, ask the
> [Infrastructure team](https://github.com/orgs/open-switch/teams/infrastructure)
> on GitHub to create a new maintainers group for the repository. The name shall
> be **opx**-**new-repo**-maintainers.

There are two files to modify and one to create.

1. Create `gerrit/acls/opx/new-repo.config`

```yaml
[access "refs/heads/*"]
abandon = group Change Owner
abandon = group opx-new-repo-maintainers
label-Code-Review = -2..+2 group opx-new-repo-maintainers
label-Workflow = -1..+1 group Change Owner

[submit]
mergeContent = true
action = rebase if necessary
```

This file provides access control to the repository. Only maintainers group
members can approve changes.

2. Modify `gerrit/projects.yaml`

Add this section alphabetically.

```yaml
- project: opx/new-repo
  description: Example repository description
```

3. Add CI jobs

For now, we'll just add a simple merge check. More complicated jobs can be
added later.

Modify `zuul/layout.yaml`

```yaml
- name: opx/new-repo
  template:
   - name: merge-check
   - name: noop-jobs
```

## Adding CI Jobs

If you are not creating new build scripts, there are several builders already
available to you.

- (python) tox-multiple: run with an envlist for tox
```yaml
builders:
  - tox-multiple:
    envlist: 'py27,py34,py35,py36,pypy,pypy3'
```
- (debian) opx-*: builders are available for the full lifecycle
```yaml
builders:
 - opx-setup:
   module: 'opx-new-repo'
 - opx-pull-docker-image
 - opx-build-module:
   module: 'all'
 - opx-test-smoke-aws:
   module: 'opx-new-repo'
```

You'll need to create/modify several files.

1. `jenkins/jobs/macros.yaml` - build scripts. These scripts are called as
   builders/publishers in the next file.
1. `jenkins/jobs/opx-new-repo-jobs.yaml` - jenkins job template and job group
1. `jenkins/jobs/projects.yaml` - links repository to file above
1. `zuul/layout.yaml` - links repository to jenkins job

See existing repositories for examples.

