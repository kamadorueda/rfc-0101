> Note: This document is a draft for now

# Should we have a style guide?

Summary of arguments from all members of the community:

- (good) Reduces subjectiveness
  as the best practice
  would be written in an official document.

- (good) Allows to further converge the code to some standard.

- (good) Allows to discourage any comments on formatting
  that is not based on examples in the style guide.

- (good) Once the style guide is official,
  linters can be created by the community to enforce them.
  For instance: placing `pname` before `version` in `stdenv.mkDerivation`.

- (good) Save reviewers time
  as they won't need to ask for the same changes on each PR,
  and instead just point people to a link.

- (good) Allows to define conventions
  beyond what can be automatically enforced
  by nixfmt/nixpkgs-fmt/alejandra.

  For instance:

  ```nix
  { meta = { maintainers = [ lib.maintainers.xyz ]; }
  ```

  vs

  ```nix
  { meta = with lib; { maintainers = with maintainers; [ xyz ]; }
  ```

- (bad) Impossible or too much work to state all possible cases.

  Notes:

  - This is true.
  - While perfection is a noble goal,
    ["Perfect is the enemy of good"](https://en.wikipedia.org/wiki/Perfect_is_the_enemy_of_good),
    [Analysis Paralysis](https://en.wikipedia.org/wiki/Analysis_paralysis)
    and
    [Diminishing Returns](https://en.wikipedia.org/wiki/Diminishing_returns) are noble things to avoid, too.

- (bad) It can be harder to contribute
  specially if the formatters
  do not automatically enforce the rules in the style guide.

Proposal:

Let's divide the style guide in three parts:

1. The part verified by a tool and fixed by a tool:
   By a formatter like nixpkgs-fmt/nixfmt/alejandra.

1. The part verified by a tool (like nix-linter),
   and fixed manually by contributors.

1. The part verified by reviewers,
   and fixed manually by contributors:

   For instance: the order of attributes (`pname`, `version`, `patches`) in `mkDerivation`.

From the above list we can see that only (3)
needs to be addressed by the style guide,
and (1) and (2) are left to the CI/CD
by means of a GitHub Action or similar.

Action items (if we all agree with the current proposal):

- Create the initial style guide
  with a few best-practices that are currently wide-spread in Nixpkgs.

  For instance:

  - Order of attributes in `mkDerivation`.
  - The proper form of `meta`.

- Empower some people to approve changes to the style guide.
  In other words,
  find appropriate [CODEOWNERS](https://github.com/NixOS/nixpkgs/blob/master/.github/CODEOWNERS).

- Link the style guide in [CONTRIBUTING.md](https://github.com/NixOS/nixpkgs/blob/master/CONTRIBUTING.md)
  from Nixpkgs.

- Discourage reviewers from performing style suggestions
  on Pull Requests if those are not found on the style guide.
  If additions to the style guide need to be made,
  feel free to present the arguments to the code owner of the style guide
  and not to the Pull Request contributor.
