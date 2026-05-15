#!/bin/bash
#
# Parses RELEASE_SUMMARY.md (bullet list produced by summarize_changelog.sh) and
# prepends a new release entry to the Flutter changelog JSON consumed by yuno-docs
# (changelog/source/flutter.json).
#
# Bullet format expected:
#   - **TYPE**: **Title in Title Case**: Description.
# (Title bold markers are tolerated as optional.)
#
# Usage:
#   ./build_release_json_flutter.sh <target_flutter.json> <version> <release_summary.md>

set -e

if [ "$#" -ne 3 ]; then
  echo "❌ Usage: $0 <target_flutter.json> <version> <release_summary.md>"
  exit 1
fi

TARGET_JSON=$1
VERSION=$2
SUMMARY_FILE=$3

if [ ! -f "$SUMMARY_FILE" ]; then
  echo "❌ Release summary file not found: $SUMMARY_FILE"
  exit 1
fi

if ! command -v jq >/dev/null 2>&1; then
  echo "❌ jq is required but not installed."
  exit 1
fi

ENTRIES_JSON='[]'
LINE_COUNT=0

while IFS= read -r line; do
  [ -z "$(echo "$line" | tr -d '[:space:]')" ] && continue
  case "$line" in
    -\ *|\*\ *) ;;
    *) continue ;;
  esac

  TYPE=$(echo "$line" | sed -n 's/^[[:space:]]*[-*][[:space:]]*\*\*\([A-Z]\{1,\}\)\*\*:.*/\1/p')
  REST=$(echo "$line" | sed -n 's/^[[:space:]]*[-*][[:space:]]*\*\*[A-Z]\{1,\}\*\*:[[:space:]]*\(.*\)/\1/p')
  REST=$(echo "$REST" | sed 's/^\*\*\(.*\)\*\*:/\1:/')
  TITLE=$(echo "$REST" | sed 's/:.*//' | sed 's/[[:space:]]*$//')
  DESCRIPTION=$(echo "$REST" | sed 's/^[^:]*:[[:space:]]*//')

  if [ -z "$TYPE" ] || [ -z "$TITLE" ] || [ -z "$DESCRIPTION" ]; then
    echo "⚠️  Skipping malformed bullet: $line"
    continue
  fi

  ENTRY=$(jq -n \
    --arg type "$TYPE" \
    --arg title "$TITLE" \
    --arg description "$DESCRIPTION" \
    '{type: $type, title: $title, description: $description, group: null, migration_guide: null, links: []}')

  ENTRIES_JSON=$(echo "$ENTRIES_JSON" | jq --argjson entry "$ENTRY" '. + [$entry]')
  LINE_COUNT=$((LINE_COUNT + 1))
done < "$SUMMARY_FILE"

if [ "$LINE_COUNT" -eq 0 ]; then
  echo "❌ No valid entries parsed from $SUMMARY_FILE."
  echo "   Expected bullets in the form: - **TYPE**: **Title**: Description. (Title bold is optional.)"
  exit 1
fi

RELEASE_OBJECT=$(jq -n \
  --arg version "$VERSION" \
  --argjson entries "$ENTRIES_JSON" \
  '{
    version: $version,
    release_date: null,
    upgrade: {
      snippet: ("flutter pub add yuno:" + $version),
      language: "bash"
    },
    entries: $entries
  }')

if [ ! -f "$TARGET_JSON" ]; then
  echo "📄 Target JSON does not exist. Creating new file at $TARGET_JSON."
  mkdir -p "$(dirname "$TARGET_JSON")"
  jq -n --argjson release "$RELEASE_OBJECT" \
    '{sdk: "flutter", releases: [$release]}' > "$TARGET_JSON"
else
  EXISTING=$(jq --arg v "$VERSION" '.releases[]? | select(.version == $v) | .version' "$TARGET_JSON" | head -1)
  if [ -n "$EXISTING" ]; then
    echo "❌ Version $VERSION already exists in $TARGET_JSON. Aborting to avoid duplicates."
    exit 1
  fi

  TMP_FILE="$TARGET_JSON.tmp"
  jq --argjson release "$RELEASE_OBJECT" \
    '.releases = ([$release] + .releases)' "$TARGET_JSON" > "$TMP_FILE"
  mv "$TMP_FILE" "$TARGET_JSON"
fi

echo "✅ Added release $VERSION with $LINE_COUNT entries to $TARGET_JSON"
