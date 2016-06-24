## General


Will search through all known Gitlab projects on YOUR own instrance of GitLab.
Currently doesn't seem to be supported feature on GitLab itself.  
Code is tested with GitLab Community Edition 8.6.6.
It is really fitted to work with this specific version, never tested it with any other.
Before it can run replace 2 params in config.yml :

GITLAB_URL:https://your.gitlab.uri   (What is your Gitlab url)
PRIVATE_TOKEN:YOUR_TOKEN (Token to use to talk to gitlab. Needs to be admin token)


## Usage

bundle install

Usage: ./gitlab_global_code_search [options]
    -d, --dryrun
    -r, --recache
    -s SEARCH_STRING,                [REQUIRED]
        --search-string
    -n, --namespaces NAMESPACES      [REQUIRED] Comma separated list of namespaces (you can set namespaces=all to search through all Gitlab repos, but mind the Load on the server

First time project runs it will need to create local cache, so don't wonder why it loads 100 projects per GitLab page
Next time you need to recache use --recache option

## Examples

Locate word 'curl' in all found project code
./gitlab_global_code_search.rb -s curl -n all

Locate word 'findme' in projects with namespaces namespace1 and namespace2
./gitlab_global_code_search.rb -s findme -n namespace1,namespace2
