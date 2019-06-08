# GCP documentation for your ebook reader

Main entry point is the `Makefile`.

```
make get
```

Gets the urls from the `sources.txt` file, and puts the html in `docs/`


```
make sanitize-html
```
Takes the files from `docs/`, and cleans the html so it can be parsed better in
later stages. Results are in `html/`.

```
make epub
```

Takes the files in `html/`, and converts them to the epub format.


```
make kindle
```
Creates kindle ebooks from the epub files.



