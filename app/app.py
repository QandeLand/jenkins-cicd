from flask import Flask, jsonify
import mysql.connector
import os

app = Flask(__name__)

def get_db():
    return mysql.connector.connect(
        host=os.environ.get("DB_HOST", "mysql"),
        user=os.environ.get("DB_USER", "appuser"),
        password=os.environ.get("DB_PASSWORD", "apppass"),
        database=os.environ.get("DB_NAME", "appdb")
    )

@app.route("/health")
def health():
    return jsonify({"status": "ok"})

@app.route("/users")
def get_users():
    db = get_db()
    cursor = db.cursor()
    cursor.execute("SELECT id, name FROM users")
    users = [{"id": row[0], "name": row[1]} for row in cursor.fetchall()]
    return jsonify(users)

if __name__ == "__main__":
    app.run(host="0.0.0.0", port=5000)
