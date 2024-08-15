reverse_img() {
    local path="$1"

    # Define basePngs array (example)

    while IFS= read -r line; do



            if [[ $line =~ $re ]]; then
                 matched="${BASH_REMATCH[1]}"
                 
                 echo "$matched"

            fi
    done < "$path"
}



declare -a basePngs
declare -a allNotes


notesDir="$HOME/Documents/Notes"
mapfile -d '' basePngs < <(find "$notesDir/static" -maxdepth 100 -type f -name "*.png" -print0 | xargs -0 -n 1 basename)
mapfile -d '' allNotes < <(find "$notesDir" -maxdepth 100 -type f -name "*.md" -print0 )
    

# for note in "${allNotes[@]}"; do
#      updated_note=$(sed -i -E \
#          -e 's|!\[\[([^]]*\.png)\]\]|![\1](/static/\1)|g' \
#          -e 's|\[\[([^]]*\.png)\]\]|[\1](/static/\1)|g' \
#          "$note")

#      # Replace spaces with underscores in the updated paths
#      updated_note=$(echo "$updated_note" | sed -E  's|/static/([^]]+)|/static/\1|g' | sed -E 's|(/static/[^]]*) |\1_|g')

#      # Output the updated note
    
#      # Optionally, save the updated note back to the file
#  done

for note in "${allNotes[@]}"; do
    sed -i 's/Pasted image /Pasted_image_/g' "$note"






done

