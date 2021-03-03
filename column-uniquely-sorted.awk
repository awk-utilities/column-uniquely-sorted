#!/usr/bin/awk -f


# awk-utilities/column-uniquely-sorted script
# Copyright (C) 2021 S0AndS0
#
# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU Affero General Public License as published
# by the Free Software Foundation, version 3 of the License.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU Affero General Public License for more details.
#
# You should have received a copy of the GNU Affero General Public License
# along with this program.  If not, see <https://www.gnu.org/licenses/>.


##
# Assigns parsed reference from ARGC matched from acceptable arguments reference
# @note - Dunder variables are function scoped, and should **not** be assigned by caller
# @note - Use `gawk -h` to list parameters that parser may conflict with argument parsing
# @parameter {ArrayReference} _acceptable_arguments - Array reference of acceptable arguments
# @parameter {ArrayReference} _parsed_arguments     - Array reference that parsed arguments should be saved to
# @parameter {string}         __key__               - Associative array key that points to `_acceptable_arguments[__key__]` value
# @parameter {string[]}       __acceptable_parts__  - Array split by `:` from `_acceptable_arguments[__key__]` value
# @parameter {string}         __pattern__           - Regexp pattern from `_acceptable_arguments[__key__]` value
# @parameter {string}         __type__              - Default `"value"` from `_acceptable_arguments[__key__]` value
# @parameter {number}         __index__             - Index that points to value within `ARGC`
# @parameter {string[]}       __argument_parts__    - Array split by `=` from `ARGC[__index__]` value
# @parameter {string}         __parameter__         - Value from `__acceptable_parts__[1]`
# @author S0AndS0
# @license AGPL-3.0
# @example
#   #!/usr/bin/gawk -f
#
#
#   @include "argument-parser"
#
#
#   BEGIN {
#     delete parsed_arguments
#     delete acceptable_arguments
#
#     acceptable_arguments["usage"] = "--usage:boolean"
#     acceptable_arguments["key"] = "--key|-k:value"
#     acceptable_arguments["increment"] = "-I:increment"
#
#     argument_parser(acceptable_arguments, parsed_arguments)
#
#     for (k in parsed_arguments) {
#       print "parsed_arguments[\"" k "\"] ->", parsed_arguments[k]
#     }
#   }
function argument_parser(_acceptable_arguments, _parsed_arguments,
                         __key__, __acceptable_parts__, __pattern__, __type__,
                         __index__, __argument_parts__, __parameter__)
{
    for (__index__ = 1; __index__ < ARGC; __index__++) {
        for (__key__ in _acceptable_arguments) {
            split(_acceptable_arguments[__key__], __acceptable_parts__, ":")
            __pattern__ = __acceptable_parts__[1]
            __type__ = __acceptable_parts__[2]

            if (ARGV[__index__] ~ "^(" __pattern__ ")=.*$") {
                split(ARGV[__index__], __argument_parts__, "=")
                __parameter__ = __argument_parts__[1]
                _parsed_arguments[__key__] = substr(ARGV[__index__], (length(__parameter__) + 2))
                delete ARGV[__index__]
                if (__type__ !~ "^(array|list)") {
                    delete _acceptable_arguments[__key__]
                }
                break
            } else if (ARGV[__index__] ~ "^(" __pattern__ ")$") {
                if (__type__ ~ "^bool") {
                    _parsed_arguments[__key__] = 1
                    delete ARGV[__index__]
                    delete _acceptable_arguments[__key__]
                    break
                } else if (__type__ ~ "^increment") {
                    _parsed_arguments[__key__]++
                    delete ARGV[__index__]
                    break
                } else if (__type__ ~ "^(array|list)") {
                    _parsed_arguments[__key__][(length(_parsed_arguments[__key__]) + 1)] = ARGV[__index__ + 1]
                    delete ARGV[__index__]
                    __index__++
                    delete ARGV[__index__]
                    break
                } else {
                    _parsed_arguments[__key__] = ARGV[__index__ + 1]
                    delete ARGV[__index__]
                    __index__++
                    delete ARGV[__index__]
                    delete _acceptable_arguments[__key__]
                    break
                }
            }
        }
    }
}


##
# Print usage to Standard Out (STDOUT)
function __usage__() {
    print "Collects and sorts unique columns\n\n";

    print "Usage: column-uniquely-sorted.awk [OPTION]...\n\n";

    print "Options:";
    print "--blank <string>";
    print "    Blank line identifier, if undefined then blank lines/columns are ignored\n";

    print "--column <number>";
    print "    Selected column to collect, count, and sort. Default `0`\n";

    print "--count";
    print "    Sorts by count if defined\n";

    print "--usage";
    print "    Prints this message and exits\n";

    print "--reverse";
    print "    Reverse sorted output\n";

    print "--version";
    print "    Prints version for this script and exits\n\n";

    print "Examples:";
    print "# file-one.txt";
    print "  foo";
    print "  bar";
    print "  spam";
    print "  ham\n";

    print "# file-two.txt";
    print "  foo";
    print "  lamb";
    print "  spam";
    print "  ham\n";

    print "column-uniquely-sorted.awk file-one.txt file-two.txt";
    print "  #> bar";
    print "  #> foo";
    print "  #> ham";
    print "  #> lamb";
    print "  #> spam\n";

    print "column-uniquely-sorted.awk --count --reverse file-one.txt file-two.txt";
    print "  #> 2 spam";
    print "  #> 2 ham";
    print "  #> 2 foo";
    print "  #> 1 lamb";
    print "  #> 1 bar";
}


##
# Print license to Standard Out (STDOUT)
# @parameter {string} __date__
# @parameter {number} __year__
# @parameter {string} __author__
function __print_license__(__date__, __year__, __author__) {
    __author__ = "S0AndS0";
    __date__ = "date +'%Y'";
    __date__ | getline __year__;
    close(__date__);

    print "column-uniquely-sorted.awk - 0.0.1\n";
    print "Copyright (C)", __year__, __author__ "\n";

    print "This program is free software: you can redistribute it and/or modify";
    print "it under the terms of the GNU Affero General Public License as published";
    print "by the Free Software Foundation, version 3 of the License.\n";

    print "This program is distributed in the hope that it will be useful,";
    print "but WITHOUT ANY WARRANTY; without even the implied warranty of";
    print "MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the";
    print "GNU Affero General Public License for more details.\n";

    print "You should have received a copy of the GNU Affero General Public License";
    print "along with this program.  If not, see <https://www.gnu.org/licenses/>.";
}


##
# Initialize variables and parse command-line options
BEGIN {
    delete parsed_arguments;
    delete acceptable_arguments;

    acceptable_arguments["blank"] = "--blank:value";
    acceptable_arguments["column"] = "--column:value";
    acceptable_arguments["count"] = "--count:boolean";
    acceptable_arguments["usage"] = "--usage:boolean";
    acceptable_arguments["reverse"] = "--reverse:boolean";
    acceptable_arguments["license"] = "--license:boolean";

    argument_parser(acceptable_arguments, parsed_arguments);

    if (parsed_arguments["usage"]) {
        __usage__();
        exit 0;
    }

    if (parsed_arguments["license"]) {
        __print_license__();
        exit 0;
    }

    delete merged_lines_array;
    delete parsed_lines_array;
}


##
# Build array with line, or column, as key and count as value
{
    if (parsed_arguments["blank"]) {
      if (length($parsed_arguments["column"])) {
          merged_lines_array[$parsed_arguments["column"]]++;
      } else {
          merged_lines_array[parsed_arguments["blank"]]++;
      }
    } else {
        merged_lines_array[$parsed_arguments["column"]]++;
    }
}


##
# Parse, sort, and print array of lines
END {
    __index__ = 0;
    if (parsed_arguments["count"]) {
        for (line in merged_lines_array) {
            parsed_lines_array[__index__++] = merged_lines_array[line] " " line;
            delete merged_lines_array[line];
        }
    } else {
        for (line in merged_lines_array) {
            parsed_lines_array[__index__++] = line;
            delete merged_lines_array[line];
        }
    }

    asort(parsed_lines_array);

    if (parsed_arguments["reverse"]) {
        for (__index__ = length(parsed_lines_array); __index__ > 0; __index__--) {
            print parsed_lines_array[__index__];
            delete parsed_lines_array[__index__];
        }
    } else {
        for (__index__ in parsed_lines_array) {
            print parsed_lines_array[__index__];
            delete parsed_lines_array[__index__];
        }
    }
}

