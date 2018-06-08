import os, sys, urllib.request

request_headers = {
	"User-Agent": "Mozilla/5.0 (Windows NT 6.1) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/41.0.2228.0 Safari/537.36"
}

def fetch_page(url, request_headers):
	request = urllib.request.Request(url, None, request_headers)
	response = urllib.request.urlopen(request)
	if response and response.status == 200:
		return response.read()
	return False

def fetch_and_save_page(year):
	if not year:
		print("error: invalid year {}".format(year))
		return

	filename = "en_wikipedia_org_{}_NHL_Entry_Draft.html".format(year)
	url = "https://en.wikipedia.org/wiki/{}_NHL_Entry_Draft".format(year)

	if os.path.isfile(filename):
		print("warning: file exists: {}".format(filename))
		return

	page = fetch_page(url, request_headers)
	if page:
		with open(filename, "wb") as output_file:
		 	output_file.write(page)

	return filename

if __name__ == "__main__":
	fetch_and_save_page(sys.argv[1])
