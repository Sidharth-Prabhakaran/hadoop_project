 #!/bin/bash
PASS=0
SCORE=0 
TOTAL_TESTS=6

hadoop fs -ls /  > output.txt
TEST_1=$( grep -e "sqoop" output.txt | wc -l )
if [ $TEST_1 -eq 1 ]
then PASS=$((PASS + 1))
fi;


hadoop fs -ls /user/hive/warehouse/visa.db/  > output1.txt
TEST_2=$( grep -e "h1b_data" output1.txt | wc -l )
if [ $TEST_2 -eq 1 ]
then PASS=$((PASS + 1))
fi;


TEST_3=$( grep -e "question1" output1.txt | wc -l )
if [ $TEST_3 -eq 1 ]
then PASS=$((PASS + 1))
fi;

TEST_4=$( grep -e "question2" output1.txt | wc -l )
if [ $TEST_4 -eq 1 ]
then PASS=$((PASS + 1))
fi;


TEST_5=$( grep -e "question3" output1.txt | wc -l )
if [ $TEST_5 -eq 1 ]
then PASS=$((PASS + 1))
fi;

hadoop fs -ls /user/hive/warehouse/pluseval.db/  > output1.txt
TEST_6=$( grep -e "question4" output1.txt | wc -l )
if [ $TEST_6 -eq 1 ]
then PASS=$((PASS + 1))
fi;
SCORE=$((PASS*100 / TOTAL_TESTS))
echo "FS_SCORE:$SCORE%"
