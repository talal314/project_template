import mysql.connector
import csv
import sys
import os

if(len(sys.argv)!=3):
    print("Error, use: python3 <python file> <human_proteins_uniprot.txt> <max_phase> <result.csv>")

print(sys.argv[2]))

fileExist = os.path.exists(sys.argv[3])
# Get genes from file.txt
with open(sys.argv[1]) as f:
    genes = f.read().splitlines()

#print(genes)
#print(fileExist)
mydb = mysql.connector.connect(
  host="localhost",
  user="root",
  passwd="password",
  database="chembl_29"
)

cur = mydb.cursor()

for gen in genes:
    print(gen)

    sql = "SELECT DISTINCT compound_name, max_phase, ACTION_T.action_type, M.pref_name,CS.accession FROM compound_records C, assays A, target_dictionary T, activities ACT, molecule_dictionary M, drug_mechanism D, action_type ACTION_T,component_sequences CS,target_components TC WHERE C.record_id = ACT.record_id AND ACT.assay_id = A.assay_id AND A.tid = T.tid AND pchembl_value >=6 AND M.molregno = C.molregno AND D.molregno = M.molregno AND D.action_type = ACTION_T.action_type AND max_phase = "+ sys.argv[2]+" AND CS.component_id = TC.component_id AND TC.tid = T.tid AND CS.accession=" +"'" +gen+ "'"
    cur.execute(sql)

    myresult = cur.fetchall()
    if myresult:
        # New empty list called 'result'. This will be written to a file.
        result = list()

        # The row name is the first entry for each entity in the description tuple.
        column_names = list()
        for i in cur.description:
            column_names.append(i[0])

        result.append(column_names)

        for row in myresult:
            result.append(row)
            fileExist = os.path.exists(sys.argv[3])
            with open(sys.argv[3], 'a', newline='') as csvfile:
                csvwriter = csv.writer(csvfile, delimiter=',', quotechar='"', quoting=csv.QUOTE_MINIMAL)
                if fileExist:
                    for row in range(1,len(result)):
                        print("exist")
                        print(result[row])
                        csvwriter.writerow(result[row])
                else:
                    for row in range(0,len(result)):
                        print(result[row])
                        csvwriter.writerow(result[row])
