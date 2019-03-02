# G404

To start your Phoenix server:

  * Install dependencies with `mix deps.get`
  * Start Phoenix endpoint with `mix phx.server`

Run tests: `mix test`.

## Notes

Messages can be sent into channel `translator` with payload of format `{"message": "к переводу"}` and any event name.
Response will be broadcast with payload in format `{"eng_message": "translated"}` with event name `translation`.
