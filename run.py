from flask import Flask, request, jsonify
from geopy.geocoders import Nominatim
import psycopg2

app = Flask(__name__)

connection = psycopg2.connect(user="postgres",
                                  password="password",
                                  host="127.0.0.1",
                                  port="54320",
                                  database="postgres")
cursor = connection.cursor()

@app.route('/')
def healthChecks():
    return {'ststus': 200,
    'msg':'The server is running'}

@app.route('/address',methods=['GET', 'POST'])
def getAddress():
    latitude=request.args.get('latitude')
    longitude=request.args.get('longitude')
    laglong = str(latitude)+','+str(longitude)
    if latitude and longitude:
        try:
            geolocator = Nominatim(user_agent="siya_get_location")
            # location = geolocator.reverse("52.509669, 13.376294")
            location = geolocator.reverse(laglong)
            print(location)
            return location.raw
        except Exception as e:
            return(str(e))
    else:
        return {'ststus': 500,
    'msg':'Both Latitude and longitude are required'}

@app.route('/geo-coordinate')
def getGeoCoordinate():
    address=request.args.get('address')
    if address:
        try:
            geolocator = Nominatim(user_agent="siya_get_location")
            location = geolocator.geocode(str(address))

            print(location)
            return location.raw
        except Exception as e:
            return(str(e))
    else:
        return {'ststus': 500,
    'msg':'The address is required'}

def tableExists(tbname):
    exists = False
    try:
        cursor.execute("select exists(select relname from pg_class where relname='" + tbname + "')")
        exists = cursor.fetchone()[0]
        print(exists)
    except psycopg2.Error as e:
        print(e)
    return exists

@app.route('/getdata')
def queryTable():
    tbname=request.args.get('tbname')
    limit=request.args.get('limit')

    print ("Connecting to database\n    ->{}".format(connection))
    tbRows = []
    if tableExists(tbname): 
        buildQury = "select * from "+ str(tbname) +" limit "+ str(limit)
        cursor.execute(buildQury)

        for table in cursor.fetchall():
            tbRows.append(table)
        cursor.close()
        jsonObject = jsonify(tbRows)
        print("Done Geting Data")
        return jsonObject
    else:
        return "Table does not Exist in DB"

@app.route('/generateAddress')
def generateAddress():
    cursor.execute("SELECT * FROM amazing_report_3")
    for row in cursor.fetchall():
        print(row[4])
        latitude = row[4]
        longitude = row[5]
        latlong = str(latitude)+','+str(longitude)
        try:
            geolocator = Nominatim(user_agent="siya_get_location")
            location = geolocator.reverse(latlong)
            print(location)
            print(row[0])
            cursor.execute(
            "UPDATE amazing_report_3 SET address=(%s)"
            " WHERE id = (%s)", 
            (str(location),str(row[0]),))
            connection.commit()
            
        except Exception as e:
            return(str(e))
    cursor.close()
    return jsonify(location.raw)


if __name__ == '__main__':
    app.run(host='0.0.0.0', use_reloader=True)
