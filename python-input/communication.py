# Echo server program
import socket

conn = None

def setup():
    global conn
    HOST = ''                 # Symbolic name meaning all available interfaces
    PORT = 1234              # Arbitrary non-privileged port
    s = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
    s.bind((HOST, PORT))
    s.listen(1)
    conn, addr = s.accept()
    print('Connected by', addr)

def send(data):
    global conn
    try:
        conn.sendall(bytes(data, "ascii"))
        return True
    except:
        conn.close()
        return False

def end():
    global conn
    conn.close()