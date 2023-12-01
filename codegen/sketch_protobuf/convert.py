from google.protobuf import json_format
import program_pb2

with open('hello.json') as f:
    json_str = f.read()
    result = json_format.Parse(json_str, program_pb2.Program(), ignore_unknown_fields=True)
    print(result)
