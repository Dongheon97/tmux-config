#!/usr/bin/env bash
if command -v nvidia-smi >/dev/null 2>&1; then
  # 쉼표 제거
  read used total power temp <<< "$(nvidia-smi --query-gpu=memory.used,memory.total,power.draw,temperature.gpu \
    --format=csv,noheader,nounits | head -n1 | tr -d ',')"

  # 정수 변환
  : "${used:=0}" ; : "${total:=1}"
  percent=$(( used * 100 / total ))
  power_int=$(printf "%.0f" "$power" 2>/dev/null)

  # 색상 결정 (초록/노랑/빨강)
  if [ "$percent" -lt 40 ]; then
    color="colour076"   # green
  elif [ "$percent" -lt 70 ]; then
    color="colour220"   # yellow
  else
    color="colour160"   # red
  fi

  # 출력: 메모리(색상) + 전력/온도(기본색)
  printf "#GPU:#[fg=%s]%dMiB#[default] %s°C %sW" \
    "$color" "$used" "${temp:-N/A}" "${power_int:-N/A}"
else
  echo "GPU: N/A"
fi
