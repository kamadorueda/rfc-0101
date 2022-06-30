# RFC 0101

## Motivation

> _"Prevent debate around how things should be formatted."
> \- [PR 101](https://github.com/NixOS/rfcs/pull/101)._

## Procedure

> _"Guide the discussion as long as it is constructive,
> new points are brought up as the RFC is iterated on,
> and from time to time summarize the current state of discussion.
> If this is the case no longer,
> then the Shepherd Team shall step in with a motion for FCP."
> \- [RFC 36](https://github.com/NixOS/rfcs/blob/220af8e4f171425d168334f07163ea3db2eb8161/rfcs/0036-rfc-process-team-amendment.md?plain=1#L63-L66)._

## Meetings

- **2022-03-04**: [0x4A6F], [kamadorueda], [infinisil].
- **2021-11-27**: [0x4A6F], [mohe2015].
- **2021-11-20**: [0x4A6F], [zimbatm].

## Notation

| Symbol |               Meaning               |
| :----: | :---------------------------------: |
|   ✅   |         There is consensus.         |
|   🤔   | No consensus or pending to discuss. |

## Points discussed

- ✅ Having a code formatter is a good thing.

- ✅ Formatting tools considered:

  - [Nixpkgs-fmt](https://github.com/nix-community/nixpkgs-fmt) -
    [demo](https://nix-community.github.io/nixpkgs-fmt/).
  - [NixFmt](https://github.com/serokell/nixfmt) -
    [demo](https://nixfmt.serokell.io/).
  - [Alejandra](https://github.com/kamadorueda/alejandra) -
    [demo](https://kamadorueda.github.io/alejandra/) -
    [style guide](https://github.com/kamadorueda/alejandra/blob/main/STYLE.md).

- ✅ Impact needs to be measured:

  - ✅ Does it make evaluation slower?

    Not significantly,
    according to comparisons between
    `$ time nix-env -qaf ./nixpkgs --drv-path --xml`.

  - ✅ Does it increase download size?

    Not significantly (no more than 0.72%).

  - ✅ Does it break evaluation?

    No, according to
    [nixpkgs-review](https://github.com/Mic92/nixpkgs-review)
    before and after formatting.

- ✅ How to pin the formatters?

  Have a special attribute in Nixpkgs pinned to a version
  and only upgrade it on the release cycle.

- ✅ Style is subjective.

  Variants and bugs have been widely discussed in:
  https://pad.lassul.us/NixOS-rfc0101-bikeshed

- ✅ Formatting tools can have issues,
  or some portions of the codebase are better not to format.

  We'll have to exclude those files.

- ✅ Migration of Nixpkgs to the formatted state:

  One big commit with `.git-blame-ignore-revs`
  on the release cycle:

  - Supported by GitHub on the web UI:

    https://docs.github.com/en/repositories/working-with-files/using-files/viewing-a-file#ignore-commits-in-the-blame-view

  - Supported on the CLI:

    ```sh
    $ git config blame.ignoreRevsFile .git-blame-ignore-revs
    ```

## Points pending to discuss

- 🤔 How to integrate it with nixpkgs?
  How to maintain the formatted state over time?

  - ✅ Using a GitHub Action to enforce formatting.
  - ✅ Add \*2nix tools to the list of excluded files.
  - ✅ If bugs are found in the formatter,
    add file to the exclusions.
  - 🤔 Proof of concept?

    - Script that formats: `$ ./maintainers/scripts/fmt.sh`.

      - 🤔 How to keep the closure as small as possible?

    - GitHub action that checks formatting.

- 🤔 Should we have a style guide?

  Trade-offs:

  - (Good) Allows to discourage any comments on formatting not based on examples in the style guide.
  - (Good) Allows to define conventions beyond the style like:

    ```nix
    { meta = { maintainers = [ lib.maintainers.xyz ]; }
    ```

    vs

    ```nix
    { meta = with lib; { maintainers = with maintainers; [ xyz ]; }
    ```

  - (Bad) Impossible or too much work to state all possible cases.
  - (Bad) Harder to contribute
    specially if the formatters
    do not automatically enforce the rules in the style guide.

  Notes:

  - One of the formatters have a
    [style guide](https://github.com/kamadorueda/alejandra/blob/main/STYLE.md) already
    and it enforces it automatically.
  - Let _The Best_ not be the enemy of _The Good_?

- 🤔 Should we modify the existing formatters?
  Should we make the formatters configurable?

  Notes:

  - We may not have volunteers to implement such changes.
  - Even with configurations,
    it's impossible to make everyone happy.

- 🤔 Which formatter to pick? How to take a fair decision?
  How to objectively choose the best?
  and support the decision in a way
  that no formatter author
  or member of the community feels unfair?

  - 🤔 Should we let the community decide with a poll?

    Trade-offs:

    - (Good) Probably fair if enough people vote.
      Democracy.
    - (Bad) Popularity does not mean being better
      or more beneficial.
    - (Bad) What happens if people decide
      for a style that no formatter supports?

    Notes:

    - The proposed poll is here https://pad.lassul.us/dc8lGytUTnOZipi1McLMOA#
    - After creating the poll we noticed
      some parts of it do not add value.

  - 🤔 Should the shepherd team decide alone?

    Trade-offs:

    - (Good) The shepherd team understands thoroughly
      each of the alternative features and limitations.
    - (Bad) Is it fair that just a few people
      take a decision like this?

  - 🤔 Should we have an evaluation framework to rank the formatters based on categories?

    - B% speed
    - A% style
    - D% consistency
    - E% poll?
    - X% ...

    Trade-offs:

    - (Good) Achieves balance between the things that are beneficial for Nixpkgs
      and the things that are subjective.
    - (Bad) How to fairly distribute the weights?

  - 🤔 A mix of the previous alternatives?

  Notes:

  - As of 2022-06-30 one of the formatters (Alejandra)
    already complies the
    [suggested style](https://pad.lassul.us/NixOS-rfc0101-bikeshed).
  - Comparisons between formatted results are here:
    https://github.com/kamadorueda/rfc-0101

<!--  -->

[0x4a6f]: https://github.com/0x4A6F
[infinisil]: https://github.com/infinisil
[kamadorueda]: https://github.com/kamadorueda
[mohe2015]: https://github.com/mohe2015
[zimbatm]: https://github.com/zimbatm
