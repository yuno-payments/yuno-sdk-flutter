# yuno_sdk_platform_interface

A common platform interface for the [`yuno_sdk`][1] plugin.

This interface allows platform-specific implementations of the `yuno_sdk`
plugin, as well as the plugin itself, to ensure they are supporting the
same interface.


# Note on breaking changes

Strongly prefer non-breaking changes (such as adding a method to the interface)
over breaking changes for this package.

See https://flutter.dev/go/platform-interface-breaking-changes for a discussion
on why a less-clean interface is preferable to a breaking change.

[1]: ../yuno_sdk
[2]: lib/yuno_sdk_platform_interface.dart