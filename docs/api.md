
# Differences to venueless api

```
-> room.subscribe, 1234, {room: UUID}
<- success, 1234, {}
```

```
-> room.send, 1234, {room: UUID, event_type: 'chat.message', content}
<- success, 1234, {}
<≈ room.event, EVENT
```
