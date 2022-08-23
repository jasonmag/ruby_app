# Webpage Views and Visits Logs

To start the app on finding out the page views and unique visits. 

You need to clone first the repository to your local unit:

Using ssh:
1. `git clone git@github.com:jasonmag/ruby_app.git`

Note: Your local unit ssh key must have permission to access the repository.

Using https:
1. `git clone https://github.com/jasonmag/ruby_app.git`
2. Enter your Github username and password to able to clone the repository.

By now, you must have the local copy from github repository. Next is to run
bundler. Using the Ruby version 3.1.2, run `bundle install` 

## Architecture

The application basically check the server logs given to determine the number
of visits and unique visits based on the log files given. Intention for the
app is to run in the terminal running under the required Ruby version. 

The business logic of the app processes the log file, and segregate the list
based on the uniqueness of visits on the the logs. It will save each line of 
the log file and save it by `path`, `hits`, and `uniques` as an object in the
array.

After the app process the log data, this will return with two kinds of list
of hits and unique visits. This will give the user insights of the data that 
is being process, by simply displaying the data.

## Functionality

To run the application, run the following inside the repositry below:

`ruby parser.rb fixtures/webserver.log`

Note: the command `ruby` is optional, based on your local setup for the language.

After running the command, a display if data information should appear, like 
the sample output below.

```
$ ruby parser.rb fixtures/webserver.log

Page paths order by hits:
/about/2 90 hits
/contact 89 hits
/index 82 hits
/about 81 hits
/help_page/1 80 hits
/home 78 hits

Page paths order by uniques:
/help_page/1 23 uniques
/contact 23 uniques
/home 23 uniques
/index 23 uniques
/about/2 22 uniques
/about 21 uniques
```

By checking the each data output is correct, you can check by running the 
following command.

```
$ cat fixtures/webserver.log | grep /about/2 | sort |wc -l
90
$ cat fixtures/webserver.log | grep /about/2 | sort |uniq|wc -l
22
```

## Efficiency

### Code

* `parser.rb` - command-line usage only; argument validation, obtaining a file handle.
* `lib/analyser.rb` - acts somewhat like a "controller", connecting a Scanner,
  Repository and the various input and output streams.
* `lib/scanner.rb` - parses the input file, yielding specific objects (path, ip) back to the analyser.
* `lib/in_memory_repository.rb` - handles storing and sorting the incoming objects.

It's _possible_ that specifically calling out the InMemoryRepository is a step
too far, but it's a nice easy step for future enhancement to replace it with a
database backed key which could improve sorting and querying efficiency for
large files.

### Data Processing

This hasn't been my focus for this exercise; the implemented system is probably
O(3n) as it needs to iterate through the provided set three times to produce
output; once to store, and twice to sort.

It's possible (as described above) that an "index" of sorts, that's presorted,
could be produced by modifying `InMemoryRepository#store` to build up a
different data structure, reducing algorithmic complexity.

Given the provided file is only 500 lines long, that seems unnecessary at this
stage.

If efficiency is a critical concern, log analysis can be handled better at
scale with an ELK (Elasticsearch-Logstash-Kibana) stack, or some other form of
log analysis tool.

Alternatively, the use of bash commands above to generate these figures implies
that a command-line solution using a combination of `sed` / `awk` / `sort` /
`uniq` should be possible with little effort, and is likely to be much more
performant.

### Tests

A full test suite exists in `/spec`, accessible by running `rspec` from the
command line.

Installing simplecov (see previous commit) shows code coverage is at 100%. I
have committed my latest coverage report to this repository.

## Next steps

### Potential improvements

* `parser.rb` - switch to `optparse` to parse command-line flags and allow
  switching between uniques, hits, or both.
* `parser.rb` - more validation around file access (we don't test we can read
  it before entering the analyser, f.e.)
* `parser.rb` - add `--help` commandline flag describing usage
* `lib/analyser.rb` - extract a class responsible for outputting to the command
  line in the correct format.
* `lib/in_memory_repository.rb` - Improve the efficiency of sorting by
  pregenerating sorted arrays in #store
* `lib/sql_repository.rb` - Use a MySQL repository to insert and query data;
  this might make the sorting quicker as you can let the database engine handle
  sorting the data as required for larger datasets.
* `lib/scanner.rb` - use of `String#split` here might be brittle with truncated
  or corrupted datasets.