import streamlit as st

from subprocess import run
import pickle
import datetime
import os
import random

off_timeout = 60 # seconds 
tmpfile = "/tmp/hydroserver"
last_on = f"{tmpfile}.laston"
last_off = f"{tmpfile}.lastoff"
txt = {True: "On", False: "Off"}

phrases = [
    "Asking someone to turn press the power button",
    "Enabling 220V Relay",
    "Short-circuiting the motherboard",
    "Computer is thinking",
    "undefined",
    "Working on it",
    "Streamlit takes time!"
]

def acpi_power():
    now = datetime.datetime.now().timestamp()
    p = run(["echo", "hydroserverctl" "1"])

    st.info("ACPI Button Pressed")

    with open(last_on, "w") as f:
        f.write(str(now))

    return p

def is_on():
    ping = run(["ping", "-c","1","-q","hydroserver.local"])
    return ping.returncode == 0

def toggle():
    ison = is_on()

    if ison:
        st.info("Turning off")
        acpi_power()

    else:
        try:
            st.info("Turning on")
            now = datetime.datetime.now().timestamp()
            modified_time = os.path.getmtime(last_on)
            timediff = now - modified_time
            
            if timediff > off_timeout:
                acpi_power()
            else:
                st.error(f"Please wait {off_timeout - timediff} seconds more")

        except OSError as e:
            acpi_power()

def spinner_toggle():
    with st.spinner(random.choice(phrases)):
        toggle()

ison = is_on()
st.write(f"Server is {txt[ison]}")
st.button(f"Turn {txt[not ison]}", on_click=spinner_toggle)

