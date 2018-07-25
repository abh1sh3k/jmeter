#! /bin/sh

FILENAME=$1

sed 's/,/ /g' $FILENAME > /tmp/testfile
awk -F, '{a[$3];}END{for (b in a)print b;}' $FILENAME > /tmp/labelname

echo Label "|" Samples "|" Average "|" Min "|" Max "|" StdDev "|" Error% "|" Throughput/sec "|" KB/sec "|" AvgBytes "|" > SummaryReport
while read LINE
do
    grep -w    $LINE /tmp/testfile > /tmp/$LINE
    SAMPLES=`awk '{count++}END{print count}' /tmp/$LINE`
    AVERAGE=`awk '{sum+=$2}END{print sum/NR}' /tmp/$LINE`
    MINIMUM=`awk 'min=="" || $2<min {min=$2}END{print min}' FS=" " /tmp/$LINE`
    MAXIMUM=`awk 'max=="" || $2>max {max=$2}END{print max}' FS=" " /tmp/$LINE`
    STDDEV=`awk '{sum+=$2; array[NR]=$2} END {for(x=1;x<=NR;x++){sumsq+=((array[x]-(sum/NR))^2);}print sqrt(sumsq/NR)}' /tmp/$LINE`
    ERROR=`awk '/false/ {count++} END {print ((count/NR)*100)}' /tmp/$LINE`
    THROUGHPUT=`awk '{if(min==""){min=max=$1};if($1>max){max=$1};if($1<min){min=$1}}END{print (NR/(max-min))*1000}' /tmp/$LINE`
    AVGBYTES=`awk '{sum+=$12}END{print sum/NR}' /tmp/$LINE`
    KBSEC=$(echo | awk '{print ("'"$AVGBYTES"'"/1024)*"'"$THROUGHPUT"'"}')
    echo $LINE "|" $SAMPLES "|" $AVERAGE "|" $MINIMUM "|" $MAXIMUM "|" $STDDEV "|" $ERROR "|" $THROUGHPUT "|" $KBSEC "|" $AVGBYTES "|" >>SummaryReport
    rm /tmp/$LINE
done < /tmp/labelname
rm /tmp/labelname

totSAMPLES=`awk '{count++}END{print count}' /tmp/testfile`
totAVERAGE=`awk '{sum+=$2}END{print sum/NR}' /tmp/testfile`
totMINIMUM=`awk 'min=="" || $2<min {min=$2}END{print min}' FS=" " /tmp/testfile`
totMAXIMUM=`awk 'max=="" || $2>max {max=$2}END{print max}' FS=" " /tmp/testfile`
totSTDDEV=`awk '{sum+=$2; array[NR]=$2} END {for(x=1;x<=NR;x++){sumsq+=((array[x]-(sum/NR))^2);}print sqrt(sumsq/NR)}' /tmp/testfile`
totERROR=`awk '/false/ {count++} END {print ((count/NR)*100)}' /tmp/testfile`
totTHROUGHPUT=`awk '{if(min==""){min=max=$1};if($1>max){max=$1};if($1<min){min=$1}}END{print (NR/(max-min))*1000}' /tmp/testfile`
totAVGBYTES=`awk '{sum+=$12}END{print sum/NR}' /tmp/testfile`
totKBSEC=$(echo | awk '{print ("'"$totAVGBYTES"'"/1024)*"'"$totTHROUGHPUT"'"}')
echo TOTAL "|" $totSAMPLES "|" $totAVERAGE "|" $totMINIMUM "|" $totMAXIMUM "|" $totSTDDEV "|" $totERROR "|" $totTHROUGHPUT "|" $totKBSEC "|" $totAVGBYTES "|" >>SummaryReport
rm /tmp/testfile
