#!/bin/bash
set -e

VERSION=$1
CHANGELOG_FILE="../../yuno_sdk/CHANGELOG.md"
SUMMARY_FILE="RELEASE_SUMMARY.md"

if [ -z "$VERSION" ]; then
  echo "❌ Usage: ./summarize_changelog.sh <version>"
  echo "Example: ./summarize_changelog.sh 1.0.12"
  exit 1
fi

if [ ! -f "$CHANGELOG_FILE" ]; then
  echo "❌ Changelog file not found at: $CHANGELOG_FILE"
  exit 1
fi

if [ -z "$OPENAI_API_KEY" ]; then
  echo "❌ Missing OPENAI_API_KEY environment variable"
  echo "💡 Set it with: export OPENAI_API_KEY='your-api-key'"
  exit 1
fi

# Extract changelog block for the requested version (between its header and the next).
CHANGELOG_CONTENT=$(sed -n "/^.*##[[:space:]]\{0,\}$VERSION[[:space:]]*$/,/^.*##[[:space:]]\{1,\}[0-9]/p" "$CHANGELOG_FILE" | sed '1d;$d')
echo "🔍 Changelog extracted for version $VERSION:"
echo "---------------------------------------------"
echo "$CHANGELOG_CONTENT"
echo "---------------------------------------------"
if [ -z "$CHANGELOG_CONTENT" ]; then
  echo "❌ No changelog entry found for version $VERSION in $CHANGELOG_FILE"
  exit 1
fi

PROMPT="Clean up and professionally summarize the following changelog for the public Flutter SDK release notes (this is PUBLIC documentation consumed by SDK customers/integrators).
- Use a bullet point list format.
- Do NOT invent, infer, or add any information that is not explicitly present in the changelog. If something is unclear, omit it rather than guessing.
- Only include information that is USEFUL for an SDK customer (merchant integrator): user-facing behavior changes, new public APIs, supported payment methods, bug fixes affecting integrators, breaking changes, deprecations.
- EXCLUDE internal implementation details that customers don't care about: refactors, internal renames, code cleanup, CI/build pipeline changes, test changes, internal dependency bumps, internal logs, internal class/file changes, commit hygiene, and anything tagged [internal].
- STRIP all internal identifiers from the output, even when they appear in the source changelog: feature flag names, backend/dashboard configuration keys, environment variable names, internal class/method/file/property names, internal endpoint paths, and ANY identifier wrapped in backticks. These are operator-facing internals, not customer-facing concepts. If a change is gated behind a flag or setting, describe it generically as 'a settings option', 'a configurable behavior', or 'an opt-in capability' — never name the flag, the dashboard section, or the storage key.
- Reformulate every bullet in customer-facing terms: describe WHAT the integrator can now do (new capability, new setting, new behavior, new payment method), not HOW it is wired internally. Avoid implementation vocabulary like 'flag', 'gated by', 'behind a flag', 'config key', 'in settings UI', 'in dashboard'; if it must be mentioned, use neutral phrasing like 'an opt-in setting'.
- Each bullet point MUST follow EXACTLY this format: '- **TYPE**: **Title in Title Case**: Detailed description ending in a period.'
  - The separator between the Title and the Description MUST be a colon followed by a single space (': ').
  - The asterisks '**' are RESERVED as structural markers only (around the TYPE tag and around the Title). Do NOT use '**', '*', backticks, em-dash '—', or any other markdown/special formatting inside the Title or anywhere inside the Description. The Title and Description must be plain text.
  - The Title MUST be in Title Case, short (2–6 words), and describe the change as a noun phrase. The Title MUST NOT contain a colon.
  - The Description MUST be one or two complete sentences that explain the change in a way that is useful for an SDK customer. Colons are allowed inside the Description.
- Use exactly ONE of the following tags as TYPE, based on the nature of the change:
  - 'ADDED' — for new features, new public APIs, new payment methods, or any new capability.
  - 'CHANGED' — for changes to existing behavior, updates, enhancements, or improvements that are not bug fixes (including native SDK version bumps).
  - 'REMOVED' — for features, APIs, or capabilities that have been removed.
  - 'FIXED' — for bug fixes or corrections to incorrect behavior.
  - 'DEPRECATED' — for features or APIs that are marked as deprecated and will be removed in a future release.
  - 'SECURITY' — for security-related fixes or improvements.
- Choose the tag that best fits each item. Do not use more than one tag per bullet.
- If multiple bug fixes are present, you can group them into a single bullet point: '- **FIXED**: **Bug Fixes and Stability**: Various bug fixes and stability improvements.'
- Remove ticket IDs, links, and dates.
- Improve clarity and grammar, but do not embellish or add context that is not in the source changelog.
- Do NOT use emojis anywhere in the output. No emojis in the tag, title, description, or any part of the bullet — plain text only.
- Do not add any extra comments, explanations, headings, or introductory text—only return the cleaned-up bullet list with proper prefixes.\n\n$CHANGELOG_CONTENT"

echo "🚀 Calling OpenAI API..."

# Escape a string for safe embedding inside a JSON string value (no jq dependency).
escape_json_string() {
  local s="$1"
  s="${s//\\/\\\\}"
  s="${s//\"/\\\"}"
  s="${s//$'\r'/\\r}"
  s="${s//$'\t'/\\t}"
  s="${s//$'\n'/\\n}"
  printf '%s' "$s"
}

ESCAPED_PROMPT=$(escape_json_string "$PROMPT")
PAYLOAD='{"model":"gpt-4o","messages":[{"role":"system","content":"You are an expert in software releases."},{"role":"user","content":"'"$ESCAPED_PROMPT"'"}],"temperature":0.7}'

RESPONSE=$(curl -s https://api.openai.com/v1/chat/completions \
  -H "Authorization: Bearer $OPENAI_API_KEY" \
  -H "Content-Type: application/json" \
  -d "$PAYLOAD")

echo "✅ Response received from OpenAI"

if echo "$RESPONSE" | grep -qE '"error"[[:space:]]*:[[:space:]]*\{'; then
  echo "❌ OpenAI API returned an error:"
  echo "$RESPONSE"
  exit 1
fi

CONTENT_RAW=$(echo "$RESPONSE" | sed -n '/"content":/,/"refusal":/p' | sed '1s/.*"content":[[:space:]]*"//; $s/",[[:space:]]*"refusal".*//' | sed ':a;N;$!ba;s/\n/ /g')

if [ -z "$CONTENT_RAW" ]; then
  CONTENT_RAW=$(echo "$RESPONSE" | tr '\n' ' ' | sed 's/.*"content":[[:space:]]*"\([^"]*\)".*/\1/')
fi

CONTENT_CLEAN=$(echo "$CONTENT_RAW" | sed 's/"refusal": null,.*$//; s/",.*$//')
SUMMARY=$(echo "$CONTENT_CLEAN" | sed 's/\\"/"/g; s/\\n/\
/g; s/\\\\/\\/g; s/\\t/\t/g')

if [ -z "$SUMMARY" ]; then
  echo "⚠️ Could not extract summary. Full response:"
  echo "$RESPONSE"
  exit 1
fi

echo "$SUMMARY" > "$SUMMARY_FILE"
echo "✅ Summary generated in $SUMMARY_FILE"
echo ""
echo "📄 Summary content:"
echo "========================"
cat "$SUMMARY_FILE"
