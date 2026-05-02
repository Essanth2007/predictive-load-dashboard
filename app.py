from flask import Flask, render_template, jsonify
import mysql.connector
import os

app = Flask(__name__)

def db():
    return mysql.connector.connect(
        host=os.getenv("DB_HOST", "localhost"),
        user=os.getenv("DB_USER", "root"),
        password=os.getenv("DB_PASSWORD", "Essanth@123"),
        database=os.getenv("DB_NAME", "Miniproject")
    )

@app.route("/")
def home():
    return render_template("dashboard.html")

@app.route("/data")
def data():
    conn = db()
    cur = conn.cursor()

    cur.execute("""
        SELECT 
            c.cpu_percent,
            m.percent_used,
            d.percent_used,
            s.snapshot_id
        FROM system_snapshot s
        JOIN cpu_metrics c ON s.snapshot_id = c.snapshot_id
        JOIN memory_metrics m ON s.snapshot_id = m.snapshot_id
        JOIN disk_metrics d ON s.snapshot_id = d.snapshot_id
        ORDER BY s.snapshot_id DESC
        LIMIT 15
    """)

    rows = cur.fetchall()

    cur.execute("""
        SELECT alert_message
        FROM alerts
        ORDER BY alert_id DESC
        LIMIT 1
    """)
    alert_row = cur.fetchone()

    conn.close()

    rows = rows[::-1]

    labels = [r[3] for r in rows]
    cpu = [float(r[0]) for r in rows]
    ram = [float(r[1]) for r in rows]
    disk = [float(r[2]) for r in rows]

    latest = {
        "cpu": cpu[-1] if cpu else 0,
        "ram": ram[-1] if ram else 0,
        "disk": disk[-1] if disk else 0
    }

    return jsonify({
        "labels": labels,
        "cpu": cpu,
        "ram": ram,
        "disk": disk,
        "alert": alert_row[0] if alert_row else "System Normal",
        "latest": latest
    })

if __name__ == "__main__":
    app.run(host="0.0.0.0", port=5000, debug=False)