# Array Syntax

## 1. Declaration
```
array=(val1, val2, val3)
```

## 2. Concat/Appending
```
array+=(newval1, newVal2)
```

## 3. Reading

### 3.1 Accessing all indices
```
${!array[@]}
```

### 3.2 Accessing all elements
```
${array[@]}
```

### 3.3 Get size
```
${#array[@]}
```

### 3.4 Slicing 
```
${array[@]:start_index:number_of_elements}
```


## 4. Looping example
``` 
for element in ${array[@]}; do
    //some stuff
done
```
