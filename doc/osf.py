## This is unfinished and untested code to submit a PDF paper to OSF
## via their API. Full testing is pending on resolution of these two
## issues: https://github.com/CenterForOpenScience/osf.io/issues/11313
## and https://github.com/CenterForOpenScience/osf.io/issues/11314

## The paper submission process happens in two stages:
## 1. Upload the PDF file to osfstorage.
## 2. Create a preprint using the uploaded PDF file.

from contextlib import contextmanager
import json
from urllib.parse import urljoin
import sys

import requests

api_key_file = "api-key"
api_base_url = "https://api.osf.io/v2/"
paper = "/path/to/paper.pdf"
paper_filename = "foo.pdf"

@contextmanager
def osf_session(api_key):
    with requests.session() as session:
        session.headers.update({"Accept": "application/json",
                                "Authorization": f"Bearer {api_key}"})
        yield session

def osf_url(path):
    return urljoin(api_base_url, path)

def read_api_key(filename):
    with open(filename) as file:
        return file.read()

with osf_session(read_api_key(api_key_file)) as session:
    # Get an upload link.
    response = session.get(osf_url("users/me/nodes/"))
    # FIXME: Do not arbitrarily use the 0th project.
    files_link = (response.json()
                  ["data"][0]["relationships"]["files"]["links"]
                  ["related"]["href"])
    upload_link = (session.get(files_link)
                   .json()["data"][0]["links"]["upload"])
    # Upload the paper and get a node ID.
    with open(paper, "rb") as file:
        response = session.put(upload_link,
                               params={"kind": "file",
                                       "name": paper_filename},
                               data=file)
    json.dump(response.json(), sys.stderr, indent=2)
    node_id = response.json()["data"]["id"]
    # Create preprint from uploaded file.
    response = session.post(osf_url("preprints/"),
                            headers={
                                "Accept": "application/json",
                                "Authorization": f"Bearer {read_api_key(api_key_file)}"
                            },
                            json={
                                "data": {
                                    "type": "preprints",
                                    "attributes": {
                                        "public": False,
                                        "title": "Testing OSF API for BioHackrXiv"
                                    },
                                    "relationships": {
                                        "node": {"data": {"type": "nodes",
                                                          "id": node_id}},
                                        "provider": {"data": {"type": "providers",
                                                              "id": "biohackrxiv"}}
                                    }
                                }
                            })
    print(response.status_code)
    json.dump(response.json(), sys.stderr, indent=2)
