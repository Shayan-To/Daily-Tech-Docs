#!/bin/bash
git add --all && \
git commit --message "Commit." --quiet && \
git show HEAD --oneline --stat && \
git fetch
git rebase origin/master
git push
read -rsn 1 -p "Press any key to continue..."
