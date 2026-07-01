# shell-scripts

Mostly shell and awk

Compatible bash, zsh, ksh

### Guidelines

* Abort early
* Avoid bashisms : `let`&emsp;`<<<`&emsp;`<(`
* implement --info
* implement -V --version
* implement --help and --usage 
* indenting is 3 or 4 spaces, no tabulations

### Naming rules

| use | Meaning |
| :--: | --- |
| +++ | recommended |
| ++ | alternate formatting, external source |
| + | tolerated, don't overdo |
| - | rewrite whenever possible | 
| --- | prohibited |

| item | case | use | examples |
| :--- | :--- | :--: | :--- |
| *program* | `lowercase` | +++ | pgconnections.sh<br>oraserverinfo.sh |
| | `camelCase` | ++ | copyFromSAN |
| | mixed case | ++ | getDriverInfo-4.260408.7.jar |
| *function* | `snake_case` | +++ | do_nothing<br> set_params |
| | `lowercase` | +++ | printmsg<br> |
| *constant* | \_`UPPERCASE`\_ | +++ | \_HELP\_ <br> \_EOT\_ <br> \_DATA\_ |
| | `UPPERCASE` | + | `RC=$?`<br> -> legacy use, prefer `ReturnCode=$?` |
| | `UPPERCASE` | - | EOT |
| *variable* | `PascalCase` | +++ | FileName<br>Total<br>Value |
| | `lowercase` | - | i, j, k, f, n, nbl - counters, loop indexes |
| *parameter* [1] | Param\_`snake_case` | +++ | `Param\_db\_name` <br/> `Param\_username` |
| | ParamDefault\_`snake_case` | +++ |`ParamDefault\_db\_port`=5432 --db-port |

[1] Parameters may be linked to arguments --db-name => Param_db_name & ParamDefault_db_name ; --dry-run => Param_dry_run<br>
Or internal processing parameters Param_scripts_dir, Param_max_retries. 

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
