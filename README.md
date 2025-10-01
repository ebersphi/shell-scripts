# shell-scripts

Mostly shell and awk

Compatible bash, zsh, ksh

### Guidelines

* Abort early
* Avoid bashisms : `let`&emsp;`<<<`&emsp;`<(`
* implement --info
* implement -V --version
* implement -h --help --usage 
* indenting is 3 or 4 spaces, no tabulations

### Naming rules
| item | case | examples |
| :--- | :--- | :--- |
| function | snake_case | do_nothing<br> set_params |
| constant | \_UPPERCASE_ | \_HELP_ <br> \_EOT_ |
| variable | camelCase<br>PascalCase | fileName<br>Total<br>Value |

### Coding rules


Preferred coding uses
* increment, int maths

```
   myVar=$(( myVar + 1))
   sizeInKB=$(( ( TotalMB - DiffMB ) * 1024 )) 
```
* tests

``` 
   [ <test> ] || [ <test> ]
   [ <test> ] && [ <test> ]
```

* read from a file

```
while read -r Line; do
   ...
done < `file`
```
