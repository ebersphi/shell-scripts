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
| *program* | `lowercase` | pgconnections.sh oraserverinfo.sh |
| | `camelCase` | copyFromSAN |
| | mixed case `| getDriverInfo-4.260408.7.jar |
| *function* | `snake_case` | do_nothing<br> set_params |
| | `lowercase` | printmsg<br>  |
| *constant* | \_`UPPERCASE`\_ | \_HELP\_ <br> \_EOT\_ |
| | `UPPERCASE` | RC=$? - legacy use |
| *variable* | `PascalCase` | fileName<br>Total<br>Value |
| | `lowercase` | i, j, k, f, n, nbl - counters, loop indexes |
| *parameter* | Param\_`snake_case` | Param\_db\_name / --db-name |
| | ParamDefault\_`snake_case` | ParamDefault\_db\_port=5432 |

### Coding rules

Preferred coding uses
* increment, int maths

```bash
   MyVar=$(( MyVar + 1))
   SizeInKB=$(( ( TotalMB - DiffMB ) * 1024 )) 
```
* tests

```bash 
   [ <test> ] || [ <test> ]
   [ <test> ] && [ <test> ]
```

* read from a file

```bash
while read -r Line; do
   ...
done < "$File"
```
