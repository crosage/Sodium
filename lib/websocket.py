import asyncio
import websockets
import json
import wmi
import datetime

async def get_pnp_entities(websocket, path):
    c = wmi.WMI()

    while True:
        print(f"醒了{datetime.datetime.now()}")
        pnp_entities = []
        for device in c.Win32_PnPEntity():
            entity = {
                "Name": device.Name,
                "Manufacturer": device.Manufacturer,
                "Description": device.Description,
                "PNPDeviceID": device.PNPDeviceID
            }
            pnp_entities.append(entity)
        print("要发送了")
        await websocket.send(json.dumps(pnp_entities))
        print(f"睡一秒{datetime.datetime.now()}")
        await asyncio.sleep(0.5)  # Adjust the interval as needed

async def start_server():
    async with websockets.serve(get_pnp_entities, "localhost", 8910):
        await asyncio.Future()
asyncio.run(start_server())
