echo "Getting latest release info..."

url="$(curl -s https://api.github.com/repos/newren/git-filter-repo/releases/latest | grep 'browser_download_url.*\.tar\.xz' | cut -d '"' -f 4)"
file="${url##*/}"

echo "Downloading lastest release and extracting the documentation..."
echo "Url: $url"

curl -Ls "$url" | \
	tar --xz --to-stdout -xf - "${file%%.tar.xz}/Documentation/html/git-filter-repo.html" \
		> "$(git --html-path)/git-filter-repo.html"

echo "Installing the actual package using pip..."

pip install git-filter-repo

read -rsn 1 -p "Press any key to continue..."

