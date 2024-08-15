
notesDir="$HOME/Documents/Notes"
find "$notesDir/static" -maxdepth 100 -type f -name "*.png" -print0 | \
while IFS= read -r -d '' file; do
    # Get the directory and the filename separately
    dir=$(dirname "$file")
    base=$(basename "$file")
    # Replace spaces with underscores in the filename
    newBase=${base// /_}
    # Rename the file
    mv "$file" "$dir/$newBase"
done
