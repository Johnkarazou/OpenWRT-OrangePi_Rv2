echo 1 > /sys/devices/system/cpu/cpufreq/boost || true
echo userspace > /sys/devices/system/cpu/cpufreq/policy0/scaling_governor || true
echo 1800000 > /sys/devices/system/cpu/cpufreq/policy0/scaling_setspeed || true
freq=$(cat /sys/devices/system/cpu/cpufreq/policy0/scaling_cur_freq 2>/dev/null || echo "Unknown")
echo "Frequency set to: $freq"

pids=""
for i in $(seq 1 8); do
    while : ; do : ; done &
    pids="$pids $!"
done
echo "Started 8 stress workers: $pids"

for i in $(seq 1 18); do
    temp=$(cat /sys/class/thermal/thermal_zone0/temp 2>/dev/null)
    echo "Time $((i*10))s: $(awk -v t="$temp" 'BEGIN {print t/1000}') °C"
    sleep 10
done

kill $pids
echo "Stress test finished. Workers killed."
