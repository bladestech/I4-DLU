# I4-DLU (IPv4 DNS Lookup Utility)

**I4-DLU (IPv4 DNS Lookup Utility)** is a powerful and user-friendly command-line tool designed to perform IPv4 DNS lookups. It allows users to easily resolve domain names and URLs to their corresponding IPv4 addresses. The utility supports testing common domain suffixes and all possible suffixes available in its database, making it a versatile tool for network administrators, developers, and anyone interested in DNS resolution.

## Features

- **Common Suffix Testing**: Automatically tests common domain suffixes (e.g., `.com`, `.org`, `.net`) to find valid IPv4 addresses.
- **Full Suffix Testing**: Tests all possible domain suffixes to ensure thorough coverage.
- **Acceleration Mode**: Offers an accelerated mode to speed up the testing process, though users should be aware of potential ISP violations.
- **User-Friendly Interface**: Simple and intuitive command-line interface for easy use.
- **Clear Output**: Provides clear and concise output of resolved IPv4 addresses.

## Installation

1. **Download the Script**:
   - Clone the repository or download the script file (`I4-DLU.bat`) from the [releases page](https://github.com/bladestech/I4-DLU/releases).

2. **Run the Script**

## Usage

1. **Enter Domain Name or URL**:
   - When prompted, enter the domain name or URL you want to resolve.
   - Example: `example.com` **or** `example` (*if you want to look for the suffix of a domain.*)

2. **Test Common Suffixes**:
   - If no domain suffix is detected, you will be prompted to test common suffixes first (This is helpful if you can't remember a URL!).
   - Example: `Y` to test common suffixes.

3. **Test All Suffixes**:
   - If no valid IPs are found with common suffixes, you can choose to test all possible suffixes.
   - Example: `Y` to test all suffixes.

4. **Enter Next Domain/URL**:
   - After resolving a domain, you can enter another domain or URL to resolve.
   - Type `X` to clear the screen and start over.

## License

This project is released into the public domain under the [Unlicense](LICENSE). You are free to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the software, with or without modification.
