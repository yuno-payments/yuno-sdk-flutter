# Changelog Check
changelog_modified = git.modified_files.include?("yuno_sdk/CHANGELOG.md")

unless changelog_modified
  markdown("I see `yuno_sdk/CHANGELOG.md` is still untouched. Curious, considering your PR clearly changes things. :thinking: Heads up: this file is published to pub.dev as the package changelog, so customers will read it. Before merging, spare us 30 seconds and document what you did in user-facing terms (no ticket IDs, no internal jargon). Your future self will thank you. Ours will too.")
  fail("Changelog not updated! Please add an entry under the new version using the existing format: `- feat: <user-facing description>` for new features, `- fix: <user-facing description>` for bug fixes. Remember this file is public on pub.dev — avoid ticket IDs, internal flag names, or implementation details.")
end
