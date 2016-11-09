## General


Will search through all known Gitlab projects on YOUR own instrance of GitLab.
Currently doesn't seem to be supported feature on GitLab itself.

Code is tested with GitLab Community Edition 8.6.6.
It is really fitted to work with this specific version, never tested it with any other.

Before the first run, please replace 4 params in **config.yml**:

```yaml
GITLAB_URL: https://your.gitlab.uri   (What is your Gitlab url)
PRIVATE_TOKEN: YOUR_TOKEN (Token to use to talk to gitlab. Needs to be admin token)
REMEMBER_USER_TOKEN: YOUR_COOKIE_TOKEN (Your gitlab login cookie token)
COLOUR: true (if 'false', results are printed in monochrome)
```

You can safely copy **config.yml.example** to **config.yml** and edit.


## Usage

```bash
$ bundle install

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

* Locate word 'curl' in all found project code
```bash
./gitlab_global_code_search.rb -s curl -n all
```

* Locate word 'findme' in projects with namespaces namespace1 and namespace2
```bash
./gitlab_global_code_search.rb -s findme -n namespace1,namespace2
```

* Locate word 'foo' in project with namespace namespace1 and print results to foo.txt
```bash
./gitlab_global_code_search.rb -s foo -n namespace1 | tee result/foo.txt
```
