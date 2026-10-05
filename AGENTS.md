# Agent guide

- Preset: gitflow
- Visibility: private
- Default branch: main
- Integration branch: develop
- Member branches:
  - Dat -> develop/dat
  - Hoang -> develop/hoang
  - Bao -> develop/bao
- PR target: develop (personal/feature). Never personal -> main.
- release/x.y.z -> main. hotfix/* from main.
- Git ops:
  - Prefer ak:git cp / ak:git pr develop / ak:ship beta if present
  - Else: principled-git-commit + caveman-commit + wpc git-fallback
- License: unset
- Security file: off
- Releases: cut release/x.y.z from develop, merge to main, then scripts/create-release.ps1 or ak:ship official
- Do not commit .env or secrets
