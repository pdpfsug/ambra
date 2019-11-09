import os

from flask import Flask, redirect, request, Response
from waitress import serve
from werkzeug.utils import secure_filename

UPLOAD_FOLDER = 'gallery'
ALLOWED_EXTENSIONS = set(['png', 'jpg', 'jpeg', 'gif'])
PORT = 6789

app = Flask(__name__)


@app.route('/')
def root():
    """Return the index as static page"""
    return app.send_static_file('index.html')


@app.route('/gallery/', methods=['GET', 'POST'])
def upload_file():
    """
    Gallery handler
    ----------------
    GET: Return a JSON with all the images
    POST: Upload new image
    """
    if request.method == 'GET':
        # Create a JSON with all the data
        img_json = {}
        img_json['count'] = 0
        img_json['links'] = []

        # Get link for each file
        for file in os.listdir(app.config['UPLOAD_FOLDER']):
            # Create image URL
            url = "http://{0}:{1}/{2}/{3}".format(request.remote_addr,
                                                  PORT,
                                                  os.path.join(app.config['UPLOAD_FOLDER']),
                                                  file)
            img_json['links'].append(url)
            img_json['count'] += 1

        return img_json

    if request.method == 'POST':
        # If a file is present in the received request
        if 'file' in request.files:
            file = request.files['file']

            # If filename exists and it's allowed
            if file.filename != '' and allowed_file(file.filename):
                # Make sure the filename is ok
                filename = secure_filename(file.filename)
                # Save the image
                file.save(os.path.join(app.config['UPLOAD_FOLDER'], filename))

        return redirect('/')


@app.route('/gallery/<path:file>')
def get_file(file):
    """Retrive file from gallery"""
    if request.method == 'GET':
        f = open(os.path.join(app.config['UPLOAD_FOLDER'], file), 'rb')
        content = f.read()
        f.close()
        return Response(content, mimetype='image/*')


def allowed_file(filename):
    """Check if uploaded file is allowed"""
    return '.' in filename and filename.rsplit('.', 1)[1].lower() in ALLOWED_EXTENSIONS


if __name__ == "__main__":
    app.config['UPLOAD_FOLDER'] = UPLOAD_FOLDER
    # DEBUG app.run(host='0.0.0.0', port=PORT, debug=True)
    serve(app, host='0.0.0.0', port=PORT)
