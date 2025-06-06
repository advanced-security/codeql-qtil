## Contributing

[fork]: https://github.com/advanced-security/codeql-qtil/fork
[pr]: https://github.com/advanced-security/codeql-qtil/compare
[code-of-conduct]: CODE_OF_CONDUCT.md

Hi there! We're thrilled that you'd like to contribute to this project. Your help is essential for keeping it great.

Contributions to this project are [released](https://help.github.com/articles/github-terms-of-service/#6-contributions-under-repository-license) to the public under the [project's open source license](LICENSE.md).

Please note that this project is released with a [Contributor Code of Conduct](CODE_OF_CONDUCT.md). By participating in this project you agree to abide by its terms.

## Scope

This project considers the following contributions, in order of priority:
1. **Bug fixes**: Fixing bugs in the qtil library.
2. **Additional language support**: Adding or improving qtil support for current or additional languages
3. **Performance improvements**: Improving the performance of the qtil library.
4. **Documentation improvements**: Clarifying how features work, adding examples, correcting incorrect information.
5. **New features**: We really would **love** to see what new features you can come up with! No feature is too small or too big, so long as it is useful to the community. That said -- we reserve the right to be strict about which new features we will accept. If in doubt, please open an issue to discuss it first!

## Submitting a pull request

The next step, after registering and discussing your improvement, is proposing the improvement in a pull request.

1. [Fork](fork) and clone the repository
2. Configure and install the [CodeQL CLI](https://github.com/github/codeql-cli-binaries/releases).
3. Create a new branch: `git checkout -b my-branch-name`
4. Make your changes and commit them: `git commit -m 'Add some feature'`
5. Ensure the files are appropriately formatted: QL files should be formatted with `codeql query format`.
6. Create new tests for any new features or changes to existing features. Ensure all existing tests pass. Tests can be run with `codeql test run $DIR`, where `$DIR` is either `/test` in the repo root, or `$LANG/test` for a specific language.
7. If relevant, ensure the change will be applied to all languages supported by qtil. Exceptions can be applied if necessary.
8. Push to your fork and [submit a draft pull request](https://github.com/advanced-security/codeql-qtil/compare). Make sure to select **Create Draft Pull Request**.
9. Address failed checks, if any.
10. Mark the [pull request ready for review](https://docs.github.com/en/pull-requests/collaborating-with-pull-requests/proposing-changes-to-your-work-with-pull-requests/changing-the-stage-of-a-pull-request#marking-a-pull-request-as-ready-for-review).
11. Pat your self on the back and wait for your pull request to be reviewed and merged.

Here are a few things you can do that will increase the likelihood of your pull request being accepted:

- Ensure all PR checks succeed.
- Keep your change as focused as possible. If there are multiple changes you would like to make that are not dependent upon each other, consider submitting them as separate pull requests.
- Write a [good commit message](http://tbaggery.com/2008/04/19/a-note-about-git-commit-messages.html).

## Resources

- [How to Contribute to Open Source](https://opensource.guide/how-to-contribute/)
- [Using Pull Requests](https://help.github.com/articles/about-pull-requests/)
- [GitHub Help](https://help.github.com)