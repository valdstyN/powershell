import wave
import pyaudio
import base64
from flask import Flask, request, send_file, make_response
from flask_cors import CORS

app = Flask(__name__)
CORS(app)
audio = None
frames = []
recording = False
stream = None
p = 8080

# pip install -U flask-cors
# pip install pyaudio
# pip install flask
#

@app.route('/', methods=['GET', 'POST'])
def handle_request():
    if request.method == 'GET':
        return handle_get()
    elif request.method == 'POST':
        return handle_post()
    else:
        return "Method not supported."

def handle_get():
    with open("output"+p+".wav", "rb") as file:
        encoded = base64.b64encode(file.read()).decode('utf-8')
    #return encoded
    response = make_response(encoded)
    # response.headers['xxx']='yyy'
    return response
    
def handle_post():
    global recording, audio, frames, stream

    if not recording:
        recording = True
        audio = pyaudio.PyAudio()
        stream = audio.open(format=pyaudio.paInt16, channels=1, rate=44100, input=True, frames_per_buffer=1024)
        print("Recording audio...")
        while recording:
            data = stream.read(1024)
            frames.append(data)

    else:
        recording = False
        stream.stop_stream()
        stream.close()
        audio.terminate()
        print("Stopped recording.")
        save_audio()

    return "OK"


def save_audio():
    global frames
    wave_file = wave.open("output"+p+".wav", 'wb')
    wave_file.setnchannels(1)
    wave_file.setsampwidth(audio.get_sample_size(pyaudio.paInt16))
    wave_file.setframerate(44100)
    wave_file.writeframes(b''.join(frames))
    wave_file.close()
    frames = []
    print("Saved audio to output.wav.")

if __name__ == '__main__':
    print('Create connection on port: ')
    p = input()
    app.run(host='192.168.0.19', port=p)
