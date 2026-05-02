import psutil
import mysql.connector
import time
import joblib
import pandas as pd
import os

model = joblib.load("load_predictor.pkl")

def connect_with_retry():
    while True:
        try:
            conn = mysql.connector.connect(
                host=os.getenv("DB_HOST", "localhost"),
                user=os.getenv("DB_USER", "root"),
                password=os.getenv("DB_PASSWORD", "Essanth@123"),
                database=os.getenv("DB_NAME", "Miniproject")
            )
            print("Connected to database")
            return conn
        except mysql.connector.Error as e:
            print(f"DB not ready, retrying in 5s... ({e})")
            time.sleep(5)

conn = connect_with_retry()

cursor = conn.cursor()

print("Monitoring started... Press CTRL+C to stop")

try:
    while True:
        cursor.execute("INSERT INTO system_snapshot () VALUES ()")
        snapshot_id = cursor.lastrowid

        cpu = psutil.cpu_percent()
        mem = psutil.virtual_memory()
        disk = psutil.disk_usage('/')
        net = psutil.net_io_counters()
        proc = len(psutil.pids())

        cursor.execute("INSERT INTO cpu_metrics(snapshot_id,cpu_percent) VALUES(%s,%s)", (snapshot_id,cpu))
        cursor.execute("INSERT INTO memory_metrics(snapshot_id,percent_used) VALUES(%s,%s)", (snapshot_id,mem.percent))
        cursor.execute("INSERT INTO disk_metrics(snapshot_id,percent_used) VALUES(%s,%s)", (snapshot_id,disk.percent))
        cursor.execute("INSERT INTO network_metrics(snapshot_id,bytes_sent) VALUES(%s,%s)", (snapshot_id,net.bytes_sent))
        cursor.execute("INSERT INTO system_info(snapshot_id,total_processes) VALUES(%s,%s)", (snapshot_id,proc))

        features = pd.DataFrame([[cpu, mem.percent, disk.percent, net.bytes_sent, proc]],
                                 columns=["cpu_percent", "mem_percent", "disk_percent", "bytes_sent", "total_processes"])
        pred = model.predict(features)

        if pred[0] == 1:
            cursor.execute("""
                INSERT INTO alerts(snapshot_id, metric_type, metric_value, alert_message)
                VALUES(%s,%s,%s,%s)
            """, (
                snapshot_id,
                "PREDICTION",
                cpu,
                "High Load Predicted"
            ))

        conn.commit()
        print(f"Snapshot {snapshot_id} saved")
        time.sleep(5)

except KeyboardInterrupt:
    print("Stopped")

finally:
    cursor.close()
    conn.close()