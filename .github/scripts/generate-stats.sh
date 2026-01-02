#!/bin/bash

# Generate statistics for all prompts and update README.md
# This script calculates lines, words, tokens (estimated), and file size

set -e

PROMPTS_DIR="prompts"
README_FILE="README.md"
TEMP_STATS_FILE=$(mktemp)

# Markers for the stats section
START_MARKER="<!-- PROMPT_STATS_START -->"
END_MARKER="<!-- PROMPT_STATS_END -->"

# Function to estimate tokens (approximately 4 characters per token for English text)
estimate_tokens() {
    local chars=$1
    echo $(( (chars + 3) / 4 ))
}

# Function to format file size
format_size() {
    local bytes=$1
    if [ $bytes -ge 1048576 ]; then
        echo "$(echo "scale=1; $bytes / 1048576" | bc) MB"
    elif [ $bytes -ge 1024 ]; then
        echo "$(echo "scale=1; $bytes / 1024" | bc) KB"
    else
        echo "${bytes} B"
    fi
}

# Generate the stats table and write to temp file
generate_table() {
    cat << 'HEADER'
## Prompt Statistics

Auto-generated summary of all prompts in this repository.

| Prompt | Lines | Words | Tokens (est.) | Size |
|--------|------:|------:|--------------:|-----:|
HEADER

    total_lines=0
    total_words=0
    total_tokens=0
    total_size=0

    # Process each markdown file in prompts directory (sorted alphabetically)
    for file in $(ls -1 "$PROMPTS_DIR"/*.md | sort); do
        if [ -f "$file" ]; then
            filename=$(basename "$file" .md)
            # Convert filename to display name (replace hyphens with spaces, title case)
            display_name=$(echo "$filename" | sed 's/-/ /g' | awk '{for(i=1;i<=NF;i++) $i=toupper(substr($i,1,1)) tolower(substr($i,2))}1')

            lines=$(wc -l < "$file" | tr -d ' ')
            words=$(wc -w < "$file" | tr -d ' ')
            chars=$(wc -c < "$file" | tr -d ' ')
            # Get file size - try GNU stat first, then BSD stat
            size=$(stat -c%s "$file" 2>/dev/null || stat -f%z "$file" 2>/dev/null)
            tokens=$(estimate_tokens $chars)

            total_lines=$((total_lines + lines))
            total_words=$((total_words + words))
            total_tokens=$((total_tokens + tokens))
            total_size=$((total_size + size))

            formatted_size=$(format_size $size)

            echo "| [$display_name]($file) | $lines | $words | $tokens | $formatted_size |"
        fi
    done

    # Add totals row
    formatted_total_size=$(format_size $total_size)
    echo "| **Total** | **$total_lines** | **$total_words** | **$total_tokens** | **$formatted_total_size** |"
    echo ""
    echo "*Token count is estimated based on ~4 characters per token.*"
}

# Generate stats to temp file
generate_table > "$TEMP_STATS_FILE"

# Check if markers exist in README
if grep -q "$START_MARKER" "$README_FILE"; then
    # Replace existing stats section using sed
    # First, delete everything between markers (inclusive of content, exclusive of markers)
    sed -n "1,/$START_MARKER/p" "$README_FILE" > "${README_FILE}.tmp"
    echo "" >> "${README_FILE}.tmp"
    cat "$TEMP_STATS_FILE" >> "${README_FILE}.tmp"
    echo "" >> "${README_FILE}.tmp"
    sed -n "/$END_MARKER/,\$p" "$README_FILE" >> "${README_FILE}.tmp"
    mv "${README_FILE}.tmp" "$README_FILE"
else
    # Add stats section before Credits section
    # Find line number of ## Credits
    credits_line=$(grep -n "^## Credits" "$README_FILE" | head -1 | cut -d: -f1)

    if [ -n "$credits_line" ]; then
        # Insert before Credits section
        head -n $((credits_line - 1)) "$README_FILE" > "${README_FILE}.tmp"
        echo "$START_MARKER" >> "${README_FILE}.tmp"
        echo "" >> "${README_FILE}.tmp"
        cat "$TEMP_STATS_FILE" >> "${README_FILE}.tmp"
        echo "" >> "${README_FILE}.tmp"
        echo "$END_MARKER" >> "${README_FILE}.tmp"
        echo "" >> "${README_FILE}.tmp"
        tail -n +$credits_line "$README_FILE" >> "${README_FILE}.tmp"
        mv "${README_FILE}.tmp" "$README_FILE"
    else
        # Append to end of file
        echo "" >> "$README_FILE"
        echo "$START_MARKER" >> "$README_FILE"
        echo "" >> "$README_FILE"
        cat "$TEMP_STATS_FILE" >> "$README_FILE"
        echo "" >> "$README_FILE"
        echo "$END_MARKER" >> "$README_FILE"
    fi
fi

# Clean up
rm -f "$TEMP_STATS_FILE"

echo "README.md updated with prompt statistics"
