curl -X POST \
  http://localhost:8000/login/ \
  -H 'accept: application/json' \
  -H 'content-type: application/json' \
  -d '{
	"student_id": "1234567",
	"password": "abc123"
}' -vvv
