#!/bin/sh
cd /data
tar -xzf ros2_humble.tar.gz

BASE=/data/opt/ros/humble
SITE="$BASE/lib/python3.11/site-packages"
WHEELS=/data/wheels
mkdir -p "$SITE" "$WHEELS"

# wheelを Python だけで展開（unzip不要）
/system/bin/python3 - <<'PY'
import os, sys, zipfile, glob
site=os.environ.get("SITE") or "/data/opt/ros/humble/lib/python3.11/site-packages"
wdir=os.environ.get("WHEELS") or "/data/wheels"
os.makedirs(site, exist_ok=True)
wheels=sorted(glob.glob(os.path.join(wdir,"*.whl")))
if not wheels:
    print("No wheels in", wdir, file=sys.stderr); sys.exit(1)
for w in wheels:
    print("Installing:", os.path.basename(w))
    with zipfile.ZipFile(w) as z: z.extractall(site)
print("Done ->", site)
PY

# 1) bin配下の "python系" shebang を QNX 実体に統一
grep -rIZ -l -E '^#!.*python([0-9](\.[0-9]+)?)?$|^#!.*python3' "$BASE/bin" \
| xargs -0 -r sed -i '1 s|^#!.*|#!/system/bin/python3|'

# 2) 念のため CRLF を除去（改行のせいで ENOENT になるのを防ぐ）
grep -rIZ -l '.' "$BASE/bin" | xargs -0 -r sed -i 's/\r$//'

# 3) 実行属性を保証
find "$BASE/bin" -type f -exec chmod +x {} +

# 4) 実行に必要な環境変数
export PATH="/system/bin:$BASE/bin:$PATH"
export COLCON_CURRENT_PREFIX="$BASE"
export COLCON_PYTHON_EXECUTABLE=/system/bin/python3
export PYTHONPATH="$BASE/usr/lib/python3.11/site-packages:$BASE/usr/lib/python3.11/dist-packages:$BASE/lib/python3.11/site-packages:$BASE/lib/python3.11/dist-packages:${PYTHONPATH:-}"
export LD_LIBRARY_PATH="$BASE/usr/lib:$BASE/usr/lib64:$BASE/lib:$BASE/lib64:${LD_LIBRARY_PATH:-}"
export AMENT_PREFIX_PATH="$BASE:${AMENT_PREFIX_PATH:-}"
export CMAKE_PREFIX_PATH="$BASE:${CMAKE_PREFIX_PATH:-}"

. "$BASE/setup.bash"

# 5) まず Python 側で ros2cli が見えるか確認
/system/bin/python3 -c "import sys; print(sys.executable); import ros2cli.cli as c; print('ros2cli OK')"

# 6) コマンドで起動
ros2 --help
ros2 topic list
