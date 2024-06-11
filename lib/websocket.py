import asyncio
import websockets
import json
import subprocess
import datetime
cnt=0
def run_command(command):
    result = subprocess.run(command, shell=True, capture_output=True, text=True)
    return result.stdout.strip()

async def handle_client(websocket, path):
    async for message in websocket:
        if message == "get_pnp_entities":
            await send_pnp_entities(websocket)
        elif message == "get_security_logs":
            await send_security_logs(websocket)
        elif message=="get_normal_logs":
            await send_normal_logs(websocket)
        else:
            await websocket.send("Unknown message type")


async def send_pnp_entities(websocket):
    global cnt
    cnt=cnt+1
    print(f"接收到pnp消息{cnt}")
    output = run_command('powershell "Get-WmiObject -Class Win32_PnPEntity | Select-Object -Property Name, Manufacturer,Description, PNPDeviceID | ConvertTo-Json"')
    pnp_entities = json.loads(output)
    await websocket.send(json.dumps(pnp_entities))
    print("完成发送")


async def send_security_logs(websocket):
    global cnt
    cnt=cnt+1
    print(f"接收到安全日志消息{cnt}")
    output = run_command('powershell "Get-WinEvent -LogName Security -MaxEvents 1000 | ConvertTo-Json"')
    security_logs = json.loads(output)
    await websocket.send(json.dumps(security_logs))
    print("完成发送")

async def send_normal_logs(websocket):
    global cnt
    cnt=cnt+1
    print(f"接收到普通日志消息{cnt}")
    output = run_command('powershell "Get-WinEvent -LogName Application -MaxEvents 1000 | ConvertTo-Json"')
    security_logs = json.loads(output)
    await websocket.send(json.dumps(security_logs))
    print("完成发送")

async def start_server():
    async with websockets.serve(handle_client, "localhost", 8910):
        await asyncio.Future()


asyncio.run(start_server())
