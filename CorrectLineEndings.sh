git ls-files -z | xargs -0 rm -f
git reset --hard
read -rsn 1 -p "Press any key to continue..."
