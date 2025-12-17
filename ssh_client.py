
import paramiko
import sys
import time

HOST = "192.168.15.32"
PORT = 2022
USER = "root"
PASS = "lipitico1910"

def run_ssh_command(command):
    print(f"Connecting to {HOST}:{PORT} as {USER}...")
    try:
        client = paramiko.SSHClient()
        client.set_missing_host_key_policy(paramiko.AutoAddPolicy())
        client.connect(HOST, port=PORT, username=USER, password=PASS, timeout=10)
        
        print(f"Executing: {command}")
        stdin, stdout, stderr = client.exec_command(command)
        
        # Wait for command to complete
        exit_status = stdout.channel.recv_exit_status()
        
        out = stdout.read().decode().strip()
        err = stderr.read().decode().strip()
        
        client.close()
        
        print("-" * 20)
        if out:
            print("OUTPUT:")
            print(out)
        if err:
            print("ERROR:")
            print(err)
        print("-" * 20)
        
        return exit_status, out, err

    except Exception as e:
        print(f"SSH Failed: {e}")
        return -1, "", str(e)

def upload_file(local_path, remote_path):
    print(f"Uploading {local_path} to {remote_path}...")
    try:
        client = paramiko.SSHClient()
        client.set_missing_host_key_policy(paramiko.AutoAddPolicy())
        client.connect(HOST, port=PORT, username=USER, password=PASS, timeout=10)
        
        sftp = client.open_sftp()
        sftp.put(local_path, remote_path)
        sftp.close()
        client.close()
        print("Upload successful.")
        return 0
    except Exception as e:
        print(f"Upload Failed: {e}")
        return 1

if __name__ == "__main__":
    if len(sys.argv) < 2:
        print("Usage:")
        print("  Run command: python3 ssh_client.py '<command>'")
        print("  Upload file: python3 ssh_client.py upload <local_path> <remote_path>")
        sys.exit(1)
    
    if sys.argv[1] == "upload":
        if len(sys.argv) != 4:
            print("Usage: python3 ssh_client.py upload <local_path> <remote_path>")
            sys.exit(1)
        upload_file(sys.argv[2], sys.argv[3])
    else:
        cmd = sys.argv[1]
        run_ssh_command(cmd)
