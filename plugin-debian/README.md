# Debian packaging plugin
Given code base consists of two Valder build plugins which are capable of creating debian packages with two different forms:

## debian:package
This particular plugin creates a .deb file with all runtime and libriaries binaries locater under target/ directory structure. It's algorithm is quite naive and follows given steps:

* Collect all binaries located under **target/bin** and **target/lib**,
* Call 'ldd <file>' for each of them where <file> is one of collected binaries,
* Call 'dpkg <library>' for each library used to get list of required dependencies,
* Generate control and md5sums files,
* Pack everything with 'dpkg -b'

## debian:package-dev
As you can guess this plugin creates a debian archive with all development files necessary for further usage by other developers out there. It's algorithm is slightly more complicated and involces steps as following:

* Initialize CodeContext from libvala,
* For each project dependency do:
  * Use dependency as a temporary CodeContext external package,
  * Do an AST traversal using CodeVisitor instance,
  * Collect all .vapi and .h files found by CodeContext and CodeVisitor referenced anywhere possible,
  * For each .h file run 'dpkg -S' and 'apt search' to find debian package that contains given file,
  * Generate control and md5sums files,
  * Pack everything with 'dpkg -b'

Usualy in debian control file one can define some additional metadata like package section name, mainainter address, etc. For that purpose, receipe file (**receipe.bob**) structure has been extended and now now allows to define some additional information. Please find following example:

```json
{
    "project": {
        "name": "Some project",
        "shortName": "something",
        "version": "0.0.1",
        "details": {
            "description": "This is some project",
            "authors": ["Lukasz Grabski <activey@doaplatform.org>", "Linus Torvalds <torvalds@osdl.org>"],
            "section": "devel",
            "architecture": "all"
        },
```

Both plugins take an advantage of "details" section using it's data to fill in control file. Bellow you can find all control file attributes currently used.

Control file attribute | Binding | Default value if not available
-------------|-------------------|-----------------
Package      | project.shortName | 'unknown'
Version      | project.version | '0.0.1'
Description  | project.details.description | ''
Section      | project.details.section | 'unknown'
Priority     | project.details.priority | 'optional'
Architecture | project.details.architecture | 'all'
Depends      | *Generated automatically* |
Maintainer   | project.details.authors[0] | ''
Uploaders    | project.details.authors[1..n] | ''

Packages will be locater under **/tmp** directory.

Everything is very experimental. Please send your notes or suggestions if any.