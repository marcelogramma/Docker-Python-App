#!/bin/python
# -*- coding: utf-8 -*-

import psycopg2
import os, string, arcgis

#establishing the connection
conn = psycopg2.connect(
   database="russiafly", user='postgres', host='main', port='5432'
)
#Creating a cursor object using the cursor() method
cursor = conn.cursor()

#Executing an SQL function using the execute() method
cursor.execute("select version()")

# Fetch a single row using fetchone() method.
data = cursor.fetchone()
print("Connection established to: ",data,"\n")

# Comentario lindo como para hacer esperar a la gente

print("==================================================================== \n Aguarde que en breve se mostrara en pantalla consultas al Dataset \n\
   ====================================================================")

os.system("cat /tmp/x* > /tmp/russiaflydata.sql.gz")
os.system("gunzip -dk /tmp/russiaflydata.sql.gz")
os.system("psql -U postgres -d russiafly -h main < /tmp/russiaflydata.sql -W")

#Closing the connection
conn.close()