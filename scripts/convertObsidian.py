import os
import re
from typing import List, Dict

TO_REMOVE: List[str] = ["static", ".obsidian", ".git"]
ROOT_DIR = "/home/aura/Documents/Notes"
TEST_PATH:str = "test.txt"

def getPaths() -> List[Dict[str, str]]:
    matchDict: List[Dict[str, str]] = []
    for root, dirs, files in os.walk(ROOT_DIR, topdown=True):
        dirs[:] = [d for d in dirs if d not in TO_REMOVE]
        for file in files:
            fullPath = os.path.join(root, file)
            modifiedFile = file.replace(".md", "")
            requestedPath = fullPath.replace(ROOT_DIR, "")
            matchDict.append({modifiedFile: requestedPath})
    return matchDict


def findMatches(text: str, notesList: List[Dict[str, str]]):
    pattern = r'(?:!)?\[\[([^\]]*)\]\]'
    regex = re.compile(pattern)
    matches = re.findall(regex, text)
    
    for note in notesList:
        for match in matches:
            noteKey = list(note.keys())[0]
            if noteKey == match:
                value = list(note.values())[0]
                newString = f"[{noteKey}]({value})"
                text = re.sub(r'\[\[' + re.escape(match) + r'\]\]', newString, text)
                return  text

def modifyFile(pathToFile: str, notesList: List[Dict[str, str]]):
    with open(pathToFile, "r") as f:
        lines = f.readlines()

    updated_lines = []
    for line in lines:
        updated_line = findMatches(line, notesList)
        if updated_line is not None:
            updated_lines.append(updated_line)
        else:
            updated_lines.append(line)

    with open(pathToFile, "w") as f:
        f.writelines(updated_lines)




def main():
    paths = getPaths()  
    for p in paths:
        realtivePath = list(p.values())[0]
        fullPath=f"{ROOT_DIR}{realtivePath}"
        
        if os.path.exists(fullPath):
            modifyFile(fullPath,paths)

        else:
            print("this doesnt exist ",fullPath)
            
    print("done")



main()
