# Jeepyb Close Pull Requests

- Problem: Jeepyb not closing pull requests.
- Temporary solution: hot-fix production code
```
OPX currently uses the upstream jeepyb. Upstream jeepyb relies on the project in gerrit matching the project/org in Github.
This is not the case for OPX. Until I can switch OPX to use a local jeepyb manifest, I have manually changed the file on
the server in which close-pull-requests runs.

In /usr/local/lib/python2.7/dist-packages/jeepyb/cmd/close-pull_requests.py

diff --git a/jeepyb/cmd/close_pull_requests.py b/jeepyb/cmd/close_pull_requests.py
index 701330d..4cde090 100644
--- a/jeepyb/cmd/close_pull_requests.py
+++ b/jeepyb/cmd/close_pull_requests.py
@@ -116,7 +116,7 @@ def main():
         # Handle errors in case the repo or the organization doesn't exists
         try:
             if len(project_split) > 1:
-                org = orgs_dict[project_split[0].lower()]
+                org = orgs_dict['open-switch']
                 repo = org.get_repo(project_split[1])
             else:
                 repo = ghub.get_user().get_repo(project)
```
- Real solution: fix upstream (**not done yet**)
