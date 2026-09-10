import os, sys, urllib.request
token = os.environ.get("GOOGLE_OAUTH_ACCESS_TOKEN")
bucket = os.environ.get("GCP_BUCKET_NAME")
if not token or not bucket:
    raise SystemExit("Set GOOGLE_OAUTH_ACCESS_TOKEN and GCP_BUCKET_NAME")
req = urllib.request.Request(f"https://storage.googleapis.com/storage/v1/b/{bucket}/o?maxResults=1", headers={"Authorization": f"Bearer {token}"})
with urllib.request.urlopen(req, timeout=20) as response:
    print(response.read().decode())
