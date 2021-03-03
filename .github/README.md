# Column Uniquely Sorted
[heading__top]:
  #column-uniquely-sorted
  "&#x2B06; Collects and sorts unique columns"


Collects and sorts unique columns


## [![Byte size of Column Uniquely Sorted][badge__main__column_uniquely_sorted__source_code]][column_uniquely_sorted__main__source_code] [![Open Issues][badge__issues__column_uniquely_sorted]][issues__column_uniquely_sorted] [![Open Pull Requests][badge__pull_requests__column_uniquely_sorted]][pull_requests__column_uniquely_sorted] [![Latest commits][badge__commits__column_uniquely_sorted__main]][commits__column_uniquely_sorted__main]



---


- [:arrow_up: Top of Document][heading__top]

- [:building_construction: Requirements][heading__requirements]

- [:zap: Quick Start][heading__quick_start]

  - [:floppy_disk: Clone][heading__clone]
  - [:heavy_plus_sign: Install][heading__install]
  - [:fire: Uninstall][heading__uninstall]
  - [:arrow_up: Upgrade][heading__upgrade]
  - [:bookmark_tabs: Documentation][heading__documentation]

- [&#x1F9F0; Usage][heading__usage]

  - [Examples][heading__examples]

- [&#x1F523; API][heading__api]

- [&#x1F5D2; Notes][heading__notes]

- [:chart_with_upwards_trend: Contributing][heading__contributing]

  - [:trident: Forking][heading__forking]
  - [:currency_exchange: Sponsor][heading__sponsor]

- [:card_index: Attribution][heading__attribution]

- [:balance_scale: Licensing][heading__license]


---



## Requirements
[heading__requirements]:
  #requirements
  "&#x1F3D7; Prerequisites and/or dependencies that this project needs to function properly"


This project was tested with GNU flavored Awk, AKA `gawk`; before opening new Issues please ensure that version `4.1.4` or greater is installed...


- Arch based Operating Systems


```Bash
sudo packman -Syy

sudo packman -S gawk git make
```


- Debian derived Distributions


```Bash
sudo apt-get update

sudo apt-get install gawk git make
```


______


## Quick Start
[heading__quick_start]:
  #quick-start
  "&#9889; Perhaps as easy as one, 2.0,..."


> Perhaps as easy as one, 2.0,...


---


### Clone
[heading__clone]:
  #clone
  "&#x1f4be;"


Clone this project...


```Bash
mkdir -vp ~/git/hub/awk-utilities

cd ~/git/hub/awk-utilities

git clone git@github.com:awk-utilities/column-uniquely-sorted.git
```


---


### Install
[heading__install]:
  #install
  "&#x2795;"


Project script(s) and manual page(s) may be installed via `make install` command...


```Bash
cd ~/git/hub/awk-utilities/column-uniquely-sorted

make install
```


---


### Uninstall
[heading__uninstall]:
  #uninstall
  "&#x1f525;"


Script(s) and manual page(s) for this project may be uninstalled via `uninstall` Make target...


```Bash
cd ~/git/hub/awk-utilities/column-uniquely-sorted

make uninstall
```


---


### Upgrade
[heading__upgrade]:
  #upgrade
  "&#x2b06;"


To update in the future use `make upgrade` command...


```Bash
cd ~/git/hub/awk-utilities/column-uniquely-sorted

make upgrade
```


---


### Documentation
[heading__documentation]:
  #documentation
  "&#x1F4D1;"


After installation documentation may be accessed via `man` command, eg...


```Vim
man column-uniquely-sorted.awk
```


______


## Usage
[heading__usage]:
  #usage
  "&#x1F9F0; How to utilize this repository"


Linux based distributions with MAwk, GAwk, and/or Awk installed generally may run Awk scripts directly, eg...


```Bash
script_name.awk --param=value input_file.ext
```


... However, some systems do not have the Awk executable linked to `/usr/bin/awk` file path, in such cases Awk scripts must be invoked via...


```Bash
awk -f script_name.awk --param=value input_file.ext
```


---


### Examples
[heading__examples]:
  #examples


**`file-one.txt`**


```
foo
bar
spam
ham
```


**`file-two.txt`**


```
foo
lamb
spam
ham
```


By default the `column-uniquely-sorted.awk` script will sort unique lines, not just an individual column...


```
column-uniquely-sorted.awk file-one.txt file-two.txt
#> bar
#> foo
#> ham
#> lamb
#> spam
```


And it is possible to instead sort by count, as well as reverse sort order...


```
column-uniquely-sorted.awk --count\"
                           --reverse\" 
                           file-one.txt\
                           file-two.txt
#> 2 spam
#> 2 ham
#> 2 foo
#> 1 lamb
#> 1 bar
```


______


## API
[heading__api]:
  #api
  "&#x1F523; Available command-line options"


> Available command-line options


- `--blank` `<string>` - Blank line identifier, if undefined then blank lines/columns are ignored

- `--column` `<number>` - Selected column to collect, count, and sort. Default `0`

- `--count` - Sorts by count if defined

- `--usage` - Prints help message and exits

- `--reverse` - Reverse sorted output

- `--version` - Prints version for this script and exits\n


______


## Notes
[heading__notes]:
  #notes
  "&#x1F5D2; Additional things to keep in mind when developing"


The `column-uniquely-sorted.awk` script requires that sufficient memory is available for **all** parsed entries.


Currently blank/empty lines are **not** counted or sorted.


This repository may not be feature complete and/or fully functional, Pull Requests that add features or fix bugs are certainly welcomed.


______


## Contributing
[heading__contributing]:
  #contributing
  "&#x1F4C8; Options for contributing to column-uniquely-sorted and awk-utilities"


Options for contributing to column-uniquely-sorted and awk-utilities


---


### Forking
[heading__forking]:
  #forking
  "&#x1F531; Tips for forking column-uniquely-sorted"


Start making a [Fork][column_uniquely_sorted__fork_it] of this repository to an account that you have write permissions for.


- Add remote for fork URL. The URL syntax is _`git@github.com:<NAME>/<REPO>.git`_...


```Bash
cd ~/git/hub/awk-utilities/column-uniquely-sorted

git remote add fork git@github.com:<NAME>/column-uniquely-sorted.git
```


- Commit your changes and push to your fork, eg. to fix an issue...


```Bash
cd ~/git/hub/awk-utilities/column-uniquely-sorted


git commit -F- <<'EOF'
:bug: Fixes #42 Issue


**Edits**


- `<SCRIPT-NAME>` script, fixes some bug reported in issue
EOF


git push fork main
```


> Note, the `-u` option may be used to set `fork` as the default remote, eg. _`git push -u fork main`_ however, this will also default the `fork` remote for pulling from too! Meaning that pulling updates from `origin` must be done explicitly, eg. _`git pull origin main`_


- Then on GitHub submit a Pull Request through the Web-UI, the URL syntax is _`https://github.com/<NAME>/<REPO>/pull/new/<BRANCH>`_


> Note; to decrease the chances of your Pull Request needing modifications before being accepted, please check the [dot-github](https://github.com/awk-utilities/.github) repository for detailed contributing guidelines.


---


### Sponsor
  [heading__sponsor]:
  #sponsor
  "&#x1F4B1; Methods for financially supporting awk-utilities that maintains column-uniquely-sorted"


Thanks for even considering it!


Via Liberapay you may <sub>[![sponsor__shields_io__liberapay]][sponsor__link__liberapay]</sub> on a repeating basis.


Regardless of if you're able to financially support projects such as column-uniquely-sorted that awk-utilities maintains, please consider sharing projects that are useful with others, because one of the goals of maintaining Open Source repositories is to provide value to the community.


______


## Attribution
[heading__attribution]:
  #attribution
  "&#x1F4C7; Resources that where helpful in building this project so far."


- [GitHub -- `github-utilities/make-readme`](https://github.com/github-utilities/make-readme)


______


## License
[heading__license]:
  #license
  "&#x2696; Legal side of Open Source"


```
Collects and sorts unique columns
Copyright (C) 2021 S0AndS0

This program is free software: you can redistribute it and/or modify
it under the terms of the GNU Affero General Public License as published
by the Free Software Foundation, version 3 of the License.

This program is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU Affero General Public License for more details.

You should have received a copy of the GNU Affero General Public License
along with this program.  If not, see <https://www.gnu.org/licenses/>.
```


For further details review full length version of [AGPL-3.0][branch__current__license] License.



[branch__current__license]:
  /LICENSE
  "&#x2696; Full length version of AGPL-3.0 License"


[badge__commits__column_uniquely_sorted__main]:
  https://img.shields.io/github/last-commit/awk-utilities/column-uniquely-sorted/main.svg

[commits__column_uniquely_sorted__main]:
  https://github.com/awk-utilities/column-uniquely-sorted/commits/main
  "&#x1F4DD; History of changes on this branch"


[column_uniquely_sorted__community]:
  https://github.com/awk-utilities/column-uniquely-sorted/community
  "&#x1F331; Dedicated to functioning code"


[issues__column_uniquely_sorted]:
  https://github.com/awk-utilities/column-uniquely-sorted/issues
  "&#x2622; Search for and _bump_ existing issues or open new issues for project maintainer to address."

[column_uniquely_sorted__fork_it]:
  https://github.com/awk-utilities/column-uniquely-sorted/
  "&#x1F531; Fork it!"

[pull_requests__column_uniquely_sorted]:
  https://github.com/awk-utilities/column-uniquely-sorted/pulls
  "&#x1F3D7; Pull Request friendly, though please check the Community guidelines"

[column_uniquely_sorted__main__source_code]:
  https://github.com/awk-utilities/column-uniquely-sorted/
  "&#x2328; Project source!"

[badge__issues__column_uniquely_sorted]:
  https://img.shields.io/github/issues/awk-utilities/column-uniquely-sorted.svg

[badge__pull_requests__column_uniquely_sorted]:
  https://img.shields.io/github/issues-pr/awk-utilities/column-uniquely-sorted.svg

[badge__main__column_uniquely_sorted__source_code]:
  https://img.shields.io/github/repo-size/awk-utilities/column-uniquely-sorted






[sponsor__shields_io__liberapay]:
  https://img.shields.io/static/v1?logo=liberapay&label=Sponsor&message=awk-utilities

[sponsor__link__liberapay]:
  https://liberapay.com/awk-utilities
  "&#x1F4B1; Sponsor developments and projects that awk-utilities maintains via Liberapay"



