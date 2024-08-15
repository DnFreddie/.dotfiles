
bookmark=$(pwd)
flag=$1
DATA=~/scripts/.bookmarks_list.txt

add_bookmark() {
  if [[ ! -f "$DATA" ]]; then
    touch "$DATA"
  fi 
  echo "$bookmark" >> "$DATA"
  echo "The bookmark $bookmark has been added."
}

search_bookmark() {
  if [[ ! -f "$DATA" ]]; then
    echo "There are no bookmarks."
    return
  fi 

  selected_option=$(sort "$DATA" | uniq | fzf)
  
  if [[ -n "$selected_option" ]]; then
    cd "$selected_option" || {
      echo "Failed to change directory to $selected_option."
      return
    }
  else
    echo "No option selected."
  fi
}

case $flag in
    -a) sh ~/scripts/todo.sh ;;
  -n) add_bookmark ;;
  -s) echo "Searching for arguments." ; search_bookmark;;
  -h) echo "
    -n: Add bookmark
    -s: Search bookmark
    -e: Edit bookmarks
    -E: Edit agenda
    -h: Help
      " ;;
  -e)  nvim "$HOME/scripts/.bookmarks_list.txt" ;;
  -E)  nvim "$HOME/Documents/Notes/Home.md" ;;
  *)  search_bookmark ;;
esac
