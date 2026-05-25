
export BATTERY="$(find /sys/class/power_supply/ -name "BAT*" -print -quit)"

while true; do
    if [ BATTERY != "" ]; then
	export S_BATTERY="🗲 $(cat $BATTERY/capacity)%"
    fi
    # TODO: add volume applet
    export S_DATE="⧗ $(date +'%b %d at %H:%M')"
    echo "$S_BATTERY     $S_DATE  "
    sleep 5
done

