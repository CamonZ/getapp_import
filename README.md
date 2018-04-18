# GetApp Import Challenge



## Installation

Clone the repo with Git

```
git clone https://github.com/CamonZ/getapp_import.git
```

Install dependencies and build the escript

```
mix deps.get && mix escript.build
```

## Usage

Execute the script after installation and building it

```
./import <backend> <data_location>
```

e.g.

```
./import capterra test/sample_data/capterra.yaml
```

or 

```
./import softwareadvice test/sample_data/softwareadvice.json
```

## Commit and PR History

Commits and PR history can be found on the PR used for the feature branch at [https://github.com/CamonZ/getapp_import/pull/1](https://github.com/CamonZ/getapp_import/pull/1)

## Design Notes

In order to design a good data pipeline for the CLI module I opted for following a similar design pattern
to what Plug does with the `conn` structure . Basically the application's state is passed as a token between
the different steps that data goes through in order to properly handle each edge scenario while minimizing
the cognitive load required to understand what the application does.

The data goes through the following steps:

* Command Line Parsing
* Loading existing Parsers
* Delegating Parsing to a specific backend based on options passed from the command line as well as existing parsers
* Data Insertion (This is more or less a placeholder module)
* Results Handling.

Each module returns a modified copy of the application state with either the sucessful data needed for the next step or an error
that can be printed at the end of the pipeline for reporting purposes.

### Comand Line Parsing

This module simply parses the arguments passed from the command line and assigns them based on position as 
the `selected_backend` and `data_location`

Only error returned here are if the user gives an amount of arguments different than 2.

### Loading Existing Parsers

Builds a Map with the parser names as keys and parser modules as values.

### Parsing Delegation

In order to have a simple interface, I used a module that based on the `selected_backend` and `registered_backends` 
of the state token I fetch the specific backend that's been selected by the user or in case of an unrecognized backend I
return an `UnrecognizedBacked` that simply returns an error when called to process the `data_location`.

Each specific backend conforms to a simple interface of `process/1` which receives the location for the data source to be parsed
and implements for the given backend the steps of:

* Data Fetching / Reading from a file
* Parsing from a raw JSON or YAML and returning a list of data structures
* Coercing each data structure into a `Software{}` struct which holds the `name`, `categories` and `twitter` handle for each software

Each specific parser handles the following scenarios:

* Happy parsing path.
* Error path when the data source can't be read / opened
* Error path with malformed data
* Error path with data missing main attributes which I assume to be the name and categories. This was a design decision based on the sample data
since there's a `softwareadvice` result without a twitter handle.

This last error path is simply a pattern match against the basic expected values, if there's no match possible, `nil` is returned
for the specific software instance and the final list compacted to reject all possible `nil` instances.

Finally, it's important to note that if the Command Line Parsing module has returned any type of errors any execution on this module is skipped and the 
token received as an argument is returned.


### Data Insertion

This module acts more as a placeholder for what would be actual data insertion against an Ecto Repo, it simply maps each item in the softwares list
and returns a tuple of `{:ok, software}`

This module is also skipped if there are any errors from previous modules and the original state token is returned.

### Results Handling

Finally, this module simply prints either the errors of the execution or the imported software instances.


## Tests

The implementation is thoroughly tested for the core logic of command line parsing, registering existing parsers, 
parser delegation and parser implementation.

The tests for the `DataInserter` and `ResultsHandler` modules are left pending since the former is just a placeholder module and the latter simply
prints to console the results of the execution.


## Extensability

The code is extensible in multiple points, e.g. 

* A new parser implementation can be done by modifying `BackendsRegistrator` and adding the new implentation under the `Import.Backends` namespace
* Logging for non-coerceable data for a specific parser can be done by modifying the private function `to_software(_)` of the parser implementation
* On a more complex data flow where more than one error type can happen, errors can simply be appended to the errors key on `StateToken` and printed as a list
  on `ResultsHandler`
* On `DataInserter` if a specific software instance can't be inserted or updated a tuple of `{:error, changeset}` can be returned so that errors can be inspected
  or acted upon.
* New steps can be easily added by modifying the pipeline on the `Import.CLI` module and following the convention of returning a modified `StateToken` struct


## Further Improvements

* Possibly using metaprogramming to create a simple DSL for adding new steps following the common interface. 
* Handling more complex data flows where conditions for the execution of a given step are dependent on multiple conditions
* Handling huge amounts of source data as a stream instead of a single-step read, this would require changing the execution steps 
  to maybe using a library like Flow.
* Handling of data as a stream of events that would require a backpressure mechanism.
