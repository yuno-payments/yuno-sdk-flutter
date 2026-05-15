# Changelog Check
changelog_modified = git.modified_files.include?("yuno_sdk/CHANGELOG.md")

unless changelog_modified
  markdown("I see `yuno_sdk/CHANGELOG.md` is still untouched. Curious, considering your PR clearly changes things. :thinking: Before merging, spare us 30 seconds and document what you did .. Your future self will thank you. Ours will too.")
  fail("Changelog not updated!. Please remember to follow the changelog template: `[TICKET-NUMBER](TICKET-URL) | YYYY/MM/DD | Description of changes`.")
end
