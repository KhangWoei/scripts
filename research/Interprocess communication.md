# [Interprocess communication](https://tldp.org/LDP/tlk/ipc/ipc.html)

## 1. [Piping](https://tldp.org/LDP/lpg/node10.html)
Passes the output (stdout) of a previous command to the input (stdin) of he next one or to shell. 

```
cat *.lst | sort | uniq 
# Merges and sorts all ".lst" files and deletes duplicate line
```

This creates a subshell, so any variables or results captured in the pipe will be lost.

## 2. [Process Substition](https://tldp.org/LDP/abs/html/process-sub.html)
Feeds the output of a process(es) into the `stdin` of another process

### 2.1 Template
Command list enclosed within parentheses
```
 >(command_list)
 <(command_list)
```
