# cisco-phone-nse
This repository contains an [Nmap script](https://nmap.org/book/man-nse.html) (named http-cisco-phone.nse) that retrieves the model, extension, and MAC address of Cisco IP phones. Cisco phones have a built-in HTTP server that runs on port 80, allowing you to view this information in a web browser. This script automates this process to make it easier to discover Cisco phone information on a network automatically using Nmap.

# Usage
To use this script (or any Nmap script), it needs to be placed in a directory that is searched by Nmap.

When running Nmap from the command line, the current directory is searched. This means that you can simply run nmap from the directory containing the script (http-cisco-phone.nse). This is convenient for one-time usage of the script.

For continued/repeated use of the script, the preferred method is to move the script to a directory such as `~/.nmap` on Linux-based systems, or `%APPDATA%\nmap` on Windows. For a complete list of directories, please see the [Nmap documentation](https://nmap.org/book/man-nse.html).

## Running the script
Once you have the script in a directory that will be searched by Nmap, run Nmap with the the following option: `--script http-cisco-phone`. Note that your scan must include port 80 (included in the default scan settings), since this script retrieves information from the HTTP server.

# Example output
Here is an example of what the output of this script may look like:

```
Nmap scan report for 10.31.41.59
Host is up (0.037s latency).

PORT   STATE SERVICE
80/tcp open  http
| http-cisco-phone: 
|   MAC: A0B1C2D3E4F5
|   model: CP-7821
|_  extension: 172839
```

# Testing this script
This repository contains a set of HTML files in the PhoneTestHtml directory. These HTML files are the saved output from connecting to real Cisco phones in a browser. The MACs and serial numbers in these files have been replaced with made up information, but the formatting is the same. The files are named after the model of phone they were taken from. These files are intended only for testing purposes.

To test the script with one of these files, it will need to be served by an HTTP server on port 80 when an empty path is requested. A simple way to do this is to either make a symlink named "index.html" to the HTML file in question, or to rename the file to index.html. After that, start an HTTP server in the same directory. If you have Python installed, you may run `python -m http.server 80` (port 80 requires root privileges on most systems).

At the time of writing, this script fails on some of these files (and hence their corresponding models of Cisco phone). This is due to different models of phones having different formatting for certain fields (e.g. some phones have colons in the MAC, and others do not).
