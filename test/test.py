import requests

resp = requests.post("http://localhost:5000/predict/", files={"file1": open("sample2.jpg", "rb"), "file2": open("sample.jpg", "rb"), "file3": open("sample2.jpg", "rb")})

print(resp.text)
