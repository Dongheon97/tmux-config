#!/usr/bin/env bash
# ~/.tmux/cpu_temp.sh
# CPU 패키지 온도만 기본색으로 출력

if command -v sensors >/dev/null 2>&1; then
  t=$(sensors 2>/dev/null | awk '/Package id 0:/ {gsub(/\+|°C/,"",$4); print $4; exit}')
  if [ -n "$t" ]; then
    printf "%s°C" "$t"
    exit 0
  fi
fi

# 백업 경로 (커널 인터페이스)
if compgen -G "/sys/class/thermal/thermal_zone*/temp" > /dev/null; then
  t=$(awk 'BEGIN{mx=0} {if($1>mx) mx=$1} END{printf("%.0f", mx/1000)}' /sys/class/thermal/thermal_zone*/temp 2>/dev/null)
  if [ -n "$t" ]; then
    printf "%s°C" "$t"
    exit 0
  fi
fi

printf ""

