# NPPES To S3

This is a proof-of-concept to illustrate a minimal AWS Glue job running on Spark.
It reads a single CSV table from one location in S3 and writes it to another as parquet.

## Usage

![nppess-inputs.png](nppes-inputs.png)

Add the following files from a weekly update archive from NPPES to their corresponding directories:

| Filename                                     | Directory        |
|----------------------------------------------|------------------|
| endpoint_pfile_<start_date>-<end_date>.csv   | endpoint_pfile   |
| npidata_pfile_<start_date>-<end_date>.csv    | npidata_pfile    | 
| othername_pfile_<start_date>-<end_date>.csv  | othername_plfile |
| pl_pfile_<start_date>-<end_date>.csv         | pl_pfile         | 

Next, in AWS Glue, click the run job button for 