import re

with open('package/ky/ky-resize-rootfs/files/resize-rootfs.sh', 'r') as f:
    content = f.read()

# Replace the strict pattern matching with a regex-like approach in bash
new_logic = """
# Extract the base device and partition number
if [[ "${rootsource}" =~ ^(/dev/.*[^0-9]+)([0-9]+)$ ]]; then
    rootdevice="${BASH_REMATCH[1]}"
    partnum="${BASH_REMATCH[2]}"
    # Handle mmcblk0p2 -> mmcblk0
    if [[ "${rootdevice}" == *p ]]; then
        rootdevice="${rootdevice%p}"
    fi
else
    exit 0
fi

diskname=$(basename "${rootdevice}")
partname=$(basename "${rootsource}")
"""

content = re.sub(r'case "\$\{rootsource\}".*?partname=\$\(basename "\$\{rootsource\}"\)', new_logic, content, flags=re.DOTALL)

with open('package/ky/ky-resize-rootfs/files/resize-rootfs.sh', 'w') as f:
    f.write(content)
