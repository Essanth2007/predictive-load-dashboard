import mysql.connector
import pandas as pd
from sklearn.ensemble import RandomForestClassifier
from sklearn.model_selection import train_test_split
import joblib

conn = mysql.connector.connect(
    host="localhost",
    user="root",
    password="Essanth@123",
    database="Miniproject"
)

query = """
SELECT c.cpu_percent,
       m.percent_used,
       d.percent_used,
       n.bytes_sent,
       s.total_processes
FROM cpu_metrics c
JOIN memory_metrics m ON c.snapshot_id=m.snapshot_id
JOIN disk_metrics d ON c.snapshot_id=d.snapshot_id
JOIN network_metrics n ON c.snapshot_id=n.snapshot_id
JOIN system_info s ON c.snapshot_id=s.snapshot_id
"""

df = pd.read_sql(query, conn)
conn.close()

df.columns = ["cpu_percent", "mem_percent", "disk_percent", "bytes_sent", "total_processes"]
df["label"] = df["cpu_percent"].apply(lambda x: 1 if x > 80 else 0)

X = df[["cpu_percent", "mem_percent", "disk_percent", "bytes_sent", "total_processes"]]
y = df["label"]

X_train, X_test, y_train, y_test = train_test_split(X, y, test_size=0.2)

model = RandomForestClassifier()
model.fit(X_train, y_train)

joblib.dump(model, "load_predictor.pkl")

print("Model saved")