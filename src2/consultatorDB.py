#!/bin/python3
# -*- coding: utf-8 -*-

class FileManager:
    def __init__(self, file_name, mode):
        self.file_name = file_name
        self.mode = mode
    
    def __enter__(self):
        self.file = open(self.file_name, self.mode)
        return self.file
    
    def __exit__(self, exc_type, exc_value, exc_traceback):
        self.file.close()

import psycopg2
import pandas as pd

conexion = psycopg2.connect(host="main",database="russiafly", user="postgres")

# Crea del cursor
cur = conexion.cursor()

# se crean las consultas

consulta = pd.read_sql('SELECT airport_code, airport_name FROM bookings.airports_data', conexion)
consulta1 = pd.read_sql('SELECT airport_code, city FROM bookings.airports_data', conexion)
join1 = pd.read_sql('SELECT * FROM bookings.tickets', conexion)
join2 = pd.read_sql('SELECT * FROM bookings.ticket_flights', conexion)
resultJoins1 = join1.merge(join2, how='inner')
consulta2 = pd.read_sql('SELECT flight_no, departure_airport, arrival_airport, aircraft_code, duration FROM bookings.routes', conexion)
join3 = pd.read_sql('SELECT * FROM bookings.bookings', conexion)
resultJoins2 = join3.merge(join1, how='left')
join4 = pd.read_sql('SELECT DISTINCT (aircraft_code), model FROM bookings.aircrafts_data', conexion)
join5 = pd.read_sql('SELECT DISTINCT (aircraft_code), fare_conditions FROM bookings.seats', conexion)
resultJoins3 = join4.merge(join5, how='left')

# se guarda en el log las respuestas desde la BD

with FileManager("/tmp/pp.log", "a") as a_file:
    a_file.write(f"\n============================================================================================================= \n"\
        f"{consulta.head(25)}, \n============================================================================================================= \n"\
        f"{consulta1.head(25)}, \n============================================================================================================= \n"\
        f"{join1.head(25)}, \n============================================================================================================= \n"\
        f"{resultJoins1.head(25)}, \n============================================================================================================= \n"\
        f"{consulta2.head(25)}\n============================================================================================================= \n"\
        f"{join3.head(25)} \n============================================================================================================= \n"\
        f"{resultJoins2.head(25)} \n============================================================================================================= \n"\
        f"{resultJoins3.head(25)} \n\n============================================================================================================= \n"\
        f" \n Prueba ahora ingresando a esta url, para realizar consultas al Dataset, administrar el servidor Postgres, \n"\
        f" ver diagrama ER y mucho mas, \n http://127.0.0.1:2222 Password: admin \n Luego agrege un Servidor nuevo con la direccion main"\
        f" o 127.0.0.1 \n          Usuario Base de Datos: postgres   -   Sin password \n \n"\
        f"============================================================================================================= \n")
a_file.closed

# Cierra la conexión
conexion.close()