#!/bin/bash
curl -X GET \
  http://localhost:8000/students/ \
  -H 'accept: application/json' \
  -H 'auth-key: 75494706a7b937ae9e5237625f6f6d49d81bdb0e9ada2bc7920dfef179fe8ae3'\
  -H 'authorization: eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJpZFN0dWRlbnQiOjIsIm5hbWUiOiJuZ3V5ZW4gdmFuIEIiLCJzdHVkZW50X2lkIjoiMTIzNDU2NyIsInBhc3N3b3JkIjpudWxsLCJpZENsYXNzIjpudWxsfQ.hA_cgBISTkVScKfB13ti40cVUozIjYq6yx40z0r8WFw'\
  -H 'cookie: session=206da543-e983-4366-952e-851652945105'\
  -H 'content-type: application/json' -vvv
