# Homework 7: Linux CLI Practice
## Overview
This homework assignment was made to give us some practice with Linux CLI tools and command-chaining. 
## Deliverables
### Problem 1:
1. `wc lorem-ipsum.txt -w`
2. ![P1](assets/linux_cli_practice/problem1.png)
### Problem 2:
1. `wc lorem-ipsum.txt -m`
2. ![P2](assets/linux_cli_practice/problem2.png)
### Problem 3:
1. `wc lorem-ipsum.txt -l`
2. ![P3](assets/linux_cli_practice/problem3.png)
### Problem 4:
1. `sort file-sizes.txt -h`
2. ![P4](assets/linux_cli_practice/problem4.png)
### Problem 5:
1. `sort -h -r file-sizes.txt`
2. ![P5](assets/linux_cli_practice/problem5.png)
### Problem 6:
1. `cut -d, -f3 log.csv`
2. ![P6](assets/linux_cli_practice/problem6.png)
### Problem 7:
1. `cut -d, -f2,3 log.csv`
2. ![P7](assets/linux_cli_practice/problem7.png)
### Problem 8:
1. `cut -d, -f1,4 log.csv`
2. ![P8](assets/linux_cli_practice/problem8.png)
### Problem 9:
1. `head -n3 gibberish.txt`
2. ![P9](assets/linux_cli_practice/problem9.png)
### Problem 10:
1. `tail -n 2 gibberish.txt`
2. ![P10](assets/linux_cli_practice/problem10.png)
### Problem 11:
1. `tail -q log.csv`
2. ![P11](assets/linux_cli_practice/problem11.png)
### Problem 12:
1. `grep 'and' gibberish.txt`
2. ![P12](assets/linux_cli_practice/problem12.png)
### Problem 13:
1. `grep -n -w 'we' gibberish.txt`
2. ![P13](assets/linux_cli_practice/problem13.png)
### Problem 14:
1. `grep -i -Po 'to [a-zA-z]*' gibberish.txt`
2. ![P14](assets/linux_cli_practice/problem14.png)
### Problem 15:
1. `grep -c 'FPGAs' fpgas.txt`
2. ![P15](assets/linux_cli_practice/problem15.png)
### Problem 16:
1. `grep -P '(ot|er|ile)[.!?,;:]$' fpgas.txt`
2. ![P16](assets/linux_cli_practice/problem16.png)
### Problem 17:
1. `find ../../hdl -name "*.vhd" -exec sh -c 'count=$(grep -c "^\s*--" "{}"); echo "{}:$count"' \;`
2. ![P17](assets/linux_cli_practice/problem17.png)
### Problem 18:
1. `ls > ls-output.txt` and `cat ls-output.txt`
2. ![P18](assets/linux_cli_practice/problem18.png)
### Problem 19:
1. `sudo dmesg | grep "CPU topo"` Note: I ended up using `sudo dmesg | grep "CPU"` instead as the first command returned nothing
2. ![P19](assets/linux_cli_practice/problem19.png)
### Problem 20:
1. `find ../../hdl -iname '*vhd' | wc -l`
2. ![P20](assets/linux_cli_practice/problem20.png)
### Problem 21:
1. `find ../../hdl -iname '*.vhd' -exec grep '^\s*--' {} \; | wc -l`
2. ![P21](assets/linux_cli_practice/problem21.png)
### Problem 22:
1. `grep -n "FPGAs" fpgas.txt | cut -d: -f1`
2. ![P22](assets/linux_cli_practice/problem22.png)
### Problem 23:
1. `du -h --max-depth=0 ~/Desktop/labs-and-homework-Dylan-Raber/* | sort -hr | head -n 3`
2. ![P23](assets/linux_cli_practice/problem23.png)
 