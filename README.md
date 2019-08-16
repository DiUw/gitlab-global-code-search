## General

Will search through all known Gitlab projects on YOUR own instrance of GitLab.

*Projects permisson must be set to public for script to work*

*Before the first run, please replace 4 params in **config.yml**:*

*Script was tested on Gitlab community version 11.1*


```yaml
GITLAB_URL: https://your.gitlab.uri   (What is your Gitlab url)
PRIVATE_TOKEN: YOUR_TOKEN (Token to use to talk to gitlab. Needs to be admin token)
REMEMBER_USER_TOKEN: YOUR_COOKIE_TOKEN (Your gitlab login cookie token)
COLOUR: true (if 'false', results are printed in monochrome)
```

You can safely copy **config.yml.example** to **config.yml** and edit.


## Usage

 *Note* below bundle isn't needed, because the script seems to only dependt on have ruby installed.
 
 Script was tested with:

```yaml
ruby: 2.5.5p157
gem: 2.7.6.2

```
If errors occours with json, try installing bundle with the code below. 
The code might need sudo permissons for installations, check the erorrs for permisson errors.
run this code within this repo, to locate the gemfile

```bash
$ gem install bundler:1.11.2

$ gem install json


$ bundle install

# if json fails, try

$ gem 'json', '>= 1.8' or $ gem install json -v '1.8.3'


```

```bash
Usage: ./gitlab_global_code_search [options]
    -d, --dryrun
    -r, --recache
    -s SEARCH_STRING,                [REQUIRED]
        --search-string
    -n, --namespaces NAMESPACES      [REQUIRED] Comma separated list of namespaces (you can set namespaces=all to search through all Gitlab repos, but mind the Load on the server
```

First time project runs it will need to create local cache, so don't wonder why it loads 100 projects per GitLab page.

Next time you need to recache use --recache option

## Examples

* Locate word 'azure' in all found project code
```bash
./gitlab_global_code_search.rb -s azure -n all
```

* Locate word 'findme' in projects with namespaces namespace1 and namespace2
```bash
./gitlab_global_code_search.rb -s findme -n namespace1,namespace2
```

* Locate word 'foo' in project with namespace namespace1 and print results to foo.txt
```bash
./gitlab_global_code_search.rb -s foo -n namespace1 | tee result/foo.txt
```
