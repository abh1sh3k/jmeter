# SummaryReport.sh

When we run Jmeter from command line we do not get a report like we do using "Summary Report" listener. However, command line utility can save the output in csv file and we can generate "Summary Report" like output in a text file using shell script.

Run below command from command to execute your test plan and generate output in csv.

jmeter.sh -n -t <your jmx file path> -l <output file path with file name.csv>

ex-

./jmeter.sh -n -t /home/abhishek/TestSampler.jmx -l /home/abhishek/SampleOutput.csv

Run the script with output file as its argument

./SummaryReport.sh SampleOutput.csv
