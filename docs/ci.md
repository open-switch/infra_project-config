# OpenSwitch Continuous Integration

The CI process starts when a code review is opened by a developer.

- Developer opens review or updates and existing review
- Zuul CI runs check job
  - On success, Zuul CI adds `Verified +1` tag to review
- Zuul CI waits until review has three labels:
  - `Verified    +1`
  - `Code-Review +2`
  - `Workflow    +1`
- Zuul CI runs gate job
  - On success, Zuul CI adds `Verified +2` tag to review
- Zuul CI waits until review has three labels:
  - `Verified    +2`
  - `Code-Review +2`
  - `Workflow    +1`
- Zuul CI submits review to the master branch of the repository

> Note: The check/gate jobs vary per repository. What follows is an overview. See [`infra/project-config`](https://git.openswitch.net/cgit/infra/project-config/tree/) for more information.

Repository             | Job   | Description
:--------------------- | :---- | :----------
[opx-build][opx-build] | check | build docker image, build all packages, smoketest
[opx-build][opx-build] | gate  | build docker image, build all packages, smoketest
[opx-test][opx-test]   | check | smoketest
[opx-test][opx-test]   | gate  | smoketest
all other c/c++ repos  | check | build, smoketest
all other c/c++ repos  | gate  | build, smoketest

[opx-build]: https://github.com/open-switch/opx-build "OPX Build Tools"
[opx-test]: https://github.com/open-switch/opx-test "OPX Test Scripts"
