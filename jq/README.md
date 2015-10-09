## jq is like sed for JSON data
This image executes [jq][1]. It's based on an alpine image and clocks in at a hefty 17MB.

Usage
-----
```sh
curl 'https://api.github.com/repos/stedolan/jq/commits' | docker run -i pinterb/jq:latest '.'
```

[1]: https://stedolan.github.io/jq/