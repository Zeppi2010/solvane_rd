from flask import Flask, render_template, request, redirect, url_for
import mysql.connector
from dotenv import load_dotenv
import os

load_dotenv()

app = Flask(__name__)

conn = mysql.connector.connect(
    host="localhost",
    user="root",
    password=os.getenv("DB_PASSWORD"),
    database="solvane_rd"
)
cursor = conn.cursor()
@app.route('/')
def index():
    cursor.execute("SELECT COUNT(*) FROM Facilities")
    facility_count = cursor.fetchone()[0]

    cursor.execute("SELECT COUNT(*) FROM Scientists")
    scientist_count = cursor.fetchone()[0]

    cursor.execute("SELECT COUNT(*) FROM Testers")
    tester_count = cursor.fetchone()[0]

    cursor.execute("SELECT COUNT(*) FROM Projects")
    project_count = cursor.fetchone()[0]

    cursor.execute("""
        SELECT f.Name, f.Region, COUNT(p.ProjectID) as ProjectCount
        FROM Facilities f
        LEFT JOIN Projects p ON f.FacilityID = p.FacilityID
        GROUP BY f.FacilityID, f.Name, f.Region
        ORDER BY ProjectCount DESC
    """)
    facility_stats = cursor.fetchall()

    return render_template('index.html',
        facilities=facility_count,
        scientists=scientist_count,
        testers=tester_count,
        projects=project_count,
        facility_stats=facility_stats
    )

@app.route('/facilities', methods=['GET', 'POST'])
def facilities():
    if request.method == 'POST':
        name = request.form['name']
        region = request.form['region']
        type_ = request.form['type']
        cursor.execute(
            "INSERT INTO Facilities (Name, Region, Type) VALUES (%s, %s, %s)",
            (name, region, type_)
        )
        conn.commit()
        return redirect(url_for('facilities'))

    cursor.execute("SELECT * FROM Facilities")
    facilities = cursor.fetchall()
    return render_template('facilities.html', facilities=facilities)

@app.route('/scientists', methods=['GET', 'POST'])
def scientists():
    if request.method == 'POST':
        name = request.form['name']
        facility_id = request.form['facility_id']
        type_ = request.form['type']
        cursor.execute(
            "INSERT INTO Scientists (Name, FacilityID, Type) VALUES (%s, %s, %s)",
            (name, facility_id, type_)
        )
        conn.commit()
        return redirect(url_for('scientists'))

    cursor.execute("""
        SELECT s.ScientistID, s.Name, f.Name, s.Type,
               ScientistWorkload(s.ScientistID) as Workload
        FROM Scientists s
        JOIN Facilities f ON s.FacilityID = f.FacilityID
    """)
    scientists = cursor.fetchall()

    cursor.execute("SELECT FacilityID, Name FROM Facilities")
    facilities = cursor.fetchall()

    return render_template('scientists.html', scientists=scientists, facilities=facilities)

@app.route('/testers', methods=['GET', 'POST'])
def testers():
    if request.method == 'POST':
        name = request.form['name']
        facility_id = request.form['facility_id']
        type_ = request.form['type']
        cursor.execute(
            "INSERT INTO Testers (Name, FacilityID, Type) VALUES (%s, %s, %s)",
            (name, facility_id, type_)
        )
        conn.commit()
        return redirect(url_for('testers'))

    cursor.execute("""
        SELECT t.TesterID, t.Name, f.Name, t.Type
        FROM Testers t
        JOIN Facilities f ON t.FacilityID = f.FacilityID
    """)
    testers = cursor.fetchall()

    cursor.execute("SELECT FacilityID, Name FROM Facilities")
    facilities = cursor.fetchall()

    return render_template('testers.html', testers=testers, facilities=facilities)

@app.route('/projects', methods=['GET', 'POST'])
def projects():
    if request.method == 'POST':
        name = request.form['name']
        facility_id = request.form['facility_id']
        changes = request.form['changes']
        type_ = request.form['type']
        cursor.execute(
            "INSERT INTO Projects (Name, FacilityID, Version, Changes, Type) VALUES (%s, %s, %s, %s, %s)",
            (name, facility_id, 1, changes, type_)
        )
        conn.commit()
        return redirect(url_for('projects'))

    cursor.execute("""
        SELECT p.ProjectID, p.Name, f.Name, p.Version, p.Type
        FROM Projects p
        JOIN Facilities f ON p.FacilityID = f.FacilityID
    """)
    projects = cursor.fetchall()

    cursor.execute("SELECT FacilityID, Name FROM Facilities")
    facilities = cursor.fetchall()

    return render_template('projects.html', projects=projects, facilities=facilities)


@app.route('/projects/<int:id>', methods=['GET', 'POST'])
def project_detail(id):
    if request.method == 'POST':
        action = request.form['action']

        if action == 'update':
            new_changes = request.form['changes']
            cursor.execute(
                "UPDATE Projects SET Version = Version + 1, Changes = %s WHERE ProjectID = %s",
                (new_changes, id)
            )
            conn.commit()

        elif action == 'assign_scientist':
            sid = request.form['scientist_id']
            cursor.execute("CALL AssignScientist(%s, %s)", (sid, id))
            conn.commit()

        elif action == 'assign_tester':
            tid = request.form['tester_id']
            cursor.execute(
                "INSERT INTO TesterProjects (TesterID, ProjectID) VALUES (%s, %s)",
                (tid, id)
            )
            conn.commit()

        return redirect(url_for('project_detail', id=id))

    cursor.execute("""
        SELECT p.ProjectID, p.Name, f.Name, p.Version, p.Changes, p.Type, p.FacilityID
        FROM Projects p
        JOIN Facilities f ON p.FacilityID = f.FacilityID
        WHERE p.ProjectID = %s
    """, (id,))
    project = cursor.fetchone()

    cursor.execute("""
        SELECT s.ScientistID, s.Name, s.Type
        FROM Scientists s
        JOIN ScientistProjects sp ON s.ScientistID = sp.ScientistID
        WHERE sp.ProjectID = %s
    """, (id,))
    assigned_scientists = cursor.fetchall()

    cursor.execute("""
        SELECT t.TesterID, t.Name, t.Type
        FROM Testers t
        JOIN TesterProjects tp ON t.TesterID = tp.TesterID
        WHERE tp.ProjectID = %s
    """, (id,))
    assigned_testers = cursor.fetchall()

    cursor.execute("""
        SELECT s.ScientistID, s.Name
        FROM Scientists s
        WHERE s.FacilityID = %s
        AND s.ScientistID NOT IN (
            SELECT ScientistID FROM ScientistProjects WHERE ProjectID = %s
        )
    """, (project[6], id))
    available_scientists = cursor.fetchall()

    cursor.execute("""
        SELECT t.TesterID, t.Name
        FROM Testers t
        WHERE t.FacilityID = %s
        AND t.TesterID NOT IN (
            SELECT TesterID FROM TesterProjects WHERE ProjectID = %s
        )
    """, (project[6], id))
    available_testers = cursor.fetchall()

    cursor.execute("""
        SELECT OldVersion, NewVersion, Changes, ChangedAt
        FROM ProjectChangelog
        WHERE ProjectID = %s
        ORDER BY ChangedAt DESC
    """, (id,))
    changelog = cursor.fetchall()

    return render_template('project_detail.html',
        project=project,
        assigned_scientists=assigned_scientists,
        assigned_testers=assigned_testers,
        available_scientists=available_scientists,
        available_testers=available_testers,
        changelog=changelog
    )

if __name__ == '__main__':
    app.run(debug=True)