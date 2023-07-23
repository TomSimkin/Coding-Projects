from flask import Flask, render_template, request, redirect, url_for, flash, session, g, send_from_directory
from werkzeug.utils import secure_filename
from flask_recaptcha import ReCaptcha
import json
import requests
import sqlite3
import hashlib
import os
import re


SECRET_KEY = 'development key'
DATABASE = 'database.db'
UPLOAD_FOLDER = os.getcwd() + '\userfiles'


app = Flask(__name__)
app.config.from_object(__name__)
app.config['MAX_CONTENT_LENGTH'] = 16 * 1024 * 1024
app.config['UPLOAD_FOLDER'] = UPLOAD_FOLDER
print app.config['UPLOAD_FOLDER']
app.config.update({'RECAPTCHA_ENABLED': True,
                   'RECAPTCHA_SITE_KEY':
                       '6LcvQCUUAAAAAHgOya9xANiSNyQzNxlPWJ-0eBfr',
                   'RECAPTCHA_SECRET_KEY':
                       '6LcvQCUUAAAAAL3wOMeQnVrZ77YVteuGEJMoVkO-'})
recaptcha = ReCaptcha(app=app)


###--Database--###


def connect_db():
    """
    Connects to the database
    """
    return sqlite3.connect(app.config['DATABASE'])


@app.before_request
def before_request():
    """
    Functions marked with before_request() are called before a request and passed no arguments.
    """
    g.db = connect_db()


@app.teardown_request
def teardown_request(exception):
    """
    If an exception occurred while the request was being processed, it is passed to each function; otherwise,
    None is passed in.
    """
    db = getattr(g, 'db', None)
    if db is not None:
        db.close()


###--Routes--###


@app.route('/')
def mainpage():
    """
    Renders the main page
    """
    return render_template("mainpage.html")


@app.route('/login', methods=['GET', 'POST'])
def login():
    """
    Renders the login page
    """
    return render_template("login.html")


@app.route('/logincheck', methods=['GET', 'POST'])
def logincheck():
    """
    Validates the login
    """
    check = g.db.execute('select pword from users where uname = ?', (request.form['username'], ))
    arrayCheck = check.fetchall()
    encrypt = hashlib.md5()
    encrypt.update(request.form['password'])
    encryptpword = encrypt.hexdigest()
    if request.method == 'POST':
        if len(arrayCheck) == 0:
            flash('Wrong username and/or password', 'error')
            return redirect(url_for('login'))
        elif arrayCheck[0][0] != encryptpword:
            flash('Wrong username and/or password', 'error')
            return redirect(url_for('login'))
        else:
            session['username'] = request.form['username']
            session['logged_in'] = True
            return redirect(url_for('upload'))
    return redirect(url_for('login'))


@app.route('/register/', methods=['GET', 'POST'])
def register():
    """
    Renders the register page
    """
    return render_template("register.html")


@app.route('/registercheck/', methods=['GET', 'POST'])
def registercheck():
    """
    Validates the registration
    """
    checkusername = g.db.execute('select uname from users where uname = ?', (request.form['usernameR'], ))
    fetchusername = checkusername.fetchall()
    r = requests.post('https://www.google.com/recaptcha/api/siteverify', data={'secret':
                        '6LcvQCUUAAAAAL3wOMeQnVrZ77YVteuGEJMoVkO-', 'response': request.form['g-recaptcha-response']})
    google_response = json.loads(r.text)
    checkre = request.form['usernameR']
    if request.method == 'POST':
        if not fetchusername:
            if not (4 <= len(request.form['usernameR']) <= 20):
                flash('Username is too short or long', 'error')
                return redirect(url_for('register'))
            if not (4 <= len(request.form['passwordR']) <= 20):
                flash('Password is too short or long', 'error')
                return redirect(url_for('register'))
            if request.form['passwordR'] != request.form['confirmP']:
                flash('Passwords do not match', 'error')
                return redirect(url_for('register'))
            if re.match("^[A-Za-z0-9]*$", checkre) is None:
                flash('Username can only contain english letters and numbers', 'error')
                return redirect((url_for('register')))
            if not google_response['success']:
                flash('Captcha is incorrect', 'error')
                return redirect(url_for('register'))
            session['logged_in'] = True
            encrypt = hashlib.md5()
            encrypt.update(request.form['passwordR'])
            encryptpword = encrypt.hexdigest()
            g.db.execute('insert into users (uname, pword) values (?, ?);', (request.form['usernameR'], encryptpword))
            g.db.commit()
            os.mkdir(os.path.join(app.config['UPLOAD_FOLDER'], request.form['usernameR']))
            return redirect(url_for('upload'))
        else:
            flash('Username is already taken', 'error')
            return redirect(url_for('register'))
    return redirect(url_for('register'))


@app.route('/logout')
def logout():
    """
    Logout
    """
    session.pop('logged_in', None)
    return redirect(url_for('mainpage'))


@app.route('/upload')
def upload():
    """
    Renders the upload page
    """
    return render_template('upload.html')


def make_tree(path, username):
    """
    Creates a dictionary with the file names with their paths
    """
    tree = dict(name=os.path.basename(path), children=[])
    try:
        lst = os.listdir(path)
    except OSError:
        pass
    else:
        for name in lst:
            fn = os.path.join(path, name)
            print(fn)
            if os.path.isdir(fn):
                pass
            else:
                with open(fn) as f:
                    contents = f.read()
                    link_s = "userfiles/" + username + "/" + name
                tree['children'].append(dict(name=name, contents=contents, link=link_s))
    return tree


@app.route('/userfiles/<username>/<filename>', methods=['GET', 'POST'])
def download_file(username, filename):
    """
    Sending the file to the user
    """
    path = os.getcwd() + "/userfiles/" + username
    return send_from_directory(path, filename=filename)


@app.route('/uploader', methods=['POST'])
def uploader():
    """
    Checks if the file is valid and uploads the file
    """
    if request.method == 'POST':
        if 'file' not in request.files:
            flash('File part not found', 'error')
            return redirect(url_for('upload'))
        file = request.files['file']
        if file.filename == '':
            flash('No file selected', 'error')
            return redirect(url_for('upload'))
        if len(file.read()) > app.config['MAX_CONTENT_LENGTH']:
            flash('File size is too big, has to be under 16MB', 'error')
            return redirect(url_for('upload'))
        else:
            filename = secure_filename(file.filename)
            file.save(os.path.join(app.config['UPLOAD_FOLDER'] + '\\' + session['username'], filename))
            flash('File uploaded successfully')
            return redirect(url_for('upload', filename=filename))


@app.route('/download/', methods=['GET', 'POST'])
def download():
    """
    Renders the download page
    """
    path = os.path.join(app.config['UPLOAD_FOLDER'] + '\\' + session['username'])
    return render_template('download.html', tree=make_tree(path, session['username']))

if __name__ == '__main__':
    app.run(debug=True, port=80)

